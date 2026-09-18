#!/bin/sh
set -eu

ROOT=${PLUGIN_ROOT:?PLUGIN_ROOT is required}

# Root/hook authority is established inside the native broker from the
# kernel-owned local socket peer, exact installed host executable identity, and
# verified process ancestry. Never export a caller-supplied/environment PID as
# an authority hint.
unset CONCIERGE_CODEX_APP_SERVER_PID 2>/dev/null || true

case "$(/usr/bin/uname -m)" in
  arm64|aarch64) ARCH=arm64 ;;
  x86_64|amd64) ARCH=x64 ;;
  *) ARCH=unsupported ;;
esac
case "$(/usr/bin/uname -s)" in
  Darwin) PLATFORM=macos
    NATIVE_ROOT="${CONCIERGE_NATIVE_HOST_ROOT:-$HOME/Library/Application Support/Concierge}"
    ;;
  Linux) PLATFORM=linux
    DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
    NATIVE_ROOT="${CONCIERGE_NATIVE_HOST_ROOT:-$DATA_HOME/concierge/native-host}"
    ;;
  *) PLATFORM=unsupported; NATIVE_ROOT= ;;
esac

# Once installed, hooks execute the exact immutable release payload used by the
# running broker. This lets the broker compare the kernel-reported peer image to
# its own executable identity instead of trusting a filename or caller path.
if [ -n "$NATIVE_ROOT" ]; then
  VERSION=$(/bin/cat "$NATIVE_ROOT/current.version" 2>/dev/null || true)
  INSTALLED="$NATIVE_ROOT/releases/$VERSION/concierge-host"
  if [ -n "$VERSION" ] && [ -x "$INSTALLED" ]; then
    exec "$INSTALLED" plugin-hook
  fi
fi

HOST="$ROOT/runtime/$PLATFORM-$ARCH/concierge-host"
if [ -f "$ROOT/runtime/macos-runtime.manifest" ]; then
  HOST=$(/bin/sh "$ROOT/hooks/prepare-macos-runtime.sh") || exit 1
  exec "$HOST" plugin-hook
fi
if [ -x "$HOST" ]; then
  exec "$HOST" plugin-hook
fi

# Contributor/local-marketplace fallback only. Effectful calls still fail
# closed until an authenticated installed broker is available.
exec node "$ROOT/hooks/concierge-hooks.mjs"
