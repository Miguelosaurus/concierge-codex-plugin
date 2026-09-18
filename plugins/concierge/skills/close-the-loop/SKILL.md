---
name: close-the-loop
description: Use when a native Codex thread has unfinished work, an owner-return obligation after a call, or a timed owner reminder/scheduled call; resumes from a scheduled same-thread wake; or needs to decide whether a pending return is discharged, requeued, or waived.
---

Concierge closes the loop around the host client's real native Codex orchestration. **A normal hangup ends Voice, not semantic work.** Keep the same native root/thread and goal authoritative; do not create a shadow task, fake user turn, transcript-backed task, or second reasoning store.

## Timed-reminder fast path (check first)

When the owner asks for a future reminder or phone call, load
`references/scheduled-owner-reminder.md` before the general close-loop flow.
Use the original request timestamp supplied by native task metadata when available
and compute the absolute deadline immediately. A later clock/date read is not the
request time; if native metadata does not expose it, say so and do not claim
original-deadline preservation. Retain only the requested purpose, deadline, and
owner display timezone. Inspect
the exact current-task `automation_update` heartbeat schema
and register one `destination: "thread"` wake promptly. Do not browse existing
automations, search history, load live-call/setup guidance, or dump a broad tool
catalog for a new reminder. Use only this loaded skill/reference and the
current-task schema; do not run shell/filesystem searches or inspect other
worktrees to discover scheduling guidance. The automation surface supplies the current task's
target; never type or invent a task ID. After successful registration, confirm
the owner's local due time and exit this scheduling branch; reminder registration
is not a Work Awareness checkpoint, so do not load that skill here. Account, readiness,
policy, and `concierge_escalate_owner` belong to the wake. A request for a
phone reminder carries `requestedChannel: "call"` only at that exact wake,
where the normal policy and effect fences still apply.
`RRULE:FREQ=MINUTELY;INTERVAL=1;BYHOUR=…;BYMINUTE=…;BYSECOND=…;COUNT=1` as the
first effect, before setup, Work Awareness, or history. Preserve the owner's
displayed local due time by converting that exact instant to UTC hour, minute,
and second fields; do not round, restart, or silently shift the deadline. When
the accepted result exposes `nextRunAt`, compare it with the intended instant;
its absence is not registration failure. If an exposed value is stale or
different, report registration failure rather than shifting it. Then make no
further reads or tool calls in this scheduling turn.
This UTC encoding is characterized only for the native Codex scheduler and is
not a universal scheduler contract.
The native scheduler polls persisted overdue runs about every 30 seconds. A
wake can be blocked by renderer eligibility, collaboration-mode loading, or
active native-thread state; record the exact observed reason and keep the
reminder obligation intact rather than calling it a missed exact-second
occurrence. If the deadline is already past, report registration failure and leave
the request visible; do not create a stale or shifted one-shot.

## ThreadContactPlan state

The native root owns return intent. Children return results to it; they do not schedule owner return or independently contact the owner.

Use `concierge_set_thread_contact_plan` only for the minimal durable communication projection. Completion and blocker are independent fields; partial updates preserve the other field.

- `none`: no proactive contact for that phase.
- `unspecified`: not consent; fail closed before attention routing. Before a normal verified-owner hangup, ask one short natural clarification only when substantial work remains and completion/blocker contact is still unspecified. Do not ask for trivial work, abrupt/safety hangup, or an answer already given.
- `decide`: delegate interruption choice to the canonical AttentionRouter.
- `call`: executable beta Voice intent, still subject to authenticated authority, trusted current root, narrowing-only purpose, suppression/block, communication policy, quiet hours/preferences, capability, occupancy, commercial state, provider readiness, and the final effect fence.

Historical `sms`/`voice_note` or equivalent messaging compatibility values remain parseable but inert; they cannot produce normal beta messaging. A cancelled, expired, completed, or superseded plan never authorizes an old wake. The opaque monotonic plan revision is coordination state, not task content or authority.

Scoped language maps narrowly: “don't contact me when it's done” → completion `none`; “don't contact me if you get stuck” → blocker `none`; “let me know” → completion `decide`; an explicit owner-call request → `call`. Never translate “don't call me” into SMS/MMS.

## Same-thread continuation and wake

