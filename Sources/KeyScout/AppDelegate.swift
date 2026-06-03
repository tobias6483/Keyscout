import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private let controller = KeyScoutController()
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
        )

        menu.addItem(
            NSMenuItem(
                title: "Generate Unused Shortcut",
                action: #selector(generateUnusedShortcut),
                keyEquivalent: "g"
            )
        )

        menu.addItem(
            NSMenuItem(
                title: "Export JSON",
                action: #selector(exportJSON),
                keyEquivalent: "e"
            )
        )

        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        for item in menu.items where item.action != nil {
            item.target = self
        }

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
        let catalog = controller.scanFrontmostApplication()
        updateStatus("Scanned \(catalog.shortcuts.count) shortcuts")
    }

    @objc private func generateUnusedShortcut() {
        updateStatus(controller.generatedShortcutSummary())
    }

    @objc private func exportJSON() {
        do {
            let url = try controller.exportLatestCatalog()
            updateStatus("Exported \(url.lastPathComponent) to Downloads")
        } catch {
            updateStatus("Export failed: \(error.localizedDescription)")
        }
    }

    private func updateStatus(_ status: String) {
        statusText = status
        statusItem?.menu = makeMenu(status: status)
    }
}
