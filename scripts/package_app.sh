#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="KeyScout"
DIST_DIR="$ROOT_DIR/dist"
ARTIFACTS_DIR="$DIST_DIR/artifacts"
APP_DIR="$DIST_DIR/$APP_NAME.app"
ZIP_PATH="$ARTIFACTS_DIR/$APP_NAME.app.zip"
CHECKSUM_PATH="$ZIP_PATH.sha256"
NOTARIZE="${KEYSCOUT_NOTARIZE:-0}"

cd "$ROOT_DIR"

scripts/build_app.sh

rm -rf "$ARTIFACTS_DIR"
mkdir -p "$ARTIFACTS_DIR"

if [[ "$NOTARIZE" == "1" ]]; then
  scripts/notarize_app.sh "$APP_DIR"
fi

ditto -c -k --keepParent "$APP_DIR" "$ZIP_PATH"
(
  cd "$ARTIFACTS_DIR"
  shasum -a 256 "$APP_NAME.app.zip" > "$APP_NAME.app.zip.sha256"
)

echo "Packaged $ZIP_PATH"
echo "Wrote $CHECKSUM_PATH"
