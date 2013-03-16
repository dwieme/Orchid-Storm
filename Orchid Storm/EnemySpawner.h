#import "Updateable.h"

@class GameScene;

@interface EnemySpawner : NSObject <Updateable>
- (id)initWithScene:(GameScene *)scene;
@end
