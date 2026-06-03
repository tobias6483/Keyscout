# Issue Triage

KeyScout uses lightweight GitHub Actions issue triage for maintainer routing.
The goal is to label issues without sending issue content to a third-party
triage service.

## Automation

The workflow lives at `.github/workflows/issue-triage.yml`.

It reads the issue title and body with `actions/github-script`, creates missing
repository labels when needed, and applies matching labels.

## Labels

- `area:scanner`: Accessibility API scanning, app menu traversal, and app
  shortcut discovery.
- `area:generator`: unused shortcut generation, candidate ranking, and reserved
  shortcut handling.
- `area:mapping`: curated app mappings, manual mappings, imports, and JSON
  mapping data.
- `area:menu-bar`: menu bar UX, status text, actions, and future shortcut list
  views.
- `area:docs`: README, docs, roadmap, release notes, and contributor guidance.
- `area:release`: build, packaging, artifacts, signing, notarization, and
  distribution work.
- `privacy-review`: issues that mention permissions, privacy/security,
  Accessibility, local storage, exports, networking, analytics, telemetry, or
  cloud behavior.
- `needs-triage`: fallback label when no specific routing label matches.

Use the `Privacy review` issue template for proposed Accessibility permission
changes, new data storage, networking, telemetry, sync, crash reporting, or
other permission-sensitive behavior.

## Maintainer Notes

Labels are hints, not decisions. Maintainers should still review privacy,
permission, and shortcut-data-impacting changes manually before implementation.

The workflow is intentionally local to GitHub Actions and does not add runtime
tracking, app telemetry, or any KeyScout product dependency.
