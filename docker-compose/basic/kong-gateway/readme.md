# 进入到上面已经安装好的实例中
docker exec -it kong-gateway bash
# 进入到/usr/local/kong目录
cd /usr/local/kong
# 生成秘钥对
kong hybrid gen_cert
# 退出容器
exit
# 将生成的秘钥对拷贝到宿主机上
mkdir -p /data/kong/crt/
docker cp kong-gateway:/usr/local/kong/cluster.crt /data/kong/crt/
docker cp kong-gateway:/usr/local/kong/cluster.key /data/kong/crt/



