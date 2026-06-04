import Foundation
import Testing
@testable import KeyScout

@Suite("Shortcut mapping store")
struct ShortcutMappingStoreTests {
    @Test("missing file loads empty mapping library")
    func missingFileLoadsEmptyLibrary() throws {
        let store = ShortcutMappingStore(fileURL: temporaryStoreURL())

        #expect(try store.load().shortcuts.isEmpty)
    }

    @Test("saves and loads mapping library")
    func savesAndLoadsLibrary() throws {
        let url = temporaryStoreURL()
        defer {
            try? FileManager.default.removeItem(at: url.deletingLastPathComponent())
        }

        let store = ShortcutMappingStore(fileURL: url)
        let library = ShortcutMappingLibrary(shortcuts: [exampleShortcut])

        try store.save(library)

        #expect(try store.load().shortcuts == [exampleShortcut])
    }

    @Test("throws for corrupt JSON")
    func throwsForCorruptJSON() throws {
        let url = temporaryStoreURL()
        defer {
            try? FileManager.default.removeItem(at: url.deletingLastPathComponent())
        }

        try FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try Data("{ invalid json }".utf8).write(to: url)

        #expect(throws: Error.self) {
            _ = try ShortcutMappingStore(fileURL: url).load()
        }
    }

    private func temporaryStoreURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
            .appendingPathComponent("imported-mappings.json")
    }

    private var exampleShortcut: AppShortcut {
        AppShortcut(
            appName: "Example Editor",
            bundleIdentifier: "com.example.editor",
            menuPath: ["File", "Open"],
            shortcut: KeyboardShortcut(modifiers: [.command], key: "O"),
            source: .manual
        )
    }
}
