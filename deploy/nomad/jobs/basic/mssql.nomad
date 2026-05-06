job "mssql" {
  datacenters = ["dc1"]
  type        = "service"

  group "mssql" {
    count = 1

    network {
      port "mssql" {
        static = 1433
        to     = 1433
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "mssql" {
      driver = "docker"

      config {
        image = "mcr.microsoft.com/mssql/server:2019-latest"
        ports = ["mssql"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "mssql"
      }

      resources {
        cpu    = 2000
        memory = 4096
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "mssql"
        tags = ["mssql", "docker-compose-converted"]
        port = "mssql"
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
