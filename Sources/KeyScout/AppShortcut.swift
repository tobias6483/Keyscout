import Foundation

struct AppShortcut: Codable, Equatable, Hashable, Sendable {
    var appName: String
    var bundleIdentifier: String?
    var menuPath: [String]
    var shortcut: KeyboardShortcut
    var source: ShortcutSource

    init(
        appName: String,
        bundleIdentifier: String? = nil,
        menuPath: [String],
        shortcut: KeyboardShortcut,
        source: ShortcutSource
    ) {
        self.appName = appName
        self.bundleIdentifier = bundleIdentifier
        self.menuPath = menuPath
        self.shortcut = shortcut
        self.source = source
    }
}

enum ShortcutSource: String, Codable, Sendable {
    case accessibility
    case curated
    case manual
}
