#import "GameLayer.h"

@interface GameLayer ()
@end

@implementation GameLayer

- (void)onEnter
{
    [super onEnter];
}

- (id)init
{
    if(self = [super initWithColor:ccc4(255, 255, 255, 255)])
    {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

@end