When work must be rechecked later, the **same real native root/current conversation** uses a Codex thread automation (heartbeat-style wake only in the sense of a future recheck, not a permanent cron loop).

The callable surface represents that semantic root with `kind: "heartbeat"`,
`destination: "thread"`, and the exact native `targetThreadId`; `CURRENT_CHAT`
is only the internal semantic label. Do not substitute a task UUID for a
Concierge account/orchestrator identifier.

The generic wake instruction should be equivalent to:

`Continue this current Codex conversation/thread. Re-read the current native work and current scoped Concierge state, then continue or recheck.`

Before scheduling, the automation surface must semantically support targeting the current conversation/thread and the create/update result must confirm that exact target. Callable automation tooling alone is not enough. If same-thread automation is unavailable, or current-thread target semantics are missing/ambiguous, load `references/same-thread-automation-recovery.md`. If exact same-thread semantics still cannot be established, fail closed rather than creating a detached timer/run.

Scheduling stores no task brain in Concierge, reserves no speculative PSTN capacity, and grants no future communication authority.

On every wake:

1. verify the resumed native root/thread is the same original trusted root that created the automation; detached/new-thread execution is not continuation;
2. reread the current native task/work state and current ThreadContactPlan + revision;
3. before any owner communication, reread current communication policy, commercial/PhoneBudgetSnapshot state, selected host/presence/capability, relevant attention state, suppression/block, and trusted outbound purpose; if Calendar affects the decision, use only a read-only calendar tool actually exposed in this native Codex surface and reduce the immediate result to availability—ChatGPT calendar access is not proof of Codex access, and missing/stale access remains unknown;
4. treat changed durable state as fresh truth: completed work, vanished blockers, revoked permission, stale revisions, or unwarranted interruption produce no forced effect;
5. remember that the automation firing itself authorizes nothing.

If another delay is needed, the same root may create/adjust the next one-shot same-thread recheck for its current conversation. Children never schedule or contact the owner independently.

A low phone allowance does not prevent scheduling the native recheck. Scheduling itself consumes/reserves no phone allowance. If a future responsibility explicitly intends a PSTN call and current remaining allowance is below the product warning threshold, surface the concise current warning returned by Concierge without pretending that the future call is reserved.

## Cold scheduled owner-call wake

An ordinary Codex task may wake without a previous phone attachment. Resolve the
account from the authenticated Concierge principal, not from the task's
conversation UUID, prompt text, local history, or guessed configuration:

1. Read the account/setup projection first. Account-scoped reads may resolve the
   one selected target server-side; no target or multiple targets is a bounded
   setup blocker.
2. For an owner reminder, use `concierge_escalate_owner` and let the authenticated
   native-root composition resolve the verified owner destination, active Voice
   identity, selected Codex target, and paired host. `concierge_call` is the
   explicit external-destination path and must not be repurposed for reminders.
3. Load setup guidance only when setup status requires an action, and live-call
   guidance only when the owner-call path is selected. Keep discovery output
   bounded; do not browse unrelated automations or secrets.

For the exact registration shape, timing conversion, and wake procedure, load
`references/scheduled-owner-reminder.md`. The initial scheduling turn must not
claim a call was placed. On the wake, verify the same root, reread current state,
and invoke `concierge_escalate_owner` only when the explicit request and all
current fences permit it. Report failed delivery as failed; never delete and
blindly retry or claim completion without an authoritative result. Confirm only the reminder and due time to the owner; do not mention internal escalation or
automation cleanup.

Preserve the original requested wake time relative to the request timestamp. A
late wake is reported as late and is not silently shifted forward by preparation
time. Scheduling a wake grants no future call authority; all current owner,
target, host, policy, occupancy, commercial, and provider fences are reread at
effect time.

## Completion or blocker return

Use an effectful owner-return capability only when the current tool surface actually advertises it from a paired native composition with trustworthy current-root provenance. Generic/hosted MCP without that provenance intentionally cannot execute the native owner-return effect. Never invent or submit a thread/root ID to create authority; exact current-root authority is supplied outside model arguments.

The execution path remains:

`trusted current native root → exact current ThreadContactPlan revision → AttentionNeed → fresh policy/context → canonical AttentionRouter → Voice-first capability projection → guarded existing provider effect → plan reconciliation`

