#!/bin/bash
set -e

DATA_DIR=/data
SEED_DIR=/seed

if [ ! -f "$DATA_DIR/purpur-server.jar" ]; then
  echo "[entrypoint] Empty volume detected, seeding from image with current world/plugins/config..."
  cp -a "$SEED_DIR"/. "$DATA_DIR"/
fi

# purpur.yml (incl. startup-commands) always tracks git, even on an already-seeded volume,
# so config changes take effect on redeploy without touching the live server by hand.
cp "$SEED_DIR/purpur.yml" "$DATA_DIR/purpur.yml"

cd "$DATA_DIR"

if [ -n "$RCON_PASSWORD" ]; then
  sed -i "s/^rcon.password=.*/rcon.password=${RCON_PASSWORD}/" server.properties
fi

if [ -n "$MANAGEMENT_SECRET" ]; then
  sed -i "s/^management-server-secret=.*/management-server-secret=${MANAGEMENT_SECRET}/" server.properties
fi

if [ -n "$SERVER_PORT" ]; then
  sed -i "s/^server-port=.*/server-port=${SERVER_PORT}/" server.properties
fi

echo "[entrypoint] Starting Purpur with -Xms${INIT_MEMORY:-1G} -Xmx${MAX_MEMORY:-2G}"
exec java -Xms"${INIT_MEMORY:-1G}" -Xmx"${MAX_MEMORY:-2G}" -jar purpur-server.jar nogui
