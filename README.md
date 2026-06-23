# CreatorPilot Infra

Centralized infrastructure for the CreatorPilot platform — a mobile-first YouTube analytics assistant.

This repo keeps local Docker Compose for development and Azure production wiring for deployment configuration.

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
| redis               | 6379  | Optional Redis cache for MCP short-term memory |

For Azure production:
- `creatorpilot-api` remains a public Azure Container App
- `creatorpilot-mcp` remains an internal Azure Container App
- PostgreSQL should be Azure Database for PostgreSQL Flexible Server
- Redis is optional in closed testing; if enabled, use Azure Cache for Redis for MCP short-term cache/memory
- Firebase credentials for push notifications should be mounted only into the API container as a secret-backed file

## Quick Start

```bash
# From this directory
docker compose build
docker compose up
```

`docker-compose.yml` is for local development only. It intentionally uses Docker service names such as `postgres`, `redis`, and `creatorpilot-mcp`.

## Files

- `docker-compose.yml` — Service orchestration
- `api.Dockerfile` — Build config for creatorpilot-api
- `mcp.Dockerfile` — Build config for creatorpilot-mcp
- `.env.example` — Local development env template
- `azure.production.env.example` — Azure production env mapping template

## Environment Variables

Copy `.env.example` to `.env` for local development.

Azure production values should not be committed to this repo. Put them in Azure Container Apps secrets/config instead, using `azure.production.env.example` as the reference mapping.

Local dev example:

```env
POSTGRES_URL=postgresql://creatorpilot_admin:creatorpilot_secret@postgres:5432/creatorpilot
DATABASE_URL=postgresql://creatorpilot_admin:creatorpilot_secret@postgres:5432/creatorpilot
POSTGRES_HOST=postgres
REDIS_HOST=redis
MCP_BASE_URL=http://creatorpilot-mcp:8001
GOOGLE_CLIENT_ID=your_id
GOOGLE_CLIENT_SECRET=your_secret
GOOGLE_REDIRECT_URI=http://localhost:8000/auth/youtube/callback
```

## Azure Production Notes

- MCP is the only runtime service in this architecture that should need direct PostgreSQL connectivity. Redis connectivity is optional and only used for MCP short-term cache/memory.
- API production config should point only to MCP's internal Azure URL unless API code later proves a DB dependency.
- Google OAuth should redirect back to the public API callback route, not a frontend localhost callback.
- `FIREBASE_CREDENTIALS` should point to the mounted API container path, defaulting to `/secrets/firebase.json`.
- `APPLICATIONINSIGHTS_CONNECTION_STRING` can be set on both API and MCP to enable Azure Monitor Application Insights telemetry for requests, exceptions, and outbound dependencies.
- In Azure Container Apps, mount the Firebase service account JSON into the API container as a secret volume or equivalent file mount.
- Mount the Google Play service-account JSON into the API container and set `GOOGLE_PLAY_SERVICE_ACCOUNT_FILE` to that mounted path.
- Configure the Google Play RTDN Pub/Sub push endpoint as `POST https://<public-api-host>/api/v1/google-play/rtdn?token=<GOOGLE_PLAY_RTDN_TOKEN>`.
- Set `GOOGLE_PLAY_RTDN_TOKEN` on the API Container App to a long random shared secret used only for the Pub/Sub push URL.
- Set `INTERNAL_SERVICE_TOKEN` on both API and MCP so MCP can call protected internal API routes such as subscription alert delivery.
- Set `API_INTERNAL_BASE_URL` on MCP so MCP can call the API's internal alert endpoint for subscription lifecycle emails.
- Optional subscription alert email delivery uses the API SMTP env vars: `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`, `SMTP_SENDER_EMAIL`, `SMTP_RECIPIENT_EMAIL`, and optional `SMTP_USE_TLS`.
- Restart or redeploy the API Container App after adding or rotating the Firebase credentials mount.
- Azure PostgreSQL should use TLS with `sslmode=require`.
- If Azure Redis is enabled, use TLS with `REDIS_SSL=true` and port `6380`.
- Do not expose MCP publicly.

## Minimal Cutover

1. Create Azure Database for PostgreSQL Flexible Server and, if desired, Azure Cache for Redis.
2. Create the PostgreSQL database and application user.
3. Restore existing PostgreSQL data if needed.
4. Run MCP Alembic migrations against Azure PostgreSQL using `POSTGRES_URL`.
5. Update MCP Azure env/secrets with the Azure PostgreSQL values and optional Redis values.
6. Update API `MCP_BASE_URL` to the internal Azure MCP URL.
7. Mount the Firebase service account JSON into the API container and set `FIREBASE_CREDENTIALS=/secrets/firebase.json`.
8. Mount the Google Play service-account JSON into the API container and set `GOOGLE_PLAY_SERVICE_ACCOUNT_FILE` to that mount.
9. Set `GOOGLE_PLAY_RTDN_TOKEN` on API and configure Pub/Sub push to `POST https://<public-api-host>/api/v1/google-play/rtdn?token=<GOOGLE_PLAY_RTDN_TOKEN>`.
10. Set `INTERNAL_SERVICE_TOKEN` on both API and MCP to the same random value.
11. Set `API_INTERNAL_BASE_URL=https://<public-api-host>` on MCP so RTDN-triggered lifecycle alerts can be sent through API.
12. Set `APPLICATIONINSIGHTS_CONNECTION_STRING` on both API and MCP if you want Azure Monitor tracing and failure telemetry.
13. Restart or redeploy the API and MCP Container Apps so the new Google Play, SMTP, internal-token, and telemetry env vars are available at boot.
14. Validate MCP health, DB connectivity, optional Redis connectivity, API-to-MCP calls, Application Insights telemetry, the API notification test path, and the RTDN webhook path.
