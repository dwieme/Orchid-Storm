#import "GameScene.h"
#import "cocos2d.h"
#import "Unit.h"
#import "Player.h"
#import "Updateable.h"
#include <CoreMotion/CoreMotion.h>

@interface GameScene ()
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) float lastPitch;
@property (nonatomic, strong) GameLayer *layer;
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

- (id)init
{
    if(self = [super init])
    {
        _layer = [GameLayer node];
        [self addChild:_layer];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        screenWidth = winSize.width;
        screenHeight = winSize.height;
        
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
                                                     playerSprite.contentSize.height * 0.5)];
    [gameObjects addObject:self.player];
    
    [self.layer addUnit:self.player];
}

+ (void)addGameObject:(id)object
{
    [gameObjects addObject:object];
}

+ (void)removeGameObject:(id)object
{
    [gameObjects removeObject:object];
}

- (void)gameLoop
{
    NSLog(@"%d", [gameObjects count]);
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
            self.lastPitch = pitch;
            [self.player updateMovement:pitch];
        }
    }
}

@end
