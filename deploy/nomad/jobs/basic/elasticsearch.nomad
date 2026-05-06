job "elasticsearch" {
  datacenters = ["dc1"]
  type        = "service"

  group "elasticsearch" {
    count = 1

    network {
      port "es" {
        static = 9200
        to     = 9200
      }
      port "transport" {
        static = 9300
        to     = 9300
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "elasticsearch" {
      driver = "docker"

      config {
        image = "elasticsearch:7.17.0"
        ports = ["es"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "elasticsearch"
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
        name = "elasticsearch"
        tags = ["elasticsearch", "docker-compose-converted"]
        port = "es"
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
