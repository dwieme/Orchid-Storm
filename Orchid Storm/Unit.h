#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Unit : CCNode

@property (nonatomic, strong) CCSprite *sprite;
@property (nonatomic) NSInteger health;
@property (nonatomic) NSUInteger damage;

- (id)initWithSprite:(CCSprite *)sprite;

@end
