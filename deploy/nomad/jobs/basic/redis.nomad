job "redis" {
  datacenters = ["dc1"]
  type        = "service"

  group "redis" {
    count = 1

    network {
      port "redis" {
        static = 6379
        to     = 6379
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:6.2.16"
        ports = ["redis"]
        volumes = [
          "/opt/nomad/volumes/redis:/data"
        ]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "redis"
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
        name = "redis"
        tags = ["redis", "docker-compose-converted"]
        port = "redis"
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