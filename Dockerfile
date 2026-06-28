FROM debian:latest
RUN apt-get update \
	&& apt-get install -y cron curl unzip openssh-client \
	&& rm -rf /var/lib/apt/lists/*

#Install supercronic and sqlite3 tools
# Latest releases available at https://github.com/aptible/supercronic/releases
WORKDIR /root
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.46/supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=5bcefed628e32adc08e32634db2d10e9230dbca0 \
    SUPERCRONIC=supercronic-linux-amd64

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic \
 && curl --output tools.zip https://sqlite.org/2026/sqlite-tools-linux-x64-3530200.zip \
 && unzip tools.zip \
 && rm tools.zip \
 && mv * /usr/local/bin \
 && mkdir /backup

WORKDIR /app
COPY . .

RUN useradd appuser && mkdir /home/appuser
USER appuser

CMD ["supercronic", "crontab"] 

