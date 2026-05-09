job "postgresql" {
  datacenters = ["dc1"]
  type        = "service"

  group "postgresql" {
    count = 1

    network {
      port "postgresql" {
        static = 5432
        to     = 5432
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "postgresql" {
      driver = "docker"

      config {
        image = "postgres:13"
        ports = ["postgresql"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "postgresql"
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
        name = "postgresql"
        tags = ["postgresql", "docker-compose-converted"]
        port = "postgresql"
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
