datacenter = "dc1"
data_dir  = "/opt/nomad/data"
log_level = "INFO"

bind_addr = "0.0.0.0"

ports {
  http = 5656
}

# ==========
# Client 配置
# ==========
client {
  enabled = true
  servers = ["172.16.48.1:4647"]
  node_class = "compute"

  network_interface = "eth0"

  # Docker / exec / raw_exec 默认已启用，无需 enabled_task_drivers
  options = {
    "docker.privileged" = "false"
  }

  # 预留资源（强烈建议）
  reserved {
    cpu    = 500    # MHz
    memory = 1024   # MB
    disk   = 1024   # MB
  }
}

# ==========
# Consul 集成
# ==========
consul {
  address = "127.0.0.1:8500"
}