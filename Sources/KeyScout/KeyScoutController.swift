import AppKit
import Foundation

@MainActor
final class KeyScoutController {
    private let scanner = AccessibilityShortcutScanner()
    private let generator = ShortcutGenerator()
    private let presenter = ShortcutListPresenter()
    private var latestCatalog = ShortcutCatalog(shortcuts: [])

    func scanFrontmostApplication() -> ShortcutCatalog {
        latestCatalog = scanner.scanFrontmostApplication()
        return latestCatalog
    }

    func generatedShortcutSummary() -> String {
        let catalog = scanFrontmostApplication()

        guard let shortcut = generator.firstUnusedShortcut(in: catalog) else {
            return "No unused shortcut found"
        }

        return "Suggested unused shortcut: \(shortcut)"
    }

    func latestAppSummary() -> String {
        presenter.appSummary(for: latestCatalog)
    }

    func latestShortcutRows() -> [ShortcutMenuRow] {
        presenter.menuRows(for: latestCatalog)
    }

    func conflictSummary(for shortcut: KeyboardShortcut) -> String {
        let conflicts = latestCatalog.conflicts(for: shortcut)

        guard let conflict = conflicts.first else {
            return "\(shortcut) looks unused in the latest scan"
        }

        let appName = conflict.appName
        return "\(shortcut) is already used by \(appName)"
    }

    func exportLatestCatalog() throws -> URL {
        let data = try ShortcutJSONStore.encode(latestCatalog)
        let directory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
        let url = directory.appendingPathComponent("keyscout-shortcuts.json")
        try data.write(to: url, options: .atomic)
        return url
    }
}
