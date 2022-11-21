# 引入基础镜像
FROM centos:7

# 升级软件包版本
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && yum install -y epel-release && yum -y update

# 安装kong
RUN yum install -y wget net-tools \
  && wget https://download.konghq.com/gateway-3.x-centos-7/Packages/k/kong-3.0.1.el7.amd64.rpm \
  && yum -y install kong-3.0.1.el7.amd64.rpm \
  && \rm -rf kong-3.0.1.el7.amd64.rpm \
  && mkdir -p /data/config \
  && echo "alias ll='ls $LS_OPTIONS -l'" >> /root/.bashrc \
  && mkdir -p /usr/local/kong/logs \
  # 将日志输出到控制台
  && ln -sf /dev/stdout /usr/local/kong/logs/access.log \
  && ln -sf /dev/stdout /usr/local/kong/logs/admin_access.log \
  && ln -sf /dev/stderr /usr/local/kong/logs/error.log

# 引入插件
COPY plugins /usr/local/share/lua/5.1/kong/plugins

# 引入配置文件数据卷
VOLUME /data/config

COPY entrypoint.sh .

ENTRYPOINT ["/entrypoint.sh"]

RUN chmod 755 ./entrypoint.sh

STOPSIGNAL SIGQUIT

HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health

CMD ["./entrypoint.sh"]
