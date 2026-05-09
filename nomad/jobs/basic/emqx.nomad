job "emqx" {
  datacenters = ["dc1"]
  type        = "service"

  group "emqx" {
    count = 1

    network {
      port "mqtt" {
        static = 1883
        to     = 1883
      }
      port "dashboard" {
        static = 18083
        to     = 18083
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "emqx" {
      driver = "docker"

      config {
        image = "emqx/emqx:5.1.6"
        ports = ["mqtt"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "emqx"
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
        name = "emqx"
        tags = ["emqx", "docker-compose-converted"]
        port = "mqtt"
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
