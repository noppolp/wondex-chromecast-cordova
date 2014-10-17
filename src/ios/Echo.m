/********* Echo.m Cordova Plugin Implementation *******/

#import "Echo.h"
#import "WDGCTextChannel.h"
#import "DataClass.h"
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
    DataClass *data=[DataClass getInstance];
    CDVPluginResult* pluginResult = nil;

    NSString* receiverAppId = [command.arguments objectAtIndex:0];
    
    if (receiverAppId != nil && [receiverAppId length] > 0) {

        data.receiverAppId = receiverAppId;
        
        data.deviceScanner = [[GCKDeviceScanner alloc] init];
        [data.deviceScanner addListener:self];
        [data.deviceScanner startScan];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Empty receiverAppId"];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getDevices:(CDVInvokedUrlCommand*)command{
    DataClass *data=[DataClass getInstance];
    CDVPluginResult* pluginResult = nil;
    @try {
        
        NSMutableDictionary *deviceDict = [NSMutableDictionary
                                           dictionaryWithDictionary:@{}];
        for (GCKDevice *device in data.deviceScanner.devices) {
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

- (void)selectDevice:(CDVInvokedUrlCommand*)command
{
    DataClass *data=[DataClass getInstance];
    CDVPluginResult* pluginResult = nil;
    NSString* deviceId = [command.arguments objectAtIndex:0];
    
    if (deviceId != nil && [deviceId length] > 0) {
        
        GCKDevice* selectedDevice = nil;
        
        for (GCKDevice *device in data.deviceScanner.devices) {
            if ([device.deviceID isEqualToString:deviceId]) {
                selectedDevice = device;
            }
        }
        
        if (selectedDevice != nil) {
            data.selectedDevice = selectedDevice;
            [self connectToDevice];
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:deviceId];
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Device id not found"];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Empty device id"];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)disconnectDevice:(CDVInvokedUrlCommand*)command
{
    DataClass *data=[DataClass getInstance];
    [data.deviceManager leaveApplication];
    [data.deviceManager disconnect];
    [self deviceDisconnected];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)isDeviceConnected:(CDVInvokedUrlCommand*)command{
    DataClass *data=[DataClass getInstance];
    CDVPluginResult* pluginResult = nil;
    if (data.deviceManager != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:data.deviceManager.isConnected];
    }else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:false];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getError:(CDVInvokedUrlCommand*)command{
    DataClass *data=[DataClass getInstance];
    NSString* error = data.error;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:error];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    data.error = @"";
}

- (void)sendText:(CDVInvokedUrlCommand*)command{
    DataClass *data=[DataClass getInstance];
    CDVPluginResult* pluginResult = nil;
    
    if (!data.deviceManager || !data.deviceManager.isConnected) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Device is not connected"];
    }else{
        NSString* msg = [command.arguments objectAtIndex:0];
        [data.textChannel sendTextMessage:msg];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (BOOL)isConnected {
    DataClass *data=[DataClass getInstance];
    return data.deviceManager.isConnected;
}

- (void)connectToDevice {
    DataClass *data=[DataClass getInstance];
    if (data.selectedDevice == nil)
        return;
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    data.deviceManager =
    [[GCKDeviceManager alloc] initWithDevice:data.selectedDevice
                           clientPackageName:[info objectForKey:@"CFBundleIdentifier"]];
    data.deviceManager.delegate = self;
    [data.deviceManager connect];
}

- (void)deviceDisconnected {
    DataClass *data=[DataClass getInstance];
    data.textChannel = nil;
    data.deviceManager = nil;
    data.selectedDevice = nil;
}

#pragma mark - GCKDeviceScannerListener
- (void)deviceDidComeOnline:(GCKDevice *)device {
  
}

- (void)deviceDidGoOffline:(GCKDevice *)device {
  
}


#pragma mark - GCKDeviceManagerDelegate

- (void)deviceManagerDidConnect:(GCKDeviceManager *)deviceManager {
    DataClass *data=[DataClass getInstance];
    //launch application after getting connectted
    [data.deviceManager launchApplication:data.receiverAppId];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didConnectToCastApplication:(GCKApplicationMetadata *)applicationMetadata
            sessionID:(NSString *)sessionID
  launchedApplication:(BOOL)launchedApplication {
    
    DataClass *data=[DataClass getInstance];
    
    data.textChannel =
    [[WDGCTextChannel alloc] initWithNamespace:@"urn:x-cast:toys.wondex.cast"];
    [data.deviceManager addChannel:data.textChannel];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didFailToConnectToApplicationWithError:(NSError *)error {
    
    DataClass *data=[DataClass getInstance];
    
    [self showError:error];
    
    [self deviceDisconnected];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didFailToConnectWithError:(GCKError *)error {
    
    DataClass *data=[DataClass getInstance];
    
    [self showError:error];
    
    [self deviceDisconnected];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didDisconnectWithError:(GCKError *)error {
    
    DataClass *data=[DataClass getInstance];
    
    if (error != nil) {
        [self showError:error];
    }
    [self deviceDisconnected];
    
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didReceiveStatusForApplication:(GCKApplicationMetadata *)applicationMetadata {
    
    DataClass *data=[DataClass getInstance];
    
    data.applicationMetadata = applicationMetadata;
}

#pragma mark - misc
- (void)showError:(NSError *)error {
    
    DataClass *data=[DataClass getInstance];
    
    data.error = error.description;
}

@end