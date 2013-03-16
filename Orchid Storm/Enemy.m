#import "Enemy.h"
#import "Projectile.h"
#import "cocos2d.h"
#import "GameLayer.h"

@interface Enemy ()
@property (nonatomic) NSUInteger fireCounter;

@property (nonatomic) CGPoint target;

typedef enum{
    seeking,
    staying,
    targeting
}movementState;

@property (nonatomic) movementState state;

@end

@implementation Enemy

- (void)update
{
    
    ++self.fireCounter;
    
    switch (self.fireType) {
        case Dumb:
            if (self.fireCounter >= self.fireSpeed)
            {
                Unit *player = ((GameScene*)self.sprite.parent.parent).player;
                if(player.health>0 && self.onGround == player.onGround){
                
                    Projectile *proj = [[Projectile alloc] initWithSprite:10
                                                                 position:self.position
                                                                 velocity:ccp(0, -6 )
                                                                   damage:self.damage
                                                             friendlyFire:NO
                                                                 onGround:self.onGround];
                    GameLayer *layer = (GameLayer *)[self.sprite parent];
                    [proj.sprite setScale:2];
                    [layer spawnProjectile:proj];
                    self.fireCounter = 0;
                    
                }
            }
            break;
        case TargetPlayer:
        {
            if (self.fireCounter >= self.fireSpeed && self.position.y > GameScene.screenHeight/3.0)
            {
                Unit *player = ((GameScene*)self.sprite.parent.parent).player;
                if(player.health>0 && self.onGround == player.onGround){
                
                    CGPoint v = ccp(player.position.x - self.position.x ,player.position.y - self.position.y);
                    float mag = sqrt(v.x*v.x + v.y*v.y);
                    v = ccp(v.x * ((self.speed * 1.5)/mag),v.y * ((self.speed * 1.5)/mag));
                    Projectile *proj = [[Projectile alloc] initWithSprite:6
                                                                 position:self.position
                                                                 velocity:v
                                                                   damage:self.damage
                                                             friendlyFire:NO
                                                                 onGround:self.onGround];
                    GameLayer *layer = (GameLayer *)[self.sprite parent];
                    [proj.sprite setScale:2];
                    [proj.sprite setRotation:atanf(v.x/v.y)*(180/M_PI)];
                    [layer spawnProjectile:proj];
                    self.fireCounter = 0;
                }
            }
            
            break;
        }
        case TargetPoint:
            break;
        case Spread:
            break;
        case NotShooting:
            break;
    }
    
    switch (self.movementType) {
        case Landlocked:
            if (self.position.y < -30)
            {
                self.health = 0;
            }
            
            break;
        case Stationary:
        {
            
            if(self.state == targeting){
                
                NSValue *targetValue = (NSValue*)self.wayPoints[0];
                self.target = targetValue.CGPointValue;
                
                
                CGPoint d = ccp(self.target.x - self.position.x,self.target.y -self.position.y );
                float mag = sqrt(d.x*d.x + d.y*d.y);
                d = ccp(d.x * (self.speed/mag),d.y * (self.speed/mag));
                self.velocity = d;
                self.state = seeking;

            }
            else if(self.state == seeking){
                CGPoint d = ccp(self.position.x - self.target.x ,self.position.y - self.target.y);
                if(abs(d.x) < 1 && abs(d.y) < 1 ){
                    self.velocity = ccp(0,0);
                    self.state = staying;
                }
            }
            break;
        }
        case Strafe:
        {
            if(self.state == targeting){
                NSValue *targetOneValue = (NSValue*)self.wayPoints[0];
                NSValue *targetTwoValue = (NSValue*)self.wayPoints[1];
                
                if(self.target.x == (targetOneValue.CGPointValue).x &&
                   self.target.y == (targetOneValue.CGPointValue).y){
                    self.target = targetTwoValue.CGPointValue;
                }
                else{
                    self.target = targetOneValue.CGPointValue;
                }
                
                
                CGPoint d = ccp(self.target.x - self.position.x,self.target.y -self.position.y );
                float mag = sqrt(d.x*d.x + d.y*d.y);
                d = ccp(d.x * (1.0/mag),d.y * (1.0/mag));
                //do rotating here
                d = ccp(d.x * self.speed,d.y * self.speed);
                self.velocity = d;
                
                self.state = seeking;
                
            }
            else if(self.state == seeking){
                CGPoint d = ccp(self.position.x - self.target.x ,self.position.y - self.target.y);
                if(abs(d.x) < 2 && abs(d.y) < 2 ){
                    self.velocity = ccp(0,0);
                    self.state = targeting;
                }
            }
            break;
        }
        default:
            break;
    }
    
    
    self.position = ccp(self.position.x + self.velocity.x, self.position.y + self.velocity.y);
    
    
    [super update];
}

- (id)initWithSprite:(CCSprite *)sprite
         andPosition:(CGPoint)position
            fireType:(FireType)fireType
        movementType:(MovementType)movementType
           wayPoints:(NSMutableArray*)wayPoints
              health:(NSInteger)health
              damage:(NSUInteger)damage
           fireSpeed:(NSUInteger)fireSpeed
            speed:(NSUInteger)speed
            onGround:(BOOL)onGround
{
    if(self = [super initWithSprite:sprite
                        andPosition:position
                             health:health
                             damage:damage
                           onGround:onGround])
    {
        _movementType = movementType;
        _fireType = fireType;
        
        if(_movementType == Landlocked){
            
            _velocity = ccp(0, -SCROLL_SPEED);
        }
        else{
            _state = targeting;
            _velocity = ccp(0,0);
        }
        
        _wayPoints = wayPoints;
        
        _fireSpeed = fireSpeed;
        _speed = speed;
        _fireCounter = 0;
    }
    
    return self;
}

@end
