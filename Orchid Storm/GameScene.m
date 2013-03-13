#import "GameScene.h"
#import "cocos2d.h"
#import "Unit.h"
#import "Player.h"
#import "Updateable.h"
#import "EnemySpawner.h"
#import "Projectile.h"
#include <CoreMotion/CoreMotion.h>

#define SHIP_ANIMATION_TAG 1337

typedef enum {
    Flying, Driving, Landing, TakingOff
} PlayerState;

@interface GameScene ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) GameLayer *groundLayer;
@property (nonatomic, strong) GameLayer *skyLayer;
@property (nonatomic) PlayerState playerState;
@property (nonatomic, strong) EnemySpawner *spawner;
@property (nonatomic, strong) CCAction *landAction;
@property (nonatomic, strong) CCAction *takeOffAction;
@property (nonatomic, strong) CCAction *bankRightAction;
@property (nonatomic, strong) CCAction *bankRightToNormalAction;
@property (nonatomic, strong) CCAction *bankLeftAction;
@property (nonatomic, strong) CCAction *bankLeftToNormalAction;
@end

@implementation GameScene

static NSMutableArray *gameObjects;
static CGFloat screenWidth;
static CGFloat screenHeight;

+ (CGFloat)screenWidth
{
    return screenWidth;
}

+ (CGFloat)screenHeight
{
    return screenHeight;
}

- (CMMotionManager *)motionManager
{
    if (!_motionManager) _motionManager = [[CMMotionManager alloc] init];
    return _motionManager;
}

- (EnemySpawner *)spawner
{
    if (!_spawner) _spawner = [[EnemySpawner alloc] initWithScene:self];
    return _spawner;
}

- (id)init
{
    if(self = [super init])
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        screenWidth = winSize.width;
        screenHeight = winSize.height;
        
        _groundLayer = [[GameLayer alloc] initWithType:YES];
        _skyLayer = [[GameLayer alloc] initWithType:NO];
        
        [self addChild:_groundLayer];
        [self addChild:_skyLayer];
        
        gameObjects = [[NSMutableArray alloc] init];

        [self createPlayer];
        
        [self schedule:@selector(gameLoop)];
        
        self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
        if (self.motionManager.isDeviceMotionAvailable) {
            [self.motionManager startDeviceMotionUpdates];
        }
    }
    
    return self;
}

