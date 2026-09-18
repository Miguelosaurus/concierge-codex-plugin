---
name: setup-concierge
description: Use when the user asks to set up or expand Concierge, inspect its existing phone identity, choose the operational phone target, connect the Codex native host, or configure owner-attention/Voice escalation behavior.
---

Concierge gives an **existing native orchestrator** a persistent PSTN Voice identity. It does not create a replacement voice agent.

## Connect this computer

For this request, first load [local-connection.md](references/local-connection.md).
Its exact local-host check gates success. Account setup status and the selected
host can describe another computer; they cannot establish this computer's state.

## Durable setup loop

`concierge_get_setup_status` is the setup source of truth. Read it before explaining or continuing setup. **Follow the exact returned next action.** After every web or native handoff, call `concierge_get_setup_status` again. Treat one response as the current state: report the concrete pending/required action it names, or the readiness it proves, rather than inventing a parallel checklist.

Load [setup-branches.md](references/setup-branches.md) when the user asks for product explanation, a second computer, a target comparison, Work behavior, or the consumer-facing connection direction, or when durable status requires account activation/recovery or a local connection handoff. That reference supplies branch-specific guidance; this file keeps the status loop and hard effect boundaries in view.

For “Help me finish setting up Concierge with a short onboarding call,” a first setup request, or an explicit request to configure calls, load [finish-setup-conversation.md](references/finish-setup-conversation.md). It completes durable prerequisites, asks for explicit authorization before one short owner call, and keeps the optional preference interview separate from what `concierge_get_setup_status` proves.

1. Read status and identify the one current state/action.
   When the requested outcome is to connect **this computer**, account-level
   readiness is only background state. It may describe another computer on the
   same Concierge account and cannot prove the current computer is connected.
   Do not satisfy that request from `concierge_get_setup_status`,
   `concierge_get_account_status`, or `concierge_get_capabilities` alone.
2. If status asks for target or computer readiness, use the supported Codex path. **Current beta phone target: Codex only**, and only a paired native host that is ready can carry live phone work.
3. When local readiness is required, tell the user to open Codex on the desired computer with the installed Concierge plugin selected and active and issue exactly **“Connect this computer”**. Browser setup cannot install the plugin and ordinary ChatGPT cannot execute the local lifecycle hook. Keep pairing/device/bearer material out of chat.
   If Concierge was installed or enabled during the current task, its lifecycle
   hook did not run for the prompt that preceded installation. Installation also
   does not trust plugin hooks. Pause here and explain the one required approval:
   Concierge contributes six local lifecycle hooks (`SessionStart`,
   `UserPromptSubmit`, `PreToolUse`, `SubagentStart`, `SubagentStop`, and
   `Stop`), and Codex must expose their exact current definitions in its own
   hook-review UI. Ask the user to close and reopen Codex so the newly installed
   plugin is loaded, open the Concierge plugin details, and use the Hooks row:
   it reports how many hooks need review and offers **Review** and **Trust all**.
   Have the user inspect the six definitions with **Review**, then choose
   **Trust all**. The equivalent detailed path is Codex Settings → Hooks → From
   Plugins → Concierge, where each current definition has its own **Trust**
   action. Then have them open a
   fresh Codex task with Concierge active and send exactly **“Connect this
   computer”**. Keep this to one clear user approval; do not send them through a
   terminal checklist.

   The agent may explain the hook purposes and wait, but it must not treat a
   conversational “yes” as Codex hook trust, write `trusted_hash` values, use a
   hook-trust bypass flag, or hide the review because the package is visible on
   GitHub. If Codex does not present its native review screen after relaunch,
   report that the local hook approval surface is unavailable and stop the
   connection handoff. Never replace the trusted fresh local hook invocation
   with account-status reads or claim the current computer is connected because
   the account is already ready.
