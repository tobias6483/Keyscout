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

    func listRows(for catalog: ShortcutCatalog, filter: ShortcutListFilter = ShortcutListFilter()) -> [ShortcutListRow] {
        catalog.shortcuts
            .filter { filter.matches($0) }
            .map { shortcut in
                ShortcutListRow(
                    appName: shortcut.appName,
                    shortcut: shortcut.shortcut.description,
                    command: shortcut.menuTitle,
                    menuPath: shortcut.menuPath.joined(separator: " > "),
                    source: shortcut.source.rawValue
                )
            }
    }

    private func pluralizedShortcut(count: Int) -> String {
        count == 1 ? "shortcut" : "shortcuts"
    }
}

struct ShortcutMenuRow: Equatable, Sendable {
    var title: String
    var detail: String
}

struct ShortcutListRow: Equatable, Sendable {
    var appName: String
    var shortcut: String
    var command: String
    var menuPath: String
    var source: String
}

struct ShortcutListFilter: Equatable, Sendable {
    var query: String
    var source: ShortcutSource?

    init(query: String = "", source: ShortcutSource? = nil) {
        self.query = query
        self.source = source
    }

    func matches(_ shortcut: AppShortcut) -> Bool {
        if let source, shortcut.source != source {
            return false
        }

        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedQuery.isEmpty else {
            return true
        }

        let haystack = [
            shortcut.appName,
            shortcut.bundleIdentifier ?? "",
            shortcut.menuPath.joined(separator: " "),
            shortcut.shortcut.description,
            shortcut.source.rawValue
        ]
        .joined(separator: " ")

        return haystack.range(of: trimmedQuery, options: [.caseInsensitive, .diacriticInsensitive]) != nil
    }
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
