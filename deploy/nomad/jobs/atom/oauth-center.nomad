job "oauth-center" {
  datacenters = ["dc1"]
  type        = "service"

  group "oauth-center" {
    count = 1

    network {
      port "app" {
        static = 8082
        to     = 8082
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "oauth-center" {
      driver = "docker"

      config {
        image = "registry.cn-hangzhou.aliyuncs.com/structured/structured-oauth-center:latest"
        ports = ["app"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "oauth-center"
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
        name = "oauth-center"
        tags = ["oauth-center", "docker-compose-converted"]
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
