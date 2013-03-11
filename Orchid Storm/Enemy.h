#import "Unit.h"
#import "Updateable.h"

@interface Enemy : Unit <Updateable>

typedef enum {
    Basic
} EnemyType;

@property (nonatomic) EnemyType type;
@property (nonatomic) CGPoint velocity;
@property (nonatomic) NSUInteger fireSpeed;

- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position
                type:(EnemyType)type
              health:(NSInteger)health
              damage:(NSUInteger)damage
           fireSpeed:(NSUInteger)fireSpeed
            onGround:(BOOL)onGround;
@end
