//
//  THGradient.h
//  frutris
//
//  Created by Benjamin Schüttler on 01.07.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface THGradient : NSObject {
  NSArray *_colors;
  float *_colorAnchors;
}

-(UIColor *)colorAtPosition:(float)position;

+(THGradient *)gradientWithColors:(UIColor *)color,...;
+(THGradient *)gradientWithColorsFromArray:(NSArray *)colors;

@end

@interface NSString (THGradient)

-(THGradient *)gradientValue;

@end