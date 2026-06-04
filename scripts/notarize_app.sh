#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_PATH="${1:-$ROOT_DIR/dist/KeyScout.app}"
NOTARY_PROFILE="${KEYSCOUT_NOTARY_PROFILE:-}"
NOTARY_APPLE_ID="${KEYSCOUT_NOTARY_APPLE_ID:-}"
NOTARY_TEAM_ID="${KEYSCOUT_NOTARY_TEAM_ID:-}"
NOTARY_PASSWORD="${KEYSCOUT_NOTARY_PASSWORD:-}"
TEMP_ZIP="$(mktemp -t keyscout-notary.XXXXXX).zip"

cleanup() {
  rm -f "$TEMP_ZIP"
}
trap cleanup EXIT

if [[ ! -d "$APP_PATH" ]]; then
  echo "App bundle not found: $APP_PATH" >&2
  exit 1
fi

ditto -c -k --keepParent "$APP_PATH" "$TEMP_ZIP"

if [[ -n "$NOTARY_PROFILE" ]]; then
  xcrun notarytool submit "$TEMP_ZIP" \
    --keychain-profile "$NOTARY_PROFILE" \
    --wait
elif [[ -n "$NOTARY_APPLE_ID" && -n "$NOTARY_TEAM_ID" && -n "$NOTARY_PASSWORD" ]]; then
  xcrun notarytool submit "$TEMP_ZIP" \
    --apple-id "$NOTARY_APPLE_ID" \
    --team-id "$NOTARY_TEAM_ID" \
    --password "$NOTARY_PASSWORD" \
    --wait
else
  echo "Set KEYSCOUT_NOTARY_PROFILE or KEYSCOUT_NOTARY_APPLE_ID, KEYSCOUT_NOTARY_TEAM_ID, and KEYSCOUT_NOTARY_PASSWORD." >&2
  exit 1
fi

xcrun stapler staple "$APP_PATH"
xcrun stapler validate "$APP_PATH"

echo "Notarized and stapled $APP_PATH"
