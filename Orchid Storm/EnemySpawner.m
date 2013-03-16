#import "EnemySpawner.h"
#import "GameScene.h"
#import "cocos2d.h"
#import "GameLayer.h"

#define NUM_ENEMY_IDS 10

@interface EnemySpawner ()
@property (nonatomic) NSUInteger ticks;
@property (nonatomic) NSUInteger level;
@property (nonatomic, strong) GameScene *scene;
@end

@implementation EnemySpawner

- (id)initWithScene:(GameScene *)scene
{
    if(self = [super init])
    {
        _ticks = 0;
        _scene = scene;
        _level = 1;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"saucer.plist"];
        CCSpriteBatchNode *saucerSprites = [CCSpriteBatchNode batchNodeWithFile:@"saucer.png"];
        [self.scene.skyLayer addChild:saucerSprites];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"heliglider.plist"];
        CCSpriteBatchNode *heliSprites = [CCSpriteBatchNode batchNodeWithFile:@"heliglider.png"];
        [self.scene.skyLayer addChild:heliSprites];
    }
    
    return self;
}

- (void)update
{
    ++self.ticks;
    if(self.ticks>=1800){
        self.level +=1;
        self.ticks = 0;
    }
    [self updateGround];
    [self updateSky];
    
}
-(void)updateGround
{
    
    if (self.ticks % (200-self.level*20) ==0)
    {
        int rand = arc4random()%4;
        switch(rand)
        {
            case 0:
                [self spawnRandDumbTurret:self.level damage:self.level attackSpeed:(120/self.level)];
                break;
            case 1:
                [self spawnRandHover:self.level damage:self.level attackSpeed:(120/self.level)];
                break;
            case 2:
                [self spawnRandSmartJeep:self.level damage:self.level attackSpeed:(120/self.level)];
                break;
            case 3:
                [self spawnRandSmartTurret:self.level damage:self.level attackSpeed:(120/self.level)];
                break;
        }       
    }
}
-(void)updateSky
{
    if (self.ticks % (200-self.level*20)==0)
    {
        int rand = arc4random()%3;
        switch(rand)
        {
            case 0:
                [self spawnRandSaucer:self.level damage:self.level attackSpeed:(120/self.level)];
                
                break;
            case 1:
                [self spawnRandCopter:self.level damage:self.level attackSpeed:(120/self.level)];
               
                break;
            case 2:
                [self spawnRandJet:self.level damage:self.level attackSpeed:(120/self.level)];
                break;
            case 3:
                //[self spawnRandSmartTurret:self.level damage:self.level attackSpeed:(300/self.level)];
                break;
        }
    }
}
-(void)spawnRandDumbTurret:(int)hp damage:(int)damage attackSpeed:(int)attackSpeed
{
    //CGPoint waypointOne = ccp(arc4random() % (int)[GameScene screenWidth], arc4random() % (int)[GameScene screenHeight]);
    //CGPoint waypointTwo = ccp(arc4random() % (int)[GameScene screenWidth], arc4random() % (int)[GameScene screenHeight]);
    //NSMutableArray *wayP = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithCGPoint:waypointOne],[NSValue valueWithCGPoint:waypointTwo]]];
    
    CGPoint pos = ccp(arc4random() % (int)[GameScene screenWidth], [GameScene screenHeight]+30);
    
    Enemy *enemy = [[Enemy alloc] initWithSprite:[[CCSprite alloc] initWithFile:@"turret.png"]
                                     andPosition:pos
                                        fireType:Dumb
                                    movementType:Landlocked
                                       wayPoints:nil
                                          health:hp
                                          damage:damage
                                       fireSpeed:attackSpeed
                                           speed:SCROLL_SPEED
                                        onGround:YES];
    [self.scene spawnEnemy:enemy onGround:YES];
}

