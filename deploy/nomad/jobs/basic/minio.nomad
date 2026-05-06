job "minio" {
  datacenters = ["dc1"]
  type        = "service"

  group "minio" {
    count = 1

    network {
      port "minio" {
        static = 9000
        to     = 9000
      }
      port "console" {
        static = 9001
        to     = 9001
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "minio" {
      driver = "docker"

      config {
        image = "minio/minio:latest"
        ports = ["minio"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "minio"
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
        name = "minio"
        tags = ["minio", "docker-compose-converted"]
        port = "minio"
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
