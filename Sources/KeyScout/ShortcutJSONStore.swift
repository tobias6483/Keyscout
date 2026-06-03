import Foundation

enum ShortcutJSONStore {
    static func encode(_ catalog: ShortcutCatalog) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        return try encoder.encode(catalog)
    }

    static func decode(_ data: Data) throws -> ShortcutCatalog {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(ShortcutCatalog.self, from: data)
    }
}
