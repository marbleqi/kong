#!/bin/bash

# 判断传入参数mode是否为init
if [ ${mode} == "init" ]
then
  echo "初始化数据库"
  kong migrations bootstrap -c /data/config/kong.conf
else
  # 启动服务
  kong start -c /data/config/kong.conf

  # 生成一个临时日志文件
  echo "" > /root/kong.log

  # 追踪日志文件，并形成守护进程
  tail -f /root/kong.log
fi