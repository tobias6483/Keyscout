import Foundation
import Testing
@testable import KeyScout

@Suite("Shortcut catalog")
struct ShortcutCatalogTests {
    @Test("finds conflicts by normalized shortcut")
    func findsConflicts() {
        let shortcut = KeyboardShortcut(modifiers: [.command, .shift], key: "k")
        let catalog = ShortcutCatalog(
            shortcuts: [
                AppShortcut(
                    appName: "VS Code",
                    bundleIdentifier: "com.microsoft.VSCode",
                    menuPath: ["View", "Command Palette"],
                    shortcut: shortcut,
                    source: .manual
                )
            ]
        )

        #expect(catalog.conflicts(for: KeyboardShortcut(modifiers: [.shift, .command], key: "K")).count == 1)
    }

    @Test("merges catalogs and preserves shortcut sources")
    func mergesCatalogs() {
        let scannedAt = Date(timeIntervalSince1970: 1_800_000_000)
        let importedAt = Date(timeIntervalSince1970: 1_800_000_010)
        let scanned = ShortcutCatalog(
            scannedAt: scannedAt,
            shortcuts: [
                AppShortcut(
                    appName: "Example",
                    bundleIdentifier: "com.example.app",
                    menuPath: ["File", "Open"],
                    shortcut: KeyboardShortcut(modifiers: [.command], key: "O"),
                    source: .accessibility
                )
            ]
        )
        let imported = ShortcutCatalog(
            scannedAt: importedAt,
            shortcuts: [
                AppShortcut(
                    appName: "Example",
                    bundleIdentifier: "com.example.app",
                    menuPath: ["Window", "Inspector"],
                    shortcut: KeyboardShortcut(modifiers: [.command, .option], key: "I"),
                    source: .manual
                )
            ]
        )

        let merged = scanned.merging(imported)

        #expect(merged.scannedAt == importedAt)
        #expect(merged.shortcuts.map(\.source) == [ShortcutSource.accessibility, .manual])
        #expect(merged.conflicts(for: KeyboardShortcut(modifiers: [.command, .option], key: "I")).count == 1)
    }
}
