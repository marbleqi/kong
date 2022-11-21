#!/bin/bash

# 启动服务
kong start -c /data/config/kong.conf

# 生成一个临时日志文件
echo "" > /root/kong.log

# 追踪日志文件，并形成守护进程
tail -f /root/kong.log
