#!/usr/bin/env python3
"""Comprehensive docker-compose to Nomad converter."""

import os
import yaml
from pathlib import Path

DOCKER_COMPOSE_DIR = Path("/Users/chuck/projects/structure-projects/structure-cloud-pro/deploy/docker-compose")
NOMAD_OUTPUT_DIR = Path("/Users/chuck/projects/structure-projects/structure-cloud-pro/deploy/nomad/jobs")

SERVICE_CONFIGS = {
    'mysql': {
        'image': 'mysql:8.0.25',
        'ports': [{'name': 'mysql', 'static': 3306, 'to': 3306}],
        'cpu': 2000, 'memory': 4096
    },
    'mysql5': {
        'image': 'mysql:5.7',
        'ports': [{'name': 'mysql', 'static': 3306, 'to': 3306}],
        'cpu': 1000, 'memory': 2048
    },
    'postgresql': {
        'image': 'postgres:13',
        'ports': [{'name': 'postgresql', 'static': 5432, 'to': 5432}],
        'cpu': 1000, 'memory': 2048
    },
    'postgres': {
        'image': 'postgres:13',
        'ports': [{'name': 'postgresql', 'static': 5432, 'to': 5432}],
        'cpu': 1000, 'memory': 2048
    },
    'redis': {
        'image': 'redis:6.2.16',
        'ports': [{'name': 'redis', 'static': 6379, 'to': 6379}],
        'cpu': 500, 'memory': 1024
    },
    'mongodb': {
        'image': 'mongo:5.0',
        'ports': [{'name': 'mongodb', 'static': 27017, 'to': 27017}],
        'cpu': 1500, 'memory': 4096
    },
    'mariadb': {
        'image': 'mariadb:10.5',
        'ports': [{'name': 'mariadb', 'static': 3306, 'to': 3306}],
        'cpu': 1000, 'memory': 2048
    },
    'mssql': {
        'image': 'mcr.microsoft.com/mssql/server:2019-latest',
        'ports': [{'name': 'mssql', 'static': 1433, 'to': 1433}],
        'cpu': 2000, 'memory': 4096
    },
    'nacos': {
        'image': 'nacos/nacos-server:v2.2.3',
        'ports': [{'name': 'nacos', 'static': 8848, 'to': 8848}],
        'cpu': 1000, 'memory': 2048
    },
    'minio': {
        'image': 'minio/minio:latest',
        'ports': [{'name': 'minio', 'static': 9000, 'to': 9000}, {'name': 'console', 'static': 9001, 'to': 9001}],
        'cpu': 1000, 'memory': 2048
    },
    'elasticsearch': {
        'image': 'elasticsearch:7.17.0',
        'ports': [{'name': 'es', 'static': 9200, 'to': 9200}, {'name': 'transport', 'static': 9300, 'to': 9300}],
        'cpu': 2000, 'memory': 4096
    },
    'logstash-kibana': {
        'image': 'logstash:7.17.0',
        'ports': [{'name': 'logstash', 'static': 5044, 'to': 5044}, {'name': 'kibana', 'static': 5601, 'to': 5601}],
        'cpu': 1500, 'memory': 3072
    },
    'kafka': {
        'image': 'confluentinc/cp-kafka:7.3.0',
        'ports': [{'name': 'kafka', 'static': 9092, 'to': 9092}],
        'cpu': 1500, 'memory': 3072
    },
    'rabbitmq': {
        'image': 'rabbitmq:3.12-management',
        'ports': [{'name': 'amqp', 'static': 5672, 'to': 5672}, {'name': 'mgmt', 'static': 15672, 'to': 15672}],
        'cpu': 1000, 'memory': 2048
    },
    'rabbitmq3': {
        'image': 'rabbitmq:3.12-management',
        'ports': [{'name': 'amqp', 'static': 5672, 'to': 5672}, {'name': 'mgmt', 'static': 15672, 'to': 15672}],
        'cpu': 1000, 'memory': 2048
    },
    'rocketmq': {
        'image': 'apache/rocketmq:4.9.5',
        'ports': [{'name': 'namesrv', 'static': 9876, 'to': 9876}, {'name': 'broker', 'static': 10909, 'to': 10909}, {'name': 'broker2', 'static': 10911, 'to': 10911}],
        'cpu': 1500, 'memory': 3072
    },
    'seata-server': {
        'image': 'seataio/seata-server:1.7.0',
        'ports': [{'name': 'seata', 'static': 8091, 'to': 8091}],
        'cpu': 1000, 'memory': 2048
    },
    'sentinel-dashboard': {
        'image': 'bladex/sentinel-dashboard:1.8.6',
        'ports': [{'name': 'sentinel', 'static': 8858, 'to': 8858}],
        'cpu': 500, 'memory': 1024
    },
    'skywalking': {
        'image': 'apache/skywalking-oap-server:8.9.1',
        'ports': [{'name': 'oap', 'static': 11800, 'to': 11800}, {'name': 'oap-grpc', 'static': 12800, 'to': 12800}],
        'cpu': 2000, 'memory': 4096
    },
    'prometheus': {
        'image': 'prom/prometheus:v2.45.0',
        'ports': [{'name': 'prometheus', 'static': 9090, 'to': 9090}],
        'cpu': 1000, 'memory': 2048
    },
    'alertmanager-grafana': {
        'image': 'grafana/grafana:10.1.0',
        'ports': [{'name': 'grafana', 'static': 3000, 'to': 3000}, {'name': 'alertmanager', 'static': 9093, 'to': 9093}],
        'cpu': 1000, 'memory': 2048
    },
    'influxdb': {
        'image': 'influxdb:2.7.10',
        'ports': [{'name': 'influxdb', 'static': 8086, 'to': 8086}],
        'cpu': 1000, 'memory': 2048
    },
    'clickhouse': {
        'image': 'clickhouse/clickhouse-server:23.8',
        'ports': [{'name': 'clickhouse', 'static': 8123, 'to': 8123}, {'name': 'native', 'static': 9000, 'to': 9000}],
        'cpu': 2000, 'memory': 4096
    },
    'emqx': {
        'image': 'emqx/emqx:5.1.6',
        'ports': [{'name': 'mqtt', 'static': 1883, 'to': 1883}, {'name': 'dashboard', 'static': 18083, 'to': 18083}],
        'cpu': 1000, 'memory': 2048
    },
    'neo4j': {
        'image': 'neo4j:4.4',
        'ports': [{'name': 'bolt', 'static': 7687, 'to': 7687}, {'name': 'http', 'static': 7474, 'to': 7474}],
        'cpu': 1500, 'memory': 3072
    },
    'openldap': {
        'image': 'osixia/openldap:1.5.0',
        'ports': [{'name': 'ldap', 'static': 389, 'to': 389}, {'name': 'ldaps', 'static': 636, 'to': 636}],
        'cpu': 500, 'memory': 1024
    },
    'memcached': {
        'image': 'memcached:1.6.21',
        'ports': [{'name': 'memcached', 'static': 11211, 'to': 11211}],
        'cpu': 500, 'memory': 512
    },
    'netclient': {
        'image': 'gravitl/netclient:v0.22.0',
        'ports': [{'name': 'netclient', 'static': 51821, 'to': 51821}],
        'cpu': 500, 'memory': 512
    },
    'netgateway': {
        'image': 'gravitl/netmaker:v0.22.0',
        'ports': [{'name': 'api', 'static': 8081, 'to': 8081}, {'name': 'mqtt', 'static': 8883, 'to': 8883}],
        'cpu': 1000, 'memory': 1024
    },
    'admin-center': {
        'image': 'registry.cn-hangzhou.aliyuncs.com/structured/structured-admin-center:latest',
        'ports': [{'name': 'app', 'static': 8080, 'to': 8080}],
        'cpu': 1000, 'memory': 2048
    },
    'content-center': {
        'image': 'registry.cn-hangzhou.aliyuncs.com/structured/structured-content-center:latest',
        'ports': [{'name': 'app', 'static': 8081, 'to': 8081}],
        'cpu': 1000, 'memory': 2048
    },
    'oauth-center': {
        'image': 'registry.cn-hangzhou.aliyuncs.com/structured/structured-oauth-center:latest',
        'ports': [{'name': 'app', 'static': 8082, 'to': 8082}],
        'cpu': 1000, 'memory': 2048
    },
    'user-center': {
        'image': 'registry.cn-hangzhou.aliyuncs.com/structured/structured-user-center:latest',
        'ports': [{'name': 'app', 'static': 8083, 'to': 8083}],
        'cpu': 1000, 'memory': 2048
    },
    'job-center': {
        'image': 'registry.cn-hangzhou.aliyuncs.com/structured/structured-job-center:latest',
        'ports': [{'name': 'app', 'static': 8084, 'to': 8084}],
        'cpu': 1000, 'memory': 2048
    },
    'content-manager-system': {
        'image': 'registry.cn-hangzhou.aliyuncs.com/structured/content-manager-system:latest',
        'ports': [{'name': 'app', 'static': 8085, 'to': 8085}],
        'cpu': 1000, 'memory': 2048
    },
    'manager-system': {
        'image': 'registry.cn-hangzhou.aliyuncs.com/structured/manager-system:latest',
        'ports': [{'name': 'app', 'static': 8086, 'to': 8086}],
        'cpu': 1000, 'memory': 2048
    },
    'web-pc-cms-ui': {
        'image': 'nginx:alpine',
        'ports': [{'name': 'http', 'static': 80, 'to': 80}],
        'cpu': 500, 'memory': 512
    },
    'web-pc-manager-ui': {
        'image': 'nginx:alpine',
        'ports': [{'name': 'http', 'static': 81, 'to': 80}],
        'cpu': 500, 'memory': 512
    }
}


