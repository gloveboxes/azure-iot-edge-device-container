# FROM arm32v7/ubuntu:18.04
FROM balenalib/raspberrypi3:stretch
 
RUN apt-get update  && apt-get install -y \
     iptables libip6tc0 libiptc0 libnetfilter-conntrack3 libnfnetlink0 libxtables12 systemd nano \
#    apt-transport-https \
#    ca-certificates \
#    curl \
#    wget \
#    gnupg \
#    lsb-release \
#    jq \
#    net-tools \
#    iproute2 \
#    systemd \
#    build-essential \
#    python \
#    python-dev \
#    libffi-dev \
#    libssl1.0.0 \
#    libssl-dev \
#    iptables && \
&&    rm -rf /var/lib/apt/lists/*

# RUN wget https://azurecliprod.blob.core.windows.net/install.py -O azure-cli-install.py && \
#    chmod +x azure-cli-install.py && \
#    yes "" | ./azure-cli-install.py

# RUN cp /root/bin/az /usr/local/bin && \
#    az extension add --name azure-cli-iot-ext

RUN curl -L https://aka.ms/moby-engine-armhf-latest -o moby_engine.deb && dpkg -i ./moby_engine.deb && rm ./moby_engine.deb && \
    curl -L https://aka.ms/moby-cli-armhf-latest -o moby_cli.deb && dpkg -i ./moby_cli.deb && rm ./moby_cli.deb

RUN curl -L https://aka.ms/libiothsm-std-linux-armhf-latest -o libiothsm-std.deb && sudo dpkg -i ./libiothsm-std.deb && rm ./libiothsm-std.deb && \
    curl -L https://aka.ms/iotedged-linux-armhf-latest -o iotedge.deb && sudo dpkg -i ./iotedge.deb && dpkg -i ./iotedge.deb && rm ./iotedge.deb

COPY edge-provision.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/edge-provision.sh

VOLUME /var/lib/docker

EXPOSE 2375
EXPOSE 15580
EXPOSE 15581

RUN ln -s /usr/lib/arm-linux-gnueabihf/libcrypto.so.1.0.0 /lib/arm-linux-gnueabihf/libcrypto.so.1.0.2 && \
    ln -s /usr/lib/arm-linux-gnueabihf/libssl.so.1.0.0 /lib/arm-linux-gnueabihf/libssl.so.1.0.2

ENTRYPOINT ["bash", "edge-provision.sh"]

CMD []
