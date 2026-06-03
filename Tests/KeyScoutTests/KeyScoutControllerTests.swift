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
}
