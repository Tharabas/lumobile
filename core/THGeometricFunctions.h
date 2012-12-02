//
//  THGeometricFunctions.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 19.11.09.
//  Copyright 2009 Rainbow Labs UG. All rights reserved.
//

#import <Foundation/Foundation.h>

//
// shortcuts for [NSNumber numberWithXY]
//
NSNumber *iNum(NSInteger i);
NSNumber *uNum(NSUInteger ui);
NSNumber *fNum(CGFloat f);
NSNumber *dNum(double d);

//
// NSRange from a min and max values
// even though the names imply that min should be greater than max
// the order does not matter
// the range will always start at the lower value and have
// a size to reach the upper value
//
NSRange THMakeRange(NSUInteger min, NSUInteger max);

//
// Predifined Points, Sizes and Rects
//
#define THHalfPoint CGPointMake(0.5, 0.5)
#define THMaxPoint CGPointMake(MAXFLOAT, MAXFLOAT)
#define THHalfSize CGSizeMake(0.5, 0.5)
#define THMaxSize CGSizeMake(MAXFLOAT, MAXFLOAT)
#define THRelationRect CGRectMake(0, 0, 1, 1)

//
// Simple Length and Area calculus
//
CGFloat THLengthOfPoint(CGPoint pt);
CGFloat THAreaOfSize(CGSize size);
CGFloat THAreaOfRect(CGRect rect);

// Size -> Point conversion
CGPoint THPointFromSize(CGSize size);

//
// CGPoint result methods
//

// returns the absolute values of a point (pt.x >= 0, pt.y >= 0)
CGPoint THAbsPoint(CGPoint point);

// floor, ceil and round simply use those functions on both values of the point
CGPoint THFloorPoint(CGPoint point);
CGPoint THCeilPoint(CGPoint point);
CGPoint THRoundPoint(CGPoint point);

// pt.x = -pt.x, pt.y = -pt.x
CGPoint THNegatePoint(CGPoint point);

// pt.x = 1 / pt.x, pt.y = 1 / pt.y
CGPoint THInvertPoint(CGPoint point);

// exchanges both x and y values
CGPoint THSwapPoint(CGPoint point);

// sum of two points
CGPoint THAddPoints(CGPoint one, CGPoint another);

// subtracts the 2nd from the 1st point
CGPoint THSubtractPoints(CGPoint origin, CGPoint subtrahend);

// sums a list of points
CGPoint THSumPoints(NSUInteger count, CGPoint points, ...);

// multiplies both x and y with one multiplier
CGPoint THMultiplyPoint(CGPoint point, CGFloat multiplier);

// multiplies each value with its corresponding value in another point
CGPoint THMultiplyPointByPoint(CGPoint one, CGPoint another);

// multiplies each value with its corresponding value in a size
CGPoint THMultiplyPointBySize(CGPoint one, CGSize size);

// positions a relative {0-1,0-1} point within absolute bounds
CGPoint THRelativeToAbsolutePoint(CGPoint relative, CGRect bounds);

// calculates the relative {0-1,0-1} point from absolute bounds
CGPoint THAbsoluteToRelativePoint(CGPoint absolute, CGRect bounds);

CGPoint THDividePoint(CGPoint point, CGFloat divisor);
CGPoint THDividePointByPoint(CGPoint point, CGPoint divisor);
CGPoint THDividePointBySize(CGPoint point, CGSize divisor);

// moves from an origin towards the destination point
// at a distance of 1 it will reach the destination
CGPoint THMovePoint(CGPoint origin, CGPoint target, CGFloat relativeDistance);

// moves from an origin towards the destination point
// distance on that way is measured in pixels
CGPoint THMovePointAbs(CGPoint origin, CGPoint target, CGFloat pixels);

// returns the center point of a rect
CGPoint THCenterOfRect(CGRect rect);

// returns the center point of a size
CGPoint THCenterOfSize(CGSize size);

// will return the origin + size value of a rect
CGPoint THEndOfRect(CGRect rect);

// will return the average distance of two rects
CGPoint THCenterDistanceOfRects(CGRect from, CGRect to);

// will return the shortest possible distance in x and y
CGPoint THBorderDistanceOfRects(CGRect from, CGRect to);

// will return the shortes possible distance from point to rect
CGPoint THPointDistanceToBorderOfRect(CGPoint point, CGRect rect);

CGPoint THNormalizedDistanceOfRects(CGRect from, CGRect to);

