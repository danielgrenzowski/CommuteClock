#import "AlarmClockViewController.h"


@interface AlarmClockViewController ()


@end

@implementation AlarmClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureLabel:self.clockLabel];
    [self configureLabel:self.alarmLabel];
    [self configureDateFormatter];
    [self updateClockLabel];
    [self updateAlarmLabel];
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateClockLabel) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ClockLabel methods

- (void)configureLabel:(UILabel *)myLabel {
    
    myLabel.textColor = [UIColor blackColor];
    myLabel.textAlignment = NSTextAlignmentCenter;
    [myLabel setAdjustsFontSizeToFitWidth:YES];
}

- (void)configureDateFormatter {
    
    self.myDateFormatter = [[NSDateFormatter alloc] init];
    [self.myDateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
}


- (void)updateClockLabel {
    
    NSDate *currentTime = [NSDate date];
    if ([self firstDate:currentTime isEqualToWithinOneSecond:self.alarm]){
        [self soundAlarm];
    }
    NSString *message = [self.myDateFormatter stringFromDate:currentTime];
    self.clockLabel.text = [NSString stringWithFormat:@"Current Time: %@", message];

}

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

- (void)updateAlarmLabel {
    
    if (self.alarm) {
        NSString *alarmTime = [self.myDateFormatter stringFromDate:self.alarm];
        NSString *commuteAdjustment = [self getCommuteTime];
        self.alarmLabel.text = [NSString stringWithFormat:@"Alarm set for %@, less %@", alarmTime, commuteAdjustment];
        
    } else {
        self.alarmLabel.text = @"No alarm set";
    }
    

}

- (void)soundAlarm {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alarm On!"
                                                        message:nil delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Snooze",@"Ok",nil];
    [alertView show];
}


- (IBAction)timePickerValueChanged:(id)sender {
    
    
}

- (void) setUpAlarm:(NSDate *)alarmDate {
    
    self.alarm = alarmDate;
}

- (IBAction)alarmSwitchValueChanged:(id)sender {
    
    if (self.alarmSwitch.isOn) {
        [self setUpAlarm:self.timePicker.date];
    } else {
        [self setUpAlarm:nil];
    }
    
    [self updateAlarmLabel];

}

@end
