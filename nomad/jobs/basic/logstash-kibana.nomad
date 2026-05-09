job "logstash-kibana" {
  datacenters = ["dc1"]
  type        = "service"

  group "logstash-kibana" {
    count = 1

    network {
      port "logstash" {
        static = 5044
        to     = 5044
      }
      port "kibana" {
        static = 5601
        to     = 5601
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "logstash-kibana" {
      driver = "docker"

      config {
        image = "logstash:7.17.0"
        ports = ["logstash"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "logstash-kibana"
      }

      resources {
        cpu    = 1500
        memory = 3072
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "logstash-kibana"
        tags = ["logstash-kibana", "docker-compose-converted"]
        port = "logstash"
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
