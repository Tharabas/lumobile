//
//  THGradient.m
//  frutris
//
//  Created by Benjamin Schüttler on 01.07.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import "THGradient.h"
#import "NSArray+TH.h"
#import "UIColor+TH.h"

@implementation THGradient

-(id)init {
  self = [super init];
  
  return self;
}

-(void)dealloc {
  free(_colorAnchors);
  [_colors release];
  [super dealloc];
}

-(UIColor *)colorAtPosition:(float)position {
  NSUInteger cc = _colors.count;
  if (cc == 0) return [UIColor whiteColor];
  if (cc == 1 || position <= 0.0) return [_colors objectAtIndex:0];
  if (position >= 1.0) return [_colors lastObject];

  UIColor *fromColor = nil, *toColor = nil;
  float partPosition = 0.0;
  
  // determine position
  if (_colorAnchors) {
    
  } else {
    // equal distribution
    float partSpace = 1.0 / (cc - 1);
    int index = floor(position / partSpace);
    partPosition = (position - index * partSpace) / partSpace;
    fromColor = [_colors objectAtIndex:index];
    toColor = [_colors objectAtIndex:index + 1];
  }
  
  return [fromColor blendedColorWithFraction:partPosition ofColor:toColor];
}

#pragma mark -

+(THGradient *)gradientWithColors:(UIColor *)color,... {
  NSMutableArray *colors = [NSMutableArray array];
  
  va_list args;
  va_start(args, color);
  
  while ((color = va_arg(args, UIColor*)) != nil) {
    [colors addObject:color];
  }
  va_end(args);
  
  return [self gradientWithColorsFromArray:colors];
}

+(THGradient *)gradientWithColorsFromArray:(NSArray *)colors {
  THGradient *re = [[[self alloc] init] autorelease];
  re->_colors = [[NSArray alloc] initWithArray:colors];
  return re;
}

@end

@implementation NSString (THGradient)

-(THGradient *)gradientValue {
  NSArray *splitted = [self componentsSeparatedByString:@";"];
  NSArray *colors = [splitted map:^(id o) { 
    return [o colorValue]; 
  }];
  return [THGradient gradientWithColorsFromArray:colors];
}

@end