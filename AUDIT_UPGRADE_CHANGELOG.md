# DCE Legal Case Monitor — Audit upgrade

- Added an administrator-only Audit tab with text, actor, field, operation and inclusive IST date filters, plus 50-row pagination.
- Added genuine Excel OOXML downloads for filtered audit, complete audit and the complete register. Workbook sheets preserve case data, deadline/extension changes, raw legacy histories, access settings/history, notification history, register metadata and request receipts.
- Every successful Excel export appends an actor-attributed event using conditional writes; backup or audit-write failures stop the download.
- Ordinary case edits and MCP saves cannot change an existing case number. Added administrator-only correction and Court-renumbering actions with reason, confirmation, uniqueness checks, versions and retry receipts. Court renumbering requires an order reference and date.
- New history entries store actor role, historical case number, historical E-office reference and applicable supporting reference. Older gaps are explicitly labelled.
- Permanent case IDs, original deadlines, existing history, authentication, project identity and plugin endpoint are retained. No production data migration is required.
- No new superadministrator role was introduced: Administrator remains the highest existing application role.

Verification limits: browser/device/accessibility checks are not certified; legacy missing metadata cannot be reconstructed; Excel downloads are review/analysis exports rather than full recovery backups. Departmental notification delivery remains unconfigured.
