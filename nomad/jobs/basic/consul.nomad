job "consul" {
  datacenters = ["dc1"]
  type = "system"

  group "consul" {
    network {
      port "http" {
        static = 8500
        to = 8500
      }
      port "dns" {
        static = 8600
        to = 8600
      }
      port "serf-lan" {
        static = 8301
        to = 8301
      }
      port "serf-wan" {
        static = 8302
        to = 8302
      }
      port "server" {
        static = 8300
        to = 8300
      }
    }

    task "consul" {
      driver = "docker"

      config {
        image = "hashicorp/consul:1.17"
        ports = ["http", "dns", "serf-lan", "serf-wan", "server"]
        command = "agent"
        args = [
          "-server",
          "-bootstrap-expect=3",
          "-ui",
          "-client=0.0.0.0",
          "-data-dir=/consul/data",
          "-retry-join=172.16.48.1",
          "-retry-join=172.16.48.135",
          "-retry-join=172.16.48.136"
        ]
      }

      resources {
        cpu = 1000
        memory = 1024
      }

      logs {
        max_files = 5
        max_file_size = 10
      }
    }
  }
}
