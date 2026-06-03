import Foundation

struct ShortcutGenerator: Sendable {
    var candidateKeys: [String]
    var modifierSets: [ShortcutModifiers]
    var reservedShortcuts: Set<KeyboardShortcut>

    init(
        candidateKeys: [String] = ShortcutGenerator.defaultCandidateKeys,
        modifierSets: [ShortcutModifiers] = ShortcutModifiers.suggested,
        reservedShortcuts: Set<KeyboardShortcut> = ReservedShortcutDefaults.all
    ) {
        self.candidateKeys = candidateKeys
        self.modifierSets = modifierSets
        self.reservedShortcuts = reservedShortcuts
    }

    func firstUnusedShortcut(in catalog: ShortcutCatalog) -> KeyboardShortcut? {
        for modifiers in modifierSets {
            for key in candidateKeys {
                let shortcut = KeyboardShortcut(modifiers: modifiers, key: key)

                if reservedShortcuts.contains(shortcut) {
                    continue
                }

                if !catalog.contains(shortcut) {
                    return shortcut
                }
            }
        }

        return nil
    }

    static let defaultCandidateKeys: [String] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map(String.init)

    static let defaultReservedShortcuts = ReservedShortcutDefaults.all
}

enum ReservedShortcutDefaults {
    static let appLifecycle: Set<KeyboardShortcut> = [
        KeyboardShortcut(modifiers: [.command], key: "H"),
        KeyboardShortcut(modifiers: [.command, .option], key: "H"),
        KeyboardShortcut(modifiers: [.command], key: "M"),
        KeyboardShortcut(modifiers: [.command], key: "Q"),
        KeyboardShortcut(modifiers: [.command], key: "W")
    ]

    static let appSwitchingAndSystemUI: Set<KeyboardShortcut> = [
        KeyboardShortcut(modifiers: [.command], key: "Space"),
        KeyboardShortcut(modifiers: [.command], key: "Tab"),
        KeyboardShortcut(modifiers: [.command, .option], key: "Esc"),
        KeyboardShortcut(modifiers: [.control], key: "Space")
    ]

    static let editingAndNavigation: Set<KeyboardShortcut> = [
        KeyboardShortcut(modifiers: [.command], key: "A"),
        KeyboardShortcut(modifiers: [.command], key: "C"),
        KeyboardShortcut(modifiers: [.command], key: "F"),
        KeyboardShortcut(modifiers: [.command], key: "G"),
        KeyboardShortcut(modifiers: [.command, .shift], key: "G"),
        KeyboardShortcut(modifiers: [.command], key: "N"),
        KeyboardShortcut(modifiers: [.command], key: "O"),
        KeyboardShortcut(modifiers: [.command], key: "P"),
        KeyboardShortcut(modifiers: [.command], key: "S"),
        KeyboardShortcut(modifiers: [.command, .shift], key: "S"),
        KeyboardShortcut(modifiers: [.command], key: "V"),
        KeyboardShortcut(modifiers: [.command], key: "X"),
        KeyboardShortcut(modifiers: [.command], key: "Z"),
        KeyboardShortcut(modifiers: [.command, .shift], key: "Z")
    ]

    static let all: Set<KeyboardShortcut> = appLifecycle
        .union(appSwitchingAndSystemUI)
        .union(editingAndNavigation)
}
