# Install Concierge in Codex

Start at [dialconcierge.com](https://dialconcierge.com). Create an account or
sign in, then follow the account setup steps.

This beta requires a Mac with Apple silicon, macOS 13 or later, and Codex
0.146.0-alpha.3.1 or later. Windows, Linux, and Intel Macs are not supported.
See [availability](https://dialconcierge.com/docs/availability).

## Install

1. Open this repository's main page on GitHub. Select **Code**, select **HTTPS**,
   and copy the repository address.
2. In Terminal, type `codex plugin marketplace add`, add a space, paste the
   address, and press Return. Codex reads this repository as a plugin marketplace.
3. Run `codex plugin add concierge@concierge`.
4. Open a new task in Codex. Keep Concierge selected and active. Review and
   enable all six hooks when Codex asks.
5. Sign in with the same Concierge account you use on the website. Codex may
   ask during installation or when you first use Concierge.

These commands require the Codex command-line tool. If Terminal cannot find
`codex`, see [Support](https://dialconcierge.com/support).

## Connect the computer

Concierge includes the signed computer helper. To connect your Mac:

1. In Codex on the Mac you want to connect, say "Connect this computer".
2. The plugin installs its included helper and opens the secure browser flow.
3. Approve the computer using the six-digit code shown on your Mac. Your existing Concierge website session is used; sign in only if that session has expired.
4. Check [your computers](https://dialconcierge.com/account/computers) for the
   Mac you just connected. Continue account setup when that Mac is ready.

Keep approval codes and passwords in the browser. Do not paste them into a
Codex task. If the browser does not open or the computer stays offline, use
[Support](https://dialconcierge.com/support).

## Updates

When a new release is available, run these commands in Terminal:

```sh
codex plugin marketplace remove concierge
codex plugin marketplace add https://github.com/Miguelosaurus/concierge-codex-plugin --ref v0.1.0-alpha.85
codex plugin add concierge@concierge
```

Start a new task, keep Concierge active, and review any changed hooks.
Say "Connect this computer" to run its setup
or repair flow. Complete browser approval if asked, then check the computer's
connection before making calls. If your marketplace uses a fixed release,
follow that release's upgrade instructions.

The beta supports one live Codex phone call at a time in the United States.
Work phone calls and normal text messages are not part of this beta.
