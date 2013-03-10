#import "Projectile.h"
#import "GameScene.h"

@implementation Projectile

- (id)initWithSprite:(CCSprite *)sprite
            position:(CGPoint)position
            velocity:(CGPoint)velocity
              damage:(NSUInteger)damage
{
    if(self = [super init])
    {
        self.sprite = sprite;
        self.position = position;
        self.velocity = velocity;
        self.damage = damage;
    }
    
    return self;
}

- (void)update
{
    [self setPosition:ccp(self.position.x + self.velocity.x,
                          self.position.y + self.velocity.y)];
    self.sprite.position = ccp(self.position.x, self.position.y);
    
    if (self.position.x > [GameScene screenWidth]
        || self.position.x < 0
        || self.position.y > [GameScene screenHeight]
        || self.position.y < 0)
    {
        [[self.sprite parent] removeChild:self.sprite cleanup:YES];
        [GameScene removeGameObject:self];
    }
}

@end
