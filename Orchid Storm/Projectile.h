#import "CCNode.h"
#import "cocos2d.h"
#import "Updateable.h"
#import "Unit.h"

@interface Projectile : Unit <Updateable>
@property (nonatomic) CGPoint velocity;
@property (nonatomic) BOOL friendlyFire;

- (id)initWithSprite:(CCSprite *)sprite
            position:(CGPoint)position
            velocity:(CGPoint)velocity
              damage:(NSUInteger)damage
        friendlyFire:(BOOL)friendlyFire
            onGround:(BOOL)onGround;
@end
