# JSON Schema

KeyScout exports shortcut catalogs as pretty-printed JSON. The format is
intended to be readable, local-first, and stable enough for contributors to
review sample mappings while the app is still pre-release.

The current export does not include a schema version field. Additive fields may
be introduced before the first tagged release, but existing field meanings
should not change without a changelog entry and migration note.

See [sample-catalog.json](examples/sample-catalog.json) for a complete example.

## Catalog

```json
{
  "scannedAt": "2027-01-15T08:00:00Z",
  "shortcuts": []
}
```

Fields:

- `scannedAt`: ISO 8601 UTC timestamp for when the catalog snapshot was created.
- `shortcuts`: array of shortcut records sorted by app name, then shortcut sort
  key.

## Shortcut Record

```json
{
  "appName": "Example",
  "bundleIdentifier": "com.example.app",
  "menuPath": ["File", "Open"],
  "shortcut": {
    "key": "O",
    "modifiers": 1
  },
  "source": "manual"
}
```

Fields:

- `appName`: display name for the app that owns the shortcut.
- `bundleIdentifier`: app bundle identifier when known. This value may be
  `null` for manual or imported mappings where the bundle identifier is not
  available.
- `menuPath`: ordered menu hierarchy for the command, for example
  `["File", "Open Recent"]`.
- `shortcut`: normalized keyboard shortcut.
- `source`: origin of the record. Valid values are `accessibility`, `curated`,
  and `manual`.

## Shortcut

```json
{
  "key": "K",
  "modifiers": 3
}
```

Fields:

- `key`: normalized key label. Single-character keys are uppercased. Recognized
  aliases include `Esc`, `Return`, `Space`, and `Delete`.
- `modifiers`: integer bitmask for modifier keys.

Modifier bits:

| Modifier | Bit | Value |
| --- | ---: | ---: |
| Command | 0 | 1 |
| Shift | 1 | 2 |
| Option | 2 | 4 |
| Control | 3 | 8 |

Examples:

- `1`: Command
- `3`: Command + Shift
- `5`: Command + Option
- `15`: Command + Shift + Option + Control

## Contribution Notes

Shortcut mapping contributions should use stable menu names and avoid private
or organization-specific shortcuts. If a mapping was manually verified, set
`source` to `manual`; future curated mapping files should use `curated`.

KeyScout can merge curated/manual mappings with the latest scan when the mapping
matches the scanned app name or bundle identifier. Conflicts are evaluated
across all merged sources.
