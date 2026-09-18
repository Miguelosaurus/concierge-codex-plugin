Load when the user asks for product behavior, a target comparison, a second computer, or the consumer-facing connection direction during setup. Return to `setup-concierge` for status and completion.

## Product and computer branch

For product explanations, use `concierge_search_product_docs` and `concierge_read_product_doc` when available. Preserve the returned availability qualifications. Authenticated setup/computer state takes precedence over a generic guide for the user's next action. Public help explains the product; it does not grant access to private work or start an effect workflow.

Connecting another computer is separate from first-account setup. Point to [Computers](https://dialconcierge.com/account/computers), then have the user open Codex on the desired computer with the installed Concierge plugin active and say **“Connect this computer”**. Do not restart subscription, owner verification, or phone provisioning because one computer is already connected. Multiple connections do not synchronize native project histories or guarantee account-wide context access. Use current computer state and the owner-private work-context diagnostic when available rather than guessing which machine contains missing work.

For a request about **this computer**, overall setup, capabilities, and account
status are account-scoped and may describe a different connected computer.
They cannot replace the local hook flow or prove that the intended computer was
paired. If installing or enabling Concierge was the current task, open a fresh
Codex task with Concierge active and send exactly **“Connect this computer”**;
the earlier install prompt cannot retroactively run the newly installed hook.
After the hook flow, verify the intended computer through the connected-computer
projection before describing it as connected.

Workspace Agents are an optional managed-workspace adapter, never a consumer prerequisite. Do not substitute ordinary Chat Voice, GPT-Live/Realtime, a Workspace Agent, or another shadow supervisor for a missing selected-target adapter. The selected target determines where new Concierge phone work/context lives; Work and Codex histories remain separate.

## Target and Work branch

Concierge v1 has one selected operational phone target and one retained phone identity. The current beta target is Codex when its paired native host is ready. Work is a full first-party cloud orchestrator with durable context/history, cloud continuation, cross-device chats, and native Work Voice. The current limitation is the Concierge adapter: characterized supported surfaces do not expose an addressable Work conversation plus external Voice/control/media attachment. Preserve an already-owned number and offer Codex; do not buy a number solely for Work or pair a local computer just to make Work appear ready.

Codex is local/native orchestration over the user's real Codex threads, App Server, repos/tools/device context, and Codex Voice. Work and Codex histories remain separate. Subscription, verified owner, contacts, communication preferences, retained phone identity, and allowance remain account-level state shared by the selected target.

## Handoff branch

Browser setup cannot install the plugin, and an ordinary ChatGPT conversation does not execute the local lifecycle hook. The uploaded ChatGPT skills do not bootstrap hooks, runtime files, or a native host: they assume a completed installed Codex integration and trusted lifecycle hooks. A ready paired host is the resulting prerequisite before promising phone Voice. If the installation prerequisite is absent, report that concrete unavailable prerequisite and use the supported connection route; never fabricate a downloader, manual credential step, or hidden bootstrap. The user must continue in local Codex with the installed Concierge plugin selected and active. Protocol details are adapter internals: do not ask the user to clone the repository, install Node, download a separate desktop app, or run terminal pairing/install commands. Keep device codes, bearer material, pairing secrets, and provider credentials out of model-visible chat. After the handoff, reread `concierge_get_setup_status` and report only the returned state.
