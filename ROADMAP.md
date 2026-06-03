# Roadmap

This roadmap is intentionally lightweight. KeyScout should stay focused on becoming a useful macOS menu bar utility before expanding.

## Phase 0: Project Setup

- Project brief: complete
- MIT license: complete
- Contribution guide: complete
- Security policy: complete
- Privacy policy: complete
- GitHub issue and pull request templates: complete
- Branch protection: complete
- Changelog: complete
- Issue triage workflow and docs: complete
- Release docs and v0.1 checklist drafts: complete
- Unsigned app artifact workflow: complete

## Phase 1: Research Prototype

- Explore macOS Accessibility APIs for reading menu shortcuts: initial
  frontmost-app scanner implemented
- Document what can and cannot be detected reliably
- Define shortcut normalization rules: initial implementation complete
- Define reserved macOS shortcut handling: expanded initial defaults documented
- Create sample JSON mapping format: initial Codable export and schema
  documentation implemented
- Add curated shortcut mapping data: initial built-in mapping library
  implemented

## Phase 2: Core Logic

- Shortcut model: initial implementation complete
- Modifier and key normalization: initial implementation complete
- Conflict detection: initial implementation complete
- Unused shortcut generation: initial implementation complete
- Reserved shortcut categories: initial implementation complete
- JSON import/export: initial implementation complete
- Curated/manual mapping merge: initial implementation complete
- Unit tests: initial coverage complete
- JSON schema fixture test: initial coverage complete

## Phase 3: macOS MVP

- Swift/AppKit menu bar app: initial scaffold complete
- App scanner: initial frontmost-app scanner complete
- Per-app shortcut list: initial menu submenu complete; richer view pending
- Conflict warning UI: core logic complete; richer UI pending
- Generate unused shortcut action: initial menu action complete
- Local snapshot export: initial JSON export complete

## Phase 4: Alpha Release

- Signed build workflow
- Basic release notes
- Documentation for permissions
- Contributor guide for shortcut mappings
- Known limitations page
- Manual app QA recorded against the v0.1 checklist

## Later Ideas

- Curated community shortcut database
- Import mappings from common launcher or automation tools
- System shortcut awareness
- Optional user-defined blocked combinations
- App-specific suggestion profiles
