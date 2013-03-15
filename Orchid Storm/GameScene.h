#import "CCScene.h"
#import "cocos2d.h"
#import "GameLayer.h"
#import "Enemy.h"

#define SCROLL_SPEED 3

@interface GameScene : CCScene
@property (nonatomic, strong) Player *player;

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (void)addGameObject:(id)object;
+ (void)removeGameObject:(id)object;
- (void)spawnEnemy:(Enemy *)enemy onGround:(BOOL)onGround;
@end
