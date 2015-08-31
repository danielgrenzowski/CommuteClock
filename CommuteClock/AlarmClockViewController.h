#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AlarmClock.h"


@interface AlarmClockViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *alarmAdjustmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *clockLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UISwitch *alarmSwitch;

@property (strong, nonatomic) AlarmClock *myAlarmClock;

- (void)updateClockLabel;
- (void)updateAlarmLabel;

- (IBAction)alarmSwitchValueChanged:(id)sender;

@end
