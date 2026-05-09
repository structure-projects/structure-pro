job "seata-server" {
  datacenters = ["dc1"]
  type        = "service"

  group "seata-server" {
    count = 1

    network {
      port "seata" {
        static = 8091
        to     = 8091
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "seata-server" {
      driver = "docker"

      config {
        image = "seataio/seata-server:1.7.0"
        ports = ["seata"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "seata-server"
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
        name = "seata-server"
        tags = ["seata-server", "docker-compose-converted"]
        port = "seata"
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
