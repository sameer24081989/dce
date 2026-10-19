# Audited commissioning test plan — 19 October 2026

Purpose: establish evidenced acceptance for a departmental Court-obligation register. This is an audited finite plan, not proof against every possible failure.

## Initial list audited

The starting list covered functional regression, roles, validation, audit/Excel, concurrency, backup/recovery, browser/mobile and hosting. Audit found omissions: scheduler downtime/missed reminder points; confirmed extension grant date; an unattended runner with revocable authority; actual versus simulated delivery; non-Court-verified dates; transferred-officer access; capacity limits; staff exercise evidence; target-platform authentication trust boundaries; and rollback that preserves newer data.

## Refined execution list

| ID | Work package | Evidence / acceptance |
|---|---|---|
| P01 | Existing 85-scenario matrix | Rerun; identify six browser/device gaps separately |
| P02 | Audit/Excel/case-number 47 scenarios | Rerun; role checks, legacy preservation, concurrency |
| P03 | Existing supplementary suites | Authentication, MCP, rate window, notification retries, recovery |
| P04 | Exact seven/three-day reminders | IST calendar arithmetic; no inferred deadlines |
| P05 | Catch-up after missed/new/revised deadline | Once per case/deadline/recipient; normal three-day alert retained |
| P06 | Invalid/missing/legacy deadline evidence | Flag missing evidence; do not invent grant dates |
| P07 | Extensions and disposal | Requested extension leaves deadline; granted date/reference recorded; disposal alone is not completion |
| P08 | Scheduled runner authority | Explicit opt-in, dedicated secret, active administrator delegation, no browser-origin bypass |
| P09 | Failure/duplicate delivery | Backoff, leases, relay idempotency contract; simulated transport distinguished from inbox proof |
| P10 | Recovery and access races | Tampered backup refusal; safe empty-target recovery; changed authority stops commits |
| P11 | Data volume | Synthetic large calendar/register and payload/capacity safeguards; no production load testing |
| P12 | Excel integrity | Independent reader; Unicode, formulas, continuation columns |
| P13 | Hosted regression | Run candidate under separate hosted R2 staging; preserve private audience |
| P14 | Live smoke/integrity | Compare released code, authentication boundary and unchanged production records |
| P15 | Browser, phone, keyboard, screen reader | Requires supported browser capability or departmental test operators; never substitute static assertions |
| P16 | Security review | Boundary review and automated negative tests; independent penetration test remains distinct |
| P17 | SDC runtime/storage/authentication | Document current dependencies and target acceptance contracts; requires SDC specifications and access |
| P18 | SDC TLS/domain/network/monitoring | Target evidence required; do not guess endpoints or credentials |
| P19 | Real email/scheduler receipt | Department-controlled staging mailbox, configured relay and unattended schedule required |
| P20 | Training/UAT | Prepare role-specific exercises, expected outcomes, attendance/sign-off form; actual staff completion requires staff |
| P21 | Ownership/operations | Primary/alternate administrators, source ownership, backup operator, retention and recovery objectives to be approved |
| P22 | Cutover/rollback | Rehearsal, record/hash comparison, write freeze, last delta, rollback without overwriting newer data |

Status convention: PASS = executed acceptance evidence; FAIL = observed mismatch; BLOCKED = required environment/access missing; PREPARED = material ready but people/environment exercise unexecuted; PARTIAL = only the explicitly stated part has evidence. Historical results are labelled and not presented as newly executed.

## Execution boundaries

Production case records will not be seeded, migrated, corrected or restored. Source-only fixes can be published after isolated tests. No real officer messages, external invitations or new scheduled automations will be sent/created. Departmental deployment cannot be commissioned without the target server, chosen identity provider and delivery configuration.
