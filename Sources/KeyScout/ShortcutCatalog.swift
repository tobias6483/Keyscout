import Foundation

struct ShortcutCatalog: Codable, Equatable, Sendable {
    var scannedAt: Date
    var shortcuts: [AppShortcut]

    init(scannedAt: Date = Date(), shortcuts: [AppShortcut]) {
        self.scannedAt = scannedAt
        self.shortcuts = shortcuts.sorted { $0.catalogSortKey < $1.catalogSortKey }
    }

    func conflicts(for shortcut: KeyboardShortcut) -> [AppShortcut] {
        shortcuts.filter { $0.shortcut == shortcut }
    }

    func contains(_ shortcut: KeyboardShortcut) -> Bool {
        !conflicts(for: shortcut).isEmpty
    }

    func merging(_ other: ShortcutCatalog) -> ShortcutCatalog {
        ShortcutCatalog(
            scannedAt: max(scannedAt, other.scannedAt),
            shortcuts: shortcuts + other.shortcuts
        )
    }
}

private extension AppShortcut {
    var catalogSortKey: String {
        [
            appName,
            shortcut.sortKey,
            menuPath.joined(separator: "\u{0}"),
            source.rawValue
        ]
        .joined(separator: "\u{0}")
    }
}
