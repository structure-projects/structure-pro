job "manager-system" {
  datacenters = ["dc1"]
  type        = "service"

  group "manager-system" {
    count = 1

    network {
      port "app" {
        static = 8086
        to     = 8086
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "manager-system" {
      driver = "docker"

      config {
        image = "registry.cn-hangzhou.aliyuncs.com/structured/manager-system:latest"
        ports = ["app"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "manager-system"
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
        name = "manager-system"
        tags = ["manager-system", "docker-compose-converted"]
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
