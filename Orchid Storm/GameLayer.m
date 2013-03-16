#import "GameLayer.h"

#define PLAYER_NOSE 20

@interface GameLayer ()
@end

@implementation GameLayer

- (NSMutableArray *)enemies
{
    if(!_enemies) _enemies = [[NSMutableArray alloc] init];
    return _enemies;
}

- (void)onEnter
{
    [super onEnter];
}

- (void)addUnit:(Unit *)unit
{
    if([unit isMemberOfClass:[Enemy class]])
    {
        [self.enemies addObject:(Enemy *)unit];
    }
    
    [self addChild:unit.sprite];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    GameScene *parent = (GameScene *)[self parent];
    if(self.isGround == parent.player.onGround && parent.player.health>0 && parent.playerState != Landing && parent.playerState != TakingOff )
    {
        int spriteId = 7;
        switch (parent.player.damage) {
            case 1:
                spriteId = 7;
                break;
            
            case 2:
                spriteId = 8;
                break;
                
            case 3:
                spriteId = 11;
                break;
                
            case 4:
                spriteId = 10;
                break;
                
            case 5:
                spriteId = 6;
                break;
                
            case 6:
                spriteId = 9;
                break;
                
            default:
                spriteId = 5;
                break;
        }
        switch(parent.player.weaponType){
            case 1:
            {
                Projectile *proj = [[Projectile alloc] initWithSprite:spriteId
                                                 position:ccp(parent.player.position.x, parent.player.position.y +PLAYER_NOSE)
                                                 velocity:ccp(0, 5)
                                                   damage:parent.player.damage
                                             friendlyFire:YES
                                                 onGround:parent.player.onGround];
                [proj.sprite setScale:2];
                [self spawnProjectile:proj];
                break;
            }
            case 2:
            {
                Projectile *proj = [[Projectile alloc] initWithSprite:spriteId
                                                 position:ccp(parent.player.position.x+5, parent.player.position.y +PLAYER_NOSE)
                                                 velocity:ccp(0, 5)
                                                   damage:parent.player.damage
                                             friendlyFire:YES
                                                 onGround:parent.player.onGround];
                [self spawnProjectile:proj];
                Projectile *projTwo= [[Projectile alloc] initWithSprite:spriteId
                                                 position:ccp(parent.player.position.x-5, parent.player.position.y +PLAYER_NOSE)
                                                 velocity:ccp(0, 5)
                                                   damage:parent.player.damage
                                             friendlyFire:YES
                                                 onGround:parent.player.onGround];
                [self spawnProjectile:projTwo];
                break;
            }
            case 3:
            {
                Projectile *proj = [[Projectile alloc] initWithSprite:spriteId
                                                             position:ccp(parent.player.position.x, parent.player.position.y +PLAYER_NOSE)
                                                             velocity:ccp(0, 5)
                                                               damage:parent.player.damage
                                                         friendlyFire:YES
                                                             onGround:parent.player.onGround];
                [self spawnProjectile:proj];
                
                Projectile *projTwo= [[Projectile alloc] initWithSprite:spriteId
                                                               position:ccp(parent.player.position.x+5, parent.player.position.y +PLAYER_NOSE)
                                                               velocity:ccp(1, 4)
                                                                 damage:parent.player.damage
                                                           friendlyFire:YES
                                                               onGround:parent.player.onGround];
                [projTwo.sprite setRotation:atanf(1/4.0)*(180/M_PI)];
                [self spawnProjectile:projTwo];
                
                Projectile *projThree= [[Projectile alloc] initWithSprite:spriteId
                                                               position:ccp(parent.player.position.x-5, parent.player.position.y +PLAYER_NOSE)
                                                               velocity:ccp(-1, 4)
                                                                 damage:parent.player.damage
                                                           friendlyFire:YES
                                                               onGround:parent.player.onGround];
                [projThree.sprite setRotation:atanf(-1/4.0)*(180/M_PI)];
                [self spawnProjectile:projThree];
                
                break;
            }
            case 4:
            {
                Projectile *proj = [[Projectile alloc] initWithSprite:spriteId
                                                             position:ccp(parent.player.position.x+5, parent.player.position.y +PLAYER_NOSE)
                                                             velocity:ccp(1, 4)
                                                               damage:parent.player.damage
                                                         friendlyFire:YES
                                                             onGround:parent.player.onGround];
                [proj.sprite setRotation:atanf(1/4.0)*(180/M_PI)];
                [self spawnProjectile:proj];
                
                Projectile *projTwo= [[Projectile alloc] initWithSprite:spriteId
                                                               position:ccp(parent.player.position.x-5, parent.player.position.y +PLAYER_NOSE)
                                                               velocity:ccp(-1, 4)
                                                                 damage:parent.player.damage
                                                           friendlyFire:YES
                                                               onGround:parent.player.onGround];
                [projTwo.sprite setRotation:atanf(-1/4.0)*(180/M_PI)];
                [self spawnProjectile:projTwo];
                
                Projectile *projThree= [[Projectile alloc] initWithSprite:spriteId
                                                                 position:ccp(parent.player.position.x+10, parent.player.position.y +PLAYER_NOSE)
                                                                 velocity:ccp(2, 3)
                                                                   damage:parent.player.damage
                                                             friendlyFire:YES
                                                                 onGround:parent.player.onGround];
                [projThree.sprite setRotation:atanf(2/3.0)*(180/M_PI)];
                [self spawnProjectile:projThree];
                
                Projectile *projFour= [[Projectile alloc] initWithSprite:spriteId
                                                                 position:ccp(parent.player.position.x-10, parent.player.position.y +PLAYER_NOSE)
                                                                 velocity:ccp(-2, 3)
                                                                   damage:parent.player.damage
                                                             friendlyFire:YES
                                                                 onGround:parent.player.onGround];
                [projFour.sprite setRotation:atanf(-2/3.0)*(180/M_PI)];
                [self spawnProjectile:projFour];
                
                break;
            }
            case 5:
            {
                Projectile *proj = [[Projectile alloc] initWithSprite:spriteId
                                                             position:ccp(parent.player.position.x+5, parent.player.position.y +PLAYER_NOSE)
                                                             velocity:ccp(1, 4)
                                                               damage:parent.player.damage
                                                         friendlyFire:YES
                                                             onGround:parent.player.onGround];
                [proj.sprite setRotation:atanf(1/4.0)*(180/M_PI)];
                [self spawnProjectile:proj];
                
                Projectile *projTwo= [[Projectile alloc] initWithSprite:spriteId
                                                               position:ccp(parent.player.position.x-5, parent.player.position.y +PLAYER_NOSE)
                                                               velocity:ccp(-1, 4)
                                                                 damage:parent.player.damage
                                                           friendlyFire:YES
                                                               onGround:parent.player.onGround];
                [projTwo.sprite setRotation:atanf(-1/4.0)*(180/M_PI)];
                [self spawnProjectile:projTwo];
                
                Projectile *projThree= [[Projectile alloc] initWithSprite:spriteId
                                                                 position:ccp(parent.player.position.x+10, parent.player.position.y +PLAYER_NOSE)
                                                                 velocity:ccp(2, 3)
                                                                   damage:parent.player.damage
                                                             friendlyFire:YES
                                                                 onGround:parent.player.onGround];
                [projThree.sprite setRotation:atanf(2/3.0)*(180/M_PI)];
                [self spawnProjectile:projThree];
                
                Projectile *projFour= [[Projectile alloc] initWithSprite:spriteId
                                                                position:ccp(parent.player.position.x-10, parent.player.position.y +PLAYER_NOSE)
                                                                velocity:ccp(-2, 3)
                                                                  damage:parent.player.damage
                                                            friendlyFire:YES
                                                                onGround:parent.player.onGround];
                [projFour.sprite setRotation:atanf(-2/3.0)*(180/M_PI)];
                [self spawnProjectile:projFour];
                
                Projectile *projFive = [[Projectile alloc] initWithSprite:spriteId
                                                             position:ccp(parent.player.position.x, parent.player.position.y +PLAYER_NOSE)
                                                             velocity:ccp(0, 5)
                                                               damage:parent.player.damage
                                                         friendlyFire:YES
                                                             onGround:parent.player.onGround];
                [self spawnProjectile:projFive];
                
                break;
            }
                
            default:
            {
                Projectile *proj = [[Projectile alloc] initWithSprite:spriteId
                                                             position:ccp(parent.player.position.x+5, parent.player.position.y +PLAYER_NOSE)
                                                             velocity:ccp(1, 4)
                                                               damage:parent.player.damage
                                                         friendlyFire:YES
                                                             onGround:parent.player.onGround];
                [proj.sprite setRotation:atanf(1/4.0)*(180/M_PI)];
                [self spawnProjectile:proj];
                
                Projectile *projTwo= [[Projectile alloc] initWithSprite:spriteId
                                                               position:ccp(parent.player.position.x-5, parent.player.position.y +PLAYER_NOSE)
                                                               velocity:ccp(-1, 4)
                                                                 damage:parent.player.damage
                                                           friendlyFire:YES
                                                               onGround:parent.player.onGround];
                [projTwo.sprite setRotation:atanf(-1/4.0)*(180/M_PI)];
                [self spawnProjectile:projTwo];
                
                Projectile *projThree= [[Projectile alloc] initWithSprite:spriteId
                                                                 position:ccp(parent.player.position.x+10, parent.player.position.y +PLAYER_NOSE)
                                                                 velocity:ccp(2, 3)
                                                                   damage:parent.player.damage
                                                             friendlyFire:YES
                                                                 onGround:parent.player.onGround];
                [projThree.sprite setRotation:atanf(2/3.0)*(180/M_PI)];
                [self spawnProjectile:projThree];
                
                Projectile *projFour= [[Projectile alloc] initWithSprite:spriteId
                                                                position:ccp(parent.player.position.x-10, parent.player.position.y +PLAYER_NOSE)
                                                                velocity:ccp(-2, 3)
                                                                  damage:parent.player.damage
                                                            friendlyFire:YES
                                                                onGround:parent.player.onGround];
                [projFour.sprite setRotation:atanf(-2/3.0)*(180/M_PI)];
                [self spawnProjectile:projFour];
                
                Projectile *projFive = [[Projectile alloc] initWithSprite:spriteId
                                                                 position:ccp(parent.player.position.x+5, parent.player.position.y +PLAYER_NOSE)
                                                                 velocity:ccp(0, 5)
                                                                   damage:parent.player.damage
                                                             friendlyFire:YES
                                                                 onGround:parent.player.onGround];
                [self spawnProjectile:projFive];
                
                Projectile *projSix = [[Projectile alloc] initWithSprite:spriteId
                                                                 position:ccp(parent.player.position.x-5, parent.player.position.y +PLAYER_NOSE)
                                                                 velocity:ccp(0, 5)
                                                                   damage:parent.player.damage
                                                             friendlyFire:YES
                                                                 onGround:parent.player.onGround];
                [self spawnProjectile:projSix];
                
                break;
            }
                
        }
        
    }
}

