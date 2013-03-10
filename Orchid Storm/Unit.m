#import "Unit.h"

@implementation Unit

- (id)init
{
    return [super init];
}

- (void)update
{
    self.sprite.position = ccp(self.position.x, self.position.y);
}

- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position
{
    if(self = [self init])
    {
        self.sprite = sprite;
        self.position = position;
        self.sprite.position = ccp(self.position.x, self.position.y);
    }
    
    return self;
}

@end
