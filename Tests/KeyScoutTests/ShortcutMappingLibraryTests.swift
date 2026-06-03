import Foundation
import Testing
@testable import KeyScout

@Suite("Shortcut mapping library")
struct ShortcutMappingLibraryTests {
    @Test("matches mappings by bundle identifier or app name")
    func matchesMappings() {
        let library = ShortcutMappingLibrary(shortcuts: [
            AppShortcut(
                appName: "Different Display Name",
                bundleIdentifier: "com.example.editor",
                menuPath: ["File", "Save"],
                shortcut: KeyboardShortcut(modifiers: [.command], key: "S"),
                source: .curated
            ),
            AppShortcut(
                appName: "Example Editor",
                menuPath: ["Tools", "Custom Action"],
                shortcut: KeyboardShortcut(modifiers: [.command, .shift], key: "A"),
                source: .manual
            ),
            AppShortcut(
                appName: "Other App",
                bundleIdentifier: "com.example.other",
                menuPath: ["File", "Open"],
                shortcut: KeyboardShortcut(modifiers: [.command], key: "O"),
                source: .curated
            )
        ])
        let scanned = ShortcutCatalog(shortcuts: [
            AppShortcut(
                appName: "Example Editor",
                bundleIdentifier: "com.example.editor",
                menuPath: ["File", "Open"],
                shortcut: KeyboardShortcut(modifiers: [.command], key: "O"),
                source: .accessibility
            )
        ])

        let catalog = library.catalog(matching: scanned)

        #expect(catalog.shortcuts.count == 2)
        #expect(catalog.shortcuts.map(\.source) == [.curated, .manual])
    }

    @Test("merged catalog detects conflicts across scanned and mapped sources")
    func detectsMergedConflicts() {
        let library = ShortcutMappingLibrary(shortcuts: [
            AppShortcut(
                appName: "Example Editor",
                bundleIdentifier: "com.example.editor",
                menuPath: ["Tools", "Run"],
                shortcut: KeyboardShortcut(modifiers: [.command, .shift], key: "R"),
                source: .curated
            )
        ])
        let scanned = ShortcutCatalog(shortcuts: [
            AppShortcut(
                appName: "Example Editor",
                bundleIdentifier: "com.example.editor",
                menuPath: ["File", "Reload"],
                shortcut: KeyboardShortcut(modifiers: [.command, .shift], key: "R"),
                source: .accessibility
            )
        ])

        let conflicts = library
            .mergedCatalog(with: scanned)
            .conflicts(for: KeyboardShortcut(modifiers: [.shift, .command], key: "r"))

        #expect(conflicts.map(\.source) == [.accessibility, .curated])
    }
}
