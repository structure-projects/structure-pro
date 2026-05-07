job "user-center" {
  datacenters = ["dc1"]
  type        = "service"

  group "user-center" {
    count = 1

    network {
      port "app" {
        static = 8083
        to     = 8083
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "user-center" {
      driver = "docker"

      config {
        image = "registry.cn-hangzhou.aliyuncs.com/structured/structured-user-center:latest"
        ports = ["app"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "user-center"
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
        name = "user-center"
        tags = ["user-center", "docker-compose-converted"]
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
