#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface LocationAPI : NSObject

+ (CLLocationCoordinate2D) getLocationCoordinateFromAddressString:(NSString *)address;

@end
