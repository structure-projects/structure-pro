#!/bin/bash

# Structure Cloud Pro - 生成访问地址导航页面

cat > /tmp/structure-cloud-nav.html << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Structure Cloud Pro - 系统导航</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        h1 {
            text-align: center;
            color: white;
            margin-bottom: 40px;
            font-size: 2.5rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }
        .card-header {
            display: flex;
            align-items: center;
            margin-bottom: 16px;
        }
        .card-icon {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-right: 16px;
        }
        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #333;
        }
        .card-desc {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 16px;
        }
        .card-link {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            transition: opacity 0.3s;
        }
        .card-link:hover {
            opacity: 0.9;
        }
        .card-status {
            margin-top: 12px;
            padding: 8px 12px;
            border-radius: 4px;
            font-size: 0.85rem;
        }
        .status-green { background: #d4edda; color: #155724; }
        .status-blue { background: #d1ecf1; color: #0c5460; }
        .status-orange { background: #fff3cd; color: #856404; }
        .section-title {
            color: white;
            margin: 40px 0 20px 0;
            font-size: 1.5rem;
            border-bottom: 2px solid rgba(255,255,255,0.3);
            padding-bottom: 10px;
        }
        .creds {
            background: #f8f9fa;
            border-radius: 6px;
            padding: 12px;
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
            margin-top: 12px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Structure Cloud Pro</h1>
        
        <div class="section-title">🗄️ 基础设施服务</div>
        <div class="grid">
            <div class="card">
                <div class="card-header">
                    <div class="card-icon" style="background: #e3f2fd;">🔄</div>
                    <div class="card-title">Nacos</div>
                </div>
                <div class="card-desc">服务注册与发现、配置中心</div>
                <a href="http://localhost:8848/nacos" class="card-link" target="_blank">访问 Nacos</a>
                <div class="creds">用户: nacos / 密码: nacos</div>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <div class="card-icon" style="background: #e8f5e9;">🐰</div>
                    <div class="card-title">RabbitMQ</div>
                </div>
                <div class="card-desc">消息队列</div>
                <a href="http://localhost:15672" class="card-link" target="_blank">访问 RabbitMQ</a>
                <div class="creds">用户: guest / 密码: guest</div>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <div class="card-icon" style="background: #fff3e0;">🔴</div>
                    <div class="card-title">Redis</div>
                </div>
                <div class="card-desc">分布式缓存</div>
                <div class="card-status status-blue">redis-cli -p 6379</div>
            </div>
        </div>
        
        <div class="section-title">📊 可观测性服务</div>
        <div class="grid">
            <div class="card">
                <div class="card-header">
                    <div class="card-icon" style="background: #f3e5f5;">✈️</div>
                    <div class="card-title">SkyWalking</div>
                </div>
                <div class="card-desc">链路追踪与APM</div>
                <a href="http://localhost:8080" class="card-link" target="_blank">访问 SkyWalking</a>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <div class="card-icon" style="background: #e1bee7;">📈</div>
                    <div class="card-title">Prometheus</div>
                </div>
                <div class="card-desc">指标监控与告警</div>
                <a href="http://localhost:9090" class="card-link" target="_blank">访问 Prometheus</a>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <div class="card-icon" style="background: #fce4ec;">📉</div>
                    <div class="card-title">AlertManager</div>
                </div>
                <div class="card-desc">告警通知管理</div>
                <a href="http://localhost:9093" class="card-link" target="_blank">访问 AlertManager</a>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <div class="card-icon" style="background: #ede7f6;">📊</div>
                    <div class="card-title">Grafana</div>
                </div>
                <div class="card-desc">监控可视化</div>
                <a href="http://localhost:3000" class="card-link" target="_blank">访问 Grafana</a>
                <div class="creds">用户: admin / 密码: admin123</div>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <div class="card-icon" style="background: #e8eaf6;">🔍</div>
                    <div class="card-title">Elasticsearch</div>
                </div>
                <div class="card-desc">搜索引擎/日志存储</div>
                <a href="http://localhost:9200" class="card-link" target="_blank">访问 Elasticsearch</a>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <div class="card-icon" style="background: #e3f2fd;">📊</div>
                    <div class="card-title">Kibana</div>
                </div>
                <div class="card-desc">日志查询与可视化</div>
                <a href="http://localhost:5601" class="card-link" target="_blank">访问 Kibana</a>
            </div>
        </div>
        
        <div class="section-title">⚡ 流量控制与网关</div>
        <div class="grid">
            <div class="card">
                <div class="card-header">
                    <div class="card-icon" style="background: #fbe9e7;">🛡️</div>
                    <div class="card-title">Sentinel</div>
                </div>
                <div class="card-desc">限流熔断控制台</div>
                <a href="http://localhost:8858" class="card-link" target="_blank">访问 Sentinel</a>
                <div class="creds">用户: sentinel / 密码: sentinel</div>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <div class="card-icon" style="background: #fffde7;">🦍</div>
                    <div class="card-title">Kong Gateway</div>
                </div>
                <div class="card-desc">API网关管理</div>
                <a href="http://localhost:8001" class="card-link" target="_blank">访问 Kong Admin</a>
            </div>
        </div>
        
        <div class="section-title">🛠️ 运维工具</div>
        <div class="grid">
            <div class="card">
                <div class="card-header">
                    <div class="card-icon" style="background: #e0f2f1;">💻</div>
                    <div class="card-title">Docker</div>
                </div>
                <div class="card-desc">容器管理</div>
                <div class="card-status status-orange">docker ps</div>
            </div>
        </div>
    </div>
</body>
</html>
EOF

echo "================================================"
echo " 🌐 系统导航页面已生成！"
echo "================================================"
echo ""
echo "📄 文件路径：/tmp/structure-cloud-nav.html"
echo ""
echo "🚀 正在启动本地服务..."
if command -v open &> /dev/null; then
    open /tmp/structure-cloud-nav.html
elif command -v xdg-open &> /dev/null; then
    xdg-open /tmp/structure-cloud-nav.html
else
    python3 -m http.server 8000 --directory /tmp &
    echo ""
    echo "请在浏览器中打开：http://localhost:8000/structure-cloud-nav.html"
fi
