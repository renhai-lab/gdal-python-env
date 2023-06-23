# Use an official GDAL image as the base image
ARG BUILD_IMAGE_NAME

FROM ${BUILD_IMAGE_NAME} as build

# Set the working directory in the container
WORKDIR /app

# 设置非交互式环境变量
ENV DEBIAN_FRONTEND=noninteractive

# 设置时区
RUN apt-get --allow-releaseinfo-change update \
    && apt-get install -y tzdata git python3-pip --fix-missing\
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \

RUN cd /tmp \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && sudo apt-get update \
    && sudo apt install ./google-chrome-stable_current_amd64.deb \
    && wget https://registry.npmmirror.com/binary.html?path=chromedriver/108.0.5359.71/chromedriver_linux64.zip \
    && sudo unzip chromedriver_linux64.zip -d /usr/bin/chromedriver \
    && sudo chmod +x /usr/bin/chromedriver
    

# Copy the requirements.txt file to the container
COPY ./requirements.txt /tmp/requirements.txt

RUN 
#    && pip config --global set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
#    && pip config --global set install.trusted-host pypi.tuna.tsinghua.edu.cn \
    pip install pip -U \
    && PIP_ROOT_USER_ACTION=ignore pip install \
    --disable-pip-version-check \
    --no-cache-dir \
     -r ./requirements.txt \
    && rm -rf /tmp/*


ENV TZ=Asia/Shanghai
ENV LANG C.UTF-8

CMD ["python"]

