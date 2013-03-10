#import "CCScene.h"
#import "cocos2d.h"
#import "GameLayer.h"

@interface GameScene : CCScene
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (void)addGameObject:(id)object;
+ (void)removeGameObject:(id)object;
@end
