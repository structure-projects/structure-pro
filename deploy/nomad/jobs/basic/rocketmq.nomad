job "rocketmq" {
  datacenters = ["dc1"]
  type        = "service"

  group "rocketmq" {
    count = 1

    network {
      port "namesrv" {
        static = 9876
        to     = 9876
      }
      port "broker" {
        static = 10909
        to     = 10909
      }
      port "broker2" {
        static = 10911
        to     = 10911
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "rocketmq" {
      driver = "docker"

      config {
        image = "apache/rocketmq:4.9.5"
        ports = ["namesrv"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "rocketmq"
      }

      resources {
        cpu    = 1500
        memory = 3072
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "rocketmq"
        tags = ["rocketmq", "docker-compose-converted"]
        port = "namesrv"
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
