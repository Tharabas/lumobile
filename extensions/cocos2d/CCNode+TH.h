//
//  CCNode+TH.h
//  frutris
//
//  Created by Benjamin Schüttler on 29.05.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"
#import "cocos2d_extensions.h"

@interface CCNode (TH)

-(CGPoint)pointAtAnchor:(CGPoint)anchor;

-(CGPoint)distanceToAnchor:(CGPoint)anchor;
-(void)setPositionWithDistance:(CGPoint)distance toAnchor:(CGPoint)anchor;

@property (nonatomic,readwrite,assign) CGPoint relativePosition;

//
// the following properties have to be seen as distances
// to the corresponding relative points in the screen
//
// setters actually move the position of the node
// and getter return the distance to that point
//

@property (nonatomic,readwrite,assign) CGPoint center;
@property (nonatomic,readwrite,assign) CGPoint topLeft;
@property (nonatomic,readwrite,assign) CGPoint topRight;
@property (nonatomic,readwrite,assign) CGPoint bottomLeft;
@property (nonatomic,readwrite,assign) CGPoint bottomRight;

@property (nonatomic,readwrite,assign) float centerX;
@property (nonatomic,readwrite,assign) float centerY;
@property (nonatomic,readwrite,assign) float top;
@property (nonatomic,readwrite,assign) float bottom;
@property (nonatomic,readwrite,assign) float left;
@property (nonatomic,readwrite,assign) float right;

-(id)pulse;
-(id)pulseWithDuration:(ccTime)pulseTime;
-(id)pulseWithDuration:(ccTime)pulseTime toScale:(float)scale;
-(id)pulseWithDuration:(ccTime)pulseTime toScale:(float)scale repetitions:(NSUInteger)repetitions;

@end
