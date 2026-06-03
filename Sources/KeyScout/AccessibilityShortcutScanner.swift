import AppKit
import ApplicationServices
import Foundation

final class AccessibilityShortcutScanner {
    func scanFrontmostApplication() -> ShortcutCatalog {
        guard let application = NSWorkspace.shared.frontmostApplication else {
            return ShortcutCatalog(shortcuts: [])
        }

        return scan(application: application)
    }

    func scan(application: NSRunningApplication) -> ShortcutCatalog {
        let appName = application.localizedName ?? "Unknown App"
        let bundleIdentifier = application.bundleIdentifier
        let appElement = AXUIElementCreateApplication(application.processIdentifier)

        var menuBarValue: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(appElement, kAXMenuBarAttribute as CFString, &menuBarValue)

        guard result == .success, let menuBar = menuBarValue else {
            return ShortcutCatalog(shortcuts: [])
        }

        let shortcuts = collectShortcuts(
            from: menuBar as! AXUIElement,
            appName: appName,
            bundleIdentifier: bundleIdentifier,
            path: []
        )

        return ShortcutCatalog(shortcuts: shortcuts)
    }

    private func collectShortcuts(
        from element: AXUIElement,
        appName: String,
        bundleIdentifier: String?,
        path: [String]
    ) -> [AppShortcut] {
        var results: [AppShortcut] = []
        let title = stringAttribute(kAXTitleAttribute, from: element)
        let currentPath = title.map { path + [$0] } ?? path

        if let shortcut = shortcut(from: element), !currentPath.isEmpty {
            results.append(
                AppShortcut(
                    appName: appName,
                    bundleIdentifier: bundleIdentifier,
                    menuPath: currentPath,
                    shortcut: shortcut,
                    source: .accessibility
                )
            )
        }

        for child in children(of: element) {
            results.append(
                contentsOf: collectShortcuts(
                    from: child,
                    appName: appName,
                    bundleIdentifier: bundleIdentifier,
                    path: currentPath
                )
            )
        }

        return results
    }

    private func shortcut(from element: AXUIElement) -> KeyboardShortcut? {
        guard let key = stringAttribute("AXMenuItemCmdChar", from: element), !key.isEmpty else {
            return nil
        }

        let modifierMask = intAttribute("AXMenuItemCmdModifiers", from: element) ?? 0
        var modifiers: ShortcutModifiers = []

        if modifierMask & 1 != 0 {
            modifiers.insert(.shift)
        }

        if modifierMask & 2 != 0 {
            modifiers.insert(.option)
        }

        if modifierMask & 4 != 0 {
            modifiers.insert(.control)
        }

        if modifierMask & 8 == 0 {
            modifiers.insert(.command)
        }

        return KeyboardShortcut(modifiers: modifiers, key: key)
    }

    private func children(of element: AXUIElement) -> [AXUIElement] {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &value)

        guard result == .success, let children = value as? [AXUIElement] else {
            return []
        }

        return children
    }

    private func stringAttribute(_ attribute: String, from element: AXUIElement) -> String? {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, attribute as CFString, &value)

        guard result == .success else {
            return nil
        }

        return value as? String
    }

    private func intAttribute(_ attribute: String, from element: AXUIElement) -> Int? {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, attribute as CFString, &value)

        guard result == .success else {
            return nil
        }

        if let intValue = value as? Int {
            return intValue
        }

        if let number = value as? NSNumber {
            return number.intValue
        }

        return nil
    }
}
