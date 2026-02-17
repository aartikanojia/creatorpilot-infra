docker compose build --no-cache && docker compose up -d --force-recreate

docker compose build --no-cache context-hub-mcp context-hub-api
docker compose up -d