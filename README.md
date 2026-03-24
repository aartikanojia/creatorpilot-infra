# CreatorPilot Infra

Centralized infrastructure for the CreatorPilot platform — a mobile-first YouTube analytics assistant.

## Architecture

```
/createrai
├── creatorpilot-infra    ← Docker configs & orchestration (this repo)
├── creatorpilot-mcp      ← MCP server (YouTube data + AI analysis)
├── creatorpilot-api      ← REST API (auth, user management, Flutter gateway)
└── creatorpilot-mobile   ← Flutter mobile app
```

## Services

| Service             | Port  | Description                        |
|---------------------|-------|------------------------------------|
| creatorpilot-api    | 8000  | FastAPI backend for mobile app     |
| creatorpilot-mcp    | 8001  | MCP server for YouTube analytics   |
| postgres            | 5433  | PostgreSQL 15 database             |
| redis               | 6379  | Redis 7 cache                      |

## Quick Start

```bash
# From this directory
docker compose build
docker compose up
```

## Files

- `docker-compose.yml` — Service orchestration
- `api.Dockerfile` — Build config for creatorpilot-api
- `mcp.Dockerfile` — Build config for creatorpilot-mcp

## Environment Variables

Create a `.env` file with:

```env
OPENAI_API_KEY=your_key
GOOGLE_CLIENT_ID=your_id
GOOGLE_CLIENT_SECRET=your_secret
GOOGLE_REDIRECT_URI=your_uri
RAZORPAY_KEY_ID=your_razorpay_key_id
RAZORPAY_KEY_SECRET=your_razorpay_key_secret
RAZORPAY_WEBHOOK_SECRET=your_razorpay_webhook_secret
```
