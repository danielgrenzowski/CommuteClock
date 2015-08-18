#import "AlarmClock.h"


@implementation AlarmClock


- (id)initWithTimer:(NSTimer *)timer_ andAlarm:(NSDate *)alarm_
{    
    self = [super init];
    if (self) {
        self.timer = timer_;
        self.alarm = alarm_;
    }
    return self;
}

- (void) activateClock {
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}



@end
