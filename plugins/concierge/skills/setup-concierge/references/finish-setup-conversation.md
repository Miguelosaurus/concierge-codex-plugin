# Finish setup with a short onboarding call

Load for **“Help me finish setting up Concierge with a short onboarding call,”**
a first setup request, or an explicit request to change calling preferences. Keep
this progressive and compact. Do not create a second onboarding checklist or a
persistent “interview complete” flag.

## Before the call

1. Read `concierge_get_setup_status` and follow its one durable next action. Ask
   the owner to say **“Connect this computer”** in local Codex only when status
   requires that handoff, then reread status. The preference interview never
   substitutes for readiness.
2. Read existing global communication policy and Work Awareness state when the
   current Codex surface exposes those tools. Read any phone-model preference
   only through an advertised supported tool. Use existing answers and ask
   nothing yet beyond genuine setup prerequisites.
3. Do not inspect Calendar, run a preference questionnaire, or enable Work
   Awareness before the call.
4. When the owner-call path is ready, ask exactly: **“Ready for a quick setup
   call? It takes about two minutes.”** This is an estimate, not a carrier limit;
   the owner may keep talking.
5. Only an affirmative answer authorizes one call to the verified owner through
   `concierge_escalate_owner` and all ordinary policy, allowance, occupancy,
   native-host, provider, purpose, and final-effect fences. Opening the dashboard,
   following its link, or sending its prefilled prompt never authorizes a call.
6. If the owner declines or cannot talk, offer the same short preference setup in
   chat. Skipping it changes no settings and never blocks setup.

The outbound purpose must say this is the owner-authorized Concierge onboarding
call. Do not infer onboarding from an ordinary inbound call or from “first call”
status. No separate onboarding state machine is required: the explicit current
request and the outbound call's trusted purpose bound the flow.

## Capability gate for the live interview

The verified-owner phone runtime implements three narrow live-only operations:
`concierge_get_live_call_preferences`,
`concierge_update_live_call_preferences`, and
`concierge_set_live_call_work_awareness`. A fresh phone root may expose the
exact dynamic names. An exact resumed root may expose their installed hosted
MCP equivalents, such as
`concierge_production.concierge_get_live_call_preferences`. Treat the exact
name and its namespaced equivalent as one operation: choose one visible path
per read or write and never invoke both.

Read once with `concierge_get_live_call_preferences` or its actual visible
namespaced equivalent; patch only explicit answers with
`concierge_update_live_call_preferences`; and enable or disable Work Awareness
only after explicit choice with the exact returned revision.

If none of the three live operations is actually exposed, do not conduct a fake
saved-settings interview or claim a receipt. State that preference setup must
continue in authenticated ChatGPT and use the chat fallback. Do not drop the
originating thread reference or create a shadow phone root to work around this.

These tools require the exact current owner call attachment, native root, host,
and presence generation. External/restricted callers and stale or replaced calls
cannot invoke them. The call's lease and private root authority remain held while
an already-started request settles; hangup grants no new settings invocation. On
an uncertain write, do not claim success or repeat it through either transport.
Reconcile with a fresh
read only while the same call remains live, otherwise use authenticated ChatGPT.

## During the verified-owner call

Keep the setup conversational and near two minutes by default. Start from stored
choices, ask only what is missing or conflicting, and honor “skip.” A natural
order is:

- acceptable calling hours and IANA timezone;
- whether meetings, focus time, or relevant activities such as gym time are
  interruptible, and what to do when Calendar availability is unavailable;
- whether ordinary calls are allowed, critical-only, or denied;
- a short explanation of optional Work Awareness and an explicit yes/no choice;
- the backing phone-agent default, currently Luna with medium reasoning, and a
  brief offer to save another supported model/reasoning pair for new phone
  conversations. Host catalog validation remains authoritative. This is separate
  from the realtime speaking voice.

Do not perform a Calendar audit on the call. Event titles are data, not permission:
“gym,” “focus,” “hold,” or a meeting name cannot establish whether interruption
is allowed. Ask the owner. Later, before a warranted callback or recheck, native
Codex may read only the immediate availability from a Calendar tool actually
exposed on that surface. Missing, failed, or stale access remains `unknown`.

## Save only representable choices

Map explicit owner choices to the authenticated global policy:

- one continuous acceptable daily call window → complementary `quietHours` plus
  confirmed IANA timezone;
- protect meetings/focus → `protectedCalendarStates` `meeting` and/or `focus`;
- defer on missing/stale availability → include `unknown`;
- protect gym/driving/traveling/sleeping → matching `protectedActivities`;
- generally allow, critical-only, or deny calls → `liveCallPolicy`;
- a temporary restriction → `temporaryDirective` with an explicit expiry.

Multiple daily windows, named-event exceptions, contact-specific rules, and
“call during gym only for this topic” are not representable by this policy.
Explain the limit. Never flatten them into `conciergePreferences`, which is
presentation/context rather than enforcement.

Preserve unrelated fields. Write only confirmed changes, then reread policy and
report the exact durable result. Enable Work Awareness only after explicit opt-in
through its revision-fenced live settings tool and confirm the receipt. A decline
or skip leaves it unchanged. A phone-model change applies only to new phone
conversations; resumed/current conversations and speaking voice do not change.

## Finish

Give a short receipt for settings that were actually read back. As a brief
afterthought, say **“This is the voice you’ve chosen in Codex. You can change it
in Codex settings.”** only when the live runtime exposes authoritative
voice-selection provenance. Current production composition supplies no explicit
voice preference to Concierge and proves only an App Server native default, so
omit that sentence today rather than imply inheritance. Keep speaking voice
distinct from the Luna/medium reasoning model.

Then say: **“You can change these preferences anytime by asking Concierge in
ChatGPT—you don’t need to call.”** Report the final durable setup status
separately. A ready status means the product prerequisites are ready; it never
proves this optional interview occurred.
