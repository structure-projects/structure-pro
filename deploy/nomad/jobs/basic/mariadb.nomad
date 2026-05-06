job "mariadb" {
  datacenters = ["dc1"]
  type        = "service"

  group "mariadb" {
    count = 1

    network {
      port "mariadb" {
        static = 3306
        to     = 3306
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "mariadb" {
      driver = "docker"

      config {
        image = "mariadb:10.5"
        ports = ["mariadb"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "mariadb"
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
        name = "mariadb"
        tags = ["mariadb", "docker-compose-converted"]
        port = "mariadb"
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
