job "clickhouse" {
  datacenters = ["dc1"]
  type        = "service"

  group "clickhouse" {
    count = 1

    network {
      port "clickhouse" {
        static = 8123
        to     = 8123
      }
      port "native" {
        static = 9000
        to     = 9000
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "clickhouse" {
      driver = "docker"

      config {
        image = "clickhouse/clickhouse-server:23.8"
        ports = ["clickhouse"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "clickhouse"
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
        name = "clickhouse"
        tags = ["clickhouse", "docker-compose-converted"]
        port = "clickhouse"
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
