# Roadmap

This roadmap is intentionally lightweight. KeyScout should stay focused on becoming a useful macOS menu bar utility before expanding.

## Phase 0: Project Setup

- Project brief
- MIT license
- Contribution guide
- Security policy
- Privacy policy
- GitHub issue and pull request templates
- Branch protection

## Phase 1: Research Prototype

- Explore macOS Accessibility APIs for reading menu shortcuts
- Document what can and cannot be detected reliably
- Define shortcut normalization rules
- Define reserved macOS shortcut handling
- Create sample JSON mapping format

## Phase 2: Core Logic

- Shortcut model
- Modifier and key normalization
- Conflict detection
- Unused shortcut generation
- JSON import/export
- Unit tests

## Phase 3: macOS MVP

- SwiftUI menu bar app
- App scanner
- Per-app shortcut list
- Conflict warning UI
- Generate unused shortcut action
- Local snapshot export

## Phase 4: Alpha Release

- Signed build workflow
- Basic release notes
- Documentation for permissions
- Contributor guide for shortcut mappings
- Known limitations page

## Later Ideas

- Curated community shortcut database
- Import mappings from common launcher or automation tools
- System shortcut awareness
- App-specific suggestion profiles
- Optional user-defined blocked combinations
