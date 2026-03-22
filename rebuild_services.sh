#!/usr/bin/env bash
set -euo pipefail

echo "🕒 Starting rebuild_services.sh at $(date '+%Y-%m-%d %H:%M:%S')"

# Enable BuildKit for cache mount support
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

usage() {
  echo "Usage: $0 [mcp|api|all] [--no-cache] [--up]"
  echo ""
  echo "  mcp         Build creatorpilot-mcp only"
  echo "  api         Build creatorpilot-api only"
  echo "  all         Build both services (default)"
  echo "  --no-cache  Force rebuild without cache"
  echo "  --up        Start services after build"
  exit 0
}

TARGET="all"
BUILD_ARGS=""
START_AFTER=false

for arg in "$@"; do
  case "$arg" in
    mcp)        TARGET="creatorpilot-mcp" ;;
    api)        TARGET="creatorpilot-api" ;;
    all)        TARGET="all" ;;
    --no-cache) BUILD_ARGS="--no-cache" ;;
    --up)       START_AFTER=true ;;
    -h|--help)  usage ;;
    *)          echo "Unknown argument: $arg"; usage ;;
  esac
done

echo "🔨 Building ${TARGET} ..."

if [ "$TARGET" = "all" ]; then
  docker compose build $BUILD_ARGS creatorpilot-mcp creatorpilot-api
else
  docker compose build $BUILD_ARGS "$TARGET"
fi

echo "✅ Build complete!"

if [ "$START_AFTER" = true ]; then
  echo "🚀 Starting services ..."
  docker compose up -d --force-recreate
  echo "✅ Services started!"
fi