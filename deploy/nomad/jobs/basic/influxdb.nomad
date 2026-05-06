job "influxdb" {
  datacenters = ["dc1"]
  type        = "service"

  group "influxdb" {
    count = 1

    network {
      port "influxdb" {
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

    task "influxdb" {
      driver = "docker"

      config {
        image = "influxdb:2.7.10"
        ports = ["influxdb"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "influxdb"
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
        name = "influxdb"
        tags = ["influxdb", "docker-compose-converted"]
        port = "influxdb"
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
