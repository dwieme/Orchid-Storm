#import "GameScene.h"
#import "cocos2d.h"
#import "GameLayer.h"
#import "Enemy.h"
#import "Unit.h"
#import "Player.h"
#import "Updateable.h"
#import "EnemySpawner.h"
#import "Projectile.h"
#import "Powerup.h"
#import "MenuScene.h"
#import "HUDLayer.h"
#include <CoreMotion/CoreMotion.h>

#define SHIP_ANIMATION_TAG 1337

@interface GameScene ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) HUDLayer *hudLayer;
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
        
        _hudLayer = [[HUDLayer alloc] init];
        
        [self addChild:_groundLayer];
        [self addChild:_skyLayer];
        [self addChild:_hudLayer];
        
        gameObjects = [[NSMutableArray alloc] init];
        
        [Projectile initSpriteSheetForScene:self];

        [self createPlayer];
        
        [self schedule:@selector(gameLoop)];
        
        self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
        if (self.motionManager.isDeviceMotionAvailable) {
            [self.motionManager startDeviceMotionUpdates];
        }
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"upgrades.plist"];
        CCSpriteBatchNode *groundUpgradeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"upgrades.png"];
        [self.groundLayer addChild:groundUpgradeSpriteSheet];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"upgrades.plist"];
        CCSpriteBatchNode *skyUpgradeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"upgrades.png"];
        [self.skyLayer addChild:skyUpgradeSpriteSheet];
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
    for(int i = 28; i <= 31; ++i)
    {
        [bankRightAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Player%04d", i]]];
    }
    CCAnimation *bankRightAnim = [CCAnimation animationWithSpriteFrames:bankRightAnimFrames delay:0.1f];
    self.bankRightAction = [CCAnimate actionWithAnimation:bankRightAnim];
    self.bankRightAction.tag = SHIP_ANIMATION_TAG;
    
    // BANK RIGHT TO NORMAL ANIMATION
    NSMutableArray *bankRightToNormalAnimFrames = [NSMutableArray array];
    for(int i = 31; i >= 28; --i)
    {
        [bankRightToNormalAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Player%04d", i]]];
    }
    CCAnimation *bankRightToNormalAnim = [CCAnimation animationWithSpriteFrames:bankRightToNormalAnimFrames delay:0.1f];
    self.bankRightToNormalAction = [CCAnimate actionWithAnimation:bankRightToNormalAnim];
    self.bankRightToNormalAction.tag = SHIP_ANIMATION_TAG;
    
    // BANK LEFT ANIMATION
    NSMutableArray *bankLeftAnimFrames = [NSMutableArray array];
    for(int i = 24; i <= 27; ++i)
    {
        [bankLeftAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Player%04d", i]]];
    }
    CCAnimation *bankLeftAnim = [CCAnimation animationWithSpriteFrames:bankLeftAnimFrames delay:0.1f];
    self.bankLeftAction = [CCAnimate actionWithAnimation:bankLeftAnim];
    self.bankLeftAction.tag = SHIP_ANIMATION_TAG;
    
    // BANK LEFT TO NORMAL ANIMATION
    NSMutableArray *bankLeftToNormalAnimFrames = [NSMutableArray array];
    for(int i = 27; i >= 24; --i)
    {
        [bankLeftToNormalAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Player%04d", i]]];
    }
    CCAnimation *bankLeftToNormalAnim = [CCAnimation animationWithSpriteFrames:bankLeftToNormalAnimFrames delay:0.1f];
    self.bankLeftToNormalAction = [CCAnimate actionWithAnimation:bankLeftToNormalAnim];
    self.bankLeftToNormalAction.tag = SHIP_ANIMATION_TAG;
    
    CCSprite *playerSprite = [CCSprite spriteWithSpriteFrameName:@"Player0023"];
//    [playerSprite setScale:playerSprite.scale * 0.5];
    self.player = [[Player alloc] initWithSprite:playerSprite
                                     andPosition:ccp(winSize.width * 0.5,
                                                     (playerSprite.contentSize.height * 0.5))
                                          health:STARTING_HEALTH
                                          damage:1
                                        onGround:YES];
    self.playerState = Driving;
    [gameObjects addObject:self.player];
    
    [self.groundLayer addUnit:self.player];
}

- (void)respawnPlayer
{
    self.player.health = STARTING_HEALTH;
    [self.player.sprite setColor:ccc3(255,255,255)];
    [gameObjects addObject:self.player];
    if(self.player.onGround){
        [self.groundLayer addUnit:self.player];
    }
   else{
        [self.skyLayer addUnit:self.player];
    }
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
    [background setPosition:ccp(currPos.x, currPos.y - SCROLL_SPEED)];
    
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
    if(self.playerState !=  Driving){
        [self scrollBackground:self.skyLayer.cloudOne];
        [self scrollBackground:self.skyLayer.cloudTwo];
        [self scrollBackground:self.skyLayer.cloudThree];
        [self scrollBackground:self.skyLayer.cloudFour];
    }
    
    for (int i = [gameObjects count] - 1; i >= 0; --i) {
        id object = gameObjects[i];
        
        if ([object conformsToProtocol:@protocol(Updateable)]) {
            [object update];
        }
        
        if ([object isMemberOfClass:[Player class]]) {
            [self updatePlayer];
        }
        
        if ([object isMemberOfClass:[Enemy class]]) {
            Enemy *enemy = (Enemy *)object;
            Player *player = self.player;
            if (((enemy.onGround && self.playerState == Driving)||((!enemy.onGround && self.playerState == Flying))) && player.health>0)
            {
                NSInteger diffX = [player position].x - [enemy position].x;
                NSInteger diffY = [player position].y - [enemy position].y;
                NSInteger manhattanDist = (diffX * diffX) + (diffY * diffY);
                if(manhattanDist < 625)
                {
                    enemy.health = 0;
                    player.health -= enemy.damage;
                    [player.sprite setColor:ccc3(255, 0, 0)];
                    [player.sprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1], [CCCallBlock actionWithBlock:^{
                        [player.sprite setColor:ccc3(255, 255, 255)];
                    }], nil]];
                }
            }
            if(enemy.onGround && !player.onGround && enemy.movementType != Landlocked){
                enemy.movementType = Landlocked;
                enemy.velocity = ccp(0,-SCROLL_SPEED);
            }
            if(!enemy.onGround && player.onGround && enemy.movementType != Landlocked){
                enemy.movementType = Landlocked;
                enemy.velocity = ccp(0,-SCROLL_SPEED);
            }
        }
        
        if ([object isMemberOfClass:[Powerup class]]) {
            Powerup *powerUp = (Powerup *)object;
            [powerUp setPosition:ccp(powerUp.position.x,powerUp.position.y - SCROLL_SPEED)];
            
            if(powerUp.position.y < -30){
                powerUp.health = 0;
            }
            
            Player *player = self.player;
            if (powerUp.onGround == player.onGround && player.health>0)
            {
                NSInteger diffX = [player position].x - [powerUp position].x;
                NSInteger diffY = [player position].y - [powerUp position].y;
                NSInteger manhattanDist = (diffX * diffX) + (diffY * diffY);
                if(manhattanDist < 625)
                {
                    switch (powerUp.type) {
                        case Health:
                            player.health += powerUp.health;
                            break;
                        case Life:
                            if(player.lives < 3){
                                player.lives += powerUp.health;
                            }
                            break;
                        case Weapon:
                            player.weaponType +=1;
                            if(player.weaponType>6){
                                player.damage +=1;
                            }
                            
                            break;
                        default:
                            break;
                    }
                    powerUp.health = 0;
                }
            }
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
                                
                                [enemy.sprite setColor:ccc3(255, 0, 0)];
                                [enemy.sprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1], [CCCallBlock actionWithBlock:^{
                                    [enemy.sprite setColor:ccc3(255, 255, 255)];
                                }], nil]];
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
                                
                                [enemy.sprite setColor:ccc3(255, 0, 0)];
                                [enemy.sprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1], [CCCallBlock actionWithBlock:^{
                                    [enemy.sprite setColor:ccc3(255, 255, 255)];
                                }], nil]];
                                proj.health = 0;
                            }
                        }
                    }
                }
            }
            else
            {
                Player *player = self.player;
                if (((proj.onGround && self.playerState == Driving)||((!proj.onGround && self.playerState == Flying))) && player.health>0)
                {
                    NSInteger diffX = [player position].x - [proj position].x;
                    NSInteger diffY = [player position].y - [proj position].y;
                    NSInteger manhattanDist = (diffX * diffX) + (diffY * diffY);
                    if(manhattanDist < 625)
                    {
                        player.health -= proj.damage;
                        
                        [player.sprite setColor:ccc3(255, 0, 0)];
                        [player.sprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1], [CCCallBlock actionWithBlock:^{
                            [player.sprite setColor:ccc3(255, 255, 255)];
                        }], nil]];
                        
                        proj.health = 0;
                    }
                }
            }
        }
        
        if([gameObjects[i] isKindOfClass:[Unit class]])
        {
            Unit *unit = (Unit *)gameObjects[i];
            
            if (unit.health <= 0) {
                
                if([unit isMemberOfClass:[Enemy class]]){
                    int  drop = arc4random() % 100;
                    
                                        
                    if(drop > 66){
                        PowerupType type;
                        int hp = 1;
                        CCSprite *puSprite ;

                        drop = arc4random() % 100;
                        if(drop > 30){
                            puSprite = [[CCSprite alloc] initWithSpriteFrameName:@"Upgrades0000"];
                            type = Weapon;
                        }
                        else if(drop > 5){
                            type = Health;
                            puSprite = [[CCSprite alloc] initWithSpriteFrameName:@"Upgrades0001"];
                            hp = (arc4random() % 5) +1;
                        }
                        else{
                            puSprite = [[CCSprite alloc] initWithSpriteFrameName:@"Upgrades0002"];
                            type = Life;
                        }
                        [puSprite setScale:1.5];
                        
                        Powerup *p = [[Powerup alloc] initWithSprite:puSprite andPosition:unit.position health:hp damage:1 onGround:unit.onGround type:type];
                        if(unit.onGround){
                            [self.groundLayer addUnit:p];
                        } else {
                            [self.skyLayer addUnit:p];
                        }
                        [gameObjects addObject:p];
                    }
                    
                    
                    
                }
                
                if([unit isMemberOfClass:[Player class]]){
                    self.player.lives -=1;
                    self.player.damage = 1;
                    self.player.weaponType = 1;
                    if(self.player.lives == 0){
                        [[CCDirector sharedDirector] replaceScene:[[MenuScene alloc] init]];
                    }
                    else{
                       
                        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2], [CCCallFunc actionWithTarget:self selector:@selector(respawnPlayer)], nil]];
                        
                    }
                }
                
                
                
                GameLayer *layer = (GameLayer *)[unit.sprite parent];
                [layer removeChild:unit.sprite cleanup:YES];
                [[layer enemies] removeObject:unit];
                
                [gameObjects removeObject:unit];
            }
        }
    }
    
    [self.hudLayer updateWithPlayer:self.player];
    
    [self.spawner update];
}

- (void)changeColor
{
    
}

- (void)updatePlayer
{
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
                if ([self.player.sprite numberOfRunningActions] > 0)
                {
                    [self.player.sprite stopActionByTag:SHIP_ANIMATION_TAG];
                }
                [self.player.sprite runAction:self.bankRightAction];
                self.player.bankingState = Right;
            }
            else if (pitch < -0.1 && self.player.bankingState == Normal)
            {
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
                if ([self.player.sprite numberOfRunningActions] > 0)
                {
                    [self.player.sprite stopActionByTag:SHIP_ANIMATION_TAG];
                }
                [self.player.sprite runAction:self.bankRightAction];
                self.player.bankingState = Right;
            }
            else if (pitch > 0.1 && self.player.bankingState == Normal)
            {
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
