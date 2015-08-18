#import <Foundation/Foundation.h>


@interface AlarmClock : NSObject

@property (strong, nonatomic) NSDate *alarm;
@property (strong, nonatomic) NSTimer *timer;

- (id)initWithTimer:(NSTimer *)timer_ andAlarm:(NSDate *)alarm_;
- (void)activateClock;

@end
