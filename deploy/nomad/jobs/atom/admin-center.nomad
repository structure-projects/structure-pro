job "admin-center" {
  datacenters = ["dc1"]
  type        = "service"

  group "admin-center" {
    count = 1

    network {
      port "app" {
        static = 8080
        to     = 8080
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "admin-center" {
      driver = "docker"

      config {
        image = "registry.cn-hangzhou.aliyuncs.com/structured/structured-admin-center:latest"
        ports = ["app"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "admin-center"
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
        name = "admin-center"
        tags = ["admin-center", "docker-compose-converted"]
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
