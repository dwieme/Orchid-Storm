#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Updateable.h"

@interface Unit : CCNode <Updateable>

@property (nonatomic, strong) CCSprite *sprite;
@property (nonatomic) NSInteger health;
@property (nonatomic) NSUInteger damage;

- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position;

@end