- (void)createPlayer
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"playerShip.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"playerShip.png"];
    [self.groundLayer addChild:spriteSheet];
    
    // LANDING ANIMATION
    NSMutableArray *landAnimFrames = [NSMutableArray array];
    for(int i = 0; i <= 23; ++i)
    {
        [landAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Player%04d", i]]];
    }
    CCAnimation *landAnim = [CCAnimation animationWithSpriteFrames:landAnimFrames delay:0.05f];
    self.landAction = [CCAnimate actionWithAnimation:landAnim];
    self.landAction.tag = SHIP_ANIMATION_TAG;
    
    // TAKE OFF ANIMATION
    NSMutableArray *takeOffAnimFrames = [NSMutableArray array];
    for(int i = 23; i >= 0; --i)
    {
        [takeOffAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Player%04d", i]]];
    }
    CCAnimation *takeOffAnim = [CCAnimation animationWithSpriteFrames:takeOffAnimFrames delay:0.05f];
    self.takeOffAction = [CCAnimate actionWithAnimation:takeOffAnim];
    self.takeOffAction.tag = SHIP_ANIMATION_TAG;
    
    // BANK RIGHT ANIMATION
    NSMutableArray *bankRightAnimFrames = [NSMutableArray array];
    for(int i = 24; i <= 28; ++i)
    {
        [bankRightAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Player%04d", i]]];
    }
    CCAnimation *bankRightAnim = [CCAnimation animationWithSpriteFrames:bankRightAnimFrames delay:0.1f];
    self.bankRightAction = [CCAnimate actionWithAnimation:bankRightAnim];
    self.bankRightAction.tag = SHIP_ANIMATION_TAG;
    
    // BANK RIGHT TO NORMAL ANIMATION
    NSMutableArray *bankRightToNormalAnimFrames = [NSMutableArray array];
    for(int i = 28; i >= 24; --i)
    {
        [bankRightToNormalAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Player%04d", i]]];
    }
    CCAnimation *bankRightToNormalAnim = [CCAnimation animationWithSpriteFrames:bankRightToNormalAnimFrames delay:0.1f];
    self.bankRightToNormalAction = [CCAnimate actionWithAnimation:bankRightToNormalAnim];
    self.bankRightToNormalAction.tag = SHIP_ANIMATION_TAG;
    
    // BANK LEFT ANIMATION
    NSMutableArray *bankLeftAnimFrames = [NSMutableArray array];
    for(int i = 29; i <= 32; ++i)
    {
        [bankLeftAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Player%04d", i]]];
    }
    CCAnimation *bankLeftAnim = [CCAnimation animationWithSpriteFrames:bankLeftAnimFrames delay:0.1f];
    self.bankLeftAction = [CCAnimate actionWithAnimation:bankLeftAnim];
    self.bankLeftAction.tag = SHIP_ANIMATION_TAG;
    
    // BANK LEFT TO NORMAL ANIMATION
    NSMutableArray *bankLeftToNormalAnimFrames = [NSMutableArray array];
    for(int i = 32; i >= 29; --i)
    {
        [bankLeftToNormalAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Player%04d", i]]];
    }
    CCAnimation *bankLeftToNormalAnim = [CCAnimation animationWithSpriteFrames:bankLeftToNormalAnimFrames delay:0.1f];
    self.bankLeftToNormalAction = [CCAnimate actionWithAnimation:bankLeftToNormalAnim];
    self.bankLeftToNormalAction.tag = SHIP_ANIMATION_TAG;
    
    CCSprite *playerSprite = [CCSprite spriteWithSpriteFrameName:@"Player0023"];
    [playerSprite setScale:playerSprite.scale * 0.5];
    self.player = [[Player alloc] initWithSprite:playerSprite
                                     andPosition:ccp(winSize.width * 0.5,
                                                     (playerSprite.contentSize.height * 0.5) - 40)
                                          health:10
                                          damage:5
                                        onGround:YES];
    self.playerState = Driving;
    [gameObjects addObject:self.player];
    
    [self.groundLayer addUnit:self.player];
}

+ (void)addGameObject:(id)object
{
    [gameObjects addObject:object];
}

+ (void)removeGameObject:(id)object
{
    [gameObjects removeObject:object];
}

- (void)scrollBackground:(CCSprite *)background
{
    CGPoint currPos = background.position;
    [background setPosition:ccp(currPos.x, currPos.y - 5)];
    
    if (background.position.y + [background boundingBox].size.height * 0.5 < -40)
    {
        CGPoint newPos = ccp(background.position.x, background.position.y + (2 * [background boundingBox].size.height));
        [background setPosition:newPos];
    }
}

- (void)gameLoop
{
//    NSLog(@"NumObjectsInScene: %d", [gameObjects count]);
    
    [self scrollBackground:self.groundLayer.backgroundOne];
    [self scrollBackground:self.groundLayer.backgroundTwo];
    
    for (int i = [gameObjects count] - 1; i >= 0; --i) {
        id object = gameObjects[i];
        
        if ([object conformsToProtocol:@protocol(Updateable)]) {
            [object update];
        }
        
        if ([object isMemberOfClass:[Player class]]) {
            CMDeviceMotion *currentDeviceMotion = self.motionManager.deviceMotion;
            
            CMAttitude *currentAttitude = currentDeviceMotion.attitude;
            float roll = currentAttitude.roll;
            float pitch = currentAttitude.pitch;
            
            if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
            {
                if (roll > 0 && self.playerState == Flying)
                {
                    [self land];
                }
                else if(roll < -0.9 && self.playerState == Driving)
                {
                    [self fly];
                }
                
                if (self.playerState == Flying)
                {
                    if (pitch > 0.1 && self.player.bankingState == Normal)
                    {
                        CCLOG(@"Right: %@", self.bankRightAction);
                        
                        if ([self.player.sprite numberOfRunningActions] > 0)
                        {
                            [self.player.sprite stopActionByTag:SHIP_ANIMATION_TAG];
                        }
                        [self.player.sprite runAction:self.bankRightAction];
                        self.player.bankingState = Right;
                    }
                    else if (pitch < -0.1 && self.player.bankingState == Normal)
                    {
                        CCLOG(@"Left: %@", self.bankLeftAction);
                        
                        if ([self.player.sprite numberOfRunningActions] > 0)
                        {
                            [self.player.sprite stopActionByTag:SHIP_ANIMATION_TAG];
                        }
                        [self.player.sprite runAction:self.bankLeftAction];
                        self.player.bankingState = Left;
                    }
                    else if (self.player.bankingState == Left && pitch > -0.1)
                    {
                        if ([self.player.sprite numberOfRunningActions] > 0)
                        {
                            [self.player.sprite stopActionByTag:SHIP_ANIMATION_TAG];
                        }
                        [self.player.sprite runAction:self.bankLeftToNormalAction];
                        self.player.bankingState = Normal;
                    }
                    else if (self.player.bankingState == Right && pitch < 0.1)
                    {
                        if ([self.player.sprite numberOfRunningActions] > 0)
                        {
                            [self.player.sprite stopActionByTag:SHIP_ANIMATION_TAG];
                        }
                        [self.player.sprite runAction:self.bankRightToNormalAction];
                        self.player.bankingState = Normal;
                    }
                }
            }
            else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft)
            {
                if (roll < 0 && self.playerState == Flying)
                {
                    [self land];
                }
                else if(roll > 0.9 && self.playerState == Driving)
                {
                    [self fly];
                }
                if (self.playerState == Flying)
                {
                    if (pitch < -0.1 && self.player.bankingState == Normal)
                    {
                        CCLOG(@"Right: %@", self.bankRightAction);
                        
                        if ([self.player.sprite numberOfRunningActions] > 0)
                        {
                            [self.player.sprite stopActionByTag:SHIP_ANIMATION_TAG];
                        }
                        [self.player.sprite runAction:self.bankRightAction];
                        self.player.bankingState = Right;
                    }
                    else if (pitch > 0.1 && self.player.bankingState == Normal)
                    {
                        CCLOG(@"Left: %@", self.bankLeftAction);
                        
                        if ([self.player.sprite numberOfRunningActions] > 0)
                        {
                            [self.player.sprite stopActionByTag:SHIP_ANIMATION_TAG];
                        }
                        [self.player.sprite runAction:self.bankLeftAction];
                        self.player.bankingState = Left;
                    }
                    else if (self.player.bankingState == Left && pitch < 0.1)
                    {
                        if ([self.player.sprite numberOfRunningActions] > 0)
                        {
                            [self.player.sprite stopActionByTag:SHIP_ANIMATION_TAG];
                        }
                        [self.player.sprite runAction:self.bankLeftToNormalAction];
                        self.player.bankingState = Normal;
                    }
                    else if (self.player.bankingState == Right && pitch > -0.1)
                    {
                        if ([self.player.sprite numberOfRunningActions] > 0)
                        {
                            [self.player.sprite stopActionByTag:SHIP_ANIMATION_TAG];
                        }
                        [self.player.sprite runAction:self.bankRightToNormalAction];
                        self.player.bankingState = Normal;
                    }
                }
            }
            
//            NSLog(@"%f", pitch);
            
            [self.player updateMovement:pitch];
        }
        
        if ([object isMemberOfClass:[Projectile class]])
        {
            Projectile *proj = (Projectile *)object;
            
            if(proj.friendlyFire == YES)
            {
                if (proj.onGround)
                {
                    for(int j = [[self.groundLayer enemies] count] - 1; j >= 0; --j)
                    {
                        if([[self.groundLayer enemies][j] isMemberOfClass:[Enemy class]])
                        {
                            Enemy *enemy = (Enemy *)([self.groundLayer enemies][j]);
                            NSInteger diffX = [enemy position].x - [proj position].x;
                            NSInteger diffY = [enemy position].y - [proj position].y;
                            NSInteger manhattanDist = (diffX * diffX) + (diffY * diffY);
                            if(manhattanDist < 625)
                            {
                                enemy.health -= proj.damage;
                                proj.health = 0;
                            }
                        }
                    }
                }
                else
                {
                    for(int j = [[self.skyLayer enemies] count] - 1; j >= 0; --j)
                    {
                        if([[self.skyLayer enemies][j] isMemberOfClass:[Enemy class]])
                        {
                            Enemy *enemy = (Enemy *)([self.skyLayer enemies][j]);
                            NSInteger diffX = [enemy position].x - [proj position].x;
                            NSInteger diffY = [enemy position].y - [proj position].y;
                            NSInteger manhattanDist = (diffX * diffX) + (diffY * diffY);
                            if(manhattanDist < 625)
                            {
                                enemy.health -= proj.damage;
                                proj.health = 0;
                            }
                        }
                    }
                }
            }
            else
            {
                if (proj.onGround == (self.playerState == Driving))
                {
                    Player *player = self.player;
                    NSInteger diffX = [player position].x - [proj position].x;
                    NSInteger diffY = [player position].y - [proj position].y;
                    NSInteger manhattanDist = (diffX * diffX) + (diffY * diffY);
                    if(manhattanDist < 625)
                    {
                        player.health -= proj.damage;
                        proj.health = 0;
                    }
                }
            }
        }
        
        if([gameObjects[i] isKindOfClass:[Unit class]])
        {
            Unit *unit = (Unit *)gameObjects[i];
            
            if (unit.health <= 0) {
                GameLayer *layer = (GameLayer *)[unit.sprite parent];
                [layer removeChild:unit.sprite cleanup:YES];
                [[layer enemies] removeObject:unit];
                
                [gameObjects removeObject:unit];
            }
        }
    }
    
    [self.spawner update];
}

- (void)land
{
    self.playerState = Landing;
    [self.groundLayer runAction:[CCSequence actionOne:[CCScaleTo actionWithDuration:2 scale:[self.groundLayer scale] * 1.25]
                                                  two:[CCCallFunc actionWithTarget:self selector:@selector(switchPlayerToGround)]]];
    if ([self.player.sprite numberOfRunningActions] > 0)
    {
        [self.player.sprite stopActionByTag:SHIP_ANIMATION_TAG];
    }
    [self.player.sprite runAction:self.landAction];
}

- (void)switchPlayerToGround
{
    self.player.onGround = YES;
    self.playerState = Driving;
    [self.skyLayer removeChild:self.player.sprite cleanup:NO];
    [self.groundLayer addChild:self.player.sprite];
    [self.skyLayer setVisible:NO];
}

- (void)fly
{
    self.playerState = TakingOff;
    [self.groundLayer removeChild:self.player.sprite cleanup:NO];
    [self.skyLayer addChild:self.player.sprite];
    [self.groundLayer runAction:[CCSequence actionOne:[CCScaleTo actionWithDuration:2 scale:[self.groundLayer scale] * 0.8]
                                                  two:[CCCallFunc actionWithTarget:self selector:@selector(switchPlayerToSky)]]];
    [self.skyLayer setVisible:YES];
    if ([self.player.sprite numberOfRunningActions] > 0)
    {
        [self.player.sprite stopActionByTag:SHIP_ANIMATION_TAG];
    }
    [self.player.sprite runAction:self.takeOffAction];
}

- (void)switchPlayerToSky
{
    self.player.onGround = NO;
    self.playerState = Flying;
}

- (void)spawnEnemy:(Enemy *)enemy onGround:(BOOL)onGround
{
    [gameObjects addObject:enemy];
    onGround ? [self.groundLayer addUnit:enemy] : [self.skyLayer addUnit:enemy];
}

@end
