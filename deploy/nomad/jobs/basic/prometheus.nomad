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
        image = "prom/prometheus:v2.45.0"
        ports = ["prometheus"]
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