CGPoint THNormalizedDistanceToCenterOfRect(CGPoint point, CGRect rect);

//
// CGSize result methods
// 

// converts a point to a size
CGSize THSizeFromPoint(CGPoint point);

// ABS on both values of the size
CGSize THAbsSize(CGSize size);

// Adds the width and height of two sizes
CGSize THAddSizes(CGSize one, CGSize another);

// subtracts the subtrahends dimensions from the ones of the size
CGSize THSubtractSizes(CGSize size, CGSize subtrahend);

// returns 1 / value on both values of the size
CGSize THInvertSize(CGSize size);

// will return the ratio of an inner size to an outer size
CGSize THRatioOfSizes(CGSize inner, CGSize outer);

// will multiply a size by a single multiplier
CGSize THMultiplySize(CGSize size, CGFloat multiplier);

// will multiply a size by another size
CGSize THMultiplySizeBySize(CGSize size, CGSize another);

// will multiply a size by a point
CGSize THMultiplySizeByPoint(CGSize size, CGPoint point);

// blends one size towards another
// percentage == 0 -> one
// percentage == 1 -> another
// @see THMovePoint
CGSize THBlendSizes(CGSize one, CGSize another, CGFloat percentage);

CGSize THSizeMax(CGSize one, CGSize another);
CGSize THSizeMin(CGSize one, CGSize another);
CGSize THSizeBound(CGSize preferred, CGSize minSize, CGSize maxSize);

//
// CGRect result methods
//

// returns a zero sized rect with the argumented point as origin
CGRect THMakeRectFromPoint(CGPoint point);

// returns a zero point origin with the argumented size
CGRect THMakeRectFromSize(CGSize size);

// just another way of defining a rect
CGRect THMakeRect(CGPoint point, CGSize size);

// creates a square rect around a center point
CGRect THMakeSquare(CGPoint center, CGFloat radius);

CGRect THMultiplyRectBySize(CGRect rect, CGSize size);

// transforms a relative rect to an absolute within absolute bounds
CGRect THRelativeToAbsoluteRect(CGRect relative, CGRect bounds);

// transforms an absolute rect to a relative rect within absolute bounds
CGRect THAbsoluteToRelativeRect(CGRect absolute, CGRect bounds);

CGRect THPositionRectOnRect(CGRect inner, CGRect outer, CGPoint position);

// moves the origin of the rect
CGRect THCenterRectOnPoint(CGRect rect, CGPoint center);

// returns the innter rect with its posiion centeredn on the outer rect
CGRect THCenterRectOnRect(CGRect inner, CGRect outer);

// will a square rect with a given center
CGRect THSquareAround(CGPoint center, CGFloat distance);

// blends a rect from one to another
CGRect THBlendRects(CGRect from, CGRect to, CGFloat at);

// returns a rect at the left edge of a rect with a given inset width
CGRect THLeftEdge(CGRect rect, CGFloat width);

// returns a rect at the right edge of a rect with a given inset width
CGRect THRightEdge(CGRect rect, CGFloat width);

// returns a rect at the lower edge of a rect with a given inset width
CGRect THLowerEdge(CGRect rect, CGFloat height);

// returns a rect at the upper edge of a rect with a given inset width
CGRect THUpperEdge(CGRect rect, CGFloat height);

// macro to call a border drawing method with a border width
// this will effectively draw the border but clip the inner rect
//
// Example: THInsideClip(NSDrawLightBezel, rect, 2);
//          Will draw a 2px light beezel around a rect
#define THInsideClip(METHOD,RECT,BORDER) \
  METHOD(RECT, THLeftEdge( RECT, BORDER)); \
  METHOD(RECT, THRightEdge(RECT, BORDER)); \
  METHOD(RECT, THUpperEdge(RECT, BORDER)); \
  METHOD(RECT, THLowerEdge(RECT, BORDER))

//
// Comparison methods
//

BOOL THIsPointLeftOfRect(CGPoint point, CGRect rect);
BOOL THIsPointRightOfRect(CGPoint point, CGRect rect);
BOOL THIsPointAboveRect(CGPoint point, CGRect rect);
BOOL THIsPointBelowRect(CGPoint point, CGRect rect);

BOOL THIsRectLeftOfRect(CGRect rect, CGRect compare);
BOOL THIsRectRightOfRect(CGRect rect, CGRect compare);
BOOL THIsRectAboveRect(CGRect rect, CGRect compare);
BOOL THIsRectBelowRect(CGRect rect, CGRect compare);

//
// EOF
// 
