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
}
