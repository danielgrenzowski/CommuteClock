#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface LocationAPI : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

- (CLLocationCoordinate2D) getLocationCoordinateFromAddressString:(NSString *)address;

@end
