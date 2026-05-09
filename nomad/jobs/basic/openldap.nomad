job "openldap" {
  datacenters = ["dc1"]
  type        = "service"

  group "openldap" {
    count = 1

    network {
      port "ldap" {
        static = 389
        to     = 389
      }
      port "ldaps" {
        static = 636
        to     = 636
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    task "openldap" {
      driver = "docker"

      config {
        image = "osixia/openldap:1.5.0"
        ports = ["ldap"]
      }

      env {
        "CREATED_BY" = "Nomad"
        "SERVICE_NAME" = "openldap"
      }

      resources {
        cpu    = 500
        memory = 1024
      }

      logs {
        max_files     = 5
        max_file_size = 10
      }

      service {
        name = "openldap"
        tags = ["openldap", "docker-compose-converted"]
        port = "ldap"
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
