job "mongodb" {
  datacenters = ["dc1"]
  type        = "service"

  group "mongodb" {
    count = 1

    network {
      port "mongodb" {
        static = 27017
        to     = 27017
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "mongodb" {
      driver = "docker"

      config {
        image = "mongo:5.0"
        ports = ["mongodb"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "mongodb"
      }

      resources {
        cpu    = 1500
        memory = 4096
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "mongodb"
        tags = ["mongodb", "docker-compose-converted"]
        port = "mongodb"
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
