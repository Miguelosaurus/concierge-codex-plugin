$ErrorActionPreference = 'Stop'
$root = $env:PLUGIN_ROOT
if (-not $root) { throw 'PLUGIN_ROOT is required' }

# Root/hook authority is established inside the native broker from the OS-owned
# local socket peer, exact installed host executable identity, and verified
# process ancestry. Never export an environment PID as an authority hint.
Remove-Item Env:CONCIERGE_CODEX_APP_SERVER_PID -ErrorAction SilentlyContinue

$nativeRoot = if ($env:CONCIERGE_NATIVE_HOST_ROOT) { $env:CONCIERGE_NATIVE_HOST_ROOT } else { Join-Path $env:LOCALAPPDATA 'Concierge' }
$current = Join-Path $nativeRoot 'current.version'
if (Test-Path $current) {
  $version = (Get-Content $current -Raw).Trim()
  if ($version) {
    $installed = Join-Path (Join-Path (Join-Path $nativeRoot 'releases') $version) 'concierge-host.exe'
    if (Test-Path $installed) {
      & $installed plugin-hook
      exit $LASTEXITCODE
    }
  }
}

$arch = switch ($env:PROCESSOR_ARCHITECTURE) {
  'ARM64' { 'arm64' }
  'AMD64' { 'x64' }
  default { 'unsupported' }
}
$hostPath = Join-Path $root "runtime\windows-$arch\concierge-host.exe"
if (Test-Path $hostPath) {
  & $hostPath plugin-hook
  exit $LASTEXITCODE
}

# Contributor/local-marketplace fallback only. Effectful calls still fail
# closed until an authenticated installed broker is available.
& node (Join-Path $root 'hooks\concierge-hooks.mjs')
exit $LASTEXITCODE
