#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>


@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;

- (id)initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)location;
- (MKAnnotationView *)annotationView;

@end
