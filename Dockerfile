FROM eclipse-temurin:25-jre-jammy

RUN useradd -m -u 1000 minecraft

COPY --chown=minecraft:minecraft . /seed
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && mkdir -p /data && chown minecraft:minecraft /data

VOLUME /data
WORKDIR /data
USER minecraft
EXPOSE 25565
ENTRYPOINT ["/entrypoint.sh"]
