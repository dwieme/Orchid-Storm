#import "GameScene.h"
#import "cocos2d.h"
#import "Unit.h"
#import "Player.h"
#import "Updateable.h"
#import "EnemySpawner.h"
#import "Projectile.h"
#include <CoreMotion/CoreMotion.h>

@interface GameScene ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) float lastPitch;
@property (nonatomic, strong) GameLayer *groundLayer;
@property (nonatomic, strong) GameLayer *skyLayer;
@property (nonatomic) BOOL playerIsOnGround;
@property (nonatomic, strong) EnemySpawner *spawner;
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
    
    CCSprite *playerSprite = [[CCSprite alloc] initWithFile:@"player.png"];
    self.player = [[Player alloc] initWithSprite:playerSprite
                                     andPosition:ccp(winSize.width * 0.5,
                                                     playerSprite.contentSize.height * 0.5)
                                          health:10
                                          damage:5
                                        onGround:YES];
    self.playerIsOnGround = YES;
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
    
    if (background.position.y + [background boundingBox].size.height * 0.5 < 0)
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
            
            if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
            {
                if (roll > 0 && !self.playerIsOnGround)
                {
                    [self land];
                }
                else if(roll < -0.9 && self.playerIsOnGround)
                {
                    [self fly];
                }
            }
            else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft)
            {
                if (roll < 0 && !self.playerIsOnGround)
                {
                    [self land];
                }
                else if(roll > 0.9 && self.playerIsOnGround)
                {
                    [self fly];
                }
            }
            
            float pitch = currentAttitude.pitch;
            self.lastPitch = pitch;
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
                if (proj.onGround == self.playerIsOnGround)
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
    self.player.onGround = YES;
    self.playerIsOnGround = YES;
    [self.skyLayer removeChild:self.player.sprite cleanup:NO];
    [self.groundLayer addChild:self.player.sprite];
    [self.groundLayer setScale:[self.groundLayer scale] * 1.25];
    [self.skyLayer setVisible:NO];

    NSLog(@"Ground :(");
}

- (void)fly
{
    self.player.onGround = NO;
    self.playerIsOnGround = NO;
    [self.groundLayer removeChild:self.player.sprite cleanup:NO];
    [self.skyLayer addChild:self.player.sprite];
    [self.groundLayer setScale:[self.groundLayer scale] * 0.8];
    [self.skyLayer setVisible:YES];
    
    NSLog(@"WE'RE FLYING");
}

- (void)spawnEnemy:(Enemy *)enemy onGround:(BOOL)onGround
{
    [gameObjects addObject:enemy];
    onGround ? [self.groundLayer addUnit:enemy] : [self.skyLayer addUnit:enemy];
}

@end
