/********* Echo.h Cordova Plugin Header *******/

#import "WDGCTextChannel.h"
#import "DataClass.h"
#import <Cordova/CDV.h>
#import <GoogleCast/GoogleCast.h>

@interface Echo : CDVPlugin<GCKDeviceScannerListener, GCKDeviceManagerDelegate, GCKMediaControlChannelDelegate>

- (void)echo:(CDVInvokedUrlCommand*)command;
- (void)initCast:(CDVInvokedUrlCommand*)command;
- (void)getDevices:(CDVInvokedUrlCommand*)command;
- (void)selectDevice:(CDVInvokedUrlCommand*)command;
- (void)disconnectDevice:(CDVInvokedUrlCommand*)command;
- (void)isDeviceConnected:(CDVInvokedUrlCommand*)command;
- (void)getError:(CDVInvokedUrlCommand*)command;
- (void)sendText:(CDVInvokedUrlCommand*)command;

@end