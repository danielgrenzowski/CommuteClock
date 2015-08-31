#import "AlarmClock.h"


@implementation AlarmClock


- (id)initWithTimer:(NSTimer *)timer_ andAlarm:(NSDate *)alarm_
{    
    self = [super init];
    if (self) {
        self.timer = timer_;
        self.alarm = alarm_;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soundAlarm:) name:@"SoundAlarmClockNotification" object:nil];
    
    return self;
}

- (void)activateClock {
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)soundAlarm:(NSNotification*)notification {
  
    NSLog(@"Alarm sounded!");

}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
