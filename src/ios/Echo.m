/********* Echo.m Cordova Plugin Implementation *******/

#import "Echo.h"
#import <Cordova/CDV.h>

@implementation Echo

- (void)echo:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)initCast:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    self.deviceScanner = [[GCKDeviceScanner alloc] init];
    [self.deviceScanner addListener:self];
    [self.deviceScanner startScan];

    NSString* result = @"1";
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getDevices:(CDVInvokedUrlCommand*)command{
    NSArray *devices = self.deviceScanner.devices;
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:devices];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - GCKDeviceScannerListener
- (void)deviceDidComeOnline:(GCKDevice *)device {
  
}

- (void)deviceDidGoOffline:(GCKDevice *)device {
  
}

@end