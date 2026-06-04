# Release

KeyScout v0.1.1-alpha is available as an ad-hoc signed prerelease artifact.
This document tracks the current release path and the limitations that still
need to be clear for early testers.

## Alpha Tester Install

1. Download `KeyScout.app.zip` from the GitHub prerelease.
2. Unzip it.
3. Move `KeyScout.app` to `/Applications` if you want a stable app path.
4. Open the exact `KeyScout.app` you downloaded and unzipped.
5. Grant Accessibility permission to that exact app in System Settings.

The alpha artifact is ad-hoc signed, not Developer ID signed, and not notarized.
macOS Gatekeeper warnings are expected.

### Permission Identity

macOS treats each app path and signing identity separately for Accessibility.
Release testers should grant Accessibility to the downloaded and unzipped
`KeyScout.app`. Contributors should grant Accessibility to
`/Users/tobias/Documents/Development/Keyscout/dist/KeyScout.app`. Rebuilding,
moving, or running a different binary may require removing old Accessibility
entries and adding the exact app again.

`swift run KeyScout` launches a SwiftPM debug executable, not `KeyScout.app`.
Nobody should expect it to share Accessibility permission with the release or
local `.app` bundle.

## Local App Bundle

Build a local ad-hoc signed app bundle:

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

The bundle is intentionally local and ad-hoc signed for now. It includes:

- `CFBundleIdentifier`: `dev.tobias.keyscout`
- `LSUIElement`: enabled, so KeyScout appears as a menu bar app without a Dock icon
- `LSMinimumSystemVersion`: macOS 14.0
- Accessibility-related usage copy for local app menu inspection
- Ad-hoc code signing so macOS binds the bundle identifier and Info.plist for
  local permission testing

## Local Package Artifact

Create a zipped ad-hoc signed app artifact and SHA-256 checksum:

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

## Developer ID Signed Artifact

Maintainers with an Apple Developer Program membership and a Developer ID
Application certificate can create a signed, notarized, stapled artifact:

```sh
KEYSCOUT_CODESIGN_IDENTITY="Developer ID Application: Example (TEAMID)" \
KEYSCOUT_NOTARIZE=1 \
KEYSCOUT_NOTARY_PROFILE=keyscout-notary \
scripts/package_app.sh
```

`scripts/build_app.sh` uses ad-hoc signing by default. When
`KEYSCOUT_CODESIGN_IDENTITY` is set, it signs `dist/KeyScout.app` with hardened
runtime and timestamping. When `KEYSCOUT_NOTARIZE=1`,
`scripts/package_app.sh` runs `scripts/notarize_app.sh`, waits for Apple's
notary service, staples the ticket, validates the stapled app, then writes the
zip and checksum.

Notarization credentials can be provided in either form:

- `KEYSCOUT_NOTARY_PROFILE`: a notarytool keychain profile.
- `KEYSCOUT_NOTARY_APPLE_ID`, `KEYSCOUT_NOTARY_TEAM_ID`, and
  `KEYSCOUT_NOTARY_PASSWORD`: Apple ID, team ID, and app-specific password or
  compatible notary password.

The generated files remain:

```text
dist/artifacts/KeyScout.app.zip
dist/artifacts/KeyScout.app.zip.sha256
```

## Local Release Check

Before publishing or replacing a release artifact, run:

```sh
swift test
scripts/build_app.sh
scripts/package_app.sh
```

The package script calls `scripts/build_app.sh`, but running the bundle build
explicitly first keeps the release checklist easy to audit.

## GitHub App Artifact

The `App Artifact` workflow builds the app bundle on GitHub Actions, packages it
as `KeyScout.app.zip`, writes `KeyScout.app.zip.sha256`, and uploads both files
as a workflow artifact for maintainer testing.

Without signing secrets, the workflow produces an ad-hoc signed artifact. With
Developer ID and notary secrets, it produces a Developer ID signed, notarized,
stapled artifact.

Required GitHub secrets for signed/notarized artifacts:

- `DEVELOPER_ID_CERTIFICATE_P12_BASE64`: base64-encoded Developer ID
  Application `.p12`.
- `DEVELOPER_ID_CERTIFICATE_PASSWORD`: password for the `.p12`.
- `DEVELOPER_ID_KEYCHAIN_PASSWORD`: temporary CI keychain password.
- `DEVELOPER_ID_APPLICATION_IDENTITY`: codesign identity, for example
  `Developer ID Application: Example (TEAMID)`.
- `KEYSCOUT_NOTARIZE`: set to `1` for notarized release artifacts.
- `NOTARY_APPLE_ID`: Apple ID for `notarytool`.
- `NOTARY_TEAM_ID`: Apple Developer Team ID.
- `NOTARY_PASSWORD`: app-specific password or compatible notary password.

GitHub Actions secrets are private repository or organization settings. They
are not committed to Git, are not visible to people who clone the repository,
and should only be exposed to trusted release workflows. Do not grant
Developer ID or notary secrets to untrusted fork pull request workflows.

## Signing And Notarization

The published v0.1.1-alpha artifacts are ad-hoc signed, not Developer ID signed,
and not notarized. Users should expect a macOS Gatekeeper warning if they open
that artifact directly.

The repository now has a Developer ID signing and notarization-capable release
pipeline. Do not present a future artifact as Developer ID signed or notarized
unless `KEYSCOUT_NOTARIZE=1` was used, `notarytool` accepted the submission,
`stapler validate` passed, and the uploaded checksum matches the final stapled
app zip.

## Future Release Work

- Add bundle validation.
- Add a combined local release check script.
- Configure repository secrets for signed Developer ID release artifacts.
- Consider a Homebrew cask once the app is stable.
