#import "Enemy.h"
#import "GameScene.h"
#import "Projectile.h"

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
                CCSprite *sprite = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *proj = [[Projectile alloc] initWithSprite:sprite
                                                             position:self.position
                                                             velocity:ccp(0, -3)
                                                               damage:self.damage
                                                         friendlyFire:NO
                                                             onGround:self.onGround];
                GameLayer *layer = (GameLayer *)[self.sprite parent];
                [layer spawnProjectile:proj];
                self.fireCounter = 0;
            }
            break;
        case TargetPlayer:
        {
           
            
            if (self.fireCounter >= self.fireSpeed && self.position.y > GameScene.screenHeight/3.0)
            {
                Unit *player = ((GameScene*)self.sprite.parent.parent).player;
                
                CGPoint v = ccp(player.position.x - self.position.x ,player.position.y - self.position.y);
                float mag = sqrt(v.x*v.x + v.y*v.y);
                v = ccp(v.x * ((self.speed * 1.5)/mag),v.y * ((self.speed * 1.5)/mag));
                CCSprite *sprite = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *proj = [[Projectile alloc] initWithSprite:sprite
                                                             position:self.position
                                                             velocity:v
                                                               damage:self.damage
                                                         friendlyFire:NO
                                                             onGround:self.onGround];
                GameLayer *layer = (GameLayer *)[self.sprite parent];
                [layer spawnProjectile:proj];
                self.fireCounter = 0;
            }
            
            break;
        }
        case TargetPoint:
            break;
        case Spread:
            break;
    }
    
    switch (self.movementType) {
        case Landlocked:
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
                CCLOG(@"%f  %f",self.velocity.x,self.velocity.y);
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
