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
}
