/********* Echo.m Cordova Plugin Implementation *******/

#import "Echo.h"
#import <Cordova/CDV.h>

@implementation Echo

    GCKApplicationMetadata *applicationMetadata;
    GCKDevice *selectedDevice;

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
    CDVPluginResult* pluginResult = nil;
    @try {
        
        NSMutableDictionary *deviceDict = [NSMutableDictionary
                                           dictionaryWithDictionary:@{}];
        for (GCKDevice *device in self.deviceScanner.devices) {
            deviceDict[device.deviceID] = device.friendlyName;
        }
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:deviceDict];
    }
    @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.reason];
    }
    @finally {}
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - GCKDeviceScannerListener
- (void)deviceDidComeOnline:(GCKDevice *)device {
  
}

- (void)deviceDidGoOffline:(GCKDevice *)device {
  
}

@end