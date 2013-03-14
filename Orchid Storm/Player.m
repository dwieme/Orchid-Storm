#import "Player.h"
#import "GameScene.h"

#define MOVEMENT_SPEED_MODIFIER 12

@implementation Player

- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position
              health:(NSInteger)health
              damage:(NSUInteger)damage
            onGround:(BOOL)onGround
{
    if(self = [super initWithSprite:sprite
                        andPosition:position
                             health:health
                             damage:damage
                           onGround:onGround])
    {
        _bankingState = Normal;
        _weaponType = 1;
        _lives = 3;
    }
    
    return self;
}

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
