#import "Echo.h"
#import "WDGCTextChannel.h"
#import <Cordova/CDV.h>

@implementation DataClass
@synthesize deviceScanner;
@synthesize deviceManager;
@synthesize mediaInformation;
@synthesize applicationMetadata;
@synthesize selectedDevice;
@synthesize receiverAppId;
@synthesize textChannel;
@synthesize error;

static DataClass *instance = nil;

+(DataClass *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [DataClass new];
        }
    }
    return instance;
}

@end