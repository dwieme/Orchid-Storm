#import "cocos2d.h"
#import "Player.h"
#import "GameScene.h"

@interface HUDLayer : CCLayer

- (void)updateWithPlayer:(Player *)player;

@end
