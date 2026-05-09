#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
批量生成 Serverless 配置文件
"""
import os
import yaml
from pathlib import Path


# 服务配置
SERVICES = {
    # apps 目录
    "apps/content-manager-system": {
        "image": "registry.cn-hangzhou.aliyuncs.com/structured/structured-content-manager-system:latest",
        "port": 8080,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "Content Manager System Service",
        "env_vars": {
            "JAVA_OPTS": "-Xms256m -Xmx1024m",
            "PARAMS": "-Dfile.encoding=UTF-8 -Dspring.profiles.active=pro -Djava.security.egd=file:/dev/./urandom -Duser.timezone=Asia/Shanghai"
        }
    },
    "apps/manager-system": {
        "image": "registry.cn-hangzhou.aliyuncs.com/structured/structured-manager-system:latest",
        "port": 8080,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "Manager System Service",
        "env_vars": {
            "JAVA_OPTS": "-Xms256m -Xmx1024m",
            "PARAMS": "-Dfile.encoding=UTF-8 -Dspring.profiles.active=pro -Djava.security.egd=file:/dev/./urandom -Duser.timezone=Asia/Shanghai"
        }
    },
    
    # atom 目录
    "atom/admin-center": {
        "image": "registry.cn-hangzhou.aliyuncs.com/structured/structured-admin-center:latest",
        "port": 8080,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "Admin Center Service",
        "env_vars": {
            "APP_PATH": "/app/cloud/admin-center.jar",
            "JAVA_OPTS": "-Xms256m -Xmx1024m",
            "PARAMS": "-Dfile.encoding=UTF-8 -Dspring.profiles.active=pro -Djava.security.egd=file:/dev/./urandom -Duser.timezone=Asia/Shanghai"
        }
    },
    "atom/content-center": {
        "image": "registry.cn-hangzhou.aliyuncs.com/structured/structured-content-center:latest",
        "port": 8080,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "Content Center Service",
        "env_vars": {
            "APP_PATH": "/app/cloud/app.jar",
            "JAVA_OPTS": "-Xms256m -Xmx1024m",
            "PARAMS": "-Dfile.encoding=UTF-8 -Dspring.profiles.active=pro -Djava.security.egd=file:/dev/./urandom -Duser.timezone=Asia/Shanghai"
        }
    },
    "atom/job-center": {
        "image": "registry.cn-hangzhou.aliyuncs.com/structured/structured-job-center:latest",
        "port": 8080,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "Job Center Service",
        "env_vars": {
            "JAVA_OPTS": "-Xms256m -Xmx1024m",
            "PARAMS": "-Dfile.encoding=UTF-8 -Dspring.profiles.active=prod -Djava.security.egd=file:/dev/./urandom -Duser.timezone=Asia/Shanghai"
        }
    },
    "atom/oauth-center": {
        "image": "registry.cn-hangzhou.aliyuncs.com/structured/structured-oauth-center:latest",
        "port": 8080,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "OAuth Center Service",
        "env_vars": {
            "APP_PATH": "/app/cloud/app.jar",
            "JAVA_OPTS": "-Xms256m -Xmx1024m",
            "PARAMS": "-Dfile.encoding=UTF-8 -Dspring.profiles.active=pro -Djava.security.egd=file:/dev/./urandom -Duser.timezone=Asia/Shanghai"
        }
    },
    "atom/user-center": {
        "image": "registry.cn-hangzhou.aliyuncs.com/structured/structured-user-center:latest",
        "port": 8080,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "User Center Service",
        "env_vars": {
            "APP_PATH": "/app/cloud/app.jar",
            "JAVA_OPTS": "-Xms256m -Xmx1024m",
            "PARAMS": "-Dfile.encoding=UTF-8 -Dspring.profiles.active=pro -Djava.security.egd=file:/dev/./urandom -Duser.timezone=Asia/Shanghai"
        }
    },
    
    # basic 目录 - 基础服务
    "basic/clickhouse": {
        "image": "clickhouse/clickhouse-server:latest",
        "port": 8123,
        "cpu": 2,
        "memory": 4096,
        "timeout": 600,
        "description": "ClickHouse Database Service",
        "env_vars": {}
    },
    "basic/elasticsearch": {
        "image": "elasticsearch:8.12.0",
        "port": 9200,
        "cpu": 2,
        "memory": 4096,
        "timeout": 600,
        "description": "Elasticsearch Search Engine",
        "env_vars": {
            "discovery.type": "single-node"
        }
    },
    "basic/emqx": {
        "image": "emqx/emqx:latest",
        "port": 1883,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "EMQX MQTT Broker",
        "env_vars": {}
    },
    "basic/influxdb": {
        "image": "influxdb:latest",
        "port": 8086,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "InfluxDB Time Series Database",
        "env_vars": {}
    },
    "basic/kafka": {
        "image": "confluentinc/cp-kafka:latest",
        "port": 9092,
        "cpu": 2,
        "memory": 4096,
        "timeout": 600,
        "description": "Apache Kafka Message Queue",
        "env_vars": {
            "KAFKA_ZOOKEEPER_CONNECT": "localhost:2181"
        }
    },
    "basic/kong-gateway": {
        "image": "kong:latest",
        "port": 8000,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "Kong API Gateway",
        "env_vars": {}
    },
    "basic/mariadb": {
        "image": "mariadb:latest",
        "port": 3306,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "MariaDB Database",
        "env_vars": {}
    },
    "basic/memcached": {
        "image": "memcached:latest",
        "port": 11211,
        "cpu": 1,
        "memory": 1024,
        "timeout": 300,
        "description": "Memcached Cache Service",
        "env_vars": {}
    },
    "basic/minio": {
        "image": "minio/minio:latest",
        "port": 9000,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "MinIO Object Storage",
        "env_vars": {}
    },
    "basic/mongodb": {
        "image": "mongo:latest",
        "port": 27017,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "MongoDB NoSQL Database",
        "env_vars": {}
    },
    "basic/mssql": {
        "image": "mcr.microsoft.com/mssql/server:2022-latest",
        "port": 1433,
        "cpu": 2,
        "memory": 4096,
        "timeout": 600,
        "description": "Microsoft SQL Server",
        "env_vars": {
            "ACCEPT_EULA": "Y"
        }
    },
    "basic/mysql": {
        "image": "mysql:8.0",
        "port": 3306,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "MySQL Database",
        "env_vars": {}
    },
    "basic/mysql5": {
        "image": "mysql:5.7",
        "port": 3306,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "MySQL 5.7 Database",
        "env_vars": {}
    },
    "basic/nacos": {
        "image": "nacos/nacos-server:latest",
        "port": 8848,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "Nacos Service Discovery",
        "env_vars": {
            "MODE": "standalone"
        }
    },
    "basic/neo4j": {
        "image": "neo4j:latest",
        "port": 7474,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "Neo4j Graph Database",
        "env_vars": {}
    },
    "basic/nginx": {
        "image": "nginx:latest",
        "port": 80,
        "cpu": 1,
        "memory": 1024,
        "timeout": 300,
        "description": "Nginx Web Server",
        "env_vars": {}
    },
    "basic/openldap": {
        "image": "osixia/openldap:latest",
        "port": 389,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "OpenLDAP Directory Service",
        "env_vars": {}
    },
    "basic/postgres": {
        "image": "postgres:latest",
        "port": 5432,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "PostgreSQL Database",
        "env_vars": {}
    },
    "basic/postgresql": {
        "image": "postgres:latest",
        "port": 5432,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "PostgreSQL Database",
        "env_vars": {}
    },
    "basic/prometheus": {
        "image": "prom/prometheus:latest",
        "port": 9090,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "Prometheus Monitoring",
        "env_vars": {}
    },
    "basic/rabbitmq": {
        "image": "rabbitmq:management",
        "port": 5672,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "RabbitMQ Message Broker",
        "env_vars": {}
    },
    "basic/rabbitmq3": {
        "image": "rabbitmq:3-management",
        "port": 5672,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "RabbitMQ 3 Message Broker",
        "env_vars": {}
    },
    "basic/redis": {
        "image": "redis:latest",
        "port": 6379,
        "cpu": 1,
        "memory": 1024,
        "timeout": 300,
        "description": "Redis Cache",
        "env_vars": {}
    },
    "basic/rocketmq": {
        "image": "apache/rocketmq:latest",
        "port": 9876,
        "cpu": 2,
        "memory": 4096,
        "timeout": 600,
        "description": "RocketMQ Message Queue",
        "env_vars": {}
    },
    "basic/seata": {
        "image": "seataio/seata-server:latest",
        "port": 8091,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "Seata Distributed Transaction",
        "env_vars": {}
    },
    "basic/sentinel-dashboard": {
        "image": "sentinel-dashboard:latest",
        "port": 8858,
        "cpu": 1,
        "memory": 2048,
        "timeout": 300,
        "description": "Sentinel Dashboard",
        "env_vars": {}
    },
    
    # view 目录
    "view/web-pc-cms-ui": {
        "image": "registry.cn-hangzhou.aliyuncs.com/structured/web-pc-cms-ui:latest",
        "port": 80,
        "cpu": 1,
        "memory": 1024,
        "timeout": 300,
        "description": "Web PC CMS UI",
        "env_vars": {}
    },
    "view/web-pc-manager-ui": {
        "image": "registry.cn-hangzhou.aliyuncs.com/structured/web-pc-manager-ui:latest",
        "port": 80,
        "cpu": 1,
        "memory": 1024,
        "timeout": 300,
        "description": "Web PC Manager UI",
        "env_vars": {}
    },
    
    # dev-ops-tools 目录
    "dev-ops-tools/it-tools": {
        "image": "corentinth/it-tools:latest",
        "port": 80,
        "cpu": 1,
        "memory": 1024,
        "timeout": 300,
        "description": "IT Tools",
        "env_vars": {}
    }
}


def generate_aliyun_fc(service_path, config):
    """生成阿里云 FC 配置"""
    service_name = service_path.split("/")[-1]
    
    env_vars_str = ""
    for key, value in config["env_vars"].items():
        env_vars_str += f"        {key}: {value}\n"
    
    content = f"""edition: 3.0.0
