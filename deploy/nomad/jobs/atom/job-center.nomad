job "job-center" {
  datacenters = ["dc1"]
  type        = "service"

  group "job-center" {
    count = 1

    network {
      port "app" {
        static = 8084
        to     = 8084
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "job-center" {
      driver = "docker"

      config {
        image = "registry.cn-hangzhou.aliyuncs.com/structured/structured-job-center:latest"
        ports = ["app"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "job-center"
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
        name = "job-center"
        tags = ["job-center", "docker-compose-converted"]
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
