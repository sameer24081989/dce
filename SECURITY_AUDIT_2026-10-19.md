# DCE Legal Case Monitor — security audit and patch report

Date: 19 October 2026. Scope: the existing hosted Worker/UI/MCP code and the supplied portable Node/SQLite/OIDC application. This is source-assisted adversarial testing and remediation, not an independent penetration-test certificate or proof of absence of vulnerabilities.

## Executed audit, step by step

1. Established the existing project identity, access audience, source revision and read-only case baseline. Retained the existing URL, plugin endpoint, access configuration and case identities. All malicious inputs and write/concurrency/recovery tests used physically isolated synthetic stores.
2. Reviewed authentication trust boundaries: platform identity headers, optional email provider, portable header stripping, signed JWTs, issuer/audience/expiry/nonce, PKCE, login state, opaque cookies, logout and role revocation. Simulated providers and locally generated RSA keys were used; no real accounts were attacked.
3. Tested authorization: anonymous/unknown-account denial, Administrator/Editor/Viewer permissions, officer assignment isolation, prohibited deadline/assignment/extension changes, audit/export restrictions, MCP parity and last-administrator preservation.
4. Tested HTTP/API input handling: JSON media types, top-level object types, unknown/prototype fields, invalid UTF-8, payload size, text/control characters, calendar dates, normalized case-number uniqueness, case IDs, statuses and method/origin restrictions. Misleading JSON media types now receive HTTP 415.
5. Reviewed browser output and injection boundaries: escaped register/calendar/audit text, spreadsheet/CSV handling, script syntax and browser security headers. Added a script-hash CSP, no-store, nosniff, referrer and restricted browser permissions. Portable HTML additionally restricts framing. These are source/protocol/script-unit checks, not completed real-browser XSS certification.
6. Tested CSRF and session ambiguity: cross-origin writes/logout, callback state/nonce mismatch, callback replay, duplicate callback parameters and duplicate cookies. Ambiguous cookies/parameters fail closed.
7. Tested identity-provider abuse: oversized streamed responses, redirect policy, unknown signing-key churn and concurrent discovery requests. Streaming reads stop at bounded byte limits; concurrent discovery shares one request and unknown-key refresh is limited to once per 30 seconds per verifier instance.
8. Tested data integrity: append-only application history, actor attribution, original deadline retention, granted/requested extensions, Done/Archived/Reopened transitions, explicit completion, legacy structures and retained case identity.
9. Tested race/replay handling: record versions, aggregate ETag CAS, concurrent normalized duplicates, repeat request IDs, permission-change checks, notification leases and multi-process SQLite concurrency. Conflicts are returned instead of silently overwriting newer records.
10. Tested downloads and maintenance exposure: Administrator-only XLSX exports and audited download generation, literal spreadsheet text, filtered audit pagination, disabled privileged maintenance/export/runner routes, backup checksums and complete-object inventory consistency.
11. Tested backup/recovery attacks: corrupt snapshots, mismatched register/access owners, occupied recovery targets, production restore prohibition, local installation, byte-preserving online backups, competing destination writers and symlink destinations. Backup publication now uses an atomic no-overwrite hard link from a private temporary directory.
12. Reviewed portable operations: SQL parameter binding, storage permissions, persistent local rate limiting, request-size/time/connection limits, source-only container copying, Docker exclusions, unprivileged service/container recipes and sensitive-response caching. Node runtime has no third-party npm runtime dependencies; OS/base-image vulnerability scanning was not available.
13. Ran the full automated regression chain on file-backed isolated storage and then actual isolated SQLite storage; ran installer/online-backup checks. Built and validated the Worker ESM artifact. Published only code to the existing owner-private website, then performed bounded read-only HTTPS smoke checks and re-read the register through the existing plugin.

## Confirmed failures and patches

The first new adversarial run contained 27 checks: 11 passed and 16 failed. These failures are evidence of missing controls or malformed inputs being accepted at a particular boundary; they do not mean 16 successful production compromises. The final suite contains 40 checks, all passing.

