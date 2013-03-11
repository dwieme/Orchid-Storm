#import "Updateable.h"
#import "Enemy.h"
#import "GameScene.h"

#import <Foundation/Foundation.h>

@interface EnemySpawner : NSObject <Updateable>
- (id)initWithScene:(GameScene *)scene;
@end
