job "prometheus" {
  datacenters = ["dc1"]
  type        = "service"

  group "prometheus" {
    count = 1

    network {
      port "prometheus" {
        static = 9090
        to     = 9090
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "prometheus" {
      driver = "docker"

      config {
        image = "prom/prometheus:v2.55.1"
        ports = ["prometheus"]
        command = "--config.file=/etc/prometheus/prometheus.yml"
        args = ["--storage.tsdb.path=/prometheus", "--web.console.libraries=/etc/prometheus/console_libraries", "--web.console.templates=/etc/prometheus/consoles", "--storage.tsdb.retention=200h"]
        volumes = [
          "/opt/nomad/volumes/prometheus/conf:/etc/prometheus",
          "/opt/nomad/volumes/prometheus/data:/prometheus"
        ]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "prometheus"
      }

      resources {
        cpu    = 1000
        memory = 2048
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "prometheus"
        tags = ["prometheus", "docker-compose-converted"]
        port = "prometheus"
        check {
          name     = "tcp"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}