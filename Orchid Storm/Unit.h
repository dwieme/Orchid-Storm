#import "Updateable.h"
#import "CCNode.h"

@class CCSprite;

@interface Unit : CCNode <Updateable>

@property (nonatomic, strong) CCSprite *sprite;
@property (nonatomic) NSInteger health;
@property (nonatomic) NSUInteger damage;
@property (nonatomic) BOOL onGround;

- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position
              health:(NSInteger)health
              damage:(NSUInteger)damage
            onGround:(BOOL)onGround;

@end
