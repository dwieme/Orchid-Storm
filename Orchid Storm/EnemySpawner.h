#import "Updateable.h"
#import "Enemy.h"

#import <Foundation/Foundation.h>

@interface EnemySpawner : NSObject <Updateable>
@property (nonatomic) BOOL shouldSpawnEnemy;

- (Enemy *)spawnEnemy;
@end
