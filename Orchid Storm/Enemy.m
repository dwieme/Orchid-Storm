#import "Enemy.h"

@implementation Enemy

- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position
                type:(EnemyType)type
{
    if(self = [super initWithSprite:sprite
                        andPosition:position])
    {
        self.type = type;
    }
    
    return self;
}

@end
