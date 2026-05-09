job "sentinel-dashboard" {
  datacenters = ["dc1"]
  type        = "service"

  group "sentinel-dashboard" {
    count = 1

    network {
      port "sentinel" {
        static = 8858
        to     = 8858
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "sentinel-dashboard" {
      driver = "docker"

      config {
        image = "bladex/sentinel-dashboard:1.8.6"
        ports = ["sentinel"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "sentinel-dashboard"
      }

      resources {
        cpu    = 500
        memory = 1024
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "sentinel-dashboard"
        tags = ["sentinel-dashboard", "docker-compose-converted"]
        port = "sentinel"
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
