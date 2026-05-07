#!/usr/bin/env python3
"""Convert docker-compose files to Nomad job files."""

import os
import re
import yaml
from pathlib import Path

DOCKER_COMPOSE_DIR = Path("/Users/chuck/projects/structure-projects/structure-cloud-pro/deploy/docker-compose")
NOMAD_OUTPUT_DIR = Path("/Users/chuck/projects/structure-projects/structure-cloud-pro/deploy/nomad/jobs")


def convert_docker_compose_to_nomad(compose_path, output_dir):
    """Convert a docker-compose file to a Nomad job file."""
    try:
        with open(compose_path, 'r', encoding='utf-8') as f:
            compose_data = yaml.safe_load(f)
    except Exception as e:
        print(f"Error reading {compose_path}: {e}")
        return

    if not compose_data or 'services' not in compose_data:
        return

    for service_name, service_config in compose_data['services'].items():
        # Determine output path
        rel_path = compose_path.relative_to(DOCKER_COMPOSE_DIR)
        nomad_subdir = output_dir / rel_path.parent
        nomad_subdir.mkdir(parents=True, exist_ok=True)

        nomad_file = nomad_subdir / f"{service_name}.nomad"

        # Extract configuration from docker-compose
        image = service_config.get('image', 'nginx:alpine')
        ports = service_config.get('ports', [])
        volumes = service_config.get('volumes', [])
        environment = service_config.get('environment', [])
        restart = service_config.get('restart', 'always')
        deploy = service_config.get('deploy', {})
        replicas = deploy.get('replicas', 1)

        # Process ports
        nomad_ports = []
        for port in ports:
            if isinstance(port, str):
                if ':' in port:
                    parts = port.split(':')
                    host_port = parts[0]
                    container_port = parts[-1]
                    # Handle variable ports
                    if host_port.startswith('$') or host_port.startswith('${'):
                        host_port = 0
                    elif host_port.isdigit():
                        host_port = int(host_port)
                    else:
                        host_port = 0
                    if container_port.startswith('$') or container_port.startswith('${'):
                        container_port = 80  # default
                    elif container_port.isdigit():
                        container_port = int(container_port)
                    else:
                        container_port = 80
                else:
                    if port.startswith('$') or port.startswith('${'):
                        host_port = 0
                        container_port = 80
                    elif port.isdigit():
                        host_port = int(port)
                        container_port = host_port
                    else:
                        host_port = 0
                        container_port = 80
                nomad_ports.append({
                    'name': 'http' if len(nomad_ports) == 0 else f'port{len(nomad_ports)}',
                    'static': host_port if host_port != 0 else None,
                    'to': container_port
                })
        # Ensure at least one port exists
        if not nomad_ports:
            nomad_ports.append({
                'name': 'http',
                'static': None,
                'to': 80
            })

        # Process environment variables
        nomad_env = {}
        for env in environment:
            if isinstance(env, str):
                if '=' in env:
                    key, value = env.split('=', 1)
                    nomad_env[key] = value
            elif isinstance(env, dict):
                nomad_env.update(env)

        # Process volumes
        nomad_volumes = []
        for vol in volumes:
            if isinstance(vol, str):
                parts = vol.split(':')
                if len(parts) >= 2:
                    host_path = parts[0]
                    container_path = parts[1]
                    nomad_volumes.append({
                        'source': os.path.basename(host_path.replace('${PWD}/', '')),
                        'destination': container_path,
                        'read_only': parts[2] == 'ro' if len(parts) > 2 else False
                    })

        # Generate Nomad job
        job_content = generate_nomad_job(
            service_name=service_name,
            image=image,
            ports=nomad_ports,
            env=nomad_env,
            volumes=nomad_volumes,
            replicas=replicas,
            command=service_config.get('command'),
            entrypoint=service_config.get('entrypoint')
        )

        with open(nomad_file, 'w', encoding='utf-8') as f:
            f.write(job_content)

        print(f"Created: {nomad_file}")


def generate_nomad_job(service_name, image, ports, env, volumes, replicas=1, command=None, entrypoint=None):
    """Generate Nomad job HCL content."""
    job_name = re.sub(r'[^a-zA-Z0-9-]', '-', service_name).lower()

    # Build ports section
    ports_section = ""
    for port in ports:
        if port.get('static'):
            ports_section += f"""
      port "{port['name']}" {{
        static = {port['static']}
        to     = {port['to']}
      }}"""
        else:
            ports_section += f"""
      port "{port['name']}" {{
        to = {port['to']}
      }}"""

    # Build volumes section
    volumes_section = ""
    for vol in volumes:
        volumes_section += f"""
      volume "{vol['source']}" {{
        type      = "host"
        read_only = {str(vol['read_only']).lower()}
      }}"""

    # Build env section
    env_section = ""
    for key, value in env.items():
        env_section += f'''
        "{key}" = "{value}"'''

    # Build command/entrypoint
    config_extras = ""
    if command:
        if isinstance(command, list):
            config_extras += f'\n        args = {repr(command)}'
        else:
            config_extras += f'\n        command = "{command}"'
    if entrypoint:
        if isinstance(entrypoint, list):
            config_extras += f'\n        entrypoint = {repr(entrypoint)}'
        else:
            config_extras += f'\n        entrypoint = "{entrypoint}"'

    # Build service check
    check_type = "tcp"
    check_path = ""
    if len(ports) > 0 and ports[0]['to'] in [80, 8080, 3000, 8000, 5000]:
        check_type = "http"
        check_path = '\n          path     = "/"'

    return f"""job "{job_name}" {{
  datacenters = ["dc1"]
  type        = "service"

  group "{job_name}" {{
    count = {replicas}

    network {{{ports_section}
    }}

    restart {{
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }}

    task "{job_name}" {{
      driver = "docker"

      config {{
        image = "{image}"
        ports = ["{ports[0]['name'] if ports else 'http'}"]{config_extras}
      }}{volumes_section}

      env {{{env_section}
        "CREATED_BY" = "Nomad"
      }}

      resources {{
        cpu    = 1000
        memory = 2048
      }}

      logs {{
        max_files     = 5
        max_file_size = 10
      }}

      service {{
        name = "{job_name}"
        tags = ["{job_name}", "docker-compose-converted"]
        port = "{ports[0]['name'] if ports else 'http'}"
        check {{
          name     = "{check_type}"
          type     = "{check_type}"{check_path}
          interval = "10s"
          timeout  = "2s"
        }}
      }}
    }}
  }}
}}
"""


def main():
    """Main conversion process."""
    print("Converting docker-compose files to Nomad jobs...")

    # Find all docker-compose files
    compose_files = list(DOCKER_COMPOSE_DIR.rglob("docker-compose.yaml"))
    compose_files.extend(DOCKER_COMPOSE_DIR.rglob("docker-compose.yml"))

    for compose_file in compose_files:
        # Skip template files and init files
        if "template" in str(compose_file) or "init" in str(compose_file):
            continue
        convert_docker_compose_to_nomad(compose_file, NOMAD_OUTPUT_DIR)

    print("Conversion complete!")


if __name__ == "__main__":
    main()