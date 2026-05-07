job "rabbitmq" {
  datacenters = ["dc1"]
  type        = "service"

  group "rabbitmq" {
    count = 1

    network {
      port "amqp" {
        static = 5672
        to     = 5672
      }
      port "mgmt" {
        static = 15672
        to     = 15672
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "rabbitmq" {
      driver = "docker"

      config {
        image = "rabbitmq:4.0.3-management-alpine"
        ports = ["amqp", "mgmt"]
        volumes = [
          "/opt/nomad/volumes/rabbitmq:/var/lib/rabbitmq",
          "/opt/nomad/volumes/rabbitmq-log:/var/log/rabbitmq"
        ]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "rabbitmq"
        "RABBITMQ_DEFAULT_USER" = "guest"
        "RABBITMQ_DEFAULT_PASS" = "guest"
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
        name = "rabbitmq"
        tags = ["rabbitmq", "docker-compose-converted"]
        port = "amqp"
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