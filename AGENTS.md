# Infrastructure — Release-State Instructions

## Role

This repo manages deployment, runtime environment, and release setup.

## Current Stage

- Azure Container Apps is the active deployment path.
- Closed testing / Play Console readiness is an active release concern.
- Google Play RTDN infrastructure is part of the current release setup.

## Responsibilities

- Container/service deployment config
- Azure Container Apps environment wiring
- Public/private service exposure rules
- Environment variables and secret references
- Operational runbooks for release setup

## Critical Rules

- Do NOT add application business logic here
- Never hardcode secrets
- Keep MCP internal-only
- Keep production env assumptions explicit and reproducible

## Current Release Truths

- API is public-facing.
- MCP remains internal-only.
- Google Play RTDN and Pub/Sub push setup are relevant release infrastructure.
- SMTP / subscription alert envs are part of active runtime configuration.
- Release envs must reflect Google Play verification, RTDN, and alert delivery needs.

## Environment / Security Rules

- Keep API and MCP URLs/environment values separated by environment
- Store secrets via Azure-managed env/secret configuration
- Keep Google Play service-account credentials externalized
- Keep internal service tokens and SMTP credentials out of repo

## Deployment Priorities

- Reliable API + MCP startup
- Correct internal connectivity between API and MCP
- Google Play verification env wiring
- RTDN ingress and Pub/Sub delivery setup
- Subscription alert envs for operator/admin notifications

## Anti-Patterns

Do NOT:
- expose MCP publicly
- hardcode OAuth, SMTP, Play, or payment secrets
- keep stale release blockers after they are solved
- mix closed-testing config with unrelated dev defaults

## Done Criteria

- Azure deployment path is reproducible
- API is reachable publicly
- MCP is internal-only
- RTDN, Google Play verification, and subscription alert env wiring are present
