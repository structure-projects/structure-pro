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
        volumes = [
          "/opt/nomad/volumes/influxdb/data:/var/lib/influxdb2",
          "/opt/nomad/volumes/influxdb/config:/etc/influxdb2"
        ]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "influxdb"
        "DOCKER_INFLUXDB_INIT_MODE" = "setup"
        "DOCKER_INFLUXDB_INIT_USERNAME" = "admin"
        "DOCKER_INFLUXDB_INIT_PASSWORD" = "password"
        "DOCKER_INFLUXDB_INIT_ORG" = "example-org"
        "DOCKER_INFLUXDB_INIT_BUCKET" = "example-bucket"
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