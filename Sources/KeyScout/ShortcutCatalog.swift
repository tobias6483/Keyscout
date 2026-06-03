import Foundation

struct ShortcutCatalog: Codable, Equatable, Sendable {
    var scannedAt: Date
    var shortcuts: [AppShortcut]

    init(scannedAt: Date = Date(), shortcuts: [AppShortcut]) {
        self.scannedAt = scannedAt
        self.shortcuts = shortcuts.sorted {
            if $0.appName == $1.appName {
                return $0.shortcut.sortKey < $1.shortcut.sortKey
            }

            return $0.appName < $1.appName
        }
    }

    func conflicts(for shortcut: KeyboardShortcut) -> [AppShortcut] {
        shortcuts.filter { $0.shortcut == shortcut }
    }

    func contains(_ shortcut: KeyboardShortcut) -> Bool {
        !conflicts(for: shortcut).isEmpty
    }
}
