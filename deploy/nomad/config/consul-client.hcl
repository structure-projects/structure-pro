datacenter = "dc1"
data_dir = "/opt/consul/data"

client {
  enabled = true
  server_join {
    retry_join = ["172.16.48.1:8301", "172.16.48.135:8301", "172.16.48.136:8301"]
  }
}

ui {
  enabled = true
}

client_addr = "0.0.0.0"
bind_addr = "{{ GetInterfaceIP \"eth0\" }}"
