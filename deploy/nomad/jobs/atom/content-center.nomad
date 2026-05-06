job "content-center" {
  datacenters = ["dc1"]
  type        = "service"

  group "content-center" {
    count = 1

    network {
      port "app" {
        static = 8081
        to     = 8081
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "content-center" {
      driver = "docker"

      config {
        image = "registry.cn-hangzhou.aliyuncs.com/structured/structured-content-center:latest"
        ports = ["app"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "content-center"
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
        name = "content-center"
        tags = ["content-center", "docker-compose-converted"]
        port = "app"
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
