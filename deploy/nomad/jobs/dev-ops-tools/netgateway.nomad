job "netgateway" {
  datacenters = ["dc1"]
  type        = "service"

  group "netgateway" {
    count = 1

    network {
      port "api" {
        static = 8081
        to     = 8081
      }
      port "mqtt" {
        static = 8883
        to     = 8883
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "netgateway" {
      driver = "docker"

      config {
        image = "gravitl/netmaker:v0.22.0"
        ports = ["api"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "netgateway"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "netgateway"
        tags = ["netgateway", "docker-compose-converted"]
        port = "api"
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
