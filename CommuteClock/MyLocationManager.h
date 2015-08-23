#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface MyLocationManager : NSObject <CLLocationManagerDelegate>

+ (MyLocationManager *)sharedInstance;
@property (readonly) CLLocationManager *locationManager;

@end

