# Verify this computer

The trusted prompt hook starts pairing asynchronously. Starting it is not success.
On macOS, run this read-only diagnostic yourself (do not give the user a terminal checklist):

```sh
"$HOME/Library/Application Support/Concierge/bin/concierge-host" status --json
```

Use only `connection.hostId` from that fresh local result to match
`concierge_list_computers`. Require local `connection.paired` and
`connection.online` both true, plus that exact host's connected server record.
If the launcher or these fields are missing, pairing is not verified. Do not
substitute the selected/preferred server host or search chat logs, session files,
or memory for a host identifier. Those records can describe a different machine.
Do not read host credentials, pairing secrets or codes to perform this check.

If the native/browser approval is pending, say it is pending and keep the setup
open. Recheck local status after it completes. If it fails, report that failure;
account-wide readiness does not override it. Installation alone is not pairing.

After exact-host success, say: “This computer is connected. Return to your
Concierge setup tab and press Continue.” Keep the user in the original onboarding
flow; do not redirect to the Computers dashboard or claim phone setup is complete.
The website owns the remaining entitlement, phone verification and number steps.
For an explicit request to manage existing computers, the Computers dashboard
remains appropriate.
