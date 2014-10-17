#import "WDGCTextChannel.h"
#import <Cordova/CDV.h>
#import <GoogleCast/GoogleCast.h>

@interface DataClass : NSObject {
    
    GCKDeviceScanner* deviceScanner;
    GCKDeviceManager* deviceManager;
    GCKMediaInformation* mediaInformation;
    GCKApplicationMetadata *applicationMetadata;
    GCKDevice *selectedDevice;
    NSString *receiverAppId;
    WDGCTextChannel *textChannel;
    NSString *error;
}

@property(nonatomic,retain)GCKDeviceScanner *deviceScanner;
@property(nonatomic,retain)GCKDeviceManager* deviceManager;
@property(nonatomic,retain)GCKMediaInformation* mediaInformation;
@property(nonatomic,retain)GCKApplicationMetadata *applicationMetadata;
@property(nonatomic,retain)GCKDevice *selectedDevice;
@property(nonatomic,retain)NSString *receiverAppId;
@property(nonatomic,retain)WDGCTextChannel *textChannel;
@property(nonatomic,retain)NSString *error;
+(DataClass*)getInstance;
@end