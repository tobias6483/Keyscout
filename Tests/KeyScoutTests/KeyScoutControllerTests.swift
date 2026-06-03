import Foundation
import Testing
@testable import KeyScout

@MainActor
@Suite("KeyScout controller")
struct KeyScoutControllerTests {
    @Test("reports missing Accessibility permission")
    func reportsMissingAccessibilityPermission() {
        let controller = KeyScoutController(isAccessibilityTrusted: { false })

        #expect(controller.hasAccessibilityPermission == false)
        #expect(controller.accessibilityPermissionSummary == "Accessibility permission needed to scan app menus")
        #expect(controller.generatedShortcutSummary() == "Accessibility permission needed to scan app menus")
        #expect(controller.scanFrontmostApplication().shortcuts.isEmpty)
    }

    @Test("reports ready Accessibility permission")
    func reportsReadyAccessibilityPermission() {
        let controller = KeyScoutController(
            mappingLibrary: ShortcutMappingLibrary(),
            isAccessibilityTrusted: { true }
        )

        #expect(controller.hasAccessibilityPermission == true)
        #expect(controller.accessibilityPermissionSummary == "Accessibility permission ready")
    }

    @Test("imports mapping JSON")
    func importsMappingJSON() throws {
        let controller = KeyScoutController(
            mappingLibrary: ShortcutMappingLibrary(),
            isAccessibilityTrusted: { true }
        )
        let catalog = ShortcutCatalog(shortcuts: [
            AppShortcut(
                appName: "Example",
                bundleIdentifier: "com.example.app",
                menuPath: ["File", "Open"],
                shortcut: KeyboardShortcut(modifiers: [.command], key: "O"),
                source: .manual
            )
        ])
        let data = try ShortcutJSONStore.encode(catalog)
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")
        try data.write(to: url)
        defer {
            try? FileManager.default.removeItem(at: url)
        }

        #expect(try controller.importShortcutMappings(from: url) == 1)
    }
}
