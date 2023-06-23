# gdal-python-env
从[官方gdal镜像](https://hub.docker.com/r/osgeo/gdal/tags)构建gdal的自用python3.10环境，安装的python包见requirements.txt。

## 用法：

### 1 拉取 pull

```bash
docker pull renhai/python-env:ubuntu-full-latest # 完整版，约1.1G
# 或者
docker pull renhai/python-env:ubuntu-small-latest # 精简版，约0.3G
```

### 2 使用 

`docker compose up --build`

docker-compose.yml 示例

```bash
version: "3"

services:
  python:
    image: renhai/gdal-python-env-small:latest # or renhai/gdal-python-env-full:latest
    container_name: container_name
    network_mode: "bridge"
    environment:
      - SET_CONTAINER_TIMEZONE=true
      - CONTAINER_TIMEZONE=Asia/Shanghai
    volumes:
      - "./:/app/"
#    restart: on-failure
    command: python3 run.py
```

### 3 安装环境

1. `docker ps -a`查看 容器的id
2. `docker attach 容器的id`
3. pip install package 
