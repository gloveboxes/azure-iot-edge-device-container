# https://docs.microsoft.com/en-us/azure/iot-edge/how-to-install-iot-edge-linux-arm
# https://github.com/Azure/azure-iotedge/releases
# https://github.com/Azure/iotedge/issues/13
# https://github.com/Azure/iot-edge-v1/issues/642
# docker run -d  --name iotedge  --privileged --device=/dev/video0:/dev/video0 --device=/dev/snd:/dev/snd -e connectionString='<Your connection String>' glovebox/azure-iot-edge-device-container

FROM balenalib/raspberrypi3:stretch

RUN apt-get update && apt-get install -y \
     iptables libip6tc0 libiptc0 libnetfilter-conntrack3 libnfnetlink0 libxtables12 systemd nano && \ 
rm -rf /var/lib/apt/lists/*

RUN curl -L https://aka.ms/moby-engine-armhf-latest -o moby_engine.deb && dpkg -i ./moby_engine.deb && rm ./moby_engine.deb &&
     curl -L https://aka.ms/moby-cli-armhf-latest -o moby_cli.deb && dpkg -i ./moby_cli.deb && rm ./moby_cli.deb

RUN curl -L https://aka.ms/libiothsm-std-linux-armhf-latest -o libiothsm-std.deb && sudo dpkg -i ./libiothsm-std.deb && rm ./libiothsm-std.deb &&
     curl -L https://aka.ms/iotedged-linux-armhf-latest -o iotedge.deb && sudo dpkg -i ./iotedge.deb && dpkg -i ./iotedge.deb && rm ./iotedge.deb

COPY edge-provision.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/edge-provision.sh

VOLUME /var/lib/docker

EXPOSE 2375
EXPOSE 15580
EXPOSE 15581

RUN ln -s /usr/lib/arm-linux-gnueabihf/libcrypto.so.1.0.0 /lib/arm-linux-gnueabihf/libcrypto.so.1.0.2 &&
     ln -s /usr/lib/arm-linux-gnueabihf/libssl.so.1.0.0 /lib/arm-linux-gnueabihf/libssl.so.1.0.2

ENTRYPOINT ["bash", "edge-provision.sh"]

CMD []
