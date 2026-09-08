FROM eclipse-temurin:25-jre-jammy

ARG PURPUR_MC_VERSION=26.2

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -u 1000 minecraft

# Fetch the Purpur server jar for this MC version straight from the official
# build API instead of committing a 60MB+ binary to git.
RUN curl -fsSL -o /purpur-server.jar \
    "https://api.purpurmc.org/v2/purpur/${PURPUR_MC_VERSION}/latest/download"

COPY --chown=minecraft:minecraft . /seed
COPY --chown=minecraft:minecraft entrypoint.sh /entrypoint.sh
RUN cp /purpur-server.jar /seed/purpur-server.jar \
    && chown minecraft:minecraft /seed/purpur-server.jar \
    && chmod +x /entrypoint.sh && mkdir -p /data && chown minecraft:minecraft /data

VOLUME /data
WORKDIR /data
USER minecraft
EXPOSE 25565
ENTRYPOINT ["/entrypoint.sh"]
