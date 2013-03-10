#import "GameLayer.h"
#import "Unit.h"
#import "Player.h"
#import "Enemy.h"
#import "Projectile.h"
#import "GameScene.h"

@interface GameLayer ()
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) NSMutableArray *enemies;
@end

@implementation GameLayer

- (void)onEnter
{
    [super onEnter];
}

- (void)addUnit:(Unit *)unit
{
    if ([unit isMemberOfClass:[Player class]])
    {
        self.player = (Player *)unit;
    }
    else if([unit isMemberOfClass:[Enemy class]])
    {
        [self.enemies addObject:(Enemy *)unit];
    }
    
    [self addChild:unit.sprite];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CCSprite *sprite = [[CCSprite alloc] initWithFile:@"projectile.png"];
    Projectile *proj = [[Projectile alloc] initWithSprite:sprite
                                                 position:self.player.position
                                                 velocity:ccp(0, 5)
                                                   damage:5];
    [self addChild:sprite];
    [GameScene addGameObject:proj];
}

- (id)init
{
    if(self = [super initWithColor:ccc4(255, 255, 255, 255)])
    {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

@end