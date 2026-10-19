# DCE departmental training and user acceptance workbook

Prepared 19 October 2026. Training materials prepared; no departmental participant has been trained or signed off by this automated session. Use an approved isolated staging environment and synthetic records. Never practise bulk imports, restoration or role removal on the live register.

## Roles and prerequisites

- Administrator: maintains access, registers/assigns cases, controls deadlines/extensions/case-number correction, audits and complete Excel downloads.
- Case Officer (application role Editor): edits permitted fields of cases assigned to the same verified email; cannot change deadlines, assignment, extension fields or case number.
- Viewer: reads the register; cannot edit or download the administrator-only full database/audit.
- The private current Site has a second entry gate: Site viewing access plus the application role are both required. A role alone does not bypass Site sharing. On SDC the chosen identity/access system must reproduce this protection.
- At least one administrator must remain. Nominate primary and alternate departmental administrators. Do not share personal passwords, mail OTPs or runner/relay secrets.
- The present data model has one current recorded compliance deadline per case. Cases with simultaneous independently due obligations need an agreed additional tracking design; do not overwrite one live obligation to represent another.

## Where to find controls

Start with **Case register** in the left menu to see **Manage access** and **Reminder delivery**. Use **Audit & downloads** for audit search and administrator Excel downloads. From a selected case, use the separate case-number correction/renumbering button; ordinary case-number editing is locked.

## Facilitated sessions (suggested agenda, not completed attendance)

| Session | Audience | Exercise outcome |
|---|---|---|
| 1. Enter and verify | All users | Explain staff-entered dates, calendar urgency and missing information |
| 2. Work and control | Administrators and officers | Assign, update, manage extension, complete/reopen safely |
| 3. Audit and reporting | Administrators | Search old/current case numbers, inspect before/after values, download workbook |
| 4. Reminders and failure handling | Administrators and operator | Interpret outbox, receipt evidence, retry/catch-up, last-run summary |
| 5. Recovery and handover | Technical operator and administrators | Validate backup, recover to empty staging, reconcile and revoke former access |

## Synthetic exercise catalogue

Choose a recorded exercise date T. Use the supplied fixture generator to produce T+7, T+6, T+3, T, T-1 and unassigned synthetic cases. Generator output is local JSON only, not a production importer. Trainer must use the approved isolated fixture-loading procedure. Use department-controlled test mailboxes only for delivery exercises; `.example.test` addresses do not prove real receipt.

| Exercise | Task | Expected outcome / evidence |
|---|---|---|
| UAT-01 | Administrator registers a valid case with verified order source and deadline | One stable ID; initial audit; no inferred date |
| UAT-02 | Enter blank number, duplicate normalized number and 30 February | Rejected with actionable error; no additional record |
| UAT-03 | Assign officer A; A edits own action/order | Allowed; actor and before/after history correct |
| UAT-04 | Officer A tries case B, deadline, grant date and case number | Server denies unauthorized changes; data unchanged |
| UAT-05 | Viewer signs in | Read permitted; no edit/save or administrator audit/export actions |
| UAT-06 | Two browser windows edit the same version | First valid save wins; stale save receives conflict; manually reconcile after reload |
| UAT-07 | Request extension with date/reason, without granted order | Existing deadline remains; original deadline preserved |
| UAT-08 | Record granted extension, grant date and order reference | Administrator only; revised deadline accepted; original and audit retained |
| UAT-09 | Omit grant date on new grant | Rejected; do not invent a date to pass validation |
| UAT-10 | Correct typo in case number | Separate confirmation/reason action; same ID; old/new searchable in audit |
| UAT-11 | Record Court renumbering | Order reference and date required; same case identity |
| UAT-12 | Search audit by case, date, actor, field and action | Correct matching rows; IST date boundaries; legacy gaps labelled |
| UAT-13 | Download filtered audit and complete database Excel | Actual .xlsx opens; filters/case counts correct; export event recorded; secrets absent |
| UAT-14 | Complete, archive and reopen a synthetic case | Same ID and history retained; verify filing/task completion before marking Done |
| UAT-15 | Select calendar date with two cases; select overdue date | All relevant cases visible; overdue shown; disposal alone is not compliance completion |
| UAT-16 | Revoke officer A while their session remains open | Next restricted request denied; no continuing delegated access |
| UAT-17 | Seven-day and three-day scheduled staging runs | Observe outbox and actual departmental test-mailbox receipt at each stage |
| UAT-18 | Enter six-day deadline after missed seven-day point | One catch-up; no repeated catch-up on next run; normal three-day stage still occurs |
| UAT-19 | Relay rejects, times out or loses acceptance response | Retry/status visible; relay deduplicates stable key; no false receipt claim |
| UAT-20 | Close website before scheduled run | Independent runner executes; last-run evidence and mailbox receipt confirmed |
| UAT-21 | Change officer or granted deadline during queued retry | Obsolete notification cancelled; appropriate new recipient/deadline handled |
| UAT-22 | Recover verified snapshot into empty staging | Records, histories, roles and outbox reconcile; no production overwrite |
| UAT-23 | Use keyboard only and screen reader | Labels, focus, dialogs, date selection, validation and errors usable |
| UAT-24 | Use real phone/narrow viewport | Calendar, audit, dialogs and actions readable and operable |
| UAT-25 | Interrupt network during save, then reconnect | No misleading success; values retained; conflict-safe retry |
| UAT-26 | Departmental ownership handover | Alternate admin can operate; former officer access revoked; hosting/source/recovery ownership documented |

## Operator daily drill

1. Review due-today/overdue calendar and unassigned records; check recorded orders.
2. Inspect Reminder delivery: last completed run, data issues, Blocked/Retry/Failed items. A historical Sent status means relay acceptance, not proof of inbox reading.
3. Check external scheduler/relay monitoring. No last-run entry or stale entry requires investigation; the website must not be assumed to send reminders merely because it is open.
4. Resolve missing officer email or legacy grant evidence through an administrator. Never calculate an uncertain Court date automatically.
5. Confirm scheduled backup succeeded and protect export files as departmental records.

## Escalation exercise

A deadline is imminent and no receipt is available: record the incident and contact the responsible officer through the department's approved operational channel. Automated delivery does not replace administrative follow-up. Identify the primary/alternate operator and escalation contacts in the departmental runbook; names are not supplied or invented here.

## Completion record (blank; staff must fill)

Participant name / verified account: __________  Role: __________
Trainer: __________  Staging URL / build: __________  Exercise date: __________
Exercise IDs attempted: __________  Actual results / evidence location: __________
Defects found / retest: __________  Participant demonstration completed: __________
Trainer sign-off: __________  Departmental acceptance authority: __________
