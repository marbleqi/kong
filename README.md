# 项目说明

使用官方 KONG 安装包，制作自用的 KONG 镜像

注：需要编写自定义的配置文件 kong.conf 并挂载到容器内的/data/config 目录下

<font size="4" face="宋体" color="#ff0000">**如果不挂载该目录，容器将启动失败**</font>

kong.conf 文件内容格式如下

```conf
proxy_listen = 0.0.0.0:80, 0.0.0.0:443 ssl
admin_listen = 0.0.0.0:8001, 127.0.0.1:8444 ssl
database = postgres
; 数据库地址
pg_host = 172.18.88.2
pg_port = 5432
pg_database = kong
pg_user = kong
pg_password = kong

plugins = bundled, http301https, redirect

```

# 部署安装

注：服务器上已有 Docker 运行环境

## 准备数据库容器

```bash
# 创建docker虚拟桥接网络
docker network create --driver bridge --subnet=172.18.88.0/24 --gateway 172.18.88.1 demo-net

# 拉取数据库镜像
docker pull postgres

# 启动容器
docker run \
-dit \
--name demo-postgres \
--hostname demo-postgres \
-e POSTGRES_PASSWORD=postgres \
-v /data/demo/postgres:/var/lib/postgresql/data \
--network demo-net \
--ip 172.18.88.2 \
postgres

# 进入容器
docker exec -it demo-postgres bash

# 进入postgres数据库命令行（输入该命令后，会提示输入密码，输入默认密码postgres）
psql -h demo-postgres -U postgres

# 命令行下创建kong用户并设置用户密码
CREATE USER kong with password 'kong';
# 创建数据库kong
CREATE DATABASE kong;
# 关联数据库kong与用户kong
GRANT ALL PRIVILEGES ON DATABASE kong TO kong;

# 退出命令行
exit
# 退出容器
exit

# 数据库容器已完成初始化，删除后重新启动
docker rm -f demo-postgres

# 再次启动容器时，不用再传入初始密码
docker run \
-dit \
--name demo-postgres \
--hostname demo-postgres \
-v /data/demo/postgres:/var/lib/postgresql/data \
--network demo-net \
--ip 172.18.88.2 \
postgres

```

## 启动 KONG 容器

```bash
# 生成配置文件
mkdir -p /data/config
tee /data/config/kong.conf <<-'EOF'
proxy_listen = 0.0.0.0:80, 0.0.0.0:443 ssl
admin_listen = 0.0.0.0:8001, 127.0.0.1:8444 ssl
database = postgres
pg_host = 172.18.88.2
pg_port = 5432
pg_database = kong
pg_user = kong
pg_password = kong

plugins = bundled, http301https, redirect
EOF

# 首次启动初始化数据库（需传入变量mode=init）
docker run \
--rm \
--name demo-kong \
--hostname demo-kong \
-e mode=init \
-v /data/config:/data/config \
--network demo-net \
--ip 172.18.88.31 \
registry.cn-beijing.aliyuncs.com/marbleqi/kong:3.0.1 \

# 重新生成容器（可按需映射端口到宿主机端口）
docker run \
-dit \
--name demo-kong \
--hostname demo-kong \
-v /data/config:/data/config \
--network demo-net \
--ip 172.18.88.31 \
-p 80:80 \
-p 443:443 \
registry.cn-beijing.aliyuncs.com/marbleqi/kong:3.0.1

```
