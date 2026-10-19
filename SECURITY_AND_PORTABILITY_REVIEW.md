# Bounded source/security/portability review

Reviewed current application source and automated negative tests. This is not an independent penetration test or security accreditation.

| Boundary | Evidence / finding |
|---|---|
| Business input | Allowed fields/types, size limits, case normalization, enum and calendar-date rejection covered by tests |
| Identity | Current trusted hosting injects identity; application role enforcement is server-side. On SDC untrusted incoming headers must be stripped and identity verified by a new adapter |
| Access | Administrator/Editor/Viewer restrictions, assigned-record access, last-admin preservation, revocation and case-ID guessing tested |
| CSRF | Browser write-origin enforcement and separate non-browser secret runner tested; platform private entry gate remains distinct |
| Audit | Client actor/history fields rejected; server history, immutable case IDs and backups retained; legacy metadata gaps explicit |
| Spreadsheet | OOXML inline strings, CSV formula neutralization, XML escaping, long Unicode continuation and administrator-only full exports tested |
| Concurrency | Record versions, conditional object writes, normalized duplicate creation and delivery leases tested |
| Delivery | Catch-up and stable keys implemented; real exactly-once receipt still depends on approved relay deduplication and actual inbox evidence |
| Secrets | Runtime configuration retained outside source; training fixtures contain only dummy secrets/accounts; no credentials supplied in handover |
| Dependencies | Application package declares no third-party npm runtime dependencies; hosted platform/runtime and any future target adapters still need operational patch management |
| Recovery | Verified snapshots and empty-target recovery exercised; full SDC recovery, retention, encryption and recovery objectives require target evidence |
| Abuse/scale | Per-isolate rolling limiter and aggregate 8 MiB register guard exist. A multi-instance SDC deployment needs appropriate shared transactions and gateway rate limiting |
| Logs/monitoring | Sanitized application errors and denied-access telemetry tested. External retention, stale-run alarms, bounce handling and on-call escalation are not commissioned |

Current architecture cannot be certified ready for an unspecified generic SDC server. Required porting: HTTP/runtime wrapper, storage transaction/CAS adapter, verified departmental authentication, TLS/domain, scheduler/relay integration, monitoring and actual-target testing. Do not deploy the test file store as a production database.
