# State Data Centre technical handover and cutover runbook

Prepared 19 October 2026. Target-server deployment and commissioning have not occurred. This is an implementation/acceptance specification based on the current source, not an assurance that the current Worker can run unchanged on an SDC VM.

## Current application and dependencies

- JavaScript ESM Worker with HTTP `fetch` entry point; HTML/UI served by the Worker.
- Cloudflare R2 object-storage binding `BUCKET`; conditional ETag writes protect the aggregate `register-v2/{ownerId}.json` against lost edits and duplicates.
- Separate access configuration, original legacy case objects, verified backup objects and security telemetry in the same application storage binding.
- Current platform supplies authenticated identity headers and private-Site access. Optional email OTP adapter is present but requires a configured authentication service; presence of code is not proof of configured sign-in.
- API endpoints enforce roles; MCP tools remain on `/mcp`.
- Do not put the Worker behind a generic HTTP server that accepts client-supplied identity headers. The SDC adapter must strip untrusted identity headers, verify the selected departmental session/token, and inject identity only after verification. An SDC server will not automatically inherit platform identity or private-Site sharing.

## Information SDC must supply before choosing the deployment adapter

| Topic | Required answer |
|---|---|
| Hosting | VM, container or managed application platform; supported OS/runtime; installation/deployment route |
| Database/storage | PostgreSQL or object-storage options; atomic transaction/CAS facilities; encryption/access controls |
| Authentication | Approved identity provider/protocol, account provisioning, MFA/session/revocation policy |
| Network | DNS/departmental domain, TLS termination, ingress/egress, firewall/proxy requirements |
| Delivery | Approved email relay, credentials mechanism, quotas, deduplication and bounce reporting |
| Scheduler | Supported machine scheduler, secret storage, retry and monitoring mechanism |
| Operations | Operator, patching responsibility, logs/retention, alert destination, backup service |
| Recovery | Department-approved recovery time and maximum data-loss targets; restore destination |
| Integration | Whether authenticated external MCP access is permitted and how it will be tested |

Do not select or invent SDC hostnames, server sizes, credentials, approved services, retention periods or mandatory regulatory requirements from this runbook.

## Required adaptation work

1. Wrap the Worker HTTP logic in the SDC-supported runtime, or port it to an approved server framework.
2. Implement a storage adapter preserving read/list/conditional-put semantics, or use database transactions with a uniqueness constraint and version comparison. The file-backed test store is a test fixture, not a production database.
3. Replace platform identity with verified departmental authentication and session management. Preserve stable case IDs and explicitly map user identities/emails; owner keys must not silently create a separate empty register.
4. Configure secrets in the approved secret store, with least privilege and rotation. Do not put secrets in browser code, Git, Excel or training files.
5. Integrate scheduling and relay under the contracts in `NOTIFICATIONS_SETUP.md`.
6. Repeat all regression suites against the actual adapters, plus real browser, network, volume, backup and receipt tests on SDC.

## Migration rehearsal

- Obtain a fresh authorised full recovery backup and a human-readable Excel export. Excel is not the full recovery backup.
- Run `node tools/verify-backup.mjs /absolute/path/backup.json` locally in a controlled environment. It is read-only: checksum, schema, ownership, IDs, canonical numbers and dates. A hash is an integrity check, not an authenticity signature or encryption.
- Reconcile source/target ID set, case count, each deadline/original deadline, complete history, permissions, outbox and pending receipts. Preserve unknown legacy structures verbatim.
- Resolve invalid legacy values through a separately audited staff correction. Never silently normalize/delete originals to make an import pass.
- Restore to a separate empty target; keep incomplete recovery offline. Confirm ordinary users cannot reach it before acceptance.
- Test concurrent writes across more than one process/instance. A single-process lock or limiter is not sufficient evidence for a multi-instance SDC deployment.
- Rehearse repeat import/recovery and prove no duplicate cases or reminder sends. Preserve relay idempotency state through cutover.

## Proposed operational commissioning gates

Each gate needs a named reviewer, date, observed evidence and a PASS. Use `tools/acceptance-status.mjs evidence.json` to validate the completeness of supplied evidence. The tool does not independently verify any assertion.

1. Target runtime and storage transactions verified.
2. Departmental authentication, revocation, roles and external/private entry controls verified.
3. TLS/domain/network and secret management approved by the responsible technical team.
4. Restored data reconciled; target recovery drill completed.
5. Browser/mobile/keyboard/screen-reader and network-failure acceptance completed.
6. Department-controlled test-mailbox receipt and unattended closed-browser scheduler run completed.
7. Monitoring, failed-delivery escalation and operator backup demonstrated.
8. Staff role exercises completed; ownership and cutover/rollback approved.

## Cutover sequence

1. Record the accepted source/build, domain, backup location, operators and rollback decision authority.
2. Suspend old scheduled delivery before enabling the new runner. Keep only one authorised sender/runner active to avoid duplicate reminders.
3. Agree a write freeze; take and verify the final backup/delta; reconcile to the accepted target.
4. Verify role membership, primary/alternate administrators and pending notification/idempotency state.
5. Change the agreed departmental domain/routing; perform real sign-in, role, case, audit, Excel and notification checks.
6. Resume writes and then the new scheduled runner; watch its first actual run and recipient receipt.
7. Preserve the old service safely under agreed access/retention controls. Do not leave two writable authoritative registers.
8. Update/reconnect the plugin to the accepted endpoint using the supported plugin management flow; test authenticated reads and safe writes. Keeping the same plugin connection across a new host is not automatic and has not been commissioned.

## Rollback sequence

Stop new writes and scheduled delivery; capture all changes since cutover; decide whether repair or rollback is safer. Restore routing/code only after reconciling newer accepted staff changes and message receipts. Never restore an older database over newer edits just to match an older code release. Reconcile notification idempotency before resuming either runner.

## Monitoring and ownership assignment (must be completed by department)

Service owner: ____  Technical operator: ____  Alternate: ____
Application/source owner: ____  Identity administrator: ____  Backup custodian: ____
Relay owner: ____  Scheduler owner: ____  Incident/escalation contact: ____
Recovery objectives / backup frequency / retention approved by: ____
SDC staging URL / production URL / secret-store reference (no secrets): ____
