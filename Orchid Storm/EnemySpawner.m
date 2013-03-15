#import "EnemySpawner.h"
#import "GameScene.h"
#import "Enemy.h"

#define TICKS_THRESHOLD 300

@interface EnemySpawner ()
@property (nonatomic) NSUInteger ticks;
@property (nonatomic, strong) GameScene *scene;
@end

@implementation EnemySpawner

- (id)initWithScene:(GameScene *)scene
{
    if(self = [super init])
    {
        _ticks = 0;
        _scene = scene;
    }
    
    return self;
}

- (void)update
{
    ++self.ticks;
    if (self.ticks == TICKS_THRESHOLD)
    {
        CGPoint point = ccp([GameScene screenWidth] * 0.5, [GameScene screenHeight] + 20);
        CCSprite *sprite = [[CCSprite alloc] initWithFile:@"monster.png"];
        
        CGPoint waypointOne = ccp([GameScene screenWidth] , ([GameScene screenHeight]*2) / 3);
        CGPoint waypointTwo = ccp(0, ([GameScene screenHeight]*2) / 3);
        NSMutableArray *wayPoints = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithCGPoint:waypointOne],
                                                                            [NSValue valueWithCGPoint:waypointTwo]]];
        
        Enemy *enemy = [[Enemy alloc] initWithSprite:sprite
                                         andPosition:point
                                            fireType:TargetPlayer
                                        movementType:Landlocked
                                           wayPoints:wayPoints
                                              health:10
                                              damage:1
                                           fireSpeed:30
                                               speed:SCROLL_SPEED
                                            onGround:YES];
        [self.scene spawnEnemy:enemy onGround:YES];
        self.ticks = 0;
    }
}

@end
