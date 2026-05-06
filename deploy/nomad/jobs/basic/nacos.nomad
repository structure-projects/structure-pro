job "nacos" {
  datacenters = ["dc1"]
  type        = "service"

  group "nacos" {
    count = 1

    network {
      port "nacos" {
        static = 8848
        to     = 8848
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "nacos" {
      driver = "docker"

      config {
        image = "nacos/nacos-server:v2.2.3"
        ports = ["nacos"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "nacos"
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
        name = "nacos"
        tags = ["nacos", "docker-compose-converted"]
        port = "nacos"
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
