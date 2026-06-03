# Development

KeyScout is a native macOS Swift package.

## Requirements

- macOS 14 or newer
- Swift 6 / Xcode 26 or newer recommended

## Build

```sh
swift build
```

## Test

```sh
swift test
```

## Run

```sh
swift run KeyScout
```

KeyScout appears in the macOS menu bar as `⌘?`.

## Local App Bundle

```sh
scripts/build_app.sh
open dist/KeyScout.app
```

The local app bundle is unsigned. It is useful for manual testing of menu bar
behavior and macOS permissions, but it is not a release artifact.

## Accessibility Permission

Shortcut discovery uses macOS Accessibility APIs where possible. During manual
testing, macOS may ask for Accessibility permission so KeyScout can inspect app
menus. KeyScout should explain this permission before relying on it in a public
release.
