#import "Unit.h"

@implementation Unit

- (id)init
{
    return [super init];
}

- (void)update
{
    self.sprite.position = ccp(self.position.x, self.position.y);
}

- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position
              health:(NSInteger)health
              damage:(NSUInteger)damage
            onGround:(BOOL)onGround
{
    if(self = [self init])
    {
        self.sprite = sprite;
        self.position = position;
        self.sprite.position = ccp(self.position.x, self.position.y);
        self.health = health;
        self.damage = damage;
        self.onGround = onGround;
    }
    
    return self;
}

@end
