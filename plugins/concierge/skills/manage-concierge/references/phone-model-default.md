# Default phone reasoning model

For an explicit owner request to change the default backing Codex model/effort,
use `concierge_update_global_communication_policy` with
`phoneModelDefault: {model, reasoningEffort}`. Use the exact requested model id;
if the owner's name is ambiguous, clarify it instead of guessing. Read with
`concierge_get_global_communication_policy` when asked for the current setting.
Use `phoneModelDefault: null` for an explicit reset to `gpt-5.6-luna` / `medium`.
Do not put this configuration in `conciergePreferences` text.

Say the setting is saved for **new phone conversations**, with usability
unverified until the paired host validates its model catalog at creation.
Existing/resumed conversations and their post-call continuation retain their
native settings. It does not change the realtime speech model, restart an
active call, change other tasks/global Codex configuration, or grant model
access. Absence on an older account means operator fallback, not a verified
Luna setting. Unsupported/unavailable choices must be reported, never silently
replaced. Ordinary authenticated ChatGPT account management needs no native
root, fake task id, local hook, API key, purchase, or second AI engine.
