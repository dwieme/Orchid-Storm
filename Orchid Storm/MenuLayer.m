#import "MenuLayer.h"

@implementation MenuLayer

- (void)onEnter
{
    [super onEnter];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *splash = [[CCSprite alloc] initWithFile:@"mainSplash.png"];
    [splash setPosition:ccp(winSize.width / 2, winSize.height / 2)];
    [self addChild:splash];
    
    CCMenuItem *menuItem = [CCMenuItemImage itemWithNormalImage:@"unpressedButton.png"
                                                      selectedImage:@"pressedButton.png"
                                                             target:self
                                                           selector:@selector(starButtonTapped:)];
    
    [menuItem setScale:2];
    menuItem.position = ccp(winSize.width / 2, (winSize.height / 2) - 65);
    CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu];
    
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
    [[CCDirector sharedDirector] replaceScene:[[GameScene alloc] init]];
}

@end