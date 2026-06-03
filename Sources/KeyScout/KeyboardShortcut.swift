import Foundation

struct KeyboardShortcut: Codable, Equatable, Hashable, Sendable, CustomStringConvertible {
    var modifiers: ShortcutModifiers
    var key: String

    init(modifiers: ShortcutModifiers, key: String) {
        self.modifiers = modifiers.normalized
        self.key = KeyboardShortcut.normalizeKey(key)
    }

    var description: String {
        "\(modifiers.symbols)\(key)"
    }

    var sortKey: String {
        "\(modifiers.rawValue)-\(key)"
    }

    private static func normalizeKey(_ key: String) -> String {
        let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.count == 1 {
            return trimmed.uppercased()
        }

        switch trimmed.lowercased() {
        case "escape", "esc":
            return "Esc"
        case "return", "enter":
            return "Return"
        case "space", "spacebar":
            return "Space"
        case "delete", "backspace":
            return "Delete"
        default:
            return trimmed
        }
    }
}
