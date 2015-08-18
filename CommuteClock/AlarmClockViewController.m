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
    self.clockLabel.text = [NSString stringWithFormat:@"Current Time: %@", message];
}

- (void)updateAlarmLabel {
    
    if (self.myAlarmClock.alarm) {
        NSString *alarmTime = [self.myDateFormatter stringFromDate:self.myAlarmClock.alarm];
        NSString *commuteAdjustment = [self getCommuteTime];
        self.alarmLabel.text = [NSString stringWithFormat:@"Alarm set for %@, less %@ minutes", alarmTime, commuteAdjustment];
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

- (NSString *)getCommuteTime {
    
    ViewController *mapViewController = (ViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
    return mapViewController.commuteTime;
}
        
- (BOOL)firstDate:(NSDate *)firstDate isEqualToWithinOneSecond:(NSDate *)secondDate {
    
    if (([firstDate timeIntervalSinceDate:secondDate] > 0 ) &&
        ([firstDate timeIntervalSinceDate:secondDate] <= 1 ))
        return YES;
    else
        return NO;
}

#pragma mark - UISwitch delegate methods

- (IBAction)alarmSwitchValueChanged:(id)sender {
    
    if (self.alarmSwitch.isOn) {
        NSDate *myAlarm = self.timePicker.date;
        self.myAlarmClock.alarm = myAlarm;
    } else {
        self.myAlarmClock.alarm = nil;
    }
    
    [self updateAlarmLabel];

}

@end
