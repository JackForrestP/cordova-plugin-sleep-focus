import Foundation
import DeviceActivity

@objc(SleepFocusPlugin)
public class SleepFocusPlugin: CDVPlugin {
    @objc public func checkSleepFocus(_ command: CDVInvokedUrlCommand) {
        if #available(iOS 15.0, *) {
            let authorizationStatus = FocusStatusCenter.shared.authorizationStatus
            if authorizationStatus == .authorized {
                let sleepFocusActive = FocusStatusCenter.shared.focusStatuses.contains { $0.isFocused(for: .sleep) }
                let result: [String: Any] = ["status": sleepFocusActive ? "active" : "inactive"]
                self.commandDelegate.send(CDVPluginResult(status: .ok, messageAs: result), callbackId: command.callbackId)
            } else {
                self.commandDelegate.send(CDVPluginResult(status: .error, messageAs: "Authorization not granted"), callbackId: command.callbackId)
            }
        } else {
            self.commandDelegate.send(CDVPluginResult(status: .error, messageAs: "iOS version too low"), callbackId: command.callbackId)
        }
    }
}
