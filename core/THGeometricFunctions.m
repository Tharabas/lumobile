//
//  THGeometricFunctions.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 19.11.09.
//  Copyright 2012 Benjamin Schüttler Softwareentwicklung. All rights reserved.
//

#import "THGeometricFunctions.h"

NSNumber *iNum(NSInteger i) {
  return [NSNumber numberWithInt:i];
}

NSNumber *uNum(NSUInteger ui) {
  return [NSNumber numberWithUnsignedInt:ui];
}

NSNumber *fNum(CGFloat f) {
  return [NSNumber numberWithFloat:f];
}

NSNumber *dNum(double d) {
  return [NSNumber numberWithDouble:d];
}

NSRange THMakeRange(NSUInteger min, NSUInteger max) {
  NSUInteger loc = MIN(min, max);
  NSUInteger len = MAX(min, max) - loc + 1;
  return NSMakeRange(loc, len);
}

//
// 2D Functions
//

inline CGFloat THLengthOfPoint(CGPoint pt) {
  return sqrt(pt.x * pt.x + pt.y * pt.y);
  //return ABS(pt.x) + ABS(pt.y);
}

inline CGFloat THAreaOfSize(CGSize size) {
  return size.width * size.height;
}

inline CGFloat THAreaOfRect(CGRect rect) {
  return THAreaOfSize(rect.size);
}

//
// CGPoint result functions
//
inline CGPoint THPointFromSize(CGSize size) {
  return CGPointMake(size.width, size.height);
}

inline CGPoint THAbsPoint(CGPoint point) {
  return CGPointMake(ABS(point.x), ABS(point.y));
}

inline CGPoint THFloorPoint(CGPoint point) {
  return CGPointMake(floor(point.x), floor(point.y));
}

inline CGPoint THCeilPoint(CGPoint point) {
  return CGPointMake(ceil(point.x), ceil(point.y));
}

inline CGPoint THRoundPoint(CGPoint point) {
  return CGPointMake(round(point.x), round(point.y));
}

inline CGPoint THNegatePoint(CGPoint point) {
  return CGPointMake(-point.x, -point.y);
}

inline CGPoint THInvertPoint(CGPoint point) {
  return CGPointMake(1 / point.x, 1 / point.y);
}

inline CGPoint THSwapPoint(CGPoint point) {
  return CGPointMake(point.y, point.x);
}

inline CGPoint THAddPoints(CGPoint one, CGPoint another) {
  return CGPointMake(one.x + another.x, one.y + another.y);
}

inline CGPoint THSubtractPoints(CGPoint origin, CGPoint subtrahend) {
  return CGPointMake(origin.x - subtrahend.x, origin.y - subtrahend.y);
}

inline CGPoint THSumPoints(NSUInteger count, CGPoint point, ...) {
  CGPoint re = point;
  
  va_list pts;
  va_start(pts, point);
  
  for (int i = 0; i < count; i++) {
    CGPoint pt = va_arg(pts, CGPoint);
    re.x += pt.x;
    re.y += pt.y;
  }
  
  va_end(pts);
  
  return re;
}

inline CGPoint THMultiplyPoint(CGPoint point, CGFloat multiplier) {
  return CGPointMake(point.x * multiplier, point.y * multiplier);
}

inline CGPoint THMultiplyPointByPoint(CGPoint one, CGPoint another) {
  return CGPointMake(one.x * another.x, one.y * another.y);
}

inline CGPoint THMultiplyPointBySize(CGPoint one, CGSize size) {
  return CGPointMake(one.x * size.width, one.y * size.height);
}

inline CGPoint THRelativeToAbsolutePoint(CGPoint relative, CGRect bounds) {
  return CGPointMake(relative.x * bounds.size.width  + bounds.origin.x,
                     relative.y * bounds.size.height + bounds.origin.y
                     );
}

inline CGPoint THAbsoluteToRelativePoint(CGPoint absolute, CGRect bounds) {
  return CGPointMake((absolute.x - bounds.origin.x) / bounds.size.width, 
                     (absolute.y - bounds.origin.y) / bounds.size.height
                     );
}

inline CGPoint THDividePoint(CGPoint point, CGFloat divisor) {
  return CGPointMake(point.x / divisor, point.y / divisor);
}

