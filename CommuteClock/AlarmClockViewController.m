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
    [self configureDateFormatter];
    
    [self.myAlarmClock activateClock];
    [self updateAlarmLabel];

}

#pragma mark - Configure UI

- (void)configureLabel:(UILabel *)myLabel {
    
    myLabel.textColor = [UIColor blackColor];
    myLabel.textAlignment = NSTextAlignmentCenter;
    [myLabel setAdjustsFontSizeToFitWidth:YES];
}

- (void)configureDateFormatter {
    
    self.myDateFormatter = [[NSDateFormatter alloc] init];
    [self.myDateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
}


#pragma mark - Update UI

- (void)updateClockLabel {
    
    NSDate *currentTime = [NSDate date];
    if ([self firstDate:currentTime isEqualToWithinOneSecond:self.myAlarmClock.alarm]){
        [self soundAlarm];
    }
    
    
    NSString *message = [self.myDateFormatter stringFromDate:currentTime];
    self.clockLabel.text = [NSString stringWithFormat:@"%@", message];
}

- (void)updateAlarmLabel {
    
    if (self.myAlarmClock.alarm) {

        NSDate *alarmTimeAdjusted = [self calculateCommuteTimeAdjustdedFromTime:self.myAlarmClock.alarm];
        NSString *strAlarmTime = [self.myDateFormatter stringFromDate:alarmTimeAdjusted];
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
    NSTimeInterval commuteTimeNoTraffic = mapViewController.commuteTimeWithoutTraffic;
    NSTimeInterval difference = commuteTimeInclTraffic - commuteTimeNoTraffic;
    NSLog(@"Difference between times is %f", difference);
    
    return [alarmTime dateByAddingTimeInterval:-difference];;
    
}
        
- (BOOL)firstDate:(NSDate *)firstDate isEqualToWithinOneSecond:(NSDate *)secondDate {
    
    if (([firstDate timeIntervalSinceDate:secondDate] > 0 ) &&
        ([firstDate timeIntervalSinceDate:secondDate] <= 1 ))
        return YES;
    else
        return NO;
}

- (NSDate *)roundDownToNearestMinute:(NSDate *)myDate {
    
    NSTimeInterval timeSince1970 = [[NSDate date] timeIntervalSince1970];
    
    timeSince1970 -= fmod(timeSince1970, 60); // subtract away any extra seconds
    
    return [NSDate dateWithTimeIntervalSince1970:timeSince1970];
}

#pragma mark - UISwitch delegate methods

- (IBAction)alarmSwitchValueChanged:(id)sender {
    
    if (self.alarmSwitch.isOn) {
        NSDate *myAlarm = self.timePicker.date;
        self.myAlarmClock.alarm = [self roundDownToNearestMinute:myAlarm];
    } else {
        self.myAlarmClock.alarm = nil;
    }
    
    [self updateAlarmLabel];

}

@end
