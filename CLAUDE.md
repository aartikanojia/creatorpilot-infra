# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the **infrastructure-only** repo for CreatorPilot — an AI Growth Engine for YouTube Creators. It contains Docker configs, Dockerfiles, and orchestration. Source code lives in sibling repos:

- `../creatorpilot-api` — FastAPI backend (auth, routing, plan enforcement, Firebase notifications)
- `../creatorpilot-mcp` — MCP server (YouTube Data API, AI analysis, LLM orchestration)
- `../creatorpilot-mobile` — Flutter mobile app

**Rule: Docker changes belong here. Feature/logic changes belong in the respective service repo.**

## Common Commands

```bash
# Start all services
docker compose up

# Build all images
docker compose build

# Rebuild a specific service and restart it
./rebuild_services.sh mcp --up       # rebuild MCP + restart
./rebuild_services.sh api --up       # rebuild API + restart
./rebuild_services.sh all --up       # rebuild both + restart

# Force rebuild without cache
./rebuild_services.sh mcp --no-cache --up

# View logs
docker compose logs -f creatorpilot-mcp
docker compose logs -f creatorpilot-api
```

BuildKit is required and enabled automatically by `rebuild_services.sh` (`DOCKER_BUILDKIT=1`).

## Architecture

4-tier system:

```
Flutter App → creatorpilot-api (port 8000) → creatorpilot-mcp (port 8001)
                     ↕                              ↕
               PostgreSQL :5433              Azure OpenAI / Gemini
               Redis :6379
```

**creatorpilot-api** handles: authentication (Firebase + Google OAuth), plan/tier enforcement (Free vs Pro), rate limiting, push notifications (FCM), and proxying requests to MCP.

**creatorpilot-mcp** handles: YouTube Data API calls, AI analysis modules (Retention Diagnosis, CTR Diagnosis, Growth Forecast, etc.), LLM orchestration. Primary LLM: Azure OpenAI. Fallback: Gemini.

**PostgreSQL 15**: User accounts, subscriptions, usage history.
**Redis 7**: Caching and rate limiting.

## Environment Variables

Copy `.env.example` to `.env` before starting. Key groups:

| Group | Variables |
|-------|-----------|
| Azure OpenAI (primary LLM) | `AZURE_OPENAI_API_KEY`, `AZURE_OPENAI_ENDPOINT`, `AZURE_OPENAI_DEPLOYMENT`, `AZURE_OPENAI_API_VERSION` |
| Gemini (fallback LLM) | `GEMINI_API_KEY` |
| Database | `DATABASE_URL`, `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD` |
| Google OAuth | `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `GOOGLE_REDIRECT_URI` |
| Firebase | `FIREBASE_CREDENTIALS` (path to `firebase.json`) |
| Feature flags | `FORCE_PRO_MODE` |

Firebase credentials file must be present at the path referenced by `FIREBASE_CREDENTIALS` (default: `/secrets/firebase.json`), mounted as a volume in docker-compose.

## Dockerfiles

- `api.Dockerfile` — builds `../creatorpilot-api`; Python 3.11, port 8000, runs as non-root `appuser`
- `mcp.Dockerfile` — builds `../creatorpilot-mcp`; Python 3.11, port 8001, runs as non-root `mcp` (uid 1000), includes `/health` healthcheck

Both use multi-stage builds with BuildKit cache mounts (`--mount=type=cache`) optimized for Apple Silicon (ARM64 / `linux/arm64`).

## AI Implementation Rules (from AI_IMPLEMENTATION_RULES.md)

- Implement only what is explicitly requested — no extras, no refactors beyond scope
- Do not redesign architecture or replace existing engines (RetentionDiagnosisEngine, CTRDiagnosisEngine, etc.)
- Respect service boundaries: MCP owns AI/analytics, API owns auth/routing, Infra owns Docker
- Responses must be deterministic and structured JSON — no hallucinated metrics
- Debug logs are acceptable; heavy logging frameworks are not
- Never modify auth logic or expose secrets

## Product Phases (from CREATORPILOT_PRODUCT_ROADMAP.md)

Development follows Phases 0–7. Current focus determines what is in-scope to implement:

- **Phase 0**: Foundation hardening (DB schema, env configs, JSON contract)
- **Phase 1**: Baseline analytics (9 MCP tools, 3 mobile tabs)
- **Phase 2**: AI intelligence layer (6 AI modules, LLM guardrails)
- **Phase 3**: Advanced AI (upload optimization, growth forecast, health score)
- **Phase 4**: Engagement & notifications
- **Phase 5**: Monetization (Stripe, Free/Pro tiers)
- **Phase 6**: Competitive intelligence
- **Phase 7**: App Store production readiness