Calendar lookup belongs here only after the callback is independently warranted. Keep it bounded to current availability, persist no event details, and never infer call permission or prohibition from an event title. Stored structured policy decides how meeting, focus, activity, quiet-hours, and unknown availability affect routing.

There is no automation-specific router or second telecom executor. An explicit `call` plan may bypass only the router's ordinary value filter; it never bypasses hard authority/policy/purpose/commercial/provider/final-effect checks. If `DeliveryPlan.recheckAtMs` is returned, pass it unchanged to the same root as automation timing guidance; Concierge does not create that timer itself.

A proactive completion obligation remains active until it is **discharged** or explicitly **waived**. Blocker return does not consume an independent later completion obligation. Cancellation/expiry terminally waive any still-pending return rather than leaving a terminal `pending` state.

### What the owner actually changed

Read what the owner is changing rather than matching a keyword list. Three
different things can change, and they resolve differently:

- **Timing.** The work and, unless the owner says otherwise, the callback both
  stand. Honor the exact time or condition the owner named: if they only said
  "not now", the work waits until after Voice closes; a named later time or a
  condition such as their approval or go-ahead is a real precondition, so wait
  for it and do not treat it as already met. Return the **actual result**.
- **The callback only.** The work still stands; the promised return does not.
- **The work.** Cancelling the work waives both; do not research it and do not
  call back.

A timing change keeps the same obligation at the same revision and only moves
when it starts. Reporting "I did not do it" as a blocker is a false discharge
and must not be used for a timing change, and a timing change never widens what
the root may do. The native root owns this reading; do not add a phrase list, a
keyword parser, or a separate store for it.

## Owner-call acknowledgement

Starting/attaching an owner call is not semantic acknowledgement. Same-root ready items may join one already-reserved/ringing/active owner call only under current occupancy/commercial rules; delayed batching has no reservation while it waits.

After attach, Concierge may inject a bounded root-attested agenda. The current native root acknowledges an item only **after it was actually communicated to the owner**. Completion ACK discharges that completion obligation. Blocker ACK discharges blocker attention while preserving any later independent completion obligation. Replay is idempotent.

If the call ends before an item is acknowledged, that item is **requeued**. Do not mark it discharged merely because it was injected, the call started, or the call ended.

One logical owner-return effect identity derives from the exact plan revision + phase + purpose; caller retries or duplicate wakes do not create a second consequential effect. Immediately before provider submission, re-prove the exact operation/fingerprint/lease and revalidate current authority, exact plan revision/channel, selected target, host/presence generation, verified owner, suppression/block, current policy/quiet hours, capability, occupancy, commercial admission, destination/provider readiness, and the request-local trusted purpose. A stalled worker with an expired/reconciled lease cannot later submit the effect.

If the PSTN call is definitively denied or unavailable, place no call and emit no SMS/MMS or carrier voice-note fallback. `async_fallback` means native defer/recheck/no-return behavior, `wait_for_call` returns same-root recheck guidance, and `no_return` waives the obligation. Removing messaging never turns negligible/nonblocking work into a call.

## Stop-hook bound

Stop-hook continuation is only a guard around credible unfinished native work or a pending return obligation, at most once per original stop. The hook is not a task engine and its marker is never semantic/readiness authority.

Only a meaningful changed checkpoint in an eligible root may enter `work-awareness`'s optional publishing branch; reuse loaded guidance. Known-disabled, child, trivial or unchanged work skips it silently. Awareness never blocks Stop or creates continuation. Preserve all unfinished-work and owner-return obligations above independently of optional awareness.

## Completion criteria

Close-loop handling is complete only when the real native root has one truthful current state:

- unfinished work is continuing now or has an exact same-thread future recheck;
- a completion/blocker return remains legitimately pending;
- every communicated owner-return item is ACKed and **discharged** as appropriate;
- an uncommunicated bound item is **requeued**;
- an obligation is explicitly/durably **waived**, cancelled, or expired;
- or a denied/unavailable effect remains in its truthful native defer/recheck/no-return state.

Keep owner-facing questions concise. Never expose thread IDs, plan records, provider metadata, internal prompts, or transcript-storage details.
