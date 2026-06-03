import Foundation

struct ShortcutGenerator: Sendable {
    var candidateKeys: [String]
    var modifierSets: [ShortcutModifiers]
    var reservedShortcuts: Set<KeyboardShortcut>

    init(
        candidateKeys: [String] = ShortcutGenerator.defaultCandidateKeys,
        modifierSets: [ShortcutModifiers] = ShortcutModifiers.suggested,
        reservedShortcuts: Set<KeyboardShortcut> = ShortcutGenerator.defaultReservedShortcuts
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

    static let defaultReservedShortcuts: Set<KeyboardShortcut> = [
        KeyboardShortcut(modifiers: [.command], key: "Q"),
        KeyboardShortcut(modifiers: [.command], key: "W"),
        KeyboardShortcut(modifiers: [.command], key: "Tab"),
        KeyboardShortcut(modifiers: [.command, .option], key: "Esc"),
        KeyboardShortcut(modifiers: [.command], key: "Space")
    ]
}
