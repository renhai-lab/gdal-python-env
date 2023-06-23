# Use an official GDAL image as the base image
ARG BUILD_IMAGE_NAME

FROM ${BUILD_IMAGE_NAME} as build

# Copy the requirements.txt file to the container
COPY ./requirements.txt /tmp/requirements.txt

# 设置非交互式环境变量
ENV DEBIAN_FRONTEND=noninteractive

# 设置时区
RUN apt-get --allow-releaseinfo-change update \
    && apt-get install -y \
    tzdata \
    git \
    python3-pip \
    wget curl \
    chromium-driver chromium \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime jq\
    && dpkg-reconfigure -f noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean


# # Install Chrome
# RUN cd /tmp \
#     && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
#     && apt-get -f install -y --force-yes \
#     && dpkg -i google-chrome-stable_current_amd64.deb

# # Install Chromedriver
# RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` \
#     && wget -N http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip -P ~/Downloads \
#     && unzip -o ~/Downloads/chromedriver_linux64.zip -d ~/Downloads \
#     && chmod +x ~/Downloads/chromedriver \
#     && rm -f /usr/local/share/chromedriver \
#     && rm -f /usr/local/bin/chromedriver \
#     && rm -f /usr/bin/chromedriver \
#     && mv -f ~/Downloads/chromedriver /usr/local/share/chromedriver \
#     && ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver \
#     && ln -s /usr/local/share/chromedriver /usr/bin/chromedriver
    

RUN cd /tmp \
    && pip install pip -U \
    && PIP_ROOT_USER_ACTION=ignore pip install \
    --disable-pip-version-check \
    --no-cache-dir \
     -r ./requirements.txt \
    && rm -rf /tmp/*

# Set the working directory in the container
WORKDIR /app

ENV TZ=Asia/Shanghai
ENV LANG C.UTF-8

CMD ["python"]

