//
//  cocos2d_extension.m
//  frutris
//
//  Created by Benjamin Schüttler on 30.06.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import "cocos2d_extensions.h"

inline BOOL lucky(float percentage) {
  if (percentage <= 0.0) return NO;
  if (percentage >= 1.0) return YES;
  return arc4random_uniform(ceil(1.0 / percentage)) == 0;
}

#pragma mark -

void ccGetRectCorners(CGPoint* points, CGRect rect) {
  // pt 0
  points[0] = rect.origin;
  
  // pt 1
  points[1] = points[0];
  points[1].y += rect.size.height;
  
  // pt 2
  points[2] = points[1];
  points[2].x += rect.size.width;
  
  // pt 3
  points[3] = points[2];
  points[3].y = rect.origin.y;
}

void ccGetPolyCorners(CGPoint* cornerPoints, NSUInteger corners, float radius, float rotation) {
  // do not render less than 3-corner-polys
  if (corners <= 2) return;
  
  float segmentArc = 360.0 / corners;
  for (int i = 0; i < corners; i++) {
    float deg = (rotation + i * segmentArc) * 180.0 * M_PI;
    cornerPoints[i] = ccp(radius * cos(deg), radius * sin(deg));
  }
}

void ccMovePoly(CGPoint* poly, NSUInteger points, CGPoint add) {
  for (int i = 0; i < points; i++) {
    poly[i].x += add.x;
    poly[i].y += add.y;
  }
}

void ccDrawRectangle(CGRect rect, ccColor4F color) {
  CGPoint points[4];
  ccGetRectCorners(points, rect);
  ccDrawSolidPoly(points, 4, color);
}

void ccDrawFrame(CGRect rect, CGFloat width, ccColor4F color) {
  glLineWidth(width);
  ccDrawColor4F(color.r, color.g, color.b, color.a);
  CGPoint points[4];
  ccGetRectCorners(points, rect);
  ccDrawPoly(points, 4, YES);
}
