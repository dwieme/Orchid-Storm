#import "Unit.h"
#import "Updateable.h"

@interface Enemy : Unit <Updateable>

typedef enum {
    Landlocked,
    Stationary,
    Strafe
} MovementType;

typedef enum {
    Dumb,
    TargetPlayer,
    TargetPoint,
    Spread
} FireType;

@property (nonatomic) MovementType movementType;
@property (nonatomic) FireType fireType;
@property (nonatomic) CGPoint velocity;
@property (nonatomic) NSUInteger fireSpeed;
@property (nonatomic) NSUInteger speed;
@property (nonatomic, strong) NSMutableArray *wayPoints;


- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position
            fireType:(FireType)fireType
        movementType:(MovementType)movementType
           wayPoints:(NSMutableArray*)wayPoints
              health:(NSInteger)health
              damage:(NSUInteger)damage
           fireSpeed:(NSUInteger)fireSpeed
               speed:(NSUInteger)speed
            onGround:(BOOL)onGround;
@end
