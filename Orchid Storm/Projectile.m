#import "Projectile.h"
#import "GameScene.h"
#import "GameLayer.h"

@implementation Projectile

+ (void) initSpriteSheetForScene:(GameScene*)scene
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bullets.plist"];
    CCSpriteBatchNode *bulletSpritesOne = [CCSpriteBatchNode batchNodeWithFile:@"bullets.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bullets.plist"];
    CCSpriteBatchNode *bulletSpritesTwo = [CCSpriteBatchNode batchNodeWithFile:@"bullets.png"];
    
    [scene.skyLayer addChild:bulletSpritesOne];
    [scene.groundLayer addChild:bulletSpritesTwo];
}

- (id)initWithSprite:(int)spriteIndex
            position:(CGPoint)position
            velocity:(CGPoint)velocity
              damage:(NSUInteger)damage
        friendlyFire:(BOOL)friendlyFire
            onGround:(BOOL)onGround
{
    if(self = [super initWithSprite:[[CCSprite alloc] initWithSpriteFrameName:[NSString stringWithFormat:@"Ammunition%04d", spriteIndex]]
                        andPosition:position
                             health:1
                             damage:damage
                            onGround:onGround])
    {
        _velocity = velocity;
        _friendlyFire = friendlyFire;
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
        || self.position.y < -30)
    {
        self.health = 0;
    }
}

@end
