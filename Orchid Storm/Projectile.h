#import "CCNode.h"
#import "cocos2d.h"
#import "Updateable.h"

@interface Projectile : CCNode <Updateable>
@property (nonatomic) CGPoint velocity;
@property (nonatomic) NSUInteger damage;
@property (nonatomic, strong) CCSprite *sprite;

- (id)initWithSprite:(CCSprite *)sprite
            position:(CGPoint)position
            velocity:(CGPoint)velocity
              damage:(NSUInteger)damage;
@end
