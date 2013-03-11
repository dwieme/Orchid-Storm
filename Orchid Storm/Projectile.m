#import "Projectile.h"
#import "GameScene.h"

@implementation Projectile

- (id)initWithSprite:(CCSprite *)sprite
            position:(CGPoint)position
            velocity:(CGPoint)velocity
              damage:(NSUInteger)damage
        friendlyFire:(BOOL)friendlyFire
            onGround:(BOOL)onGround
{
    if(self = [super initWithSprite:sprite
                        andPosition:position
                             health:1
                             damage:damage
                            onGround:onGround])
    {
        self.velocity = velocity;
        self.friendlyFire = friendlyFire;
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
        self.health = 0;
    }
}

@end
