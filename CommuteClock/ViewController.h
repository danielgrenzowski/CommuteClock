#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationAPI.h"
#import "MyLocationManager.h"
#import "Destination.h"

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet MKMapView *commuteMapView;
@property (strong, nonatomic) IBOutlet UITextField *destinationTextField;

@property (strong, nonatomic) LocationAPI *locationAPI;
@property (strong, nonatomic) MyLocationManager *myLocationManager;
@property (strong, nonatomic) Destination *destination;


- (IBAction)zoomInOnUsersLocation:(id)sender;
- (IBAction)zoomInOnDestination:(id)sender;


@end

