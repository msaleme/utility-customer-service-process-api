# Utility Customer Service Process API

A MuleSoft process-layer reference implementation for coordinating customer, billing, usage, outage, service-request, notification, and AI-assisted support capabilities.

> **Project status:** Demonstration/reference implementation. Example endpoints, credentials, analytics, performance behavior, and customer outcomes are not production commitments.

## Business problem

Utility customer interactions often span CIS and billing, usage and meter data, outage management, payments, service requests, notifications, weather, and digital channels. This project demonstrates a reusable process boundary that keeps those systems decoupled from Agentforce and other customer experiences.

## Capabilities

| Domain | Representative operations |
|---|---|
| Customer | Profile and account context |
| Usage | Historical and interval consumption |
| Billing | Bills, history and payment-plan requests |
| Outage | Outage status and customer impact |
| Service | Request creation and tracking |
| Notifications | Preferences and outbound-event context |
| Insights | Forecast or recommendation interfaces |
| Agent experience | A governed conversational query boundary |

## Architecture principles

- experience channels call a stable process API rather than source systems;
- source adapters isolate CIS, billing, OMS, analytics and notification providers;
- canonical models reduce channel-specific transformations;
- correlation IDs connect customer requests, tool calls and downstream activity;
- resilience patterns contain failures and expose partial availability explicitly;
- AI-generated explanations remain grounded in retrieved customer and operational data.

## Customer and AI governance

Production implementations should include:

- strong customer identity verification;
- purpose-based access and field-level data minimization;
- explicit authorization for payment or account changes;
- explainable eligibility, forecast and recommendation logic;
- human escalation and dispute paths;
- controls against prompt injection through retrieved content;
- PII-safe logging, retention and audit evidence;
- accessibility, language and vulnerable-customer considerations.

## Running the project

Review the Mule configuration and example property files, provide environment-managed secrets, and connect only synthetic or approved non-production data during evaluation. Inspect the implementation for the authoritative runtime and Java requirements.

## Portfolio context

This repository is part of a broader [utility grid-modernization portfolio](https://github.com/msaleme/utility-ai-mulesoft-api/blob/master/docs/portfolio-guide.md) covering grid intelligence, field operations, smart meters, customer programs, compliance, and governed AI-assisted operations.


## Related projects

- [Energy Efficiency Program Enrollment API](https://github.com/msaleme/Energy-Efficiency-Program-Enrollment-API)
- [Utility AI Semantic Layer](https://github.com/msaleme/utility-ai-mulesoft-api)
- [Utility Field Operations Support Agent](https://github.com/msaleme/field-operations-support-agent)

## License

See [LICENSE](LICENSE), if present. Verify all connector and dependency terms before redistribution.
