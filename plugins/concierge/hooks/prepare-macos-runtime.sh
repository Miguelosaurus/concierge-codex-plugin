#!/bin/sh
# Local preparation only. Never source the manifest or execute unverified bytes.
set -eu
umask 077
PATH=/usr/bin:/bin:/usr/sbin:/sbin
export PATH
unset GZIP PERL5OPT PERL5LIB ENV BASH_ENV CDPATH 2>/dev/null || true
fail() { echo "concierge-runtime: $*" >&2; exit 1; }
[ "$(/usr/bin/uname -s)" = Darwin ] && [ "$(/usr/bin/uname -m)" = arm64 ] || fail unsupported-platform
ROOT=${PLUGIN_ROOT:?PLUGIN_ROOT required}
SOURCE="$ROOT/runtime/macos-arm64"
MANIFEST="$ROOT/runtime/macos-runtime.manifest"
no_links() {
  CHECK=$1
  while [ "$CHECK" != / ] && [ "$CHECK" != . ]; do
    [ ! -L "$CHECK" ] || fail symlink-parent
    NEXT=${CHECK%/*}; [ "$NEXT" != "$CHECK" ] || fail absolute-path-required
    CHECK=${NEXT:-/}
  done
}
no_links "$SOURCE"
no_links "$MANIFEST"
[ -f "$MANIFEST" ] && [ "$(/usr/bin/stat -f %z "$MANIFEST")" -le 65536 ] || fail manifest-size
# ASCII-only records, finite sizes, unique regular-file paths; no shell parsing.
/usr/bin/awk -F '\t' '
function bad(){exit 1}
function sha(s){return length(s)==64 && s !~ /[^0-9a-f]/}
function number(s){return s ~ /^(0|[1-9][0-9]*)$/ && length(s)<=9}
NR==1 {if($0!="concierge-macos-runtime-v1")bad();next}
NR==2 {if(NF!=2||$1!="version"||$2!~/^0\.1\.0-alpha\.[0-9]+$/||length($2)>64)bad();next}
NR==3 {if(NF!=2||$1!="source"||length($2)!=40||$2~/[^0-9a-f]/)bad();next}
NR==4 {if(NF!=3||$1!="gzip"||!sha($2)||!number($3)||$3<1||$3>=104857600)bad();next}
NR>4 {
 if(NF!=5||$1!="file"||($2!="644"&&$2!="755")||!sha($3)||!number($4))bad()
 p=$5;if(p~/[^A-Za-z0-9._@\/-]/||p~/^\//||p~/\/$/||p~/\/\//||p~/(^|\/)\.\.?($|\/)/||seen[p]++)bad()
 if(p!="concierge-host"&&p!="concierge-process-info"&&p!="release-manifest.json"&&p!~/^node_modules\/@roamhq\/(wrtc|wrtc-darwin-arm64)\//)bad()
 if((p=="concierge-host"||p=="concierge-process-info")&&$2!="755")bad()
 if(p!="concierge-host"&&p!="concierge-process-info"&&$2!="644")bad()
 if($4>268435456)bad();total+=$4;if(total>314572800||NR>516)bad()
}
END {if(NR<8||!seen["concierge-host"]||!seen["concierge-process-info"]||!seen["release-manifest.json"]||!seen["node_modules/@roamhq/wrtc-darwin-arm64/wrtc.node"])exit 1}
' "$MANIFEST" || fail invalid-manifest
VERSION=$(/usr/bin/sed -n '2p' "$MANIFEST" | /usr/bin/cut -f 2)
PIN=$(/usr/bin/shasum -a 256 "$MANIFEST"); PIN=${PIN%% *}
CACHE="${HOME:?HOME required}/Library/Caches/Concierge/plugin-runtime"
no_links "$CACHE"
/bin/mkdir -p "$CACHE"
[ "$(/usr/bin/stat -f %u "$CACHE")" = "$(/usr/bin/id -u)" ] && [ "$(/usr/bin/stat -f %Lp "$CACHE")" = 700 ] || fail cache-permissions
TARGET="$CACHE/$VERSION-$PIN"
LOCK="$CACHE/$VERSION-$PIN.lock"
[ ! -L "$LOCK" ] && { [ ! -e "$LOCK" ] || [ -f "$LOCK" ]; } || fail invalid-lock
if [ "${1:-}" != --locked ]; then
  # Kernel lock ownership is released on exit/SIGKILL. Keep the inode stable.
  exec /usr/bin/lockf -k -t 4 "$LOCK" /bin/sh "$0" --locked
fi
STAGE=
cleanup() { if [ -n "$STAGE" ]; then /bin/rm -rf "$STAGE"; fi; }
trap cleanup EXIT
trap 'exit 1' HUP INT TERM
TAB=$(printf '\t')
verify_files() {
  TREE=$1
  [ -d "$TREE" ] && [ ! -L "$TREE" ] || fail cache-type
  [ -z "$(/usr/bin/find "$TREE" -type l -print)" ] || fail tree-symlink
  [ -z "$(/usr/bin/find "$TREE" ! -type f ! -type d -print)" ] || fail tree-special-file
  ACTUAL=$(/usr/bin/find "$TREE" -type f | /usr/bin/wc -l | /usr/bin/tr -d ' ')
  EXPECTED=$(/usr/bin/awk 'END{print NR-4}' "$MANIFEST")
  [ "$ACTUAL" = "$EXPECTED" ] || fail file-set
  while IFS="$TAB" read -r KIND MODE HASH BYTES FILE; do
    [ "$KIND" = file ] || continue
    ITEM="$TREE/$FILE"
    [ -f "$ITEM" ] && [ ! -L "$ITEM" ] || fail missing-file
    [ "$(/usr/bin/stat -f %z "$ITEM")" = "$BYTES" ] && [ "$(/usr/bin/stat -f %Lp "$ITEM")" = "$MODE" ] || fail size-mode
    ACTUAL_HASH=$(/usr/bin/shasum -a 256 "$ITEM"); [ "${ACTUAL_HASH%% *}" = "$HASH" ] || fail file-hash
  done < "$MANIFEST"
}
verify_signatures() {
  TREE=$1
  REQUIREMENT='=anchor apple generic and certificate leaf[subject.OU] = "F5786NY22N" and certificate leaf[field.1.2.840.113635.100.6.1.13] exists'
  for FILE in concierge-host concierge-process-info node_modules/@roamhq/wrtc-darwin-arm64/wrtc.node; do
    /usr/bin/codesign --verify --strict -R "$REQUIREMENT" "$TREE/$FILE" || fail signature
    DETAILS=$(/usr/bin/codesign --display --verbose=4 "$TREE/$FILE" 2>&1) || fail signature-inspection
    printf '%s\n' "$DETAILS" | /usr/bin/grep -q '^Authority=Developer ID Application: SEA & SEA LLC (F5786NY22N)$' || fail signer
    printf '%s\n' "$DETAILS" | /usr/bin/grep -q '^CodeDirectory .*flags=.*runtime' || fail hardened-runtime
  done
  /usr/bin/codesign --verify --strict -R '=identifier "com.concierge.native-host.process-info"' "$TREE/concierge-process-info" || fail helper-identity
}
if [ ! -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
  [ -d "$SOURCE" ] && [ -z "$(/usr/bin/find "$SOURCE" -type l -print)" ] || fail source-symlink
  [ -z "$(/usr/bin/find "$SOURCE" ! -type f ! -type d -print)" ] || fail source-special-file
  ACTUAL=$(/usr/bin/find "$SOURCE" -type f | /usr/bin/wc -l | /usr/bin/tr -d ' ')
  EXPECTED=$(/usr/bin/awk 'END{print NR-4}' "$MANIFEST")
  [ "$ACTUAL" = "$EXPECTED" ] || fail source-file-set
  GZIP_HASH=$(/usr/bin/sed -n '4p' "$MANIFEST" | /usr/bin/cut -f 2)
  GZIP_SIZE=$(/usr/bin/sed -n '4p' "$MANIFEST" | /usr/bin/cut -f 3)
  [ -f "$SOURCE/concierge-host.gz" ] && [ "$(/usr/bin/stat -f %z "$SOURCE/concierge-host.gz")" = "$GZIP_SIZE" ] || fail gzip-size
  ACTUAL=$(/usr/bin/shasum -a 256 "$SOURCE/concierge-host.gz"); [ "${ACTUAL%% *}" = "$GZIP_HASH" ] || fail gzip-hash
  STAGE=$(/usr/bin/mktemp -d "$CACHE/.staging.XXXXXXXX")
  while IFS="$TAB" read -r KIND MODE HASH BYTES FILE; do
    [ "$KIND" = file ] || continue
    DEST="$STAGE/$FILE"
    /bin/mkdir -p "${DEST%/*}"
    if [ "$FILE" = concierge-host ]; then
      # POSIX ulimit -f uses 512-byte blocks; the final size must also match exactly.
      (ulimit -f $(((BYTES + 511) / 512)); /usr/bin/gzip -dc "$SOURCE/concierge-host.gz" > "$DEST") || fail gzip-output
    else
      [ -f "$SOURCE/$FILE" ] && [ ! -L "$SOURCE/$FILE" ] || fail source-file
      /bin/cp "$SOURCE/$FILE" "$DEST"
    fi
    /bin/chmod "$MODE" "$DEST"
  done < "$MANIFEST"
  verify_files "$STAGE"
  verify_signatures "$STAGE"
  # The kernel lock excludes other publishers; never replace an existing target.
  [ ! -e "$TARGET" ] && [ ! -L "$TARGET" ] || fail target-race
  /bin/mv "$STAGE" "$TARGET"
  STAGE=
else
  verify_files "$TARGET"
  verify_signatures "$TARGET"
fi
printf '%s\n' "$TARGET/concierge-host"
