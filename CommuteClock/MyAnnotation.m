#import "MyAnnotation.h"


@interface MyAnnotation ()

@end

@implementation MyAnnotation

- (id)initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)location {
    self = [super init];
    
    if (self)
    {
        _title = newTitle;
        _coordinate = location;
    }
    
    return self;
}

- (MKAnnotationView *)annotationView {
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"redpin.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
    
}
    

@end
