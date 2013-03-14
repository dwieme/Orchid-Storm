#import "GameLayer.h"
#import "Unit.h"
#import "Player.h"
#import "Enemy.h"
#import "Projectile.h"
#import "GameScene.h"

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
    if(self.isGround == parent.player.onGround)
    {
        switch(parent.player.weaponType){
            case 1:
            {
                CCSprite *sprite = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *proj = [[Projectile alloc] initWithSprite:sprite
                                                 position:ccp(parent.player.position.x, parent.player.position.y +5)
                                                 velocity:ccp(0, 5)
                                                   damage:parent.player.damage
                                             friendlyFire:YES
                                                 onGround:parent.player.onGround];
                [self spawnProjectile:proj];
                break;
            }
            case 2:
            {
                CCSprite *sprite = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *proj = [[Projectile alloc] initWithSprite:sprite
                                                 position:ccp(parent.player.position.x+5, parent.player.position.y +5)
                                                 velocity:ccp(0, 5)
                                                   damage:parent.player.damage
                                             friendlyFire:YES
                                                 onGround:parent.player.onGround];
                [self spawnProjectile:proj];
                CCSprite *spriteTwo = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projTwo= [[Projectile alloc] initWithSprite:spriteTwo
                                                 position:ccp(parent.player.position.x-5, parent.player.position.y +5)
                                                 velocity:ccp(0, 5)
                                                   damage:parent.player.damage
                                             friendlyFire:YES
                                                 onGround:parent.player.onGround];
                [self spawnProjectile:projTwo];
                break;
            }
            case 3:
            {
                CCSprite *sprite = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *proj = [[Projectile alloc] initWithSprite:sprite
                                                             position:ccp(parent.player.position.x, parent.player.position.y +5)
                                                             velocity:ccp(0, 5)
                                                               damage:parent.player.damage
                                                         friendlyFire:YES
                                                             onGround:parent.player.onGround];
                [self spawnProjectile:proj];
                
                CCSprite *spriteTwo = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projTwo= [[Projectile alloc] initWithSprite:spriteTwo
                                                               position:ccp(parent.player.position.x+5, parent.player.position.y +5)
                                                               velocity:ccp(1, 4)
                                                                 damage:parent.player.damage
                                                           friendlyFire:YES
                                                               onGround:parent.player.onGround];
                [self spawnProjectile:projTwo];
                
                CCSprite *spriteThree = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projThree= [[Projectile alloc] initWithSprite:spriteThree
                                                               position:ccp(parent.player.position.x-5, parent.player.position.y +5)
                                                               velocity:ccp(-1, 4)
                                                                 damage:parent.player.damage
                                                           friendlyFire:YES
                                                               onGround:parent.player.onGround];
                [self spawnProjectile:projThree];
                
                break;
            }
            case 4:
            {
                CCSprite *sprite = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *proj = [[Projectile alloc] initWithSprite:sprite
                                                             position:ccp(parent.player.position.x+5, parent.player.position.y +5)
                                                             velocity:ccp(1, 4)
                                                               damage:parent.player.damage
                                                         friendlyFire:YES
                                                             onGround:parent.player.onGround];
                [self spawnProjectile:proj];
                
                CCSprite *spriteTwo = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projTwo= [[Projectile alloc] initWithSprite:spriteTwo
                                                               position:ccp(parent.player.position.x-5, parent.player.position.y +5)
                                                               velocity:ccp(-1, 4)
                                                                 damage:parent.player.damage
                                                           friendlyFire:YES
                                                               onGround:parent.player.onGround];
                [self spawnProjectile:projTwo];
                
                CCSprite *spriteThree = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projThree= [[Projectile alloc] initWithSprite:spriteThree
                                                                 position:ccp(parent.player.position.x+10, parent.player.position.y +5)
                                                                 velocity:ccp(2, 3)
                                                                   damage:parent.player.damage
                                                             friendlyFire:YES
                                                                 onGround:parent.player.onGround];
                [self spawnProjectile:projThree];
                
                CCSprite *spriteFour = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projFour= [[Projectile alloc] initWithSprite:spriteFour
                                                                 position:ccp(parent.player.position.x-10, parent.player.position.y +5)
                                                                 velocity:ccp(-2, 3)
                                                                   damage:parent.player.damage
                                                             friendlyFire:YES
                                                                 onGround:parent.player.onGround];
                [self spawnProjectile:projFour];
                
                break;
            }
            case 5:
            {
                CCSprite *sprite = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *proj = [[Projectile alloc] initWithSprite:sprite
                                                             position:ccp(parent.player.position.x+5, parent.player.position.y +5)
                                                             velocity:ccp(1, 4)
                                                               damage:parent.player.damage
                                                         friendlyFire:YES
                                                             onGround:parent.player.onGround];
                [self spawnProjectile:proj];
                
                CCSprite *spriteTwo = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projTwo= [[Projectile alloc] initWithSprite:spriteTwo
                                                               position:ccp(parent.player.position.x-5, parent.player.position.y +5)
                                                               velocity:ccp(-1, 4)
                                                                 damage:parent.player.damage
                                                           friendlyFire:YES
                                                               onGround:parent.player.onGround];
                [self spawnProjectile:projTwo];
                
                CCSprite *spriteThree = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projThree= [[Projectile alloc] initWithSprite:spriteThree
                                                                 position:ccp(parent.player.position.x+10, parent.player.position.y +5)
                                                                 velocity:ccp(2, 3)
                                                                   damage:parent.player.damage
                                                             friendlyFire:YES
                                                                 onGround:parent.player.onGround];
                [self spawnProjectile:projThree];
                
                CCSprite *spriteFour = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projFour= [[Projectile alloc] initWithSprite:spriteFour
                                                                position:ccp(parent.player.position.x-10, parent.player.position.y +5)
                                                                velocity:ccp(-2, 3)
                                                                  damage:parent.player.damage
                                                            friendlyFire:YES
                                                                onGround:parent.player.onGround];
                [self spawnProjectile:projFour];
                
                CCSprite *spriteFive = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projFive = [[Projectile alloc] initWithSprite:spriteFive
                                                             position:ccp(parent.player.position.x, parent.player.position.y +5)
                                                             velocity:ccp(0, 5)
                                                               damage:parent.player.damage
                                                         friendlyFire:YES
                                                             onGround:parent.player.onGround];
                [self spawnProjectile:projFive];
                
                break;
            }
                
            default:
            {
                CCSprite *sprite = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *proj = [[Projectile alloc] initWithSprite:sprite
                                                             position:ccp(parent.player.position.x+5, parent.player.position.y +5)
                                                             velocity:ccp(1, 4)
                                                               damage:parent.player.damage
                                                         friendlyFire:YES
                                                             onGround:parent.player.onGround];
                [self spawnProjectile:proj];
                
                CCSprite *spriteTwo = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projTwo= [[Projectile alloc] initWithSprite:spriteTwo
                                                               position:ccp(parent.player.position.x-5, parent.player.position.y +5)
                                                               velocity:ccp(-1, 4)
                                                                 damage:parent.player.damage
                                                           friendlyFire:YES
                                                               onGround:parent.player.onGround];
                [self spawnProjectile:projTwo];
                
                CCSprite *spriteThree = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projThree= [[Projectile alloc] initWithSprite:spriteThree
                                                                 position:ccp(parent.player.position.x+10, parent.player.position.y +5)
                                                                 velocity:ccp(2, 3)
                                                                   damage:parent.player.damage
                                                             friendlyFire:YES
                                                                 onGround:parent.player.onGround];
                [self spawnProjectile:projThree];
                
                CCSprite *spriteFour = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projFour= [[Projectile alloc] initWithSprite:spriteFour
                                                                position:ccp(parent.player.position.x-10, parent.player.position.y +5)
                                                                velocity:ccp(-2, 3)
                                                                  damage:parent.player.damage
                                                            friendlyFire:YES
                                                                onGround:parent.player.onGround];
                [self spawnProjectile:projFour];
                
                CCSprite *spriteFive = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projFive = [[Projectile alloc] initWithSprite:spriteFive
                                                                 position:ccp(parent.player.position.x+5, parent.player.position.y +5)
                                                                 velocity:ccp(0, 5)
                                                                   damage:parent.player.damage
                                                             friendlyFire:YES
                                                                 onGround:parent.player.onGround];
                [self spawnProjectile:projFive];
                
                CCSprite *spriteSix = [[CCSprite alloc] initWithFile:@"projectile.png"];
                Projectile *projSix = [[Projectile alloc] initWithSprite:spriteSix
                                                                 position:ccp(parent.player.position.x-5, parent.player.position.y +5)
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
        CGFloat height = [GameScene screenHeight];
        CGFloat x = width * 0.5;
        CGFloat y = height * 0.5;
        
        self.backgroundOne = [[CCSprite alloc] initWithFile:@"scrolling-background.png"];
        self.backgroundTwo = [[CCSprite alloc] initWithFile:@"scrolling-background.png"];
        
        [self.backgroundOne setScale:self.backgroundOne.scale * 3];
        [self.backgroundTwo setScale:self.backgroundTwo.scale * 3];
        
        [self.backgroundOne setPosition:ccp(x,y)];
        [self.backgroundTwo setPosition:ccp(x, self.backgroundOne.position.y + [self.backgroundOne boundingBox].size.height)];
        
        [self addChild:self.backgroundOne];
        [self addChild:self.backgroundTwo];
    }
    else
    {
        self.visible = NO;
    }

    return self;
}

@end