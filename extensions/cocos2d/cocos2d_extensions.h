//
//  cosos2d_extensions.h
//  fruitris
//
//  Created by Benjamin Schüttler on 09.04.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import "CCNode+TH.h"
#import "CCLabelTTF+TH.h"
#import "CCMenuItem+TH.h"

// Simple Audio Engine Effect
#define SFX(N) [[SimpleAudioEngine sharedEngine] playEffect:[@#N stringByAppendingString:@".mp3"]]

// cocos2d stuff
#define ccMenu(...)   [CCMenu menuWithItems:__VA_ARGS__, nil]

// action macros
#define ccSeq(...)    [CCSequence actions:__VA_ARGS__, nil]
#define ccSpawn(...)  [CCSpawn actions:__VA_ARGS__, nil]
#define ccWait(N)     [CCDelayTime actionWithDuration:N]
#define ccEase(TYPE, ACTION) [CCEase##TYPE actionWithAction:ACTION]
#define ccRepeat(ACTION, TIMES) [CCRepeat actionWithAction: ACTION times: TIMES]
#define ccLoop(ACTION) [CCRepeatForever actionWithAction: ACTION]

#define ccCallback(BLOCK) [CCCallBlock actionWithBlock: BLOCK]
#define ccCallbackN(BLOCK) [CCCallBlockN actionWithBlock: BLOCK]
#define ccRemove(CLEANUP) [CCCallBlockN actionWithBlock:^(CCNode *node) { [node removeFromParentAndCleanup:CLEANUP]; }]
#define ccSFX(NAME) ccCallback(^{ SFX(NAME); })

// transition as well
#define ccTransition(TYPE, DURATION, SCENE) [CCTransition##TYPE transitionWithDuration:DURATION scene:SCENE]

// sprite stuff
#define ccImage(NAME) [CCSprite spriteWithFile:[@#NAME stringByAppendingString:@".png"]];
#define ccImageJPG(NAME) [CCSprite spriteWithFile:[@#NAME stringByAppendingString:@".jpg"]];

#define IS_HD (CC_CONTENT_SCALE_FACTOR() == 2)
#define IS_SD (CC_CONTENT_SCALE_FACTOR() == 1)

// returns YES when the random value is <= percentage
BOOL lucky(float percentage);

// drawing extensions
void ccGetRectCorners(CGPoint* cornerPoints, CGRect rect);
void ccGetPolyCorners(CGPoint* cornerPoints, NSUInteger corners, float radius, float rotation);

void ccMovePoly(CGPoint* poly, NSUInteger points, CGPoint add);

void ccDrawRectangle(CGRect rect, ccColor4F color);
void ccDrawFrame(CGRect rect, CGFloat width, ccColor4F color);

