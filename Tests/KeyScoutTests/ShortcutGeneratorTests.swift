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

    @Test("default generator skips common macOS reserved shortcuts")
    func skipsDefaultReservedShortcuts() {
        let generator = ShortcutGenerator(
            candidateKeys: ["A", "B"],
            modifierSets: [[.command]]
        )

        #expect(generator.firstUnusedShortcut(in: ShortcutCatalog(shortcuts: [])) == KeyboardShortcut(modifiers: [.command], key: "B"))
    }

    @Test("reserved defaults include categorized system shortcuts")
    func includesCategorizedReservedDefaults() {
        #expect(ReservedShortcutDefaults.appLifecycle.contains(KeyboardShortcut(modifiers: [.command], key: "Q")))
        #expect(ReservedShortcutDefaults.appSwitchingAndSystemUI.contains(KeyboardShortcut(modifiers: [.command], key: "Space")))
        #expect(ReservedShortcutDefaults.editingAndNavigation.contains(KeyboardShortcut(modifiers: [.command], key: "S")))
        #expect(ShortcutGenerator.defaultReservedShortcuts.contains(KeyboardShortcut(modifiers: [.command, .shift], key: "Z")))
    }
}
