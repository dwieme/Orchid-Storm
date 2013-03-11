#import "Enemy.h"
#import "GameScene.h"
#import "Projectile.h"

@interface Enemy ()
@property (nonatomic) NSUInteger fireCounter;
@end

@implementation Enemy

- (void)update
{
    if (self.position.y > [GameScene screenHeight] - 20)
    {
        self.velocity = ccp(0, -2);
    }
    else
    {
        ++self.fireCounter;
        
        switch (self.type) {
            case Basic:
                if (self.velocity.x > 0)
                {
                    if (self.position.x >= [GameScene screenWidth])
                    {
                        self.velocity = ccp(-2, 0);
                    }
                }
                else if (self.velocity.x < 0)
                {
                    if (self.position.x <= 0)
                    {
                        self.velocity = ccp(2, 0);
                    }
                }
                else
                {
                    self.velocity = ccp(2, 0);
                }
                
                if (self.fireCounter == self.fireSpeed)
                {
                    CCSprite *sprite = [[CCSprite alloc] initWithFile:@"projectile.png"];
                    Projectile *proj = [[Projectile alloc] initWithSprite:sprite
                                                                 position:self.position
                                                                 velocity:ccp(0, -3)
                                                                   damage:self.damage
                                                             friendlyFire:NO
                                                                 onGround:self.onGround];
                    GameLayer *layer = (GameLayer *)[self.sprite parent];
                    [layer spawnProjectile:proj];
                    self.fireCounter = 0;
                }
                
                break;
                
            default:
                break;
        }
    }
    
    self.position = ccp(self.position.x + self.velocity.x, self.position.y + self.velocity.y);
    
    [super update];
}

- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position
                type:(EnemyType)type
              health:(NSInteger)health
              damage:(NSUInteger)damage
           fireSpeed:(NSUInteger)fireSpeed
            onGround:(BOOL)onGround
{
    if(self = [super initWithSprite:sprite
                        andPosition:position
                             health:health
                             damage:damage
                           onGround:onGround])
    {
        self.type = type;
        self.velocity = ccp(0,0);
        self.fireSpeed = fireSpeed;
        self.fireCounter = 0;
    }
    
    return self;
}

@end
