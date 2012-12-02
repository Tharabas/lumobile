//
//  CCNode+TH.m
//  frutris
//
//  Created by Benjamin Schüttler on 29.05.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import "CCNode+TH.h"

static inline CGPoint invert_x(CGPoint orig) {
  return CGPointMake(-orig.x, orig.y);
}

static inline CGPoint invert_y(CGPoint orig) {
  return CGPointMake(orig.x, -orig.y);
}

@implementation CCNode (TH)

#pragma mark -
#pragma mark Positioning

-(CGPoint)pointAtAnchor:(CGPoint)anchor {
  CGSize size = [[CCDirector sharedDirector] winSize];
  return THMultiplyPointBySize(anchor, size);
}

-(CGPoint)distanceToAnchor:(CGPoint)anchor {
  return ccpSub(self.position, [self pointAtAnchor:anchor]);
}

-(void)setPositionWithDistance:(CGPoint)distance toAnchor:(CGPoint)anchor {
  CGSize size = [[CCDirector sharedDirector] winSize];
  CGPoint pt = THMultiplyPointBySize(anchor, size);
  self.position = ccpAdd(pt, distance);
//  NSLog(@"Setting position (%.f, %.f) to (%.2f, %2f) => (%.2f, %2f)",
//        distance.x, distance.y,
//        anchor.x, anchor.y,
//        self.position.x, self.position.y);
}

-(CGPoint)relativePosition {
  CGSize size = [[CCDirector sharedDirector] winSize];
  return THDividePointBySize(self.position, size);
}

-(void)setRelativePosition:(CGPoint)pt {
  CGSize size = [[CCDirector sharedDirector] winSize];
  self.position = THMultiplyPointBySize(pt, size);
}

-(void)setCenter:(CGPoint)center {
  [self setPositionWithDistance:center toAnchor:ccp(.5,.5)];
}

-(CGPoint)center {
  return [self distanceToAnchor:ccp(.5,.5)];
}

-(void)setTopLeft:(CGPoint)topLeft {
  [self setPositionWithDistance:invert_y(topLeft) toAnchor:ccp(0, 1)];
}

-(CGPoint)topLeft {
  return invert_y([self distanceToAnchor:ccp(0, 1)]);
}

-(void)setTopRight:(CGPoint)topRight {
  [self setPositionWithDistance:invert_x(invert_y(topRight)) toAnchor:ccp(1, 1)];
}

-(CGPoint)topRight {
  return invert_x(invert_y([self distanceToAnchor:ccp(1, 1)]));
}

// alias for position
-(void)setBottomLeft:(CGPoint)bottomLeft {
  self.position = bottomLeft;
}

-(CGPoint)bottomLeft {
  return self.position;
}

-(void)setBottomRight:(CGPoint)bottomRight {
  [self setPositionWithDistance:invert_x(bottomRight) toAnchor:ccp(1, 0)];
}

-(CGPoint)bottomRight {
  return invert_x([self distanceToAnchor:ccp(1, 0)]);
}

//
// single positional property getter/setter
//

-(void)setCenterX:(float)centerX {
  self.center = CGPointMake(centerX, self.center.y);
}

-(float)centerX {
  return self.center.x;
}

-(void)setCenterY:(float)centerY {
  self.center = CGPointMake(self.center.x, centerY);
}

-(float)centerY {
  return self.center.y;
}

-(float)top {
  return self.topLeft.x;
}

-(void)setTop:(float)top {
  self.topLeft = CGPointMake(self.position.x, top);
}

-(float)bottom {
  return self.position.y;
}

-(void)setBottom:(float)bottom {
  self.position = CGPointMake(self.position.x, bottom);
}

-(float)left {
  return self.position.x;
}

-(void)setLeft:(float)left {
  self.position = CGPointMake(left, self.position.y);
}

-(float)right {
  return self.bottomRight.x;
}

-(void)setRight:(float)right {
  self.bottomRight = CGPointMake(right, self.position.y);
}

#pragma mark -
#pragma mark Effects

-(id)pulse {
  return [self pulseWithDuration:1.0];
}

-(id)pulseWithDuration:(ccTime)pulseTime {
  return [self pulseWithDuration:pulseTime toScale:1.5];
}

-(id)pulseWithDuration:(ccTime)pulseTime toScale:(float)scale {
  return [self pulseWithDuration:pulseTime toScale:scale repetitions:NSNotFound];
}

-(id)pulseWithDuration:(ccTime)pulseTime toScale:(float)scale repetitions:(NSUInteger)repetitions {
  if (repetitions == 0) return nil;

  float originalScale = self.scale;
  id grow = [CCScaleTo actionWithDuration:pulseTime * .5 scale:scale];
  id shrink = [CCScaleTo actionWithDuration:pulseTime * .5 scale:originalScale];
  
  id pulse = ccSeq(grow, shrink);
  if (repetitions == NSNotFound) {
    pulse = ccLoop(pulse);
  } else {
    pulse = ccRepeat(pulse, repetitions);
  }
  
  [self runAction:pulse];
  
  return pulse;
}


@end