-(void)spawnRandSmartTurret:(int)hp damage:(int)damage attackSpeed:(int)attackSpeed
{
    //CGPoint waypointOne = ccp(arc4random() % (int)[GameScene screenWidth], arc4random() % (int)[GameScene screenHeight]);
    //CGPoint waypointTwo = ccp(arc4random() % (int)[GameScene screenWidth], arc4random() % (int)[GameScene screenHeight]);
    //NSMutableArray *wayP = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithCGPoint:waypointOne],[NSValue valueWithCGPoint:waypointTwo]]];
    
    CGPoint pos = ccp(arc4random() % (int)[GameScene screenWidth], [GameScene screenHeight]+30);
    
    Enemy *enemy = [[Enemy alloc] initWithSprite:[[CCSprite alloc] initWithFile:@"turret.png"]
                                     andPosition:pos
                                        fireType:TargetPlayer
                                    movementType:Landlocked
                                       wayPoints:nil
                                          health:hp
                                          damage:damage
                                       fireSpeed:attackSpeed
                                           speed:SCROLL_SPEED
                                        onGround:YES];
    [self.scene spawnEnemy:enemy onGround:YES];
}

-(void)spawnRandDumbJeep:(int)hp damage:(int)damage attackSpeed:(int)attackSpeed
{
    CGPoint pos = ccp(arc4random() % (int)[GameScene screenWidth], [GameScene screenHeight]+30);
    CGPoint waypointOne = ccp(pos.x, [GameScene screenHeight]*(0.66));
    NSMutableArray *wayP = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithCGPoint:waypointOne]]];
    
    Enemy *enemy = [[Enemy alloc] initWithSprite:[[CCSprite alloc] initWithFile:@"jeep.png"]
                                     andPosition:pos
                                        fireType:Dumb
                                    movementType:Stationary
                                       wayPoints:wayP
                                          health:hp
                                          damage:damage
                                       fireSpeed:attackSpeed
                                           speed:SCROLL_SPEED
                                        onGround:YES];
    [self.scene spawnEnemy:enemy onGround:YES];
}
-(void)spawnRandSmartJeep:(int)hp damage:(int)damage attackSpeed:(int)attackSpeed
{
    CGPoint pos = ccp(arc4random() % (int)[GameScene screenWidth], [GameScene screenHeight]+30);
    CGPoint waypointOne = ccp(pos.x, [GameScene screenHeight]*(0.66));
    NSMutableArray *wayP = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithCGPoint:waypointOne]]];
    
    Enemy *enemy = [[Enemy alloc] initWithSprite:[[CCSprite alloc] initWithFile:@"jeep.png"]
                                     andPosition:pos
                                        fireType:TargetPlayer
                                    movementType:Stationary
                                       wayPoints:wayP
                                          health:hp
                                          damage:damage
                                       fireSpeed:attackSpeed
                                           speed:SCROLL_SPEED
                                        onGround:YES];
    [self.scene spawnEnemy:enemy onGround:YES];
}
-(void)spawnRandHover:(int)hp damage:(int)damage attackSpeed:(int)attackSpeed
{
    CGPoint pos = ccp(arc4random() % (int)[GameScene screenWidth], [GameScene screenHeight]+30);
    CGPoint waypointOne = ccp(arc4random() % (int)[GameScene screenWidth], (arc4random() % (int)([GameScene screenHeight]*2/3.0))+([GameScene screenHeight]/3.0));
    CGPoint waypointTwo = ccp(arc4random() % (int)[GameScene screenWidth], (arc4random() % (int)([GameScene screenHeight]*2/3.0))+([GameScene screenHeight]/3.0));
    NSMutableArray *wayP = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithCGPoint:waypointOne],[NSValue valueWithCGPoint:waypointTwo]]];
    
    Enemy *enemy = [[Enemy alloc] initWithSprite:[[CCSprite alloc] initWithFile:@"hovercraft.png"]
                                     andPosition:pos
                                        fireType:TargetPlayer
                                    movementType:Strafe
                                       wayPoints:wayP
                                          health:hp
                                          damage:damage
                                       fireSpeed:attackSpeed
                                           speed:SCROLL_SPEED
                                        onGround:YES];
    [self.scene spawnEnemy:enemy onGround:YES];
}
-(void)spawnRandSaucer:(int)hp damage:(int)damage attackSpeed:(int)attackSpeed
{
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 0; i <= 7; ++i)
    {
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Psionic Saucer%04d", i]]];
    }
    CCAnimation *anim = [CCAnimation animationWithSpriteFrames:animFrames delay:0.01f];
    
    CGPoint pos = ccp(arc4random() % (int)[GameScene screenWidth], [GameScene screenHeight]+30);
    CGPoint waypointOne = ccp(arc4random() % (int)[GameScene screenWidth], (arc4random() % (int)([GameScene screenHeight]*2/3.0))+([GameScene screenHeight]/3.0));
    CGPoint waypointTwo = ccp(arc4random() % (int)[GameScene screenWidth], (arc4random() % (int)([GameScene screenHeight]*2/3.0))+([GameScene screenHeight]/3.0));
    NSMutableArray *wayP = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithCGPoint:waypointOne],[NSValue valueWithCGPoint:waypointTwo]]];
    
    Enemy *enemy = [[Enemy alloc] initWithSprite:[CCSprite spriteWithSpriteFrameName:@"Psionic Saucer0000"]
                                     andPosition:pos
                                        fireType:TargetPlayer
                                    movementType:Strafe
                                       wayPoints:wayP
                                          health:hp
                                          damage:damage
                                       fireSpeed:attackSpeed
                                           speed:SCROLL_SPEED
                                        onGround:NO];
    [self.scene spawnEnemy:enemy onGround:NO];
    
    [enemy.sprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:anim]]];
}
-(void)spawnRandCopter:(int)hp damage:(int)damage attackSpeed:(int)attackSpeed
{
    NSMutableArray *animFrames = [NSMutableArray array];
    for(int i = 0; i <= 8; ++i)
    {
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"HeliGlider%04d", i]]];
    }
    CCAnimation *anim = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
    
    CGPoint pos = ccp(arc4random() % (int)[GameScene screenWidth], [GameScene screenHeight]+30);
    CGPoint waypointOne = ccp(arc4random() % (int)[GameScene screenWidth], (arc4random() % (int)([GameScene screenHeight]*2/3.0))+([GameScene screenHeight]/3.0));

    NSMutableArray *wayP = [[NSMutableArray alloc] initWithArray:@[[NSValue valueWithCGPoint:waypointOne]]];
    
    Enemy *enemy = [[Enemy alloc] initWithSprite:[CCSprite spriteWithSpriteFrameName:@"HeliGlider0000"]
                                     andPosition:pos
                                        fireType:TargetPlayer
                                    movementType:Stationary
                                       wayPoints:wayP
                                          health:hp
                                          damage:damage
                                       fireSpeed:attackSpeed
                                           speed:SCROLL_SPEED
                                        onGround:NO];
    [self.scene spawnEnemy:enemy onGround:NO];
    
    [enemy.sprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:anim]]];
}
-(void)spawnRandJet:(int)hp damage:(int)damage attackSpeed:(int)attackSpeed
{
    
    CGPoint pos = ccp(arc4random() % (int)[GameScene screenWidth], [GameScene screenHeight]+30);
    
    Enemy *enemy = [[Enemy alloc] initWithSprite:[[CCSprite alloc] initWithFile:@"fighter.png"]
                                     andPosition:pos
                                        fireType:Dumb
                                    movementType:Landlocked
                                       wayPoints:nil
                                          health:hp
                                          damage:damage
                                       fireSpeed:attackSpeed
                                           speed:SCROLL_SPEED
                                        onGround:NO];
    [self.scene spawnEnemy:enemy onGround:NO];
}

@end
