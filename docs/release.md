# Release

KeyScout does not have a public release yet. This document defines the initial
release path so packaging work can be added deliberately.

## Local App Bundle

Build a local unsigned app bundle:

```sh
scripts/build_app.sh
```

The generated app is written to:

```text
dist/KeyScout.app
```

Run it with:

```sh
open dist/KeyScout.app
```

The bundle is intentionally local and unsigned for now. It includes:

- `CFBundleIdentifier`: `dev.tobias.keyscout`
- `LSUIElement`: enabled, so KeyScout appears as a menu bar app without a Dock icon
- `LSMinimumSystemVersion`: macOS 14.0
- Accessibility-related usage copy for local app menu inspection

## Local Release Check

Before a first alpha release, add a `scripts/release_check.sh` script that runs:

```sh
swift build
swift test
scripts/build_app.sh
```

The release check should eventually validate bundle metadata and produce an
unsigned zipped artifact with a SHA-256 checksum.

## GitHub App Artifact

The `App Artifact` workflow builds the current unsigned app bundle on GitHub
Actions and uploads it as a workflow artifact for maintainer testing.

This is not a polished public distribution build. Signing, notarization, and a
stable release channel are future work.

## Future Release Work

- Add bundle validation.
- Add a combined local release check script.
- Add signed Developer ID builds.
- Add notarization.
- Consider a Homebrew cask once the app is stable.
