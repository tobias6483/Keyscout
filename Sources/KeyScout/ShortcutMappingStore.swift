import Foundation

struct ShortcutMappingStore: Sendable {
    var fileURL: URL

    init(fileURL: URL) {
        self.fileURL = fileURL
    }

    static func applicationSupport(fileManager: FileManager = .default) throws -> ShortcutMappingStore {
        let directory = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appendingPathComponent("KeyScout", isDirectory: true)

        return ShortcutMappingStore(fileURL: directory.appendingPathComponent("imported-mappings.json"))
    }

    func load(fileManager: FileManager = .default) throws -> ShortcutMappingLibrary {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return ShortcutMappingLibrary()
        }

        let data = try Data(contentsOf: fileURL)
        let catalog = try ShortcutJSONStore.decode(data)
        return ShortcutMappingLibrary(shortcuts: catalog.shortcuts)
    }

    func save(_ library: ShortcutMappingLibrary, fileManager: FileManager = .default) throws {
        let directory = fileURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)

        let catalog = ShortcutCatalog(shortcuts: library.shortcuts)
        let data = try ShortcutJSONStore.encode(catalog)
        try data.write(to: fileURL, options: .atomic)
    }
}
