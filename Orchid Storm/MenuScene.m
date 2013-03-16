#import "MenuScene.h"
#import "MenuLayer.h"

@implementation MenuScene

- (id)init
{
    if(self = [super init])
    {
        _layer = [MenuLayer node];
        [self addChild:_layer];
    }
    
    return self;
}

@end
