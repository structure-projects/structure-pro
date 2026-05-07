job "alertmanager-grafana" {
  datacenters = ["dc1"]
  type        = "service"

  group "alertmanager-grafana" {
    count = 1

    network {
      port "grafana" {
        static = 3000
        to     = 3000
      }
      port "alertmanager" {
        static = 9093
        to     = 9093
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "alertmanager-grafana" {
      driver = "docker"

      config {
        image = "grafana/grafana:10.1.0"
        ports = ["grafana"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "alertmanager-grafana"
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
        name = "alertmanager-grafana"
        tags = ["alertmanager-grafana", "docker-compose-converted"]
        port = "grafana"
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
