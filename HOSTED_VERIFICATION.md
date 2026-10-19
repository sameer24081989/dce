# DCE hosted staging verification — 19 October 2026

Private review site: https://dce-legal-isolated-staging.jocundgnome.chatgpt.site

This is a separate Site with independent R2 storage, no production database binding, no copied production authentication secrets, and synthetic case data only. The live department website and plugin were not deployed or migrated.

## Actual outcomes

- Local 85-scenario matrix: **79 PASS, 0 FAIL, 6 BLOCKED**.
- **66 matrix scenarios have passing hosted results** from execution inside the deployed Worker. Synthetic database fixtures used the staging site's real R2 binding with per-run namespaces.
- One initial hosted failure: OPS-03 returned 400 rather than the expected 429 when the request sequence crossed a clock-minute boundary. The limiter was changed to a rolling 60-second interval, a deterministic boundary regression was added, and the hosted retest passed.
- Supplemental hosted notification checks passed: retry exhaustion, competing delivery leases, stable keys/deduplication, and cancellation of pending delivery after a granted deadline extension.
- Hosted backup/recovery tests restored records, history and access roles into an empty isolated target, and refused an attempt to recover over a populated target. Production restore guards were also exercised.
- A private staging dataset with two cases on 19 October and an overdue case on 15 October is available for browser review. These are synthetic cases 9001/2026, 9002/2026 and 9003/2026.

`hosted-results.initial.json` retains the original failure. `hosted-retest.json` records the correction and supplemental delivery tests. `hosted-results.csv` and `hosted-results.json` combine the final evidence; NOTIFY-EXTRA is supplemental, not an additional row in the original 85.

## Verification boundaries

The 66 hosted scenarios test backend and storage behaviour, not real officer sessions in a browser. The internal harness uses synthetic actor contexts; separate HTTP boundary checks are recorded in hosted-http-auth.json. Email delivery was deliberately simulated: no real recipient was contacted, so this does not prove mailbox receipt or an authorised sender connection.

Six original rows remain blocked for actual browser evidence: UI-01, UI-02, UI-03, UI-06, UI-07 and UI-08. Underlying server/static assertions pass where applicable, but keyboard, mobile, focus, network recovery and form persistence cannot be certified from those assertions. No supported browser-control skill was available, so no browser was installed or improvised.

The test route exists only in staging source and requires both private Site access and a separate runtime secret. It is absent from the production candidate. No credential values appear in these reports.

## Remaining release gates

1. Execute the six browser/device rows on the private staging site.
2. Connect a department-authorised sending service and authenticated scheduled runner; verify a real test mailbox, timeout retry deduplication and operation while the website is closed.
3. Review the role/deadline rules and production preflight, obtain explicit production migration confirmation, and follow the maintenance-window/backup/activation sequence in DEPLOYMENT_READINESS.md.

Production deployment remains **HOLD**. A passing backend suite is not approval to migrate production data.
