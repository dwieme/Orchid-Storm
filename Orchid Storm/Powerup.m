#import "Powerup.h"

@implementation Powerup

- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position
              health:(NSInteger)health
              damage:(NSUInteger)damage
            onGround:(BOOL)onGround
                type:(PowerupType)type
{
    if(self = [super initWithSprite:sprite
                        andPosition:position
                             health:health
                             damage:damage
                           onGround:onGround])
    {
        _type = type;
    }
    
    return self;
}

@end
