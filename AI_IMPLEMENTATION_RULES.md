# AI Implementation Rules

This repository is part of the **CreatorPilot AI Growth Engine**.

All AI coding assistants must follow the rules below when implementing changes.

---

## 1. Follow the Product Roadmap

Implementation must strictly follow the official development roadmap.

Current roadmap phases:

Phase 0 — Foundation Hardening  
Phase 1 — Analytics Parity  
Phase 2 — AI Intelligence Layer  
Phase 3 — Advanced AI Features  
Phase 4 — Notifications  
Phase 5 — Monetization Layer  
Phase 6 — Competitive Intelligence  
Phase 7 — App Store Production Readiness

AI assistants must **only implement tasks belonging to the current phase**.

Do not introduce features from future phases.

---

## 2. Do Not Redesign Architecture

AI assistants must never:

• invent new services  
• move logic between projects  
• introduce new frameworks  
• modify infrastructure architecture  
• restructure the repository

The project structure is fixed.

---

## 3. Project Responsibility Boundaries

The architecture is intentionally separated.

creatorpilot-mcp  
Handles analytics and intelligence engines.

creatorpilot-api  
Handles authentication, routing, notifications, and communication with MCP.

creatorpilot-infra  
Handles Docker, environment configuration, and deployment.

AI assistants must never move logic across these boundaries.

---

## 4. Only Implement Requested Changes

AI assistants must implement **only the requested feature**.

Do not:

• refactor unrelated files  
• change code formatting across the project  
• rename modules  
• upgrade dependencies  
• reorganize directories

Unless explicitly requested.

---

## 5. Do Not Replace Existing Systems

Existing systems are considered stable unless explicitly modified.

Examples:

RetentionDiagnosisEngine  
CTRDiagnosisEngine  
GrowthForecastEngine  
EventBridge  
NotificationService

AI assistants must never rewrite or replace these systems.

---

## 6. No Hidden Feature Expansion

AI assistants must not:

• add new endpoints  
• add new engines  
• introduce caching systems  
• introduce background workers  
• add new dependencies

unless the prompt explicitly requests it.

---

## 7. Docker Rules

Infrastructure changes must only occur in:

creatorpilot-infra

AI assistants must not change container architecture unless explicitly instructed.

---

## 8. Deterministic Behavior

AI assistants must:

• follow instructions exactly  
• avoid "creative improvements"  
• avoid suggesting alternative architectures  
• avoid speculative enhancements

The goal is **predictable implementation**, not experimentation.

---

## 9. Error Handling

AI assistants may add minimal error handling only when necessary to prevent runtime crashes.

Do not redesign logic while fixing errors.

---

## 10. Logging

Debug logs are allowed during development but must not introduce heavy logging frameworks.

---

## 11. Production Safety

AI assistants must never:

• expose secrets  
• modify authentication logic  
• change database schemas unexpectedly  
• alter API contracts

---

## 12. Code Style

Follow the existing style used in the repository.

Do not reformat unrelated code.

---

## Summary

AI assistants act as **implementation executors**, not system architects.

All architectural decisions are made manually by the project owner.
