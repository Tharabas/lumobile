//
//  THEffects.m
//  frutris
//
//  Created by Benjamin Schüttler on 15.08.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import "THEffects.h"
#import "cocos2d_extensions.h"

@implementation THEffects

@synthesize setUp, tearDown, show, hide, delay, displayTime, cleanupAfterRun;

-(id)init {
  if (!(self = [super init])) return nil;
  
  cleanupAfterRun = YES;
  
  return self;
}

-(void)dealloc {
  [setUp release];
  [tearDown release];
  [show release];
  [hide release];
  [super dealloc];
}

-(id)chain {
  return [self chainWithDelay:delay displayTime:displayTime];
}

-(id)chainWithDelay:(ccTime)_delay displayTime:(ccTime)_displayTime {
  id re = ccWait(_displayTime);
  
  if (show) re = ccSeq(show, re);
  if (delay) re = ccSeq(ccWait(_delay), re);
  if (setUp) re = ccSeq(setUp, re);
  
  if (hide) re = ccSeq(re, hide);
  if (tearDown) re = ccSeq(re, tearDown);
  if (cleanupAfterRun) re = ccSeq(re, ccRemove(YES));
  
  return re;
}

-(THEffects *)withDelay:(ccTime)_delay {
  self.delay = _delay;
  return self;
}

-(THEffects *)withSetup:(id)effects {
  if (!self.setUp) self.setUp = effects;
  else self.setUp = ccSpawn(self.setUp, effects);
  return self;
}

-(THEffects *)then:(id)effects {
  if (!self.tearDown) self.tearDown = effects;
  else self.tearDown = ccSeq(self.tearDown, effects);
  return self;
}

#pragma mark -

+(THEffects *)fx {
  return [[[self alloc] init] autorelease];
}

#pragma mark -

static inline CGPoint rel(CGFloat x, CGFloat y) {
  return THMultiplyPointBySize(ccp(x, y), [[CCDirector sharedDirector] winSize]);
}

+(THEffects *)dropEffect {
  return [self dropEffectWithOffset:CGPointZero];
}

+(THEffects *)dropEffectWithOffset:(CGPoint)offset {
  // move in from top
  // dissolve downwards
  THEffects *re = [THEffects fx];
  
  re.setUp = ccCallbackN(^(CCNode *node) {
    node.position = rel(.5, 1.2);
  });
  re.show = ccEase(BounceOut, [CCMoveTo actionWithDuration:.5 position:ccpAdd(rel(.5,.5), offset)]);
  re.hide = ccSeq(ccEase(SineIn, [CCMoveTo actionWithDuration:0.3 position:rel(.5, -.2)]), 
                  [CCFadeOut actionWithDuration:0.3]);
  
  return re;
}

+(THEffects *)numSlide {
  return [self numSlideWithOffset:CGPointZero];
}

+(THEffects *)numSlideWithOffset:(CGPoint)offset {
  // move from left to right
  // shrink on the edges, but not too much
  
  THEffects *re = [THEffects fx];

  id startLeft = [CCMoveTo actionWithDuration:0.01 position:ccpAdd(rel(-0.2, 0.5), offset)];
  id startSmall = [CCScaleTo actionWithDuration:0.01 scale:.5];
  re.setUp = ccSpawn(startLeft, startSmall);

  id moveToCenter = ccEase(SineOut, [CCMoveTo actionWithDuration:0.3 position:ccpAdd(rel(.5,.5), offset)]);
  id grow = [CCScaleTo actionWithDuration:0.3 scale:1.0];
  re.show = ccSpawn(moveToCenter, grow);

  id moveOutRight = ccEase(SineIn, [CCMoveTo actionWithDuration:0.3 position:ccpAdd(rel(1.2, .5), offset)]);
  id shrink = [CCScaleTo actionWithDuration:0.3 scale:0.5];
  re.hide = ccSpawn(moveOutRight, shrink);
  
  return re;
}


@end
