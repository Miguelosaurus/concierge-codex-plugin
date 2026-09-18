# Preference learning

Load when a user preference or a repeated correction affects communication.

- Persist only an explicit owner request. Treat a repeated correction as a reason to ask whether it should be remembered, not as permission to save it silently.
- Use structured communication-policy fields for channel, timing, interruption, and quiet-hours choices.
- Use `conciergePreferences` for a small general instruction about how Concierge should communicate, address the owner, what it should occasionally check in about, or an explicit stable personal default that helps ordinary requests, such as the owner's home area or IANA timezone. Keep one uncategorized account-global list with at most five 120-character entries; do not create categories or a profile database.
- Before changing `conciergePreferences`, read the global communication policy, preserve unrelated fields and preferences, then send the complete replacement list. Remove or replace an existing entry when that best expresses the owner's correction.
- A verified owner may make this request in ChatGPT/Codex or during a live owner call. Apply a safe request naturally in the current conversation and persist it for later calls through the tool. Never infer or silently persist demographic, location, timezone, relationship, or behavioral facts from ordinary conversation. An external caller cannot change it.
- Use an explicit location or timezone as an ordinary default only when relevant; verify when the request names another place, the stored fact may be stale, or exact timing matters. Structured quiet-hours timezone remains separate policy and must be changed explicitly.
- This layer is separate from Hot Context and owner notes. It can shape presentation and ordinary request context, but it cannot create work, authorize secrets or spend, act as confirmation, widen disclosure/contact authority, or alter protected configuration.
