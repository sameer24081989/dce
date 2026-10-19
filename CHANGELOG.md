# DCE Legal Case Monitor — staged change log

Candidate prepared 19 October 2026 against source commit `0fa25e7077a6a38fe345dcd9c38bdcc890ded7f7` (live version 18 at inspection).

- Retained project ID, R2 storage binding, case IDs, existing authentication providers, website URL, MCP endpoint/tool names and professional interface.
- Strict JSON object/type/field/length validation, streamed 64 KiB request limit, real date validation, case-number canonical uniqueness, Unicode text, CSV formula neutralization and escaped case/history/calendar rendering.
- Administrator-only registration, assignments and deadline/extension changes. Editors can read/update only explicitly assigned cases; viewers retain shared read-only access. Every data operation rechecks server role; security-denial telemetry excludes bodies/credentials.
- Partial updates preserve omitted fields and legacy optional parties/institution/advocate fields. Original deadline and legacy history remain present. Changes append actor, UTC timestamp, reason, version and before/after fields.
- Atomic R2 compare-and-swap register commits serialize case uniqueness, request receipts, versions and audit changes together. Conflicting saves return 409. Create retries require a request ID; duplicate retries do not create additional records.
- Done, Archived and Reopened transitions retain case identity/history. Default active register excludes Done/Archived; filters expose them. Disposed is not proof of completed compliance.
- Calendar preserves date-only semantics, lists all matching cases including overdue, exposes case history and paginates large daily lists (50 per page). Register pagination added.
- Verified checksum backups before each data/access change; write failure prevents success response. Recovery utility restores cases, roles, receipts and history only into an empty isolated staging target. Production restore is forbidden by that utility.
- Explicit, administrator-only activation preflight and approval gate. Legacy objects remain byte-preserved; candidate does not silently backfill or activate the new register on read.
- Added reproducible isolated file-backed staging database and 85-row QA results plus supplemental authentication, calendar and safeguard regression suites.

## Hosted verification follow-up

- Provisioned a separate owner-private staging Site with independent Cloudflare R2 storage and synthetic records. No production database was attached.
- Added officer reminder outbox, status display, retry/backoff, bounded attempts, competing-run delivery leases and stable delivery keys. Delivery defaults off; actual sender/scheduler connection is still required.
- Tested retry exhaustion and cancellation following a granted extension. No actual staff messages were sent.
- Fixed a hosted-test finding in rate limiting: the clock-minute boundary reset was replaced by a rolling 60-second window. Added a deterministic boundary regression.
- Local matrix now records 79 PASS, 0 FAIL and 6 browser-dependent BLOCKED rows. Hosted evidence, including the initial failure and retest, is retained separately.
