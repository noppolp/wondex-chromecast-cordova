/********* Echo.h Cordova Plugin Header *******/

#import <Cordova/CDV.h>
#import <GoogleCast/GoogleCast.h>

@interface Echo : CDVPlugin<GCKDeviceScannerListener, GCKDeviceManagerDelegate, GCKMediaControlChannelDelegate>

@property(nonatomic, strong) GCKDeviceScanner* deviceScanner;
@property(nonatomic, strong) GCKDeviceManager* deviceManager;
@property(nonatomic, readonly) GCKMediaInformation* mediaInformation;
@property GCKApplicationMetadata *applicationMetadata;
@property GCKDevice *selectedDevice;

- (void)echo:(CDVInvokedUrlCommand*)command;
- (void)initCast:(CDVInvokedUrlCommand*)command;
- (void)getDevices:(CDVInvokedUrlCommand*)command;

@end