#import "AlarmClockViewController.h"


@interface AlarmClockViewController ()

@property (strong, nonatomic) AlarmClock *myAlarmClock;

@end


@implementation AlarmClockViewController

#pragma mark - View lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self createAlarmClock];

    [self configureLabel:self.clockLabel];
    [self configureLabel:self.alarmLabel];
    [self configureLabel:self.alarmAdjustmentLabel];
    
    [self.myAlarmClock activateClock];
    [self updateAlarmLabel];

}

#pragma mark - Configure UI

- (void)configureLabel:(UILabel *)myLabel {
    
    myLabel.textColor = [UIColor blackColor];
    myLabel.textAlignment = NSTextAlignmentCenter;
    [myLabel setAdjustsFontSizeToFitWidth:YES];
}

#pragma mark - Update UI

- (void)updateClockLabel {
    
    NSDate *currentTime = [NSDate date];
    if ([self firstDate:currentTime isEqualToWithinOneSecond:self.myAlarmClock.alarm]){
        [self soundAlarm];
    }
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"HH:mm:ss"];
    
    NSString *message = [myDateFormatter stringFromDate:currentTime];
    self.clockLabel.text = [NSString stringWithFormat:@"%@", message];
}

- (void)updateAlarmLabel {
    
    if (self.myAlarmClock.alarm) {

        NSDate *alarmTimeAdjusted = [self calculateCommuteTimeAdjustdedFromTime:self.myAlarmClock.alarm];
        
        NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:@"HH:mm:ss"];
        
        NSString *strAlarmTime = [myDateFormatter stringFromDate:alarmTimeAdjusted];
        self.alarmLabel.text = [NSString stringWithFormat:@"Alarm set for %@", strAlarmTime];
        
    } else {
        self.alarmLabel.text = @"No alarm set";
    }
}

#pragma AlarmClock methods

- (void)createAlarmClock {
    
    NSTimer *timerToUpdateClockLabelEverySecond = [NSTimer timerWithTimeInterval:1.0f
                                                                          target:self
                                                                        selector:@selector(updateClockLabel)
                                                                        userInfo:nil
                                                                         repeats:YES];
    
    self.myAlarmClock = [[AlarmClock alloc] initWithTimer:timerToUpdateClockLabelEverySecond andAlarm:nil];
    
}

- (void)soundAlarm {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SoundAlarmClockNotification"
                                                        object:self
                                                      userInfo:nil];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alarm On!"
                                                        message:nil delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Snooze",@"Ok",nil];
    [alertView show];
}

#pragma mark - ViewController logic

- (NSDate *)calculateCommuteTimeAdjustdedFromTime:(NSDate *)alarmTime {
    
    ViewController *mapViewController = (ViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
    
    NSTimeInterval commuteTimeInclTraffic = mapViewController.commuteTimeWithTraffic;
    NSLog(@"Commute time with traffic is %@", [self timeInHoursAndSeconds:commuteTimeInclTraffic]);
    
    NSTimeInterval commuteTimeNoTraffic = mapViewController.commuteTimeWithoutTraffic;
    NSLog(@"Commute time without traffic is %@", [self timeInHoursAndSeconds:commuteTimeNoTraffic]);
    
    NSTimeInterval difference = commuteTimeInclTraffic - commuteTimeNoTraffic;
    NSString *strTrafficAdjustment = [self timeInHoursAndSeconds:difference];
    self.alarmAdjustmentLabel.text = [NSString stringWithFormat:@"Traffic adjustment is %@",strTrafficAdjustment];
    
    return [NSDate dateWithTimeInterval:-difference sinceDate:alarmTime];
    
}

- (NSString *)timeInHoursAndSeconds:(NSTimeInterval)myInterval {
    
    float min = floor(myInterval/60);
    float sec = round(myInterval - min * 60);
    return [NSString stringWithFormat:@"%02d:%02d", (int)min, (int)sec];
}

- (BOOL)firstDate:(NSDate *)firstDate isEqualToWithinOneSecond:(NSDate *)secondDate {
    
    if (([firstDate timeIntervalSinceDate:secondDate] > 0 ) &&
        ([firstDate timeIntervalSinceDate:secondDate] <= 1 ))
        return YES;
    else
        return NO;
}

- (NSDate *)dateWithZeroSeconds:(NSDate *)date
{
    NSTimeInterval time = floor([date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    return  [NSDate dateWithTimeIntervalSinceReferenceDate:time];
}

#pragma mark - UISwitch delegate methods

- (IBAction)alarmSwitchValueChanged:(id)sender {
    
    if (self.alarmSwitch.isOn) {
        NSDate *myAlarm = self.timePicker.date;
        self.myAlarmClock.alarm = [self dateWithZeroSeconds:myAlarm];
        NSLog(@"Original alarm time set to: %@", self.myAlarmClock.alarm);
    } else {
        self.myAlarmClock.alarm = nil;
    }
    
    [self updateAlarmLabel];

}

@end
