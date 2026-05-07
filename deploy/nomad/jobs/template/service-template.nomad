job "[[.job_name]]" {
  datacenters = ["dc1"]
  type        = "service"

  group "[[.group_name]]" {
    count = [[.replicas]]

    network {
      port "http" {
        static = [[.port]]
        to     = [[.target_port]]
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "[[.task_name]]" {
      driver = "docker"

      config {
        image = "[[.image]]"
        ports = ["http"]
      }

      env {
        "CREATED_BY"   = "Nomad"
        "SERVICE_NAME" = "[[.job_name]]"
      }

      resources {
        cpu    = [[.cpu_limit]]
        memory = [[.memory_limit]]
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "[[.job_name]]"
        tags = ["[[.tags]]"]
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