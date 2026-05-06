job "kafka" {
  datacenters = ["dc1"]
  type        = "service"

  group "kafka" {
    count = 1

    network {
      port "kafka" {
        static = 9092
        to     = 9092
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "kafka" {
      driver = "docker"

      config {
        image = "confluentinc/cp-kafka:7.3.0"
        ports = ["kafka"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "kafka"
      }

      resources {
        cpu    = 1500
        memory = 3072
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "kafka"
        tags = ["kafka", "docker-compose-converted"]
        port = "kafka"
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
