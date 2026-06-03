import Foundation

struct ShortcutListPresenter: Sendable {
    var limit: Int

    init(limit: Int = 12) {
        self.limit = limit
    }

    func appSummary(for catalog: ShortcutCatalog) -> String {
        guard let appName = catalog.primaryAppName else {
            return "No scanned app"
        }

        return "\(appName): \(catalog.shortcuts.count) \(pluralizedShortcut(count: catalog.shortcuts.count))"
    }

    func menuRows(for catalog: ShortcutCatalog) -> [ShortcutMenuRow] {
        let rows = catalog.shortcuts.prefix(limit).map { shortcut in
            ShortcutMenuRow(
                title: "\(shortcut.shortcut)  \(shortcut.menuTitle)",
                detail: shortcut.menuPath.joined(separator: " > ")
            )
        }

        if catalog.shortcuts.count > limit {
            let overflowCount = catalog.shortcuts.count - limit

            return rows + [
                ShortcutMenuRow(
                    title: "\(overflowCount) more \(pluralizedShortcut(count: overflowCount))",
                    detail: "Export JSON to inspect the full scan"
                )
            ]
        }

        return Array(rows)
    }

    private func pluralizedShortcut(count: Int) -> String {
        count == 1 ? "shortcut" : "shortcuts"
    }
}

struct ShortcutMenuRow: Equatable, Sendable {
    var title: String
    var detail: String
}

extension ShortcutCatalog {
    var primaryAppName: String? {
        shortcuts.first?.appName
    }
}

private extension AppShortcut {
    var menuTitle: String {
        menuPath.last ?? "Untitled Shortcut"
    }
}
