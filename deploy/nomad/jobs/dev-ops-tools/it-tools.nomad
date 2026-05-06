job "it-tools" {
  datacenters = ["dc1"]
  type        = "service"

  group "it-tools" {
    count = 1

    network {
      port "http" {
        static = "19001"
        to     = 80
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "it-tools" {
      driver = "docker"

      config {
        image = "corentinth/it-tools:2024.10.22-7ca5933"
        ports = ["http"]

        auth {
          username = ""
          password = ""
        }
      }

      env {
        CREATED_BY = "Nomad"
      }

      resources {
        cpu    = 200
        memory = 128
        disk   = 512
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "it-tools"
        tags = ["it-tools", "apps"]
        port = "http"
        check {
          name     = "http"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}