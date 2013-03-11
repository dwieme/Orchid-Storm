#import "GameLayer.h"
#import "Unit.h"
#import "Player.h"
#import "Enemy.h"
#import "Projectile.h"
#import "GameScene.h"

@interface GameLayer ()
@end

@implementation GameLayer

- (NSMutableArray *)enemies
{
    if(!_enemies) _enemies = [[NSMutableArray alloc] init];
    return _enemies;
}

- (void)onEnter
{
    [super onEnter];
}

- (void)addUnit:(Unit *)unit
{
    if([unit isMemberOfClass:[Enemy class]])
    {
        [self.enemies addObject:(Enemy *)unit];
    }
    
    [self addChild:unit.sprite];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    GameScene *parent = (GameScene *)[self parent];
    if(self.isGround == parent.player.onGround)
    {
        CCSprite *sprite = [[CCSprite alloc] initWithFile:@"projectile.png"];
        Projectile *proj = [[Projectile alloc] initWithSprite:sprite
                                                     position:parent.player.position
                                                     velocity:ccp(0, 5)
                                                       damage:parent.player.damage
                                                 friendlyFire:YES
                                                     onGround:parent.player.onGround];
        [self spawnProjectile:proj];
    }
}

- (void)spawnProjectile:(Projectile *)projectile
{
    [self addChild:projectile.sprite];
    [GameScene addGameObject:projectile];
}

- (id)initWithType:(BOOL)isGround
{
    self.isGround = isGround;
    
    ccColor4B color;
    
    if(isGround)
    {
        color = ccc4(255, 255, 255, 255);
    }
    else
    {
        color = ccc4(0, 0, 255, 25);
    }
    
    if(self = [super initWithColor:color])
    {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

@end