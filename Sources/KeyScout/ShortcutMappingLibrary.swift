import Foundation

struct ShortcutMappingLibrary: Sendable {
    var shortcuts: [AppShortcut]

    init(shortcuts: [AppShortcut] = []) {
        self.shortcuts = shortcuts
    }

    func catalog(matching catalog: ShortcutCatalog, scannedAt: Date? = nil) -> ShortcutCatalog {
        let appNames = Set(catalog.shortcuts.map(\.appName))
        let bundleIdentifiers = Set(catalog.shortcuts.compactMap(\.bundleIdentifier))
        let matches = shortcuts.filter { shortcut in
            appNames.contains(shortcut.appName)
                || shortcut.bundleIdentifier.map(bundleIdentifiers.contains) == true
        }

        return ShortcutCatalog(
            scannedAt: scannedAt ?? catalog.scannedAt,
            shortcuts: matches
        )
    }

    func mergedCatalog(with catalog: ShortcutCatalog) -> ShortcutCatalog {
        catalog.merging(self.catalog(matching: catalog))
    }

    func merging(_ other: ShortcutMappingLibrary) -> ShortcutMappingLibrary {
        ShortcutMappingLibrary(shortcuts: Array(Set(shortcuts + other.shortcuts)))
    }

    static let builtIn = ShortcutMappingLibrary(shortcuts: [
        AppShortcut(
            appName: "Finder",
            bundleIdentifier: "com.apple.finder",
            menuPath: ["File", "New Finder Window"],
            shortcut: KeyboardShortcut(modifiers: [.command], key: "N"),
            source: .curated
        ),
        AppShortcut(
            appName: "Finder",
            bundleIdentifier: "com.apple.finder",
            menuPath: ["Go", "AirDrop"],
            shortcut: KeyboardShortcut(modifiers: [.command, .shift], key: "R"),
            source: .curated
        )
    ])
}
