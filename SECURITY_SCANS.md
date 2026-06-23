# Local Security Scans

Minimal repeatable local security scan workflow for the CreatorPilot AI workspace.

Run from:

`/Users/mohitkumar/Documents/createrpilot`

These commands do not require CI setup. If a tool is not installed locally,
install it separately before running the command.

## 1. Semgrep

Scan code for common security issues:

```bash
cd /Users/mohitkumar/Documents/createrpilot
semgrep scan --config auto creatorpilot-mobile creatorpilot-api creatorpilot-mcp creatorpilot-infra
```

## 2. Gitleaks

Scan the workspace for likely leaked secrets:

```bash
cd /Users/mohitkumar/Documents/createrpilot
gitleaks dir . --redact
```

## 3. Trivy filesystem scan

Scan for secrets, vulnerabilities, and misconfigurations:

```bash
cd /Users/mohitkumar/Documents/createrpilot
trivy fs --scanners vuln,secret,misconfig .
```

## Suggested pre-submit sequence

```bash
cd /Users/mohitkumar/Documents/createrpilot
semgrep scan --config auto creatorpilot-mobile creatorpilot-api creatorpilot-mcp creatorpilot-infra
gitleaks dir . --redact
trivy fs --scanners vuln,secret,misconfig .
```
