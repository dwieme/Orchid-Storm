#import "Unit.h"

@interface Enemy : Unit

typedef enum {
    Basic
} EnemyType;

@property (nonatomic) EnemyType type;

- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position
                type:(EnemyType)type;
@end
