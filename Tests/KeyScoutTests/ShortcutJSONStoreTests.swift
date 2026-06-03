import Foundation
import Testing
@testable import KeyScout

@Suite("Shortcut JSON store")
struct ShortcutJSONStoreTests {
    @Test("round trips shortcut catalogs")
    func roundTripsCatalogs() throws {
        let catalog = ShortcutCatalog(
            scannedAt: Date(timeIntervalSince1970: 1_800_000_000),
            shortcuts: [
                AppShortcut(
                    appName: "Example",
                    bundleIdentifier: "com.example.app",
                    menuPath: ["File", "Open"],
                    shortcut: KeyboardShortcut(modifiers: [.command], key: "O"),
                    source: .manual
                )
            ]
        )

        let data = try ShortcutJSONStore.encode(catalog)
        let decoded = try ShortcutJSONStore.decode(data)

        #expect(decoded == catalog)
    }

    @Test("encodes documented catalog shape")
    func encodesDocumentedCatalogShape() throws {
        let catalog = ShortcutCatalog(
            scannedAt: Date(timeIntervalSince1970: 1_800_000_000),
            shortcuts: [
                AppShortcut(
                    appName: "Example Editor",
                    bundleIdentifier: "com.example.editor",
                    menuPath: ["Window", "Show Inspector"],
                    shortcut: KeyboardShortcut(modifiers: [.command, .option], key: "i"),
                    source: .curated
                ),
                AppShortcut(
                    appName: "Example Editor",
                    bundleIdentifier: "com.example.editor",
                    menuPath: ["File", "Open"],
                    shortcut: KeyboardShortcut(modifiers: [.command], key: "o"),
                    source: .manual
                )
            ]
        )

        let data = try ShortcutJSONStore.encode(catalog)
        let json = try #require(String(data: data, encoding: .utf8))
        let fixtureURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent("docs/examples/sample-catalog.json")
        let expected = try String(contentsOf: fixtureURL, encoding: .utf8)

        #expect(expected == "\(json)\n")
    }
}
