# Use an official GDAL image as the base image
ARG BUILD_IMAGE_NAME

FROM ${BUILD_IMAGE_NAME} as build


# 设置非交互式环境变量
ENV DEBIAN_FRONTEND=noninteractive

# 设置时区
RUN apt-get --allow-releaseinfo-change update \
    && apt-get install -y tzdata chromium-driver git python3-pip --fix-missing\
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file to the container
COPY ./requirements.txt /tmp/requirements.txt

RUN cd /tmp \
#    && pip config --global set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
#    && pip config --global set install.trusted-host pypi.tuna.tsinghua.edu.cn \
    && pip install pip -U \
    && PIP_ROOT_USER_ACTION=ignore pip install \
    --disable-pip-version-check \
    --no-cache-dir \
     -r ./requirements.txt \
    && rm -rf /tmp/*


ENV TZ=Asia/Shanghai
ENV LANG C.UTF-8

CMD ["python"]