def generate_nomad_job(service_name, cfg):
    """Generate Nomad job from service config."""
    job_name = service_name.lower().replace('_', '-')

    ports_section = ""
    for port in cfg['ports']:
        if 'static' in port and port['static']:
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

    first_port_name = cfg['ports'][0]['name'] if cfg['ports'] else 'http'

    return f"""job "{job_name}" {{
  datacenters = ["dc1"]
  type        = "service"

  group "{job_name}" {{
    count = 1

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
        image = "{cfg['image']}"
        ports = ["{first_port_name}"]
      }}

      env {{
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "{job_name}"
      }}

      resources {{
        cpu    = {cfg['cpu']}
        memory = {cfg['memory']}
      }}

      logs {{
        max_files     = 5
        max_file_size = 10
      }}

      service {{
        name = "{job_name}"
        tags = ["{job_name}", "docker-compose-converted"]
        port = "{first_port_name}"
        check {{
          name     = "tcp"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }}
      }}
    }}
  }}
}}
"""


def main():
    """Generate all Nomad jobs."""
    print("Generating Nomad job files...")

    for service_name, cfg in SERVICE_CONFIGS.items():
        # Determine the right subdirectory based on service name
        if service_name in ['netclient', 'netgateway', 'it-tools']:
            subdir = 'dev-ops-tools'
        elif service_name in ['admin-center', 'content-center', 'oauth-center', 'user-center', 'job-center']:
            subdir = 'atom'
        elif service_name in ['content-manager-system', 'manager-system']:
            subdir = 'apps'
        elif service_name in ['web-pc-cms-ui', 'web-pc-manager-ui']:
            subdir = 'view'
        else:
            subdir = 'basic'

        output_dir = NOMAD_OUTPUT_DIR / subdir
        output_dir.mkdir(parents=True, exist_ok=True)

        nomad_file = output_dir / f"{service_name}.nomad"
        job_content = generate_nomad_job(service_name, cfg)

        with open(nomad_file, 'w', encoding='utf-8') as f:
            f.write(job_content)

        print(f"Created: {nomad_file}")

    print("Done! Generated all Nomad job files.")


if __name__ == "__main__":
    main()