name: {service_name}-service
access: default
vars:
  region: cn-hangzhou
  service:
    name: {service_name}
    description: {config['description']}
    internetAccess: true
  function:
    name: {service_name}
    description: {config['description']}
    runtime: custom-container
    cpu: {config['cpu']}
    memorySize: {config['memory']}
    timeout: {config['timeout']}
    caPort: {config['port']}
    customContainerConfig:
      image: {config['image']}
      command: []
      args: []
      accelerationType: Default
      webServerMode: true
  triggers:
    - name: httpTrigger
      type: http
      qualifier: LATEST
      description: HTTP Trigger
      httpTriggerConfig:
        authType: anonymous
        methods:
          - GET
          - POST
          - PUT
          - DELETE
          - HEAD
          - PATCH
          - OPTIONS
resources:
  {service_name}:
    component: fc3
    props:
      region: ${{vars.region}}
      description: ${{vars.service.description}}
      internetAccess: ${{vars.service.internetAccess}}
      role: acs:ram::{{accountId}}:role/AliyunFCDefaultRole
      logConfig:
        enableInstanceMetrics: false
        enableRequestMetrics: false
      vpcConfig:
        vpcId: ''
        vswitchIds: []
        securityGroupId: ''
      nasConfig:
        userId: -1
        groupId: -1
        mountPoints: []
      functionName: ${{vars.function.name}}
      description: ${{vars.function.description}}
      runtime: ${{vars.function.runtime}}
      cpu: ${{vars.function.cpu}}
      memorySize: ${{vars.function.memorySize}}
      timeout: ${{vars.function.timeout}}
      codeUri: ./
      caPort: ${{vars.function.caPort}}
      customContainerConfig: ${{vars.function.customContainerConfig}}
      environmentVariables:
{env_vars_str}
      triggers: ${{vars.triggers}}
"""
    return content


def generate_tencent_scf(service_path, config):
    """生成腾讯云 SCF 配置"""
    service_name = service_path.split("/")[-1]
    
    env_vars_str = ""
    for key, value in config["env_vars"].items():
        env_vars_str += f"      {key}: {value}\n"
    
    content = f"""appId: {{appId}}
component: scf
name: {service_name}
stage: prod
org: {{org}}
app: {service_name}-app
inputs:
  name: {service_name}
  src:
    src: ./
    exclude:
      - .env
  region: ap-guangzhou
  runtime: CustomContainer
  description: {config['description']}
  namespace: default
  type: web
  memorySize: {config['memory']}
  timeout: {config['timeout']}
  initTimeout: 300
  cls:
    logsetId: ''
    topicId: ''
  layers: []
  environment:
    variables:
{env_vars_str}
  containerConf:
    image: {config['image']}
    containerPort: {config['port']}
    imageTag: latest
  vpcConfig:
    vpcId: ''
    subnetId: ''
  triggers:
    - type: apigw
      parameters:
        name: {service_name}-apigw
        protocols:
          - http
          - https
        serviceName: serverless
        description: API Gateway trigger for {service_name}
        environment: release
        endPoints:
          - path: /
            method: ANY
"""
    return content


def generate_huawei_functiongraph(service_path, config):
    """生成华为云 FunctionGraph 配置"""
    service_name = service_path.split("/")[-1]
    
    env_vars_str = ""
    for key, value in config["env_vars"].items():
        env_vars_str += f"    {key}: {value}\n"
    
    content = f"""name: {service_name}
description: {config['description']}
region: cn-north-4
project: {{project}}
function:
  name: {service_name}
  description: {config['description']}
  runtime: CustomImage
  handler: ''
  memorySize: {config['memory']}
  timeout: {config['timeout']}
  codeType: CustomImage
  customImage:
    image: {config['image']}
    port: {config['port']}
  environmentVariables:
{env_vars_str}
  vpcId: ''
  subnetId: ''
  enterpriseProjectId: default
  agency: ''
  xrole: ''
  concurrency:
    strategy: dynamic
    maxConcurrent: 100
  triggers:
    - triggerType: APIG
      eventData:
        auth: IAM
        name: {service_name}-apig
        protocol: HTTP
        timeout: 5000
"""
    return content


def main():
    """主函数"""
    base_path = Path("/Users/chuck/projects/structure-projects/structure-cloud-pro/deploy/serverless-fc")
    
    for service_path, config in SERVICES.items():
        print(f"Generating configs for {service_path}...")
        service_dir = base_path / service_path
        
        # 阿里云 FC
        aliyun_content = generate_aliyun_fc(service_path, config)
        with open(service_dir / "aliyun-fc.yaml", "w", encoding="utf-8") as f:
            f.write(aliyun_content)
        
        # 腾讯云 SCF
        tencent_content = generate_tencent_scf(service_path, config)
        with open(service_dir / "tencent-scf.yaml", "w", encoding="utf-8") as f:
            f.write(tencent_content)
        
        # 华为云 FunctionGraph
        huawei_content = generate_huawei_functiongraph(service_path, config)
        with open(service_dir / "huawei-functiongraph.yaml", "w", encoding="utf-8") as f:
            f.write(huawei_content)
    
    print("All configs generated successfully!")


if __name__ == "__main__":
    main()
