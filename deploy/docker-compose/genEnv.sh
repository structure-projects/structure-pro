#!/bin/bash
# env_generator.sh - 环境变量生成脚本

set -e

# 配置文件路径
CONFIG_FILE=".env"
BACKUP_FILE=".env.backup"

# 生成随机密码函数
generate_password() {
    local length=${1:-16}
    openssl rand -base64 48 | tr -d "=+/" | cut -c1-$length
}

# 生成随机密钥函数
generate_secret_key() {
    local length=${1:-32}
    openssl rand -hex $length
}

# 备份现有配置文件
backup_config() {
    if [ -f "$CONFIG_FILE" ]; then
        cp "$CONFIG_FILE" "$BACKUP_FILE"
        echo "已备份现有配置到 $BACKUP_FILE"
    fi
}

# 生成环境变量配置
generate_env_vars() {
    cat > "$CONFIG_FILE" << EOF
# 自动生成的环境变量配置
# 生成时间: $(date)

# 数据库配置
DB_HOST=db_server
DB_PORT=3306
DB_NAME=
DB_USER=root
DB_PASSWORD=$(generate_password 20)

# API密钥
API_KEY=$(generate_secret_key 32)
JWT_SECRET=$(generate_secret_key 64)

# 应用配置
APP_ENV=production
APP_DEBUG=false
APP_KEY=$(generate_secret_key 32)

# Redis配置
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_PASSWORD=$(generate_password 16)

# MinIO配置
MINIO_ACCESS_KEY=$(generate_secret_key 16)
MINIO_SECRET_KEY=$(generate_secret_key 32)

# 其他服务密钥
ENCRYPTION_KEY=$(generate_secret_key 32)
SESSION_SECRET=$(generate_secret_key 32)

EOF

    echo "环境变量配置已生成到 $CONFIG_FILE"
}

# 交互式生成特定变量
interactive_generate() {
    echo "交互式环境变量生成器"
    echo "===================="

    read -p "请输入数据库主机 (默认: db_server): " db_host
    db_host=${db_host:-db_server}

    read -p "请输入数据库端口 (默认: 3306): " db_port
    db_port=${db_port:-3306}

    read -p "请输入数据库用户名 (默认: root): " db_user
    db_user=${db_user:-root}

    echo "正在生成配置..."

    cat > "$CONFIG_FILE" << EOF
# 交互式生成的环境变量配置
# 生成时间: $(date)

# 数据库配置
DB_HOST=${db_host}
DB_PORT=${db_port}
DB_USER=${db_user}
DB_PASSWORD=$(generate_password 20)

# API密钥
API_KEY=$(generate_secret_key 32)
JWT_SECRET=$(generate_secret_key 64)
APP_KEY=$(generate_secret_key 32)

# MinIO配置
MINIO_ACCESS_KEY=$(generate_secret_key 16)
MINIO_SECRET_KEY=$(generate_secret_key 32)

EOF

    echo "配置已生成到 $CONFIG_FILE"
}

# 显示帮助信息
show_help() {
    echo "环境变量生成脚本"
    echo "用法: $0 [选项]"
    echo "选项:"
    echo "  -a, --auto     自动生成所有配置 (默认)"
    echo "  -i, --interactive  交互式生成配置"
    echo "  -b, --backup   备份当前配置"
    echo "  -h, --help     显示帮助信息"
    echo ""
    echo "示例:"
    echo "  $0                 # 自动生成配置"
    echo "  $0 -i              # 交互式生成"
    echo "  $0 --backup        # 备份当前配置"
}

# 主程序逻辑
main() {
    case "${1:-}" in
        -a|--auto)
            backup_config
            generate_env_vars
            ;;
        -i|--interactive)
            backup_config
            interactive_generate
            ;;
        -b|--backup)
            backup_config
            ;;
        -h|--help)
            show_help
            ;;
        "")
            backup_config
            generate_env_vars
            ;;
        *)
            echo "未知选项: $1"
            show_help
            exit 1
            ;;
    esac
}

# 执行主程序
main "$@"
