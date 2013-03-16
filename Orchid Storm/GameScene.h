#import "cocos2d.h"

@class GameLayer;
@class Enemy;
@class Player;

#define SCROLL_SPEED 3

typedef enum {
    Flying, Driving, Landing, TakingOff
} PlayerState;

@interface GameScene : CCScene
@property (nonatomic, strong) Player *player;
@property (nonatomic) PlayerState playerState;
@property (nonatomic, strong) GameLayer *groundLayer;
@property (nonatomic, strong) GameLayer *skyLayer;

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (void)addGameObject:(id)object;
+ (void)removeGameObject:(id)object;
- (void)spawnEnemy:(Enemy *)enemy onGround:(BOOL)onGround;
@end
