/********* Echo.h Cordova Plugin Header *******/

#import "WDGCTextChannel.h"
#import <Cordova/CDV.h>
#import <GoogleCast/GoogleCast.h>

@interface Echo : CDVPlugin<GCKDeviceScannerListener, GCKDeviceManagerDelegate, GCKMediaControlChannelDelegate>

@property(nonatomic, strong) GCKDeviceScanner* deviceScanner;
@property(nonatomic, strong) GCKDeviceManager* deviceManager;
@property(nonatomic, readonly) GCKMediaInformation* mediaInformation;
@property GCKApplicationMetadata *applicationMetadata;
@property GCKDevice *selectedDevice;
@property NSString *receiverAppId;
@property WDGCTextChannel *textChannel;
@property NSString *error;


- (void)echo:(CDVInvokedUrlCommand*)command;
- (void)initCast:(CDVInvokedUrlCommand*)command;
- (void)getDevices:(CDVInvokedUrlCommand*)command;
- (void)selectDevice:(CDVInvokedUrlCommand*)command;
- (void)disconnectDevice(CDVInvokedUrlCommand*)command
- (void)isDeviceConnected:(CDVInvokedUrlCommand*)command;
- (void)getError:(CDVInvokedUrlCommand*)command;
- (void)sendText:(CDVInvokedUrlCommand*)command;

@end