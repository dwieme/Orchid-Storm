#import "Updateable.h"
#import "Unit.h"

@class GameScene;

@interface Projectile : Unit <Updateable>
@property (nonatomic) CGPoint velocity;
@property (nonatomic) BOOL friendlyFire;

- (id)initWithSprite:(int)spriteIndex
            position:(CGPoint)position
            velocity:(CGPoint)velocity
              damage:(NSUInteger)damage
        friendlyFire:(BOOL)friendlyFire
            onGround:(BOOL)onGround;

+ (void) initSpriteSheetForScene:(GameScene *)scene;

@end
