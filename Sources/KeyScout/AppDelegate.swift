import AppKit
import UniformTypeIdentifiers

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private let controller = KeyScoutController(importedMappingStore: try? .applicationSupport())
    private var shortcutListWindowController: ShortcutListWindowController?
    private var statusText = "Ready"

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        configureStatusItem()
    }

    private func configureStatusItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.button?.title = "⌘?"
        item.button?.toolTip = "KeyScout"
        item.menu = makeMenu(status: statusText)
        statusItem = item
    }

    private func makeMenu(status: String) -> NSMenu {
        let menu = NSMenu()
        let title = NSMenuItem(title: "KeyScout", action: nil, keyEquivalent: "")
        title.isEnabled = false
        menu.addItem(title)

        let statusItem = NSMenuItem(title: status, action: nil, keyEquivalent: "")
        statusItem.isEnabled = false
        menu.addItem(statusItem)

        if !controller.hasAccessibilityPermission {
            let permission = NSMenuItem(title: controller.accessibilityPermissionSummary, action: nil, keyEquivalent: "")
            permission.isEnabled = false
            menu.addItem(permission)

            menu.addItem(
                NSMenuItem(
                    title: "Open Accessibility Settings",
                    action: #selector(openAccessibilitySettings),
                    keyEquivalent: ""
                )
                .targeting(self)
            )
        }

        menu.addItem(.separator())

        let shortcutsMenuItem = NSMenuItem(title: "Scanned Shortcuts", action: nil, keyEquivalent: "")
        shortcutsMenuItem.submenu = makeShortcutsMenu()
        menu.addItem(shortcutsMenuItem)

        menu.addItem(.separator())

        menu.addItem(
            NSMenuItem(
                title: "Scan Frontmost App",
                action: #selector(scanFrontmostApp),
                keyEquivalent: "s"
            )
            .targeting(self)
        )

        menu.addItem(
            NSMenuItem(
                title: "Open Shortcut List",
                action: #selector(openShortcutList),
                keyEquivalent: "l"
            )
            .targeting(self)
        )

        menu.addItem(
            NSMenuItem(
                title: "Import Mapping JSON",
                action: #selector(importMappingJSON),
                keyEquivalent: "i"
            )
            .targeting(self)
        )

        menu.addItem(
            NSMenuItem(
                title: "Generate Unused Shortcut",
                action: #selector(generateUnusedShortcut),
                keyEquivalent: "g"
            )
            .targeting(self)
        )

        menu.addItem(
            NSMenuItem(
                title: "Export JSON",
                action: #selector(exportJSON),
                keyEquivalent: "e"
            )
            .targeting(self)
        )

        menu.addItem(.separator())
        menu.addItem(
            NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
                .targeting(NSApp)
        )

        return menu
    }

    private func makeShortcutsMenu() -> NSMenu {
        let menu = NSMenu()
        let summary = NSMenuItem(title: controller.latestAppSummary(), action: nil, keyEquivalent: "")
        summary.isEnabled = false
        menu.addItem(summary)

        let rows = controller.latestShortcutRows()

        if rows.isEmpty {
            let empty = NSMenuItem(title: "Scan the frontmost app to populate this list", action: nil, keyEquivalent: "")
            empty.isEnabled = false
            menu.addItem(empty)
            return menu
        }

        menu.addItem(.separator())

        for row in rows {
            let item = NSMenuItem(title: row.title, action: nil, keyEquivalent: "")
            item.toolTip = row.detail
            item.isEnabled = false
            menu.addItem(item)
        }

        return menu
    }

    @objc private func scanFrontmostApp() {
        guard controller.hasAccessibilityPermission else {
            updateStatus(controller.accessibilityPermissionSummary)
            return
        }

        let catalog = controller.scanFrontmostApplication()
        updateStatus("Scanned \(catalog.shortcuts.count) shortcuts")
        shortcutListWindowController?.refresh()
    }

    @objc private func generateUnusedShortcut() {
        updateStatus(controller.generatedShortcutSummary())
        shortcutListWindowController?.refresh()
    }

    @objc private func exportJSON() {
        do {
            let url = try controller.exportLatestCatalog()
            updateStatus("Exported \(url.lastPathComponent) to Downloads")
        } catch {
            updateStatus("Export failed: \(error.localizedDescription)")
        }
    }

    @objc private func openShortcutList() {
        if shortcutListWindowController == nil {
            shortcutListWindowController = ShortcutListWindowController(controller: controller)
        }

        shortcutListWindowController?.refresh()
        shortcutListWindowController?.showWindow(nil)
        shortcutListWindowController?.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func importMappingJSON() {
        let panel = NSOpenPanel()
        panel.title = "Import Mapping JSON"
        panel.allowedContentTypes = [.json]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        let response = panel.runModal()

        guard response == .OK, let url = panel.url else {
            return
        }

        do {
            let importedCount = try controller.importShortcutMappings(from: url)
            updateStatus("Imported \(importedCount) shortcuts")
            shortcutListWindowController?.refresh()
        } catch {
            updateStatus("Import failed: \(error.localizedDescription)")
        }
    }

    @objc private func openAccessibilitySettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") else {
            updateStatus("Could not open Accessibility settings")
            return
        }

        NSWorkspace.shared.open(url)
        updateStatus("Enable KeyScout in Accessibility settings")
    }

    private func updateStatus(_ status: String) {
        statusText = status
        statusItem?.menu = makeMenu(status: status)
    }
}

private extension NSMenuItem {
    func targeting(_ target: AnyObject) -> NSMenuItem {
        self.target = target
        return self
    }
}
