datacenter = "dc1"
data_dir  = "/opt/nomad/data"
log_level = "INFO"

server {
  enabled          = true
  bootstrap_expect = 3
  server_join {
    retry_join = ["172.16.48.1:4647", "172.16.48.135:4647", "172.16.48.136:4647"]
  }
}

raft_multiplier = 1

network {
  interface = "eth0"
  port      = "http" {
    static = 4646
    to     = 4646
  }
}

consul {
  address = "127.0.0.1:8500"
}