4. When the state requires entitlement, owner possession, phone identity, or capability reconciliation, perform only the exact supported next action. Existing entitlement and retained identity are authoritative. Paid phone acquisition is outside the plugin: do not display plans, promote an upgrade, initiate a purchase, link to checkout or a setup URL that leads to purchase, search, quote, buy, or bypass that boundary. Never request payment material in chat.
5. Require durable native readiness and adapter preflight before promising Voice. The native-host pairing and target-neutral native adapter preflight uses the existing Concierge browser session for connection approval, secure OS credential storage, service startup, and adapter checks; these are adapter internals, not consumer setup steps. A redirect, hook marker, physical DID feature, purchased-but-pending number, or model assertion is not readiness.
6. Read status again and report its one truthful result. A pending/blocked state names the exact next action and reason; a ready state names only the capability actually ready. A zero-spend native preflight proves compatibility/readiness only, not entitlement, owner authority, phone inventory, PSTN capacity, or a live call.

## Hard setup boundaries

Use owner-phone possession only when status returns `verify_owner_phone`. Telnyx Verify SMS is setup infrastructure, never a normal communication channel. Never request or echo an OTP, pairing secret/code, bearer/device material, provider identifier, or payment secret in model-visible chat.

Use a real test call only when the user explicitly authorizes that consequential external effect and all ordinary purpose, authority, commercial, provider, and final-effect fences pass. Never place a provider effect merely to prove native compatibility or source-only gating, and never place a Work live-call test while its Concierge adapter is unavailable.

Work remains a full first-party cloud orchestrator with durable Work context/history, cloud continuation, cross-device chats, and native Work Voice. It cannot currently become the operational Concierge phone target because the characterized supported surfaces do not expose an addressable Work conversation plus the required external Voice/control/media adapter. Do not pair a local computer merely to make Work appear ready, complete phone setup under Work, or buy a paid number solely for Work; preserve an already-owned identity and offer Codex.

Concierge v1 has one selected operational target and one retained phone identity. Reuse existing account/number state; never replace a retained identity or manufacture a purchase because setup is incomplete. Number state is a lifecycle (`active`, `pending`, `requires_action`, or `failed`), and `concierge_refresh_number` reconciles asynchronous provisioning. Never originate Voice from a non-active identity; an active number is usable only when the selected-target Voice bridge is also available.

Supported beta communication is inbound/outbound PSTN Voice, owner-return Voice, and same-thread native Codex autonomy. Normal SMS/MMS and carrier voice-note messaging/fallback are not beta channels. Concierge numbers are private-by-default for third-party inbound: external callers require current durable admission and remain task-scoped and untrusted after admission. Contact memory and inbound admission are separate; caller ID, speech, contact membership, or model text never creates owner authority.

Purpose admission for Voice is **narrowing-only**. Personal/transactional purpose may deny an effect but never grants authenticated identity, contact/root authority, permission to spend, policy, commercial capacity, host readiness, destination/provider capability, or final-effect authority. Exact current-root/native authority is derived outside model arguments. Use the current Concierge capability/lifecycle state rather than provider terminology.

Use `concierge_get_capabilities` and durable Concierge lifecycle state as the product source of truth; do not infer product capability from carrier features or expose provider IDs, connection IDs, tokens, credentials, or other provider plumbing unless the user is explicitly debugging infrastructure.

Attention configuration is a routing decision, not an emergency-only channel. It may consider blocking state, expected work saved, answer complexity, deadlines, Calendar/activity context, quiet hours, explicit preferences, allowance/occupancy, and trusted personal/transactional purpose. A blocker does not automatically become a call; when Voice is not justified or available, native work remains pending/deferred/continuing or uses same-thread recheck semantics. `async_fallback` never means SMS/MMS in this beta.

## Stateless effects and uncertainty

Concierge MCP transport is request-scoped/stateless. For every supported consequential mutation that accepts `operationId`, one opaque ID represents one intended side effect. Reuse it only for an identical uncertain retry; never change destination/identity/context under it or retry with a fresh ID before reconciling authoritative state. Number release may permanently lose the retained identity: require explicit confirmation immediately before execution and treat asynchronous provider acceptance as pending until durable reconciliation.

## Completion criterion

Setup is complete only when the final durable `concierge_get_setup_status` proves the requested account/owner/target/native-host/phone prerequisites are ready. A request to connect this computer additionally requires the trusted local hook flow and intended-computer verification; account-wide readiness can refer to another computer. A pending/blocked result may truthfully end the current interaction with one concrete next action and reason, but it is not setup completion. “Ready” never means a redirect, hook marker, purchased-but-pending number, physical DID capability, or model assertion.
