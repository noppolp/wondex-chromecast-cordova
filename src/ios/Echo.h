/********* Echo.h Cordova Plugin Header *******/

#import "WDGCTextChannel.h"
#import <Cordova/CDV.h>
#import <GoogleCast/GoogleCast.h>

@interface Echo : CDVPlugin<GCKDeviceScannerListener, GCKDeviceManagerDelegate, GCKMediaControlChannelDelegate>

@property(nonatomic, strong) GCKDeviceScanner* deviceScanner;
@property(nonatomic, strong) GCKDeviceManager* deviceManager;
@property(nonatomic, readonly) GCKMediaInformation* mediaInformation;


- (void)echo:(CDVInvokedUrlCommand*)command;
- (void)initCast:(CDVInvokedUrlCommand*)command;
- (void)getDevices:(CDVInvokedUrlCommand*)command;
- (void)selectDevice:(CDVInvokedUrlCommand*)command;

@end