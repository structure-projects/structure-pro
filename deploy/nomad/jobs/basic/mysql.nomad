job "mysql" {
  datacenters = ["dc1"]
  type        = "service"

  group "mysql" {
    count = 1

    network {
      port "mysql" {
        static = 3306
        to     = 3306
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "mysql" {
      driver = "docker"

      config {
        image = "mysql:8.0.25"
        ports = ["mysql"]
        command = "--character-set-server=utf8mb4"
        args = ["--collation-server=utf8mb4_general_ci", "--explicit_defaults_for_timestamp=true", "--lower_case_table_names=1"]
        volumes = [
          "/opt/nomad/volumes/mysql:/var/lib/mysql"
        ]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "mysql"
        "MYSQL_ROOT_PASSWORD" = "password"
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
        name = "mysql"
        tags = ["mysql", "docker-compose-converted"]
        port = "mysql"
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