#import "Unit.h"

@implementation Unit

- (id)init
{
    return [super init];
}

- (id)initWithSprite:(CCSprite *)sprite
{
    if(self = [self init])
    {
        self.sprite = sprite;
    }
    
    return self;
}

@end
