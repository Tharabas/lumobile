//
//  UIColor+TH.h
//  TK-Suite
//
//  Created by Benjamin Schüttler on 17.05.11.
//  Copyright 2011 Rainbow Labs UG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (TH)

@property (readonly) NSString *hexValue;
@property (readonly) CGFloat redComponent;
@property (readonly) CGFloat greenComponent;
@property (readonly) CGFloat blueComponent;
@property (readonly) CGFloat alphaComponent;

@property (readonly) CGFloat *components;
@property (readonly) CGFloat *rgba;
@property (readonly) CGFloat *rgb;

-(BOOL)getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue;
// no more need for this, has been added to iOS 5.0 lib
//-(BOOL)getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha;

@property (readonly) CGFloat relativeBrightness;
@property (readonly, getter=isDark) BOOL dark;
@property (readonly, getter=isBright) BOOL bright;

@property (readonly) UIColor *textColor;

@property (readonly) UIColor *translucent;
@property (readonly) UIColor *watermark;

-(UIColor *)blendedColorWithFraction:(CGFloat)fraction ofColor:(UIColor *)color;

+(UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+(UIColor *)colorWithRGB:(NSUInteger)colorDefinition;
+(UIColor *)colorWithARGB:(NSUInteger)colorDefinition;

+(UIColor *)colorWithName:(NSString *)colorName;
+(UIColor *)colorFromString:(NSString *)string;
+(UIColor *)colorFromHexString:(NSString *)hexString;

+(UIColor *)blueInputColor;

@end

@interface NSString (UIColor_TH)

-(UIColor *)colorValue;

@end

@interface THWebNamedColors : NSObject {
  NSMutableDictionary *colors;
}

+(THWebNamedColors *)webNamedColors;

-(UIColor *)colorWithName:(NSString *)name;
-(void)setColor:(UIColor *)color forName:(NSString *)name;

@end


