import Foundation

struct ShortcutModifiers: OptionSet, Codable, Hashable, Sendable {
    let rawValue: Int

    static let command = ShortcutModifiers(rawValue: 1 << 0)
    static let shift = ShortcutModifiers(rawValue: 1 << 1)
    static let option = ShortcutModifiers(rawValue: 1 << 2)
    static let control = ShortcutModifiers(rawValue: 1 << 3)

    static let suggested: [ShortcutModifiers] = [
        [.command, .shift],
        [.command, .option],
        [.control, .option],
        [.command, .control],
        [.command, .shift, .option],
        [.command, .shift, .control],
        [.command, .option, .control],
        [.command, .shift, .option, .control]
    ]

    var normalized: ShortcutModifiers {
        self
    }

    var symbols: String {
        [
            contains(.control) ? "⌃" : nil,
            contains(.option) ? "⌥" : nil,
            contains(.shift) ? "⇧" : nil,
            contains(.command) ? "⌘" : nil
        ]
        .compactMap { $0 }
        .joined()
    }
}
