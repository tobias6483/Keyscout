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

## Local Package Artifact

Create a zipped unsigned app artifact and SHA-256 checksum:

```sh
scripts/package_app.sh
```

The generated files are written to:

```text
dist/artifacts/KeyScout.app.zip
dist/artifacts/KeyScout.app.zip.sha256
```

The checksum file can also be regenerated manually:

```sh
cd dist/artifacts
shasum -a 256 KeyScout.app.zip > KeyScout.app.zip.sha256
```

## Local Release Check

Before a first alpha release, run:

```sh
swift test
scripts/build_app.sh
scripts/package_app.sh
```

The package script calls `scripts/build_app.sh`, but running the bundle build
explicitly first keeps the release checklist easy to audit.

## GitHub App Artifact

The `App Artifact` workflow builds the current unsigned app bundle on GitHub
Actions, packages it as `KeyScout.app.zip`, writes
`KeyScout.app.zip.sha256`, and uploads both files as a workflow artifact for
maintainer testing.

This is not a polished public distribution build. Signing, notarization, and a
stable release channel are future work.

## Signing And Notarization

Current v0.1 artifacts are unsigned and not notarized. Users should expect a
macOS Gatekeeper warning if they open the artifact directly. Do not present the
artifact as a stable public release until Developer ID signing and notarization
are available or the unsigned status is explicitly accepted for an alpha.

## Future Release Work

- Add bundle validation.
- Add a combined local release check script.
- Add signed Developer ID builds.
- Add notarization.
- Consider a Homebrew cask once the app is stable.
