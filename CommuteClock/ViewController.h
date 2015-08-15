#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "LocationAPI.h"
#import "MyAnnotation.h"


@interface ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet MKMapView *commuteMapView;

@property (strong, nonatomic) LocationAPI *locationAPI;

@property (strong, nonatomic) NSString *destinationString;
@property (strong, nonatomic) CLLocation *destination;
@property (weak, nonatomic) NSString *commuteTime;

- (IBAction)zoomInOnUsersLocation:(id)sender;
- (IBAction)zoomInOnDestination:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;

@end

