# Architecture

## High-Level Overview
CreatorPilot is an AI Growth Engine for YouTube Creators, consisting of a mobile front-end and a modular, AI-powered backend. The architecture strictly separates concerns between API routing/auth, AI processing, and infrastructure.

## System Components

### 1. Mobile Client (`creatorpilot-mobile`)
- **Technology:** Flutter
- **Purpose:** The user-facing mobile application featuring dashboards, video analysis, and an AI insights interface.
- **Key Responsibilities:** UI rendering, maintaining local state synchronized with the backend, managing user sessions, and displaying advanced AI analytics.

### 2. API Gateway (`creatorpilot-api`)
- **Technology:** Python, FastAPI
- **Purpose:** Core backend service handling mobile app requests, user management, and orchestration.
- **Key Responsibilities:**
  - Authentication and Authorization (Firebase, Google OAuth).
  - Web routing and endpoint management.
  - Plan enforcement and usage limits (Free vs Pro tiers), with payments via Razorpay.
  - Communication with the MCP service.
  - Push notifications via Firebase Cloud Messaging.
  - No direct production PostgreSQL or Redis ownership unless code explicitly requires it.

### 3. Model Context Protocol Server (`creatorpilot-mcp`)
- **Technology:** Python
- **Purpose:** The intelligence and heavy-lifting analytics engine.
- **Key Responsibilities:**
  - Integration with YouTube Data API.
  - Hosting AI modules (Retention Diagnosis, CTR Diagnosis, Growth Forecast, etc.).
  - Orchestrating LLM calls (Primary: Azure OpenAI, Fallback: Gemini).
  - Executing complex data analysis returning structured JSON.

### 4. Infrastructure & Data (`creatorpilot-infra`)
- **Technology:** Docker Compose for local development, Azure-managed PostgreSQL and Redis for production
- **Purpose:** Centralized orchestration and data persistence.
- **Components:**
  - **PostgreSQL 15:** Primary structured database holding user accounts, subscriptions, usage history, and application state.
  - **Redis 7:** Caching layer for fast retrieval of real-time data and rate limiting.
  - **Docker Compose:** Handles local development orchestration of `creatorpilot-api`, `creatorpilot-mcp`, `postgres`, and `redis`.
  - **Azure production:** Uses Azure Database for PostgreSQL Flexible Server and Azure Cache for Redis, with API public and MCP internal.

## Communication Flow
1. **Client** sends an authenticated request to `creatorpilot-api`.
2. `creatorpilot-api` validates the request and delegates MCP-backed work to `creatorpilot-mcp`.
3. `creatorpilot-mcp` reads and writes the required application state in **PostgreSQL** and uses **Redis** for caching or short-lived state.
4. `creatorpilot-mcp` gathers data from YouTube, retrieves previous context if necessary, processes it through **Azure OpenAI** or internal engines, and returns structured data to the API.
5. `creatorpilot-api` returns the unified JSON response to the Flutter front-end.

## Core Principles
- **Strict Separation of Concerns:** Logic must not cross boundaries. `creatorpilot-api` handles auth/routing, `creatorpilot-mcp` handles AI/analytics, and `creatorpilot-infra` handles deployment.
- **Predictable Behavior:** AI and data processing must always return structured JSON without hallucinated metrics.
- **Phase-Driven Evolution:** Infrastructure follows a strict roadmap from basic analytics parity to competitive intelligence.
