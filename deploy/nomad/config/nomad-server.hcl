datacenter = "dc1"
data_dir  = "/opt/nomad/data"
log_level = "INFO"

bind_addr = "0.0.0.0"

acl {
  enabled = true
}

addresses {
  http = "0.0.0.0"
  rpc  = "0.0.0.0"
  serf = "0.0.0.0"
}

ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}

server {
  enabled          = true
  bootstrap_expect = 3

  server_join {
    retry_join = [
      "172.16.48.1:4648",
      "172.16.48.135:4648",
      "172.16.48.136:4648"
    ]
  }
}

consul {
  address = "127.0.0.1:8500"
}