inline CGPoint THDividePointByPoint(CGPoint point, CGPoint divisor) {
  return CGPointMake(point.x / divisor.x, point.y / divisor.y);
}

inline CGPoint THDividePointBySize(CGPoint point, CGSize divisor) {
  return CGPointMake(point.x / divisor.width, point.y / divisor.height);
}


CGPoint THMovePoint(CGPoint origin, CGPoint target, CGFloat p) {
  // delta = distance fom target to origin
  CGPoint delta = THSubtractPoints(target, origin);
  // multiply that with the relative distance
  CGPoint way   = THMultiplyPoint(delta, p);
  // add it to the origin to move along the way
  return THAddPoints(origin, way);
}

CGPoint THMovePointAbs(CGPoint origin, CGPoint target, CGFloat pixels) {
  // Distance from target to origin
  CGPoint delta = THSubtractPoints(target, origin);
  // normalize that by x to recieve the x2y-ratio
  // but wait, if x is 0 already it can not be normalized
  if (delta.x == 0) {
    // in this case check whether y is empty too
    if (delta.y == 0) {
      // cannot move anywhere
      return origin;
    }
    return CGPointMake(origin.x, 
                       origin.y + pixels * (delta.y > 0 ? 1.0 : -1.0));
  }
  // now, grab the normalized way
  CGFloat ratio = delta.y / delta.x;
  CGFloat x = pixels / sqrt(1.0 + ratio * ratio);
  if (delta.x < 0) x *= -1;
  CGPoint move = CGPointMake(x, x * ratio);
  return THAddPoints(origin, move);
}

inline CGPoint THCenterOfRect(CGRect rect) {
  // simple math, just the center of the rect
  return CGPointMake(rect.origin.x + rect.size.width  * 0.5, 
                     rect.origin.y + rect.size.height * 0.5);
}

inline CGPoint THCenterOfSize(CGSize size) {
  return CGPointMake(size.width  * 0.5, 
                     size.height * 0.5);
}

inline CGPoint THEndOfRect(CGRect rect) {
  return CGPointMake(rect.origin.x + rect.size.width,
                     rect.origin.y + rect.size.height);
}


/*
 *   +-------+
 *   |       |   
 *   |   a   |   +-------+
 *   |       |   |       |
 *   +-------+   |   b   |
 *               |       |
 *               +-------+
 */
inline CGPoint THCenterDistanceOfRects(CGRect a, CGRect b) {
  return THSubtractPoints(THCenterOfRect(a),
                          THCenterOfRect(b));
}

CGPoint THBorderDistanceOfRects(CGRect a, CGRect b) {
  // 
  // +------------ left
  // |
  // |     +------ right  
  // v     v
  // +-----+ <---- top
  // |     |
  // +-----+ <---- bottom
  //
  
  // distances, always from ones part to anothers counterpart
  // a zero x or y indicated that the rects overlap in that dimension
  CGPoint re = CGPointZero;
  
  CGPoint oa = a.origin;
  CGPoint ea = THEndOfRect(a);
  
  CGPoint ob = b.origin;
  CGPoint eb = THEndOfRect(b);
  
  // calculate the x and y separately

  // left / right check
  if (ea.x < ob.x) {
    // [a] [b] --- a left of b
    // positive re.x
    re.x = ob.x - ea.x;
  } else if (oa.x > eb.x) {
    // [b] [a] --- a right of b
    // negative re.x
    re.x = eb.x - oa.x;
  }
  
  // top / bottom check
  if (ea.y < ob.y) {
    // [a] --- a above b
    // [b]
    // positive re.y
    re.y = ob.y - ea.y;
  } else if (oa.y > eb.y) {
    // [b] --- a below b
    // [a]
    // negative re.y
    re.y = eb.y - oa.y;
  }
  
  return re;
}

CGPoint THNormalizedDistanceOfRects(CGRect from, CGRect to) {
  CGSize mul = THInvertSize(THBlendSizes(from.size, to.size, 0.5));
  CGPoint re = THCenterDistanceOfRects(to, from);
          re = THMultiplyPointBySize(re, mul);

  return re;
}

