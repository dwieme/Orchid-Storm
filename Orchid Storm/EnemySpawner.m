#import "EnemySpawner.h"
#import "GameScene.h"
#import "Enemy.h"

#define TICKS_THRESHOLD 300

@interface EnemySpawner ()
@property (nonatomic) NSUInteger ticks;
@end

@implementation EnemySpawner

- (id)init
{
    if(self = [super init])
    {
        _ticks = 0;
        _shouldSpawnEnemy = NO;
    }
    
    return self;
}

- (void)update
{
    ++self.ticks;
    if (self.ticks == TICKS_THRESHOLD)
    {
        self.shouldSpawnEnemy = YES;
        self.ticks = 0;
    }
}

- (Enemy *)spawnEnemy
{
    CGPoint point = ccp([GameScene screenWidth] * 0.5, [GameScene screenHeight]);
    CCSprite *sprite = [[CCSprite alloc] initWithFile:@"monster.png"];
    Enemy *enemy = [[Enemy alloc] initWithSprite:sprite
                                     andPosition:point
                                     type:Basic];
    return enemy;
}

@end
