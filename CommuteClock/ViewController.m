#import "ViewController.h"

// 1 Duncan Mill Road, Toronto, ON M3B 1Z2
// 4077 Hamilton Road, Ottawa, ON K0A 1A0

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View lifecycle methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createLocationManager];
    [self initializeCommuteMapView];
    
    [self initializeGestureRecognizer];
    [self configureTimeLabel];
    
}

#pragma mark - UI setup

- (void)initializeCommuteMapView {
    
    self.commuteMapView.delegate = self;
    [self.commuteMapView setMapType:MKMapTypeStandard];
    [self.commuteMapView setZoomEnabled:YES];
    [self.commuteMapView setScrollEnabled:YES];
    self.commuteMapView.showsUserLocation = YES;
    self.commuteMapView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.commuteMapView.layer.borderWidth = 2.0;
}

- (void)initializeGestureRecognizer {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    
    [self.destinationTextField resignFirstResponder];
}

#pragma mark - timeLabel methods

- (void)configureTimeLabel {
    
    self.timeLabel.textColor = [UIColor blackColor];
    [self.timeLabel setAdjustsFontSizeToFitWidth:YES];
}

#pragma mark - LocationAPI calls

- (void)initializeDestinationFromAddressString:(NSString *)address {
    

}

#pragma mark - UI methods

- (void)displayDestinationOnMap
{
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
//    point.canShowCallout = YES;
//    pointimage = [UIImage imageNamed:@"redpin.png"];
//    point.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    
    point.coordinate = self.destination.location.coordinate;
    [self.commuteMapView addAnnotation:point];
}

- (void)drawRouteOnMap
{
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.destination.location.coordinate addressDictionary:nil];
    
    MKMapItem *destinationMapItem = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    MKMapItem *currentUserLocationMapItem = [MKMapItem mapItemForCurrentLocation];

    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:currentUserLocationMapItem];
    [request setDestination:destinationMapItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    [request setRequestsAlternateRoutes:NO];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            MKRoute *newRoute = response.routes.lastObject;
            self.destination.commuteTimeWithTraffic = newRoute.expectedTravelTime;
            
            float min = floor(newRoute.expectedTravelTime/60);
            float sec = round(newRoute.expectedTravelTime - min * 60);
            NSString *strCommuteTime = [NSString stringWithFormat:@"%02d:%02d", (int)min, (int)sec];
            
            NSString *myDestination = response.destination.name;
            
            self.timeLabel.text = [NSString stringWithFormat:@"Commute time to %@ is %@", myDestination, strCommuteTime];
            [self.commuteMapView addOverlay:newRoute.polyline];
        }
        
    }];
}

- (void)calculateCommuteTimeWithNoTraffic {
    
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.destination.location.coordinate addressDictionary:nil];
    
    MKMapItem *destinationMapItem = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    MKMapItem *currentUserLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    
    NSDate *startOfToday = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:currentUserLocationMapItem];
    [request setDestination:destinationMapItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    [request setRequestsAlternateRoutes:NO];
    [request setDepartureDate:startOfToday];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            MKRoute *newRoute = response.routes.lastObject;
            
            self.destination.commuteTimeWithoutTraffic = newRoute.expectedTravelTime;
        }
        
    }];
}

#pragma mark - MyLocationManager methods

- (void) createLocationManager {
    
    self.myLocationManager = [MyLocationManager sharedInstance];
    
}

#pragma mark - MapView delegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.commuteMapView setRegion:[self.commuteMapView regionThatFits:region] animated:YES];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return renderer;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>) annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"mapPin"];
    if(aView){
        aView.annotation = annotation;
    } else {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapPin"];
    }
    
    aView.canShowCallout = NO;
    
    return aView;

}

#pragma mark - UIButton methods

- (IBAction)zoomInOnUsersLocation:(id)sender {
    
    [self zoomIn:self.commuteMapView.userLocation.location];
}

- (IBAction)zoomInOnDestination:(id)sender {
    
    [self zoomIn:self.destination.location];
}

- (void) zoomIn:(CLLocation *)location {
    
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (location.coordinate, 1000, 1000);
    [self.commuteMapView setRegion:region animated:NO];
    
}

#pragma mark - TextField delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.destinationTextField.backgroundColor = [UIColor whiteColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([textField.text length] != 0) {
        
        NSString *destinationString = self.destinationTextField.text;
        
        CLLocationCoordinate2D destinationCoordinate = [LocationAPI getLocationCoordinateFromAddressString:destinationString];
        
        CLLocation *destinationCLLocation =
        [[CLLocation alloc] initWithCoordinate:destinationCoordinate
                                      altitude:1
                            horizontalAccuracy:1
                              verticalAccuracy:-2
                                     timestamp:nil];
        
        self.destination = [[Destination alloc] initWithLocation:destinationCLLocation andAddress:destinationString];
        
        [self displayDestinationOnMap];
        [self drawRouteOnMap];
        [self calculateCommuteTimeWithNoTraffic];
        
    } else {
        self.destinationTextField.backgroundColor = [UIColor redColor];
        self.destinationTextField.placeholder = @"Please enter a non-blank address";
    }
    
    [self.destinationTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


@end
