import AppKit
import ServiceManagement

/// Launch-at-login via SMAppService — bundle-only (the bare executable
/// has no main-app service identity to register).
///
/// BurnBar does not auto-update. Releases are GitHub tags you install yourself.
@MainActor
enum AutostartService {
    static var isAvailable: Bool { Bundle.main.bundleURL.pathExtension == "app" }

    nonisolated static func readEnabled() async -> Bool {
        await Task.detached(priority: .utility) {
            SMAppService.mainApp.status == .enabled
        }.value
    }

    @discardableResult
    static func setEnabled(_ enabled: Bool) -> Bool {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
            return true
        } catch {
            return false
        }
    }
}
