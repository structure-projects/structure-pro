datacenter = "dc1"
data_dir  = "/opt/nomad/data"
log_level = "INFO"

client {
  enabled = true

  options {
    "driver.raw_exec" = "1"
    "docker.enable_pull" = "true"
  }

  server_join {
    retry_join = ["172.16.48.1:4647", "172.16.48.135:4647", "172.16.48.136:4647"]
  }
}

network {
  interface = "eth0"
}

consul {
  address = "127.0.0.1:8500"
}