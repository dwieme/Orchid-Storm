#import "cocos2d.h"
#import "MenuLayer.h"
#import "GameScene.h"

@implementation MenuLayer

- (void)onEnter
{
    [super onEnter];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCMenuItem *starMenuItem = [CCMenuItemImage itemWithNormalImage:@"ButtonStar.png"
                                                      selectedImage:@"ButtonStarSel.png"
                                                             target:self
                                                           selector:@selector(starButtonTapped:)];
    
    starMenuItem.position = ccp(60, 60);
    CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, nil];
    starMenu.position = CGPointZero;
    [self addChild:starMenu];
    
    [self changeHeight:winSize.height];
    [self changeWidth:winSize.width];
}

- (id)init
{
    if(self = [super initWithColor:ccc4(255, 255, 255, 255)])
    {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

- (void)starButtonTapped:(id)sender
{
    [[CCDirector sharedDirector] pushScene:[[GameScene alloc] init]];
}

@end