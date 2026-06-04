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
                    keyboardShortcut: shortcut.shortcut,
                    shortcut: shortcut.shortcut.description,
                    command: shortcut.menuTitle,
                    menuPath: shortcut.menuPath.joined(separator: " > "),
                    source: shortcut.source.rawValue
                )
            }
    }

    func conflictDetail(for shortcut: KeyboardShortcut, in catalog: ShortcutCatalog) -> String {
        let conflicts = catalog.conflicts(for: shortcut)

        guard !conflicts.isEmpty else {
            return "\(shortcut) looks unused in the latest catalog"
        }

        let commands = conflicts
            .prefix(3)
            .map { "\($0.appName): \($0.menuTitle) [\($0.source.rawValue)]" }
            .joined(separator: "; ")

        if conflicts.count > 3 {
            return "\(shortcut) has \(conflicts.count) conflicts: \(commands); and \(conflicts.count - 3) more"
        }

        return "\(shortcut) has \(conflicts.count) \(pluralizedConflict(count: conflicts.count)): \(commands)"
    }

    private func pluralizedShortcut(count: Int) -> String {
        count == 1 ? "shortcut" : "shortcuts"
    }

    private func pluralizedConflict(count: Int) -> String {
        count == 1 ? "conflict" : "conflicts"
    }
}

struct ShortcutMenuRow: Equatable, Sendable {
    var title: String
    var detail: String
}

struct ShortcutListRow: Equatable, Sendable {
    var appName: String
    var keyboardShortcut: KeyboardShortcut
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