CGPoint THNormalizedDistanceToCenterOfRect(CGPoint point, CGRect rect) {
  CGPoint center = THCenterOfRect(rect);
  CGPoint half   = THMultiplyPoint(THPointFromSize(rect.size), 0.5);
  CGPoint re     = THSubtractPoints(point, center);
          re     = THMultiplyPointByPoint(re, half);
  
  return re;
}

CGPoint THPointDistanceToBorderOfRect(CGPoint point, CGRect rect) {
  CGPoint re = CGPointZero;
  
  CGPoint o = rect.origin;
  CGPoint e = THEndOfRect(rect);
  
  if (point.x < o.x) {
    re.x = point.x - re.x;
  } else if (point.x > e.x) {
    re.x = e.x - point.x;
  }
  
  if (point.y < o.y) {
    re.y = point.y - re.y;
  } else if (point.y > e.y) {
    re.y = e.y - point.y;
  }

  return re;
}

//
// CGSize functions
//

inline CGSize THSizeFromPoint(CGPoint point) {
  return CGSizeMake(point.x, point.y);
}

inline CGSize THAbsSize(CGSize size) {
  return CGSizeMake(ABS(size.width), ABS(size.height));
}

inline CGSize THAddSizes(CGSize one, CGSize another) {
  return CGSizeMake(one.width + another.width, 
                    one.height + another.height);
}

inline CGSize THInvertSize(CGSize size) {
  return CGSizeMake(1 / size.width, 1 / size.height);
}

inline CGSize THRatioOfSizes(CGSize inner, CGSize outer) {
  return CGSizeMake(inner.width / outer.width, 
                    inner.height / outer.height);
}

inline CGSize THMultiplySize(CGSize size, CGFloat multiplier) {
  return CGSizeMake(size.width * multiplier, 
                    size.height * multiplier);
}

inline CGSize THMultiplySizeBySize(CGSize size, CGSize another) {
  return CGSizeMake(size.width * another.width, 
                    size.height * another.height);
}

inline CGSize THMultiplySizeByPoint(CGSize size, CGPoint point) {
  return CGSizeMake(size.width * point.x, 
                    size.height * point.y);
}

inline CGSize THBlendSizes(CGSize one, CGSize another, CGFloat p) {
  CGSize way;
  way.width  = another.width - one.width;
  way.height = another.height - one.height;
  
  return CGSizeMake(one.width + p * way.width, 
                    one.height + p * way.height);
}

inline CGSize THSizeMax(CGSize one, CGSize another) {
  return CGSizeMake(MAX(one.width, another.width),
                    MAX(one.height, another.height));
}

inline CGSize THSizeMin(CGSize one, CGSize another) {
  return CGSizeMake(MIN(one.width, another.width),
                    MIN(one.height, another.height));
  
}

inline CGSize THSizeBound(CGSize preferred, CGSize minSize, CGSize maxSize) {
  CGSize re = preferred;
  
  re.width  = MIN(MAX(re.width,  minSize.width),  maxSize.width);
  re.height = MIN(MAX(re.height, minSize.height), maxSize.height);
  
  return re;
}


//
// CGRect result functions
//
inline CGRect THMakeRectFromPoint(CGPoint point) {
  return CGRectMake(point.x, point.y, 0, 0);
}

inline CGRect THMakeRectFromSize(CGSize size) {
  return CGRectMake(0, 0, size.width, size.height);
}

inline CGRect THMakeRect(CGPoint point, CGSize size) {
  return CGRectMake(point.x, 
                    point.y, 
                    size.width, 
                    size.height);
}

inline CGRect THMakeSquare(CGPoint center, CGFloat radius) {
  return CGRectMake(center.x - radius, 
                    center.y - radius, 
                    2 * radius, 
                    2 * radius);
}


inline CGRect THMultiplyRectBySize(CGRect rect, CGSize size) {
  return CGRectMake(rect.origin.x    * size.width,
                    rect.origin.y    * size.height,
                    rect.size.width  * size.width,
                    rect.size.height * size.height
                    );
}

