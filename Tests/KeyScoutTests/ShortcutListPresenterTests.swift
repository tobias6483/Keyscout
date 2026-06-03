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
}
