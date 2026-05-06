job "web-pc-cms-ui" {
  datacenters = ["dc1"]
  type        = "service"

  group "web-pc-cms-ui" {
    count = 1

    network {
      port "http" {
        static = 80
        to     = 80
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "web-pc-cms-ui" {
      driver = "docker"

      config {
        image = "nginx:alpine"
        ports = ["http"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "web-pc-cms-ui"
      }

      resources {
        cpu    = 500
        memory = 512
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "web-pc-cms-ui"
        tags = ["web-pc-cms-ui", "docker-compose-converted"]
        port = "http"
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
