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
    
    if(self = [super init])
    {
        self.isTouchEnabled = YES;
    }
    
    if(isGround)
    {
        CGFloat width = [GameScene screenWidth];
        CGFloat height = [GameScene screenHeight];
        CGFloat x = width * 0.5;
        CGFloat y = height * 0.5;
        
        self.backgroundOne = [[CCSprite alloc] initWithFile:@"scrolling-background.png"];
        self.backgroundTwo = [[CCSprite alloc] initWithFile:@"scrolling-background.png"];
        
        [self.backgroundOne setScale:self.backgroundOne.scale * 3];
        [self.backgroundTwo setScale:self.backgroundTwo.scale * 3];
        
        [self.backgroundOne setPosition:ccp(x,y)];
        [self.backgroundTwo setPosition:ccp(x, self.backgroundOne.position.y + [self.backgroundOne boundingBox].size.height)];
        
        [self addChild:self.backgroundOne];
        [self addChild:self.backgroundTwo];
    }
    else
    {
        self.visible = NO;
    }

    return self;
}

@end