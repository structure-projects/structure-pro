job "mysql5" {
  datacenters = ["dc1"]
  type        = "service"

  group "mysql5" {
    count = 1

    network {
      port "mysql" {
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

    task "mysql5" {
      driver = "docker"

      config {
        image = "mysql:5.7"
        ports = ["mysql"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "mysql5"
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
        name = "mysql5"
        tags = ["mysql5", "docker-compose-converted"]
        port = "mysql"
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