inline CGRect THRelativeToAbsoluteRect(CGRect relative, CGRect bounds) {
  return CGRectMake(relative.origin.x    * bounds.size.width  + bounds.origin.x,
                    relative.origin.y    * bounds.size.height + bounds.origin.y,
                    relative.size.width  * bounds.size.width,
                    relative.size.height * bounds.size.height
                    );
}

inline CGRect THAbsoluteToRelativeRect(CGRect a, CGRect b) {
  return CGRectMake((a.origin.x - b.origin.x) / b.size.width,
                    (a.origin.y - b.origin.y) / b.size.height,
                    a.size.width  / b.size.width,
                    a.size.height / b.size.height
                    );
}

inline CGRect THPositionRectOnRect(CGRect inner, CGRect outer, CGPoint position) {
  return CGRectMake(outer.origin.x 
                    + (outer.size.width - inner.size.width) * position.x, 
                    outer.origin.y 
                    + (outer.size.height - inner.size.height) * position.y, 
                    inner.size.width, 
                    inner.size.height
                    );
}

inline CGRect THCenterRectOnPoint(CGRect rect, CGPoint center) {
  return CGRectMake(center.x - rect.size.width  / 2, 
                    center.y - rect.size.height / 2, 
                    rect.size.width, 
                    rect.size.height);
}

inline CGRect THCenterRectOnRect(CGRect inner, CGRect outer) {
  return THPositionRectOnRect(inner, outer, THHalfPoint);
}

inline CGRect THSquareAround(CGPoint center, CGFloat distance) {
  return CGRectMake(center.x - distance, 
                    center.y - distance, 
                    2 * distance, 
                    2 * distance
                    );
}

CGRect THBlendRects(CGRect from, CGRect to, CGFloat p) {
  CGRect re;

  CGFloat q = 1 - p;
  re.origin.x    = from.origin.x    * q + to.origin.x    * p;
  re.origin.y    = from.origin.y    * q + to.origin.y    * p;
  re.size.width  = from.size.width  * q + to.size.width  * p;
  re.size.height = from.size.height * q + to.size.height * p;

  return re;
}

inline CGRect THLeftEdge(CGRect rect, CGFloat width) {
  return CGRectMake(rect.origin.x, 
                    rect.origin.y, 
                    width, 
                    rect.size.height);
}

inline CGRect THRightEdge(CGRect rect, CGFloat width) {
  return CGRectMake(rect.origin.x + rect.size.width - width, 
                    rect.origin.y, 
                    width, 
                    rect.size.height);
}

inline CGRect THLowerEdge(CGRect rect, CGFloat height) {
  return CGRectMake(rect.origin.x, 
                    rect.origin.y, 
                    rect.size.width, 
                    height);
}

inline CGRect THUpperEdge(CGRect rect, CGFloat height) {
  return CGRectMake(rect.origin.x, 
                    rect.origin.y + rect.size.height - height, 
                    rect.size.width, 
                    height);
}

//
// Comparison Methods
//

inline BOOL THIsPointLeftOfRect(CGPoint point, CGRect rect) {
  return THPointDistanceToBorderOfRect(point, rect).x < 0;
}

inline BOOL THIsPointRightOfRect(CGPoint point, CGRect rect) {
  return THPointDistanceToBorderOfRect(point, rect).x > 0;
}

inline BOOL THIsPointAboveRect(CGPoint point, CGRect rect) {
  return THPointDistanceToBorderOfRect(point, rect).y < 0;
}

inline BOOL THIsPointBelowRect(CGPoint point, CGRect rect) {
  return THPointDistanceToBorderOfRect(point, rect).y > 0;
}

inline BOOL THIsRectLeftOfRect(CGRect rect, CGRect compare) {
  return THNormalizedDistanceOfRects(rect, compare).x <= -1;
}

inline BOOL THIsRectRightOfRect(CGRect rect, CGRect compare) {
  return THNormalizedDistanceOfRects(rect, compare).x >= 1;
}

inline BOOL THIsRectAboveRect(CGRect rect, CGRect compare) {
  return THNormalizedDistanceOfRects(rect, compare).y <= -1;
}

inline BOOL THIsRectBelowRect(CGRect rect, CGRect compare) {
  return THNormalizedDistanceOfRects(rect, compare).y >= 1;
}

//
// EOF
//

