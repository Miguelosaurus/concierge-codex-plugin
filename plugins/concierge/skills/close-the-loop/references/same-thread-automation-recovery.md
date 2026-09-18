# Same-thread automation recovery

Load when same-thread Codex automation is unavailable **or** when the exposed automation surface does not clearly advertise/confirm current-conversation targeting semantics.

This is a temporary upstream compatibility path, not a separate Concierge scheduler architecture.

## Capability first

Inspect automatically available facts before asking the user anything: the current root's `automation_update` availability and advertised schema/mode semantics, selected native host, current host binding/presence, and thread origin/provenance when available.

Callable `automation_update` alone is not sufficient. The normal path requires semantics that explicitly support targeting the current conversation/thread and a create/update result that confirms that exact target. A cron-only/detached-run surface, a surface that cannot express current-thread targeting, or a runtime rejection of that target counts as unavailable for this contract.

Topology/origin is diagnostic context only. Do not infer this upstream condition merely from `remote` provenance, and do not ask how many devices the user has or which machine created the thread when Concierge/Codex already exposes the relevant capability and host state.

## Brand-new/root-bootstrap recovery

If semantic same-thread automation capability is unavailable on a brand-new/root-bootstrap path and the selected native execution host is already unambiguous and reachable, automatically bootstrap host-locally on that selected host with the Codex project deep link, then capability-check the resulting root again.

Require user input only when genuinely necessary: multiple plausible execution hosts require a choice, the selected host is unavailable, automatic host-local bootstrap is impossible, or recovery would require replacing/migrating an established root.

Never silently migrate an established Concierge root. Preserving the exact same root/context is more important than hiding the compatibility problem.

Temporary recovery order:

1. host-local Codex project deep link on the already-selected native execution host;
2. direct host-local Codex Desktop UI creation when automatic bootstrap is unavailable but local creation remains appropriate;
3. projectless/local `create_thread` only as recovery;
4. re-check semantic same-thread `automation_update` capability and confirm the created automation targets the current thread before scheduling.

## Fail closed

If same-thread semantics remain unavailable, do not claim scheduling succeeded and do not substitute a detached mechanism. Do not manufacture a Concierge scheduler/wake queue, bridge through ChatGPT Scheduled Tasks, add a host protocol, use arbitrary `resume(threadId)` authority, edit Codex automation TOML/SQLite, or create a detached cron run.

The automation surface never supplies semantic root authority by accepting a model-provided thread ID. Current-root identity must remain derived from trusted native provenance.

This workaround tracks upstream Codex automation provisioning issues `openai/codex#24280` and `openai/codex#29128`. Retest/remove the bootstrap workaround when upstream provisioning is fixed, while retaining the semantic current-thread capability gate and same-root safety.