| Finding group | Evidence before patch | Change | Affected deployment |
| --- | --- | --- | --- |
| JSON media type ambiguity | application/jsonp, application/json-evil and non-UTF-8 charset reached JSON parsing | Exact JSON media type; optional UTF-8 charset only | Hosted and portable |
| Missing browser response protections | No CSP; API denial lacked nosniff | CSP hashes executable inline scripts; common no-store/nosniff/referrer/permissions headers | Hosted and portable; frame restriction portable only |
| Recovery ownership mismatch | Checksum-valid snapshot with conflicting access.ownerId was accepted by staging recovery helper | Require both owner identities to match before writes | Staging recovery helper; no production restore endpoint enabled |
| Weak malformed-claim handling | Signed oversized subject, control-bearing name, inverted token times, mixed audience array or wrong azp accepted | Bound identity strings; reject control characters; validate times, audience types and authorized party | Portable OIDC |
| Provider request amplification | Eight unknown signing keys triggered 16 provider fetches; concurrent discovery duplicated fetches | Shared in-flight discovery and 30-second unknown-key refresh cooldown | Portable OIDC |
| Ambiguous login inputs | Duplicate cookies or callback state parameters accepted/consumed | Reject before session/state use | Portable OIDC and hosted email-session cookie parser |
| Unbounded provider reads | OIDC response fully buffered before checking size; email response parsed without byte limit | Stream limits: OIDC 1 MiB; optional email provider 64 KiB; no redirect forwarding | Hosted email and portable OIDC |
| Backup no-overwrite race | Source had a destination existence check followed by a separate backup write | Private temporary backup; integrity verification; atomic no-overwrite publication; mode 0600 | Portable backup command; race and symlink tests pass |
| Container checkout leakage risk | Dockerfile copied the whole build context | Explicit package/worker/sdc copies; preserve and extend secret/database/backup exclusions | Portable container recipe; actual image build remains untested |
| Connection/resource hardening | Some limits relied on defaults | Early Content-Length rejection, keepalive/request-per-socket/connection limits; no-store on early HTTP responses | Portable server; no load-resilience certification |

No formal CVSS scoring was performed. Prioritise provider resource controls, identity validation and database/backup confidentiality in target acceptance. Several findings are defence-in-depth or confined to the new portable/staging tools; they were not demonstrations of live unauthorized case access.

## Actual automated results

| Suite | PASS | FAIL | BLOCKED |
| --- | ---: | ---: | ---: |
| Original 85-scenario matrix | 79 | 0 | 6 |
| Audit, XLSX and case-number changes | 47 | 0 | 0 |
| Scripted UI unit checks | 6 | 0 | 0 |
| Commissioning checks | 34 | 0 | 0 |
| Handover tools | 13 | 0 | 0 |
| Volume/capacity guards | 4 | 0 | 0 |
| Complete package export safeguards | 5 | 0 | 0 |
| Portable server/auth/SQLite/MCP | 35 | 0 | 0 |
| New security adversarial suite | 40 | 0 | 0 |
| Installer and online backup | 7 | 0 | 0 |
| Total separately identified result rows | **270** | **0** | **6** |

These are distinct result rows, not a count of every assertion and not a count of unique vulnerability classes. Full suites were repeated with file-backed and SQLite-backed fixtures; those repeated executions are not added twice. The installer ran with actual SQLite. Additional access, email, calendar, safeguards, release, MCP, rolling-rate and reminder suites exited successfully; their internal assertions are not added to the table. Runtime: Node v24.19.0.

Blocked original cases: UI-01, UI-02, UI-03, UI-06, UI-07, UI-08. Actual browser form interactions, downloads, responsive/accessibility behaviour and network recovery remain unverified. Sites instructions prohibit an improvised browser path when the designated control-browser skill is unavailable. Scripted UI tests do not replace these checks.

Machine-readable evidence: security-before-results.json, security-adversarial-results.json, security-regression-summary.json and the individual suite result files in reports/. Older initial-failure reports are retained as historical evidence and must not be confused with the current final runs.

## Is the audit comprehensive?

It is broad at application/source and isolated protocol level. It is **not comprehensive end-to-end departmental assurance**. Reviewing the test list exposed the gaps below; they remain explicitly open rather than being silently counted as passes.