- (void)spawnProjectile:(Projectile *)projectile
{
    [self addChild:projectile.sprite];
    [GameScene addGameObject:projectile];
}

- (id)initWithType:(BOOL)isGround
{
    self.isGround = isGround;
    
    if(self = [super init])
    {
        self.isTouchEnabled = YES;
    }
    
    if(isGround)
    {
        CGFloat width = [GameScene screenWidth];
        CGFloat x = width * 0.5;
        
        self.backgroundOne = [[CCSprite alloc] initWithFile:@"background.png"];
        self.backgroundTwo = [[CCSprite alloc] initWithFile:@"background.png"];
        
//        [self.backgroundOne setScale:self.backgroundOne.scale * 3];
//        [self.backgroundTwo setScale:self.backgroundTwo.scale * 3];
        
        [self.backgroundOne setPosition:ccp(x,0)];
        [self.backgroundTwo setPosition:ccp(x, [self.backgroundOne boundingBox].size.height)];
        
        [self addChild:self.backgroundOne];
        [self addChild:self.backgroundTwo];
    }
    else
    {
        self.cloudOne = [[CCSprite alloc] initWithFile:@"cloud.png"];
        self.cloudTwo = [[CCSprite alloc] initWithFile:@"cloud.png"];
        self.cloudThree = [[CCSprite alloc] initWithFile:@"cloud.png"];
        self.cloudFour = [[CCSprite alloc] initWithFile:@"cloud.png"];
        
        [self.cloudOne setScale: 2];
        [self.cloudTwo setScale:2];
        [self.cloudThree setScale:2];
        [self.cloudFour setScale:2];
        
        
        [self.cloudOne setPosition:ccp(20, 0)];
        [self.cloudTwo setPosition:ccp(20, [self.cloudOne boundingBox].size.height)];
        
        [self.cloudThree setPosition:ccp([GameScene screenWidth]-20, 0)];
        [self.cloudFour setPosition:ccp([GameScene screenWidth]-20, [self.cloudOne boundingBox].size.height)];
        
        
        [self addChild:self.cloudOne];
        [self addChild:self.cloudTwo];
        [self addChild:self.cloudThree];
        [self addChild:self.cloudFour];
        
        self.visible = NO;
    }

    return self;
}

@end