#import "Player.h"
#import "GameScene.h"

#define MOVEMENT_SPEED_MODIFIER 8

@implementation Player

- (void)updateMovement:(float)roll
{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
    {
        [self setPosition:ccp(self.position.x + (roll * MOVEMENT_SPEED_MODIFIER), self.position.y)];
    }
    else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft)
    {
        [self setPosition:ccp(self.position.x - (roll * MOVEMENT_SPEED_MODIFIER), self.position.y)];
    }
    
    if (self.position.x > [GameScene screenWidth])
    {
        [self setPosition:ccp([GameScene screenWidth], self.position.y)];
    }
    else if (self.position.x < 0)
    {
        [self setPosition:ccp(0, self.position.y)];
    }
    
    [super update];
}

@end
