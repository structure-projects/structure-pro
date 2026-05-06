job "neo4j" {
  datacenters = ["dc1"]
  type        = "service"

  group "neo4j" {
    count = 1

    network {
      port "bolt" {
        static = 7687
        to     = 7687
      }
      port "http" {
        static = 7474
        to     = 7474
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "neo4j" {
      driver = "docker"

      config {
        image = "neo4j:4.4"
        ports = ["bolt"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "neo4j"
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
        name = "neo4j"
        tags = ["neo4j", "docker-compose-converted"]
        port = "bolt"
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
