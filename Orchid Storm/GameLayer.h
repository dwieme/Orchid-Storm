#import "cocos2d.h"
#import "Unit.h"
#import "Player.h"
#import "Projectile.h"
#import "Player.h"
#import "Enemy.h"
#import "GameScene.h"

@interface GameLayer : CCLayerColor
@property (nonatomic, strong) NSMutableArray *enemies;
@property (nonatomic) BOOL isGround;
@property (nonatomic, strong) CCSprite *backgroundOne;
@property (nonatomic, strong) CCSprite *backgroundTwo;
@property (nonatomic, strong) CCSprite *cloudOne;
@property (nonatomic, strong) CCSprite *cloudTwo;
@property (nonatomic, strong) CCSprite *cloudThree;
@property (nonatomic, strong) CCSprite *cloudFour;

- (void)addUnit:(Unit *)unit;
- (void)spawnProjectile:(Projectile *)projectile;
- (id)initWithType:(BOOL)isGround;
@end