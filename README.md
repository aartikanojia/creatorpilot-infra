# Context Hub Infrastructure

Docker Compose orchestration for the Context Hub platform — a YouTube analytics system powered by AI.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Context Hub Platform                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌──────────────────┐      ┌──────────────────────────┐    │
│   │  context-hub-api │ ───▶ │    context-hub-mcp       │    │
│   │   (Port 8000)    │      │      (Port 8001)         │    │
│   │   API Gateway    │      │      AI Brain            │    │
│   └────────┬─────────┘      └───────────┬──────────────┘    │
│            │                            │                    │
│            │         ┌──────────────────┤                    │
│            ▼         ▼                  ▼                    │
│   ┌──────────────────────┐      ┌────────────────┐          │
│   │     PostgreSQL       │      │     Redis      │          │
│   │     (Port 5433)      │      │   (Port 6379)  │          │
│   │   Long-term Memory   │      │ Short-term Mem │          │
│   └──────────────────────┘      └────────────────┘          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## 📦 Services

| Service | Description | Port |
|---------|-------------|------|
| **context-hub-api** | API Gateway for the platform | `8000` |
| **context-hub-mcp** | MCP AI Brain service | `8001` |
| **postgres** | PostgreSQL database (long-term memory) | `5433` |
| **redis** | Redis cache (short-term memory) | `6379` |

## 🚀 Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/install/)
- The following sibling repositories cloned:
  - `context-hub-api`
  - `context-hub-mcp`

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd context-hub-infra
   ```

2. **Configure environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` with your credentials:
   - `GEMINI_API_KEY` — Your Google Gemini API key
   - `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` — YouTube OAuth credentials
   - `POSTGRES_*` — Database configuration

3. **Start the services**
   ```bash
   docker compose up -d
   ```

4. **Verify services are running**
   ```bash
   docker compose ps
   ```

## 🔧 Common Commands

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# View logs
docker compose logs -f

# View logs for a specific service
docker compose logs -f context-hub-api

# Rebuild and start services
docker compose up -d --build

# Remove volumes (⚠️ deletes all data)
docker compose down -v
```

## ⚙️ Environment Variables

| Variable | Description |
|----------|-------------|
| `GEMINI_API_KEY` | Google Gemini API key |
| `DATABASE_URL` | PostgreSQL connection string |
| `GOOGLE_CLIENT_ID` | Google OAuth client ID |
| `GOOGLE_CLIENT_SECRET` | Google OAuth client secret |
| `GOOGLE_REDIRECT_URI` | OAuth redirect URI |
| `POSTGRES_DB` | PostgreSQL database name |
| `POSTGRES_USER` | PostgreSQL username |
| `POSTGRES_PASSWORD` | PostgreSQL password |
| `FORCE_PRO_MODE` | Feature flag for pro mode |

## 📁 Project Structure

```
context-hub-infra/
├── docker-compose.yml    # Service orchestration
├── .env.example          # Environment template
├── .env                  # Local environment (git-ignored)
├── .gitignore
└── README.md
```

## 🔗 Related Repositories

- [context-hub-api](../context-hub-api) — API Gateway
- [context-hub-mcp](../context-hub-mcp) — MCP AI Brain

## 📝 License

MIT
