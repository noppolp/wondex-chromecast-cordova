/********* Echo.m Cordova Plugin Implementation *******/

#import "Echo.h"
#import "WDGCTextChannel.h"
#import <Cordova/CDV.h>

@implementation Echo

    GCKApplicationMetadata *applicationMetadata;
    GCKDevice *selectedDevice;
    NSString *receiverAppId;
    WDGCTextChannel *textChannel;

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

    NSString* receiverAppId = [command.arguments objectAtIndex:0];
    
    if (receiverAppId != nil && [receiverAppId length] > 0) {

        self.receiverAppId = receiverAppId;
        
        self.deviceScanner = [[GCKDeviceScanner alloc] init];
        [self.deviceScanner addListener:self];
        [self.deviceScanner startScan];
        
        NSString* result = @"1";
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Empty receiverAppId"];
    }
    
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

- (void)selectDevice:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* deviceId = [command.arguments objectAtIndex:0];
    
    if (deviceId != nil && [echo length] > 0) {
        
        GCKDevice* selectedDevice = nil;
        
        for (GCKDevice *device in self.deviceScanner.devices) {
            if (device.deviceID == deviceId) {
                selectedDevice = device;
            }
        }
        
        if (selectedDevice != nil) {
            if (!isConnected) {
                //Connect
                self.selectedDevice = selectedDevice;
                [self connectToDevice];
            }else{
                //Disconnect then connect
                [self.deviceManager leaveApplication];
                [self.deviceManager disconnect];
                [self deviceDisconnected];
                
                [self connectToDevice];
            }
        }else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Device id not found"];
        }
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:deviceId];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Empty device id"];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



- (BOOL)isConnected {
    return self.deviceManager.isConnected;
}

- (void)connectToDevice {
    if (self.selectedDevice == nil)
        return;
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    self.deviceManager =
    [[GCKDeviceManager alloc] initWithDevice:self.selectedDevice
                           clientPackageName:[info objectForKey:@"CFBundleIdentifier"]];
    self.deviceManager.delegate = self;
    [self.deviceManager connect];
}

- (void)deviceDisconnected {
    self.textChannel = nil;
    self.deviceManager = nil;
    self.selectedDevice = nil;
}

#pragma mark - GCKDeviceScannerListener
- (void)deviceDidComeOnline:(GCKDevice *)device {
  
}

- (void)deviceDidGoOffline:(GCKDevice *)device {
  
}


#pragma mark - GCKDeviceManagerDelegate

- (void)deviceManagerDidConnect:(GCKDeviceManager *)deviceManager {
    
    //launch application after getting connectted
    [self.deviceManager launchApplication:self.receiverAppId];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didConnectToCastApplication:(GCKApplicationMetadata *)applicationMetadata
            sessionID:(NSString *)sessionID
  launchedApplication:(BOOL)launchedApplication {
    
    self.textChannel =
    [[WDGCTextChannel alloc] initWithNamespace:@"urn:x-cast:toys.wondex.cast"];
    [self.deviceManager addChannel:self.textChannel];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didFailToConnectToApplicationWithError:(NSError *)error {
    [self showError:error];
    
    [self deviceDisconnected];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didFailToConnectWithError:(GCKError *)error {
    [self showError:error];
    
    [self deviceDisconnected];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didDisconnectWithError:(GCKError *)error {
    
    [self deviceDisconnected];
    
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didReceiveStatusForApplication:(GCKApplicationMetadata *)applicationMetadata {
    self.applicationMetadata = applicationMetadata;
}

@end