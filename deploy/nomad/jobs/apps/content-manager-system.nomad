job "content-manager-system" {
  datacenters = ["dc1"]
  type        = "service"

  group "content-manager-system" {
    count = 1

    network {
      port "app" {
        static = 8085
        to     = 8085
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "content-manager-system" {
      driver = "docker"

      config {
        image = "registry.cn-hangzhou.aliyuncs.com/structured/content-manager-system:latest"
        ports = ["app"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "content-manager-system"
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
        name = "content-manager-system"
        tags = ["content-manager-system", "docker-compose-converted"]
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
