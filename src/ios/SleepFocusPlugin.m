#import "SleepFocusPlugin.h"
#import <DeviceActivity/DeviceActivity.h>

@implementation SleepFocusPlugin

- (void)checkSleepFocus:(CDVInvokedUrlCommand*)command {
    if (@available(iOS 15.0, *)) {
        if ([FocusStatusCenter.shared.authorizationStatus isEqualToNumber:@(FocusAuthorizationStatusAuthorized)]) {
            BOOL sleepFocusActive = [[FocusStatusCenter.shared.focusStatuses filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bindings) {
                return [obj isFocusedForActivity:FocusActivitySleep];
            }]] count] > 0;

            NSDictionary* result = @{@"status": sleepFocusActive ? @"active" : @"inactive"};
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } else {
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Authorization not granted"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"iOS version too low"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

@end
