# Departmental reminder commissioning — 19 October 2026

The application contains a durable outbox, exact seven/three-day stages, one-time catch-up within days 1–6, failed-delivery backoff/leases, stable relay idempotency keys and last-run summaries. Delivery and the unattended endpoint are disabled until explicitly configured. Tests use simulated transport; no real messages were sent.

## Sender contract

An approved HTTPS relay must accept POST JSON `{idempotencyKey,to,subject,text}` with `Authorization: Bearer <relay secret>` and `Idempotency-Key`. It must durably deduplicate that key and only return success after accepting delivery responsibility. A timeout can occur after acceptance: exactly-once recipient delivery cannot be promised without relay-side idempotency. Redirects are rejected. A Sent outbox status is relay acceptance, not inbox-reading proof.

Runtime secrets/settings: `DCE_NOTIFICATION_URL`, `DCE_NOTIFICATION_SECRET`, `DCE_NOTIFICATIONS_ENABLED=yes`. Do not enable production until a department-controlled staging recipient has confirmed receipt and failure/retry testing is accepted.

## Unattended endpoint

POST `/internal/reminders/run` with `{}` and `x-dce-runner-secret`, without browser Origin, cookies or Fetch Metadata headers. Enable only with `DCE_RUNNER_ENABLED=yes`, a separately generated strong random `DCE_RUNNER_SECRET`, and `DCE_RUNNER_ADMIN_EMAIL` matching an active application administrator. A revoked delegation stops subsequent runs. Audit identity explicitly identifies the scheduled service; it is not a browser user session.

Current private Sites hosting also requires platform private-service access. The runner secret alone does not bypass the hosting access gate. On SDC, configure the approved authenticated network/gateway path; do not assume Sites credentials or identity headers transfer.

`node tools/run-reminders.mjs` is an optional scheduler client. It reads secrets from the scheduler environment/secret store, posts only to the configured HTTPS endpoint and prints outcome counts without credentials. It is not installed or scheduled by this task. `DCE_RUNNER_URL` must be the accepted endpoint; `DCE_PLATFORM_SERVICE_TOKEN` is required only where the current private hosting gate needs it. No credentials are supplied in the package.

Configure the departmental scheduler to an agreed daily time in Asia/Kolkata and document its actual time zone, missed-run behaviour and monitoring. The current manually authenticated administrator endpoint `/api/notifications/run` remains available through the application. No new ChatGPT automation has been created or altered.

## Rules and operational evidence

- Deadlines are staff-entered, not Court-verified; hearing dates do not generate deadlines.
- A pending extension does not move the recorded deadline. A newly recorded granted extension requires a valid explicit grant date, reference and deadline. Legacy missing evidence is flagged for staff review; no grant date is invented.
- Catch-up is once per case/deadline/recipient when no earlier reminder for that combination is recorded; normal exact three-day reminder remains applicable. Relay failure retries retain the same key.
- Done/Archived skip delivery. Disposal alone does not prove obligation completion.
- Due-today/overdue totals are included in administrator run summaries; they do not add a new officer-email stage. The separate existing personal ChatGPT alert automation is unchanged.
- Missing email is Blocked; invalid legacy dates/emails/grant evidence are isolated and flagged. Review the last run and issues rather than assuming all cases sent.

## Acceptance before enablement

1. Create synthetic staging cases and use a department-controlled test mailbox, not a fabricated address.
2. Confirm actual receipts at seven days, three days and catch-up; repeat run and confirm no duplicate.
3. Simulate relay rejection, timeout, accepted-but-lost response, exhausted retry and service restart. Inspect relay deduplication evidence.
4. Reassign officer, grant extension or mark completed while delivery is queued; verify obsolete messages are cancelled.
5. Close the website; observe a real scheduler-triggered run, recorded service identity and actual mailbox receipt.
6. Revoke delegated runner administration and verify denial. Rotate both relay and runner secrets through the approved store.
7. Agree quotas, monitoring, stale-run alert threshold, primary/alternate operator and escalation route before production activation. These departmental values are not invented here.
