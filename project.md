# KeyScout

Unused hotkey finder for macOS.

## Pitch

KeyScout is an open-source macOS menu bar app that scans your active apps and helps you find unused keyboard shortcuts before you assign new hotkeys.

There is concrete demand for this kind of tool: macOS power users want a menu bar app that can read hotkeys across apps and suggest an unused combination. Existing cheat sheet-style tools can show mappings, but they still leave the hard part to the user: finding a shortcut that is actually free.

## Why This Is Strong

KeyScout solves a specific, under-served productivity problem: "find me an available global hotkey."

Tools like KeyClu and CheatSheet-style utilities are useful for discovering existing shortcuts, but KeyScout focuses on conflict prevention before a user assigns a new shortcut. That makes it especially useful for developers, automation-heavy users, launcher users, designers, and anyone who customizes macOS workflows.

This is a good open-source project because it is small, native, privacy-friendly, and useful to the same power-user community that is likely to contribute edge cases, app mappings, shortcut data, tests, and release feedback.

## MVP

- Menu bar app
- Global hotkey scanner
- List of known shortcuts per app
- Generate unused shortcut
- Conflict warning, for example: "⌘⇧K is already used by VS Code"
- Export shortcut data to JSON
- Local-only behavior with no tracking

## Product Principles

- Native macOS utility, not a web wrapper
- Fast menu bar workflow
- Privacy-first: all scanning and shortcut analysis stays local
- Clear conflict explanations instead of vague warnings
- Useful without account creation, cloud sync, analytics, or telemetry
- Open data model so users can inspect, export, and contribute mappings

## Technical Direction

- Swift and SwiftUI for the macOS app shell
- Menu bar-first UI
- Accessibility API exploration for reading app menu shortcuts where possible
- Curated shortcut mapping data for apps that cannot expose everything reliably
- JSON import/export for shortcut mappings and user snapshots
- Unit tests around shortcut parsing, normalization, conflict detection, and generation
- Release automation for signed builds once the app reaches a usable alpha

## Open Questions

- Which app shortcuts can be discovered reliably through macOS Accessibility APIs?
- Which apps require curated mappings or manual import?
- Should KeyScout detect only active apps, installed apps, or user-selected apps?
- What modifier/key combinations should be considered good suggestions by default?
- How should reserved macOS system shortcuts be represented?
- Should global hotkeys from launchers and automation tools be user-entered, imported, or partially detected?

## Why OpenAI/Codex Fits

KeyScout is a real developer and productivity tool, not just a toy app. It is a good fit for iterative AI-assisted development across SwiftUI, macOS Accessibility APIs, tests, documentation, release workflows, GitHub issue triage, and contribution automation.
