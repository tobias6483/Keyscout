# Security Policy

KeyScout is designed to be local-only and privacy-first, but it may interact with sensitive macOS surfaces such as Accessibility permissions, app metadata, menu shortcuts, and user-defined shortcut mappings.

## Supported Versions

KeyScout has not shipped a release yet. Security fixes will be handled on the default branch until versioned releases exist.

Once releases exist, this section should list supported versions.

## Reporting a Vulnerability

Please do not open a public issue for security-sensitive reports.

Report vulnerabilities through GitHub's private vulnerability reporting feature for this repository. If that is not available, contact the repository owner through GitHub and ask for a private reporting channel.

Please include:

- A clear description of the issue
- Steps to reproduce
- Potential impact
- macOS version
- KeyScout version or commit SHA
- Any relevant logs, with private data removed

## Security Expectations

KeyScout should:

- Avoid network access unless a future feature explicitly documents it.
- Never collect analytics or telemetry.
- Never upload shortcut data, app lists, menu titles, or user snapshots.
- Request macOS permissions only when needed.
- Explain why Accessibility permissions are needed before asking for them.
- Treat exported JSON as user-owned data.
- Avoid storing private app data unless the user explicitly saves it.
- Treat the `privacy-review` issue label as a maintainer routing hint, not as a
  substitute for manual security review.

## Out of Scope

Reports about apps that expose incorrect shortcut data are useful product bugs, but they are not automatically security vulnerabilities unless they cause privacy, permission, or integrity impact in KeyScout.
