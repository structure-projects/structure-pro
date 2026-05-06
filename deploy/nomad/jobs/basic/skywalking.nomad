job "skywalking" {
  datacenters = ["dc1"]
  type        = "service"

  group "skywalking" {
    count = 1

    network {
      port "oap" {
        static = 11800
        to     = 11800
      }
      port "oap-grpc" {
        static = 12800
        to     = 12800
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "skywalking" {
      driver = "docker"

      config {
        image = "apache/skywalking-oap-server:8.9.1"
        ports = ["oap"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "skywalking"
      }

      resources {
        cpu    = 2000
        memory = 4096
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "skywalking"
        tags = ["skywalking", "docker-compose-converted"]
        port = "oap"
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
