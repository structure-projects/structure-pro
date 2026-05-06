job "postgres" {
  datacenters = ["dc1"]
  type        = "service"

  group "postgres" {
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

    task "postgres" {
      driver = "docker"

      config {
        image = "postgres:13"
        ports = ["postgresql"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "postgres"
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
        name = "postgres"
        tags = ["postgres", "docker-compose-converted"]
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
