#!/bin/bash
echo "Starting Overleaf for class..."

# 1. Start services
docker compose up -d

# 2. Wait a few seconds for Mongo
sleep 5

# 3. Initialize replica set if not already done
if ! docker exec mongo mongosh --eval "rs.status()" | grep -q '"set" : "rs0"'; then
  echo "🔧 Initializing MongoDB replica set..."
  docker exec mongo mongosh --eval "rs.initiate()"
fi

# 4. Restart Overleaf to apply DB connection
docker compose restart overleaf

echo "Overleaf is ready at: http://localhost:8080"

