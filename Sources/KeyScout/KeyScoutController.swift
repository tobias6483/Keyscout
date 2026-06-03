import AppKit
import Foundation

@MainActor
final class KeyScoutController {
    private let scanner = AccessibilityShortcutScanner()
    private let generator = ShortcutGenerator()
    private let presenter = ShortcutListPresenter()
    private var mappingLibrary: ShortcutMappingLibrary
    private let isAccessibilityTrusted: () -> Bool
    private var latestScannedCatalog = ShortcutCatalog(shortcuts: [])
    private var latestCatalog = ShortcutCatalog(shortcuts: [])

    init(
        mappingLibrary: ShortcutMappingLibrary = .builtIn,
        isAccessibilityTrusted: @escaping () -> Bool = { AccessibilityShortcutScanner().isProcessTrusted }
    ) {
        self.mappingLibrary = mappingLibrary
        self.isAccessibilityTrusted = isAccessibilityTrusted
    }

    func scanFrontmostApplication() -> ShortcutCatalog {
        guard hasAccessibilityPermission else {
            latestScannedCatalog = ShortcutCatalog(shortcuts: [])
            latestCatalog = ShortcutCatalog(shortcuts: [])
            return latestCatalog
        }

        latestScannedCatalog = scanner.scanFrontmostApplication()
        latestCatalog = mappingLibrary.mergedCatalog(with: latestScannedCatalog)
        return latestCatalog
    }

    var hasAccessibilityPermission: Bool {
        isAccessibilityTrusted()
    }

    var accessibilityPermissionSummary: String {
        hasAccessibilityPermission
            ? "Accessibility permission ready"
            : "Accessibility permission needed to scan app menus"
    }

    func generatedShortcutSummary() -> String {
        guard hasAccessibilityPermission else {
            return accessibilityPermissionSummary
        }

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

    func latestShortcutListRows(filter: ShortcutListFilter = ShortcutListFilter()) -> [ShortcutListRow] {
        presenter.listRows(for: latestCatalog, filter: filter)
    }

    var latestShortcutCount: Int {
        latestCatalog.shortcuts.count
    }

    func importShortcutMappings(from url: URL) throws -> Int {
        let data = try Data(contentsOf: url)
        let catalog = try ShortcutJSONStore.decode(data)
        mappingLibrary = mappingLibrary.merging(ShortcutMappingLibrary(shortcuts: catalog.shortcuts))
        latestCatalog = mappingLibrary.mergedCatalog(with: latestScannedCatalog)
        return catalog.shortcuts.count
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
