import AppKit
import Foundation

@MainActor
final class KeyScoutController {
    private let scanner = AccessibilityShortcutScanner()
    private let generator = ShortcutGenerator()
    private let presenter = ShortcutListPresenter()
    private let builtInMappingLibrary: ShortcutMappingLibrary
    private var importedMappingLibrary: ShortcutMappingLibrary
    private let importedMappingStore: ShortcutMappingStore?
    private let isAccessibilityTrusted: () -> Bool
    private var latestScannedCatalog = ShortcutCatalog(shortcuts: [])
    private var latestCatalog = ShortcutCatalog(shortcuts: [])

    init(
        mappingLibrary: ShortcutMappingLibrary = .builtIn,
        importedMappingStore: ShortcutMappingStore? = nil,
        isAccessibilityTrusted: @escaping () -> Bool = { AccessibilityShortcutScanner().isProcessTrusted }
    ) {
        self.builtInMappingLibrary = mappingLibrary
        self.importedMappingStore = importedMappingStore
        self.importedMappingLibrary = (try? importedMappingStore?.load()) ?? ShortcutMappingLibrary()
        self.isAccessibilityTrusted = isAccessibilityTrusted
    }

    func scanFrontmostApplication() -> ShortcutCatalog {
        guard hasAccessibilityPermission else {
            latestScannedCatalog = ShortcutCatalog(shortcuts: [])
            latestCatalog = ShortcutCatalog(shortcuts: [])
            return latestCatalog
        }

        latestScannedCatalog = scanner.scanFrontmostApplication()
        latestCatalog = combinedMappingLibrary.mergedCatalog(with: latestScannedCatalog)
        return latestCatalog
    }

    var hasAccessibilityPermission: Bool {
        isAccessibilityTrusted()
    }

    var accessibilityPermissionSummary: String {
        hasAccessibilityPermission
            ? "Accessibility permission ready"
            : "Enable Accessibility for the exact KeyScout.app you are running"
    }

    var accessibilityPermissionDetail: String {
        hasAccessibilityPermission
            ? "KeyScout can scan app menus"
            : "`swift run` uses a different app identity and does not share Accessibility permission with KeyScout.app"
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

    func conflictRows(for shortcut: KeyboardShortcut) -> [ShortcutListRow] {
        presenter.listRows(for: ShortcutCatalog(shortcuts: latestCatalog.conflicts(for: shortcut)))
    }

    func conflictDetail(for shortcut: KeyboardShortcut) -> String {
        presenter.conflictDetail(for: shortcut, in: latestCatalog)
    }

    var latestShortcutCount: Int {
        latestCatalog.shortcuts.count
    }

    func importShortcutMappings(from url: URL) throws -> Int {
        let data = try Data(contentsOf: url)
        let catalog = try ShortcutJSONStore.decode(data)
        importedMappingLibrary = importedMappingLibrary.merging(ShortcutMappingLibrary(shortcuts: catalog.shortcuts))
        try importedMappingStore?.save(importedMappingLibrary)
        latestCatalog = combinedMappingLibrary.mergedCatalog(with: latestScannedCatalog)
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

    private var combinedMappingLibrary: ShortcutMappingLibrary {
        builtInMappingLibrary.merging(importedMappingLibrary)
    }
}
