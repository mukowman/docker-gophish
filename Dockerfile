FROM debian:jessie

RUN apt-get update && \
apt-get install --no-install-recommends -y \
unzip \
ca-certificates \
wget && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/gophish-v0.5.0-linux-64bit
RUN wget -nv https://github.com/gophish/gophish/releases/download/v0.5.0/gophish-v0.5.0-linux-64bit.zip && \
unzip gophish-v0.5.0-linux-64bit.zip && \
rm -f gophish-v0.5.0-linux-64bit.zip

RUN mkdir /app && cp -R /opt/gophish-v0.5.0-linux-64bit/* /app/ && rm -rf /opt/gophish-v0.5.0-linux-64bit
WORKDIR /app

RUN sed -i "s|127.0.0.1|0.0.0.0|g" config.json
RUN sed -i "s|gophish.db|database/gophish.db|g" config.json
RUN chmod +x ./gophish

VOLUME ["/app/database"]
VOLUME ["/app/static/endpoint"]
EXPOSE 3333 80
ENTRYPOINT ["./gophish"]
