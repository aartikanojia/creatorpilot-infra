1"}
# Infrastructure — Agent Instructions

## Role

This module manages **deployment, environment, and runtime setup**.

---

## Responsibilities

- Dockerfiles (API + MCP)
- docker-compose / deployment configs
- Nginx / reverse proxy
- Domain and HTTPS setup
- Environment variables
- CI/CD pipelines

---

## ⚠️ Critical Rules

- Do NOT add application logic here
- Keep infra separate from business code
- Never hardcode secrets

---

## Deployment Architecture

Internet
→ Reverse Proxy (Nginx)
→ API (public)
→ MCP (internal only)
→ PostgreSQL + Redis

---

## Security Rules

- MCP must NOT be publicly exposed
- Use HTTPS everywhere
- Store secrets via environment variables

---

## Environment Rules

Separate:
- dev
- staging (optional)
- production

Never mix:
- API URLs
- payment keys
- OAuth credentials

---

## Docker Rules

- Each service must have its own Dockerfile
- Use restart policies
- Use health checks
- Keep images lightweight

---

## Anti-Patterns

Do NOT:
- expose MCP directly
- hardcode credentials
- mix dev and prod configs
- skip HTTPS

---

## Done Criteria

- Services run reliably
- API publicly accessible
- MCP internal only
- Secure configura