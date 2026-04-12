# Azure Monitor Application Insights

YTCreator uses Azure Monitor Application Insights with the Azure Monitor OpenTelemetry distro for:

- request latency and failures
- unhandled exceptions
- outbound dependency calls, including API -> MCP and external HTTP calls

## Required Environment Variable

Set this on both Azure Container Apps:

```env
APPLICATIONINSIGHTS_CONNECTION_STRING=InstrumentationKey=<app-insights-key>;IngestionEndpoint=https://<region>.in.applicationinsights.azure.com/;LiveEndpoint=https://<region>.livediagnostics.monitor.azure.com/
```

One shared Application Insights resource is enough for launch. If you prefer cleaner separation later, you can give API and MCP separate resources.

## Deployment Notes

- `creatorpilot-api` and `creatorpilot-mcp` both boot normally when the connection string is missing.
- Startup logs should show either:
  - `Azure Monitor enabled for service=...`
  - or `Azure Monitor disabled: APPLICATIONINSIGHTS_CONNECTION_STRING missing`
- No secrets are printed to logs.

## Redeploy

After setting or rotating the connection string:

1. Update the Azure Container App secret/environment for `creatorpilot-api`
2. Update the Azure Container App secret/environment for `creatorpilot-mcp`
3. Restart or redeploy both services

## Azure Portal Verification

After deployment, open the Application Insights resource and check:

1. `Transaction search`
   - confirm API requests appear
   - confirm MCP requests appear
2. `Application map`
   - confirm API and MCP dependencies show up
3. `Failures`
   - confirm exceptions and failed requests are visible
4. `Performance`
   - confirm request latency percentiles are populating

## Useful KQL

Recent failed requests:

```kusto
requests
| where timestamp > ago(30m)
| where success == false
| project timestamp, cloud_RoleName, name, resultCode, duration, operation_Id
| order by timestamp desc
```

Recent exceptions:

```kusto
exceptions
| where timestamp > ago(30m)
| project timestamp, cloud_RoleName, type, outerMessage, operation_Id
| order by timestamp desc
```

Slow requests:

```kusto
requests
| where timestamp > ago(30m)
| order by duration desc
| project timestamp, cloud_RoleName, name, duration, success, operation_Id
```

API -> MCP dependency traces:

```kusto
dependencies
| where timestamp > ago(30m)
| where type == "HTTP"
| project timestamp, cloud_RoleName, target, name, resultCode, success, duration, operation_Id
| order by timestamp desc
```

## First Alerts To Create

- Failed request spike or smart detection for failure anomalies
- Exception spike on either service
- 5xx rate alert on API requests
- Container App revision unhealthy / restart spike
