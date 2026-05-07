job "netclient" {
  datacenters = ["dc1"]
  type        = "service"

  group "netclient" {
    count = 1

    network {
      port "netclient" {
        static = 51821
        to     = 51821
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "netclient" {
      driver = "docker"

      config {
        image = "gravitl/netclient:v0.22.0"
        ports = ["netclient"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "netclient"
      }

      resources {
        cpu    = 500
        memory = 512
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "netclient"
        tags = ["netclient", "docker-compose-converted"]
        port = "netclient"
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
