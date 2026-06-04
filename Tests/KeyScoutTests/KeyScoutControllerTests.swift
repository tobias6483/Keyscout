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
        #expect(controller.accessibilityPermissionSummary == "Enable Accessibility for the exact KeyScout.app you are running")
        #expect(controller.accessibilityPermissionDetail == "`swift run` uses a different app identity and does not share Accessibility permission with KeyScout.app")
        #expect(controller.generatedShortcutSummary() == "Enable Accessibility for the exact KeyScout.app you are running")
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
        #expect(controller.accessibilityPermissionDetail == "KeyScout can scan app menus")
    }

    @Test("imports mapping JSON")
    func importsMappingJSON() throws {
        let storeURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
            .appendingPathComponent("imported-mappings.json")
        let store = ShortcutMappingStore(fileURL: storeURL)
        let controller = KeyScoutController(
            mappingLibrary: ShortcutMappingLibrary(),
            importedMappingStore: store,
            isAccessibilityTrusted: { true }
        )
        let shortcut = AppShortcut(
            appName: "Example",
            bundleIdentifier: "com.example.app",
            menuPath: ["File", "Open"],
            shortcut: KeyboardShortcut(modifiers: [.command], key: "O"),
            source: .manual
        )
        let catalog = ShortcutCatalog(shortcuts: [
            shortcut
        ])
        let data = try ShortcutJSONStore.encode(catalog)
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")
        try data.write(to: url)
        defer {
            try? FileManager.default.removeItem(at: url)
            try? FileManager.default.removeItem(at: storeURL.deletingLastPathComponent())
        }

        #expect(try controller.importShortcutMappings(from: url) == 1)
        #expect(try store.load().shortcuts == [shortcut])
    }
}