| Remaining area | What is missing | Required acceptance work |
| --- | --- | --- |
| Real browser operation/security | Designated browser tooling unavailable; six scenarios blocked | Authenticated administrator/officer/viewer browser runs; stored/reflected/DOM XSS attempts in real browsers; CSP console review; actual XLSX download; responsive/accessibility and disconnect/retry checks |
| SDC network/host/TLS | No target hostname, host access, approved IP ranges or service configuration | OS/port/service inventory; firewall and management access; TLS/cipher/certificate/HSTS validation; proxy request-smuggling checks on the actual gateway stack; unprivileged process and disk permissions |
| Container and runtime supply chain | Docker/Nginx unavailable; no built image or OS package inventory | Build pinned approved image; scan image/Node/OS; patch known issues; maintain updates and produce target software inventory/SBOM |
| Real departmental identity | Provider registration, actual MFA/account policies and credentials unavailable | Login/logout/session revocation, verified-email mapping, key rotation, API audience, MFA and joiner/mover/leaver acceptance with the selected provider |
| Distributed abuse and availability | Hosted limiter is per isolate; portable limits are not a gateway/WAF; no real load tests | Gateway/WAF quotas, safe authorised staging load tests, slow-client/proxy resource tests, distributed attack controls and alerting |
| Audit authenticity and privileged storage access | Append-only in application; privileged storage/host access can alter data; SHA hashes are not signatures | Restricted storage IAM, independent audit-log forwarding/retention and tamper-evident or immutable storage; external monitoring |
| Backup operations | Local recoverability tested; no departmental encrypted/offsite service, retention, key custody or timed disaster drill commissioned | Encrypted access-controlled backups; separate recovery account; RPO/RTO acceptance; full isolated restore drill and signed-off retention/secret rotation |
| Reminders and operations | Real relay, scheduler and failure monitoring not commissioned | Test mailbox receipt, relay idempotency, missed-run/failure alerts, on-call ownership and runbooks |
| Independent validation | No external penetration tester or certification | Independent authorised penetration test and remediation retest before full departmental reliance |

Hosted framing policy was not tightened to SAMEORIGIN because the platform may embed the application; portable output is SAMEORIGIN. Confirm allowed hosted ancestors with the platform and real browser before tightening. Inline styles remain allowed for the existing interface; executable inline scripts require exact hashes. The CSP must be maintained with source changes and is not a substitute for output escaping.

Role revocation is checked against current configuration on each operation and writes recheck access ETags before commit. Separate R2 access/register writes are not a single cross-object database transaction; no claim of atomic global revocation across all concurrent isolates is made. An authorised storage administrator remains outside application-role enforcement.

## Deployment and operational decision

Code patches are suitable for the existing private platform after the passing automated checks. This release does not approve SDC cutover or full departmental reliance. Preserve the current live URL/plugin and retain the previous saved version for code rollback; do not restore older case data merely to roll back code. No case-record migration, deletion, deadline edit, role change, production restore or officer messaging was part of this security work.

Final deployment and read-only verification identifiers are recorded in the accompanying release verification report. Portable patches are delivered as source and have not been installed on an SDC server. The previously supplied confidential backup remains a separate, dated artifact and is not recreated or refreshed by this source-only security release.

## Follow-up source-package audit

An additional configuration check found that the portable OIDC adapter accepted identical browser-client and API audiences, contradicting the separate-audience requirement. It now rejects this configuration on startup. The original 36 security cases still pass with distinct API-audience fixtures. The new configuration rejection was first reproduced as a failing test and passed after correction. This is a configuration hardening issue in the portable adapter, not evidence of a successful attack against the hosted website.

Operational checks additionally found that liveness alone did not establish register readiness. An authenticated Administrator-only `/readyz` endpoint now checks that access ownership and the versioned register are readable and minimally structurally valid. Tests cover ready, unavailable and anonymous cases. It is deliberately not a full integrity/identity-provider/email check. SDC must monitor those services independently.

Corrected sdc/README.md: the source-only ZIP contains no production database or backup. Confidential production backups are separate. The older combined package must not be confused with this source-only release.

The follow-up suite originally passed 36 checks and failed three new checks (configuration rejection plus two readiness behaviours); patches resolved these failures. A fourth new check confirms anonymous readiness denial. Final follow-up automated results: 270 PASS, 0 FAIL, six original browser cases BLOCKED. Generated report timestamps record the execution time.

No changes to Worker/UI business code were needed in this follow-up. The professional teal/white interface, calendar, register, case editor, audit tab and access controls are preserved in source. No screenshots were captured and visual/browser behaviour is not certified. The Sites skill explicitly prohibits an alternative browser path when control-browser is unavailable; no browser was installed or preview server started.

Outstanding acceptance checklist: [ ] six real-browser scenarios and actual screenshots; [ ] SDC OS/network/TLS and reverse proxy assessment; [ ] actual image build/runtime vulnerability scan; [ ] departmental OIDC/MFA/account lifecycle; [ ] real email receipt/scheduler/failure monitoring; [ ] encrypted independent backups and timed disaster drill; [ ] independent penetration retest; [ ] immutable audit forwarding and operational ownership. No remaining failed automated case is known in the executed scope. These external/unsupported checks cannot be marked complete internally.
