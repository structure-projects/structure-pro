job "memcached" {
  datacenters = ["dc1"]
  type        = "service"

  group "memcached" {
    count = 1

    network {
      port "memcached" {
        static = 11211
        to     = 11211
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "memcached" {
      driver = "docker"

      config {
        image = "memcached:1.6.21"
        ports = ["memcached"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "memcached"
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
        name = "memcached"
        tags = ["memcached", "docker-compose-converted"]
        port = "memcached"
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
