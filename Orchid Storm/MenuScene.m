#import "MenuScene.h"
#import "GameScene.h"
#import "cocos2d.h"

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
