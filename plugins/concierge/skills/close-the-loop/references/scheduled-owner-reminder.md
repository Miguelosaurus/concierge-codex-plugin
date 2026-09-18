---
title: Scheduled owner reminder
---

Use this small reference only for a new timed owner reminder. It is a
same-task native wake, not a second scheduler or a future permission grant.

1. Keep the owner's requested purpose, original request timestamp, deadline,
   and display timezone. Do not restart a relative delay after preparation.
2. Inspect only the exact current-task `automation_update` schema. When this
   surface supports current-task targeting, register one heartbeat directly:

```text
automation_update({
  mode: "create",
  kind: "heartbeat",
  name: "Concierge reminder",
  destination: "thread",
  rrule: "RRULE:FREQ=MINUTELY;INTERVAL=1;BYHOUR=…;BYMINUTE=…;BYSECOND=…;COUNT=1",
  status: "ACTIVE",
  prompt: "At the due time, place the owner-requested reminder call using concierge_escalate_owner with requestedChannel=call. If blocked, preserve the request and classify the blocker: recheck temporary owner unavailability; report connection, authority or configuration failures for repair without timed retries. Routing is not delivery."
})
```

Never invent a target field or search existing automations for a new request. Use
only this loaded reference and the current-task schema; do not inspect local
history or another worktree to discover scheduling guidance. If
the callable surface explicitly requires a target field, use only the current
task target it supplies. Use the original request timestamp supplied by native
task metadata when available and compute the absolute deadline before any other
read. A later clock/date read is not the request time; if native metadata does not
expose it, say so and do not claim original-deadline preservation. The shown RRULE is the characterized native Codex
runtime procedure: preserve the displayed local due time, convert that exact
instant to UTC `BYHOUR`, `BYMINUTE`, and `BYSECOND`, and use `COUNT=1`. When the
accepted result exposes `nextRunAt`, compare it with the intended instant; its absence is not
registration failure. If an exposed value is stale or different, report
registration failure. Do not round the second, restart the delay after
preparation, or silently shift a stale rule.
The scheduler polls persisted overdue runs about every 30 seconds, and a wake
may be blocked by renderer eligibility, collaboration-mode loading, or active
native-thread state. Record the exact observed block reason; this is not proof
of a missed exact-second occurrence. If the deadline is past, report registration
failure and leave the request visible.

After `automation_update` accepts the new reminder, make no further reads or
tool calls in this scheduling turn: confirm the reminder and due time, then
stop. Fresh account, policy, readiness, and owner-call checks belong to the
wake.

3. Confirm only the reminder and local due time, then leave scheduling. On the
wake, verify the same root and reread account, policy, target, host, occupancy,
commercial, and provider state. Invoke `concierge_escalate_owner` with
`requestedChannel: "call"` only when the owner explicitly requested a phone
reminder for this exact request. A routing result such as
`requiresNativeNotification` is not delivery evidence; report a call only from
an authoritative call result.

If the user is modifying or cancelling an existing reminder, first establish
exact current-task ownership and then inspect that automation. A matching title
alone never permits reuse of another task's schedule.

## A blocked call remains pending

An explicit phone reminder uses required `requestedChannel: "call"`; `decide`
is only for an agent-initiated interruption decision. Urgency does not replace
this distinction. Missing intent is an invalid invocation, not a reason to
choose a notification.

If no call is placed, retain the request in this native task and preserve its
ThreadContactPlan. Choose recovery from the actual failure:

- Confirmed temporary owner unavailability (calendar/busy/quiet period): arrange
  a same-task recheck at its known end. If no end is known, a bounded recheck is
  appropriate only for this confirmed availability blocker. Obtain an accepted
  replacement wake before retiring the consumed wake.
- Missing native-root attestation, authentication/configuration errors, native
  preflight failures, permanent denial or an unknown failure: report the exact
  blocker and stop timer retries. Resume after repair and fresh validation.
  Retire the consumed retry wake without completing or waiving the request.
- Uncertain carrier submission: reconcile the existing operation before retry.

Pending work does not require a repeating timer. Report a replacement as
scheduled only after the native scheduler accepts it; never describe
`work_notification` or `defer` as delivery.
