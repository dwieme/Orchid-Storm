#import "HUDLayer.h"

@interface HUDLayer ()
@property (nonatomic, strong) NSMutableArray *lives;
@property (nonatomic, strong) NSMutableArray *health;
@property (nonatomic) NSUInteger hp;
@property (nonatomic) NSUInteger livs;
@end

@implementation HUDLayer

- (id)init
{
    if(self = [super init]) {
        _lives = [[NSMutableArray alloc] initWithCapacity:3];
        _health = [[NSMutableArray alloc] initWithCapacity:STARTING_HEALTH];
        
        _hp = STARTING_HEALTH;
        _livs = 3;
        
        for(int i = 0; i < 3; i++){
            _lives[i] = [[CCSprite alloc] initWithFile:@"lives.png"];
            [_lives[i] setPosition:ccp([GameScene screenWidth] - 20 - 30*i,10)];
            [self addChild:(_lives[i])];
        }
        for(int i = 0; i < STARTING_HEALTH; i++){
            _health[i] = [[CCSprite alloc] initWithFile:@"health.png"];
            [_health[i] setPosition:ccp(10+ 10*i,10)];
            [_health[i] setScale: 0.5];
            [self addChild:(_health[i])];
        }
    }
    
    return self;
}

- (void)updateWithPlayer:(Player *)player
{
    if(player.lives != self.livs){
        for(int i = 0; i < 3; i++){
            if(i < player.lives){
                [self.lives[i] setVisible:YES];
            }
            else{
                [self.lives[i] setVisible:NO];
            }
        }
        self.livs = player.lives;
    }
    if(player.health != self.hp){
        for(int i = 0; i < STARTING_HEALTH; i++){
            if(i < player.health){
                [self.health[i] setVisible:YES];
            }
            else{
                [self.health[i] setVisible:NO];
            }
        }
        self.hp = player.health;
    }
}

@end
