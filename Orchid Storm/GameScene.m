#import "GameScene.h"
#import "cocos2d.h"
#import "Unit.h"

@interface GameScene ()
@property (nonatomic, strong) Unit *player;
@end

@implementation GameScene

- (id)init
{
    if(self = [super init])
    {
        _layer = [GameLayer node];
        [self addChild:_layer];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *playerSprite = [[CCSprite alloc] initWithFile:@"player.png"];
        self.player = [[Unit alloc] initWithSprite:playerSprite];
        self.player.position = ccp(winSize.width * 0.5, self.player.sprite.contentSize.height * 0.5);
        
        self.player.sprite.position = ccp(self.player.position.x, self.player.position.y);
        
        [self addChild:self.player.sprite];
    }
    
    return self;
}

@end
