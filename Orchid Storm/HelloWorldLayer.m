//
//  HelloWorldLayer.m
//  Orchid Storm
//
//  Created by Dan Wieme on 3/9/13.
//  Copyright Sexy Incorporated 1990. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"Art/projectile.png" rect:CGRectMake(0, 0, 20, 20)];
    projectile.position = ccp(20, winSize.height * 0.5);
    
    [self addChild:projectile];
    
    CGPoint realDest = ccp(winSize.width, winSize.height * 0.5);
    float realMoveDuration = 1;
    
    NSLog(@"%f", realMoveDuration);
    
    [projectile runAction:[CCSequence actions:[CCMoveTo actionWithDuration:realMoveDuration position:realDest], [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)], nil]];
}

- (void)spriteMoveFinished:(id)sender
{
    CCSprite *sprite = (CCSprite *)sender;
    [self removeChild:sprite cleanup:YES];
}

- (void)addTarget
{
    CCSprite *target = [CCSprite spriteWithFile:@"Art/monster.png" rect:CGRectMake(0, 0, 27, 40)];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = target.contentSize.height * 0.5;
    int maxY = winSize.height - target.contentSize.height * 0.5;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    target.position = ccp(winSize.width + (target.contentSize.width * 0.5), actualY);
    [self addChild:target];
    
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(-target.contentSize.width * 0.5, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

- (void)gameLogic:(ccTime)dt
{
    [self addTarget];
}

// on "init" you need to initialize your instance
-(id) init
{
	if(self = [super initWithColor:ccc4(255, 255, 255, 255)])
    {
        self.isTouchEnabled = YES;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *player = [CCSprite spriteWithFile:@"Art/player.png"
                                               rect:CGRectMake(0, 0, 27, 40)];
        player.position = ccp(player.contentSize.width * 0.5, winSize.height * 0.5);
        [self addChild:player];
    }
    
    [self schedule:@selector(gameLogic:) interval:1.0];
    
    return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
