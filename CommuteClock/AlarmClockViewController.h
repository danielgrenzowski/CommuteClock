#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AlarmClockViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *clockLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmLabel;

@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UISwitch *alarmSwitch;

@property (strong, nonatomic) NSDate *alarm;

@property (strong, nonatomic) NSDateFormatter *myDateFormatter;


- (void)updateClockLabel;
- (void)updateAlarmLabel;

- (IBAction)timePickerValueChanged:(id)sender;
- (IBAction)alarmSwitchValueChanged:(id)sender;

@end
