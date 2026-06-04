import Testing
@testable import KeyScout

@Suite("Shortcut list presenter")
struct ShortcutListPresenterTests {
    @Test("summarizes scanned app and shortcut count")
    func summarizesScannedApp() {
        let catalog = ShortcutCatalog(shortcuts: [
            AppShortcut(
                appName: "Safari",
                menuPath: ["File", "New Window"],
                shortcut: KeyboardShortcut(modifiers: [.command], key: "N"),
                source: .manual
            )
        ])

        #expect(ShortcutListPresenter().appSummary(for: catalog) == "Safari: 1 shortcut")
    }

    @Test("formats menu rows with shortcut and menu title")
    func formatsMenuRows() {
        let catalog = ShortcutCatalog(shortcuts: [
            AppShortcut(
                appName: "Safari",
                menuPath: ["File", "New Window"],
                shortcut: KeyboardShortcut(modifiers: [.command], key: "N"),
                source: .manual
            )
        ])

        let rows = ShortcutListPresenter().menuRows(for: catalog)

        #expect(rows == [
            ShortcutMenuRow(title: "⌘N  New Window", detail: "File > New Window")
        ])
    }

    @Test("adds overflow row when there are more shortcuts than the limit")
    func addsOverflowRow() {
        let shortcuts = (1...3).map { index in
            AppShortcut(
                appName: "Example",
                menuPath: ["Menu", "Item \(index)"],
                shortcut: KeyboardShortcut(modifiers: [.command], key: "\(index)"),
                source: .manual
            )
        }

        let rows = ShortcutListPresenter(limit: 2).menuRows(for: ShortcutCatalog(shortcuts: shortcuts))

        #expect(rows.last == ShortcutMenuRow(title: "1 more shortcut", detail: "Export JSON to inspect the full scan"))
    }

    @Test("filters list rows by query and source")
    func filtersListRows() {
        let catalog = ShortcutCatalog(shortcuts: [
            AppShortcut(
                appName: "Safari",
                bundleIdentifier: "com.apple.Safari",
                menuPath: ["File", "New Window"],
                shortcut: KeyboardShortcut(modifiers: [.command], key: "N"),
                source: .accessibility
            ),
            AppShortcut(
                appName: "Safari",
                bundleIdentifier: "com.apple.Safari",
                menuPath: ["Develop", "Show Web Inspector"],
                shortcut: KeyboardShortcut(modifiers: [.command, .option], key: "I"),
                source: .curated
            )
        ])

        let rows = ShortcutListPresenter().listRows(
            for: catalog,
            filter: ShortcutListFilter(query: "inspector", source: .curated)
        )

        #expect(rows == [
            ShortcutListRow(
                appName: "Safari",
                keyboardShortcut: KeyboardShortcut(modifiers: [.command, .option], key: "I"),
                shortcut: "⌥⌘I",
                command: "Show Web Inspector",
                menuPath: "Develop > Show Web Inspector",
                source: "curated"
            )
        ])
    }

    @Test("formats conflict detail")
    func formatsConflictDetail() {
        let shortcut = KeyboardShortcut(modifiers: [.command, .shift], key: "K")
        let catalog = ShortcutCatalog(shortcuts: [
            AppShortcut(
                appName: "Example Editor",
                menuPath: ["Go", "Open Symbol"],
                shortcut: shortcut,
                source: .accessibility
            ),
            AppShortcut(
                appName: "Example Editor",
                menuPath: ["Tools", "Command Palette"],
                shortcut: shortcut,
                source: .manual
            )
        ])

        #expect(
            ShortcutListPresenter().conflictDetail(for: shortcut, in: catalog)
                == "⇧⌘K has 2 conflicts: Example Editor: Open Symbol [accessibility]; Example Editor: Command Palette [manual]"
        )
    }

    @Test("formats unused conflict detail")
    func formatsUnusedConflictDetail() {
        let shortcut = KeyboardShortcut(modifiers: [.command, .shift], key: "K")

        #expect(
            ShortcutListPresenter().conflictDetail(for: shortcut, in: ShortcutCatalog(shortcuts: []))
                == "⇧⌘K looks unused in the latest catalog"
        )
    }
}
