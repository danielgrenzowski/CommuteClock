#import "Destination.h"


@implementation Destination

- (id)initWithLocation:(CLLocation *)location_ andAddress:(NSString *)address_ {
    self = [super init];
    if (self) {
        _location = location_;
        _address = address_;
    }
    
    return self;
}

@end
