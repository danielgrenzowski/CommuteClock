#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface Destination : NSObject


@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) CLLocation *location;

@property NSTimeInterval commuteTimeWithTraffic;
@property NSTimeInterval commuteTimeWithoutTraffic;

- (id)initWithLocation:(CLLocation *)location_ andAddress:(NSString *)address_;


@end
