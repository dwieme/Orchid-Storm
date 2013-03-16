#import "Unit.h"

#define STARTING_HEALTH 10

@interface Player : Unit

typedef enum {
    Left, Right, Normal
} BankingState;

@property (nonatomic) BankingState bankingState;
@property (nonatomic) NSUInteger weaponType;
@property (nonatomic) NSUInteger lives;

- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position
              health:(NSInteger)health
              damage:(NSUInteger)damage
            onGround:(BOOL)onGround;

- (void)updateMovement:(float)roll;
@end
