#import "Unit.h"

@interface Powerup : Unit

typedef enum {
    Health, Life, Weapon
} PowerupType;

- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position
              health:(NSInteger)health
              damage:(NSUInteger)damage
            onGround:(BOOL)onGround
                type:(PowerupType)type;

@property (nonatomic) PowerupType type;

@end
