#import "cocos2d.h"
#import "Unit.h"
#import "Player.h"
#import "Projectile.h"

@interface GameLayer : CCLayerColor
@property (nonatomic, strong) NSMutableArray *enemies;
@property (nonatomic) BOOL isGround;

- (void)addUnit:(Unit *)unit;
- (void)spawnProjectile:(Projectile *)projectile;
- (id)initWithType:(BOOL)isGround;
@end