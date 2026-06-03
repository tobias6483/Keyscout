import Testing
@testable import KeyScout

@Suite("Shortcut generator")
struct ShortcutGeneratorTests {
    @Test("returns the first unused shortcut")
    func returnsFirstUnusedShortcut() {
        let usedShortcut = KeyboardShortcut(modifiers: [.command, .shift], key: "A")
        let catalog = ShortcutCatalog(
            shortcuts: [
                AppShortcut(
                    appName: "Example",
                    menuPath: ["File", "Example"],
                    shortcut: usedShortcut,
                    source: .manual
                )
            ]
        )
        let generator = ShortcutGenerator(candidateKeys: ["A", "B"], modifierSets: [[.command, .shift]])

        #expect(generator.firstUnusedShortcut(in: catalog) == KeyboardShortcut(modifiers: [.command, .shift], key: "B"))
    }

    @Test("skips reserved shortcuts")
    func skipsReservedShortcuts() {
        let reserved = KeyboardShortcut(modifiers: [.command, .shift], key: "A")
        let generator = ShortcutGenerator(
            candidateKeys: ["A", "B"],
            modifierSets: [[.command, .shift]],
            reservedShortcuts: [reserved]
        )

        #expect(generator.firstUnusedShortcut(in: ShortcutCatalog(shortcuts: [])) == KeyboardShortcut(modifiers: [.command, .shift], key: "B"))
    }
}
