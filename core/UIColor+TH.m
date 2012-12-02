//
//  UIColor+TH.m
//  TK-Suite
//
//  Created by Benjamin Schüttler on 17.05.11.
//  Copyright 2011 Rainbow Labs UG. All rights reserved.
//

#import "lumobile.h"
#import "UIColor+TH.h"

@implementation UIColor (TH)

-(NSString *)hexValue {
  //CGColorRef ref = self.CGColor;
  //CGColorSpaceRef space = CGColorGetColorSpace(ref);

  //for now assume RGBA ColorSpace
  CGFloat *rgba = self.rgba;
  
  return $(@"RGBA(%.f%%, %.f%%, %.f%%, %.f%%)", 
           rgba[0] * 100, 
           rgba[1] * 100, 
           rgba[2] * 100, 
           rgba[3] * 100
           );
}

-(CGFloat)redComponent {
  return self.rgba[0];
}

-(CGFloat)greenComponent {
  return self.rgba[1];
}

-(CGFloat)blueComponent {
  return self.rgba[2];
}

-(CGFloat)alphaComponent {
  return self.rgba[3];
}

-(CGFloat *)components {
  return (CGFloat *)CGColorGetComponents(self.CGColor);
}

-(CGFloat *)rgba {
  return self.components;
}

-(CGFloat *)rgb {
  return self.components;
}

-(BOOL)getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue {
  CGFloat alpha;
  [self getRed:red green:green blue:blue alpha:&alpha];
  return YES;
}

//-(BOOL)getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
//  CGColorRef ref = self.CGColor;
//  size_t num = CGColorGetNumberOfComponents(ref);
//  const CGFloat *rgba = CGColorGetComponents(ref);
//  
//  if (num == 1) {
//    *red   = rgba[0];
//    *green = rgba[0];
//    *blue  = rgba[0];
//    *alpha = 1.0;
//  } else if (num >= 3) {
//    *red   = rgba[0];
//    *green = rgba[1];
//    *blue  = rgba[2];
//    if (num >= 4) {
//      *alpha = rgba[3];
//    } else {
//      *alpha = 1.0;
//    }
//  }
//  
//  return YES;
//}

-(CGFloat)relativeBrightness {
  CGFloat r, g, b;
  [self getRed:&r green:&g blue:&b];
  CGFloat re = sqrt((r * r * 0.241) + (g * g * 0.691) + (b * b * 0.068));
  return re;
}

-(BOOL)isDark {
  return self.relativeBrightness < 0.42;
}

-(BOOL)isBright {
  return !self.isDark;
}

-(UIColor *)textColor {
  return self.isDark ? [UIColor lightTextColor] : [UIColor darkTextColor];
}

-(UIColor *)translucent {
  CGFloat r, g, b, a;
  [self getRed:&r green:&g blue:&b alpha:&a];
  return [UIColor colorWithRed:r green:g blue:b alpha:.85];
}

-(UIColor *)watermark {
  CGFloat r, g, b, a;
  [self getRed:&r green:&g blue:&b alpha:&a];
  return [UIColor colorWithRed:r green:g blue:b alpha:.25];
}

-(UIColor *)blendedColorWithFraction:(CGFloat)fraction ofColor:(UIColor *)color {
  CGFloat r1, g1, b1, a1;
  CGFloat r2, g2, b2, a2;
  
  [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
  [color getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
  
  CGFloat p = fraction, q = 1.0 - p,
  r = r1 * q + r2 * p,
  g = g1 * q + g2 * p,
  b = b1 * q + b2 * p,
  a = a1 * q + a2 * p;
  
  return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+(UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
  return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+(UIColor *)colorWithRGB:(NSUInteger)hex {
  return [UIColor colorWithARGB:(0xFF000000 | hex)];
}

+(UIColor *)colorWithARGB:(NSUInteger)hex {
  CGFloat v[4];
  for (NSInteger i = 3; i >= 0; i--) {
    NSUInteger l = (0xFF << (8 * i));
    v[i] = (hex & l >> (8 * i)) / 255.0;
  }
  return [UIColor colorWithRed:v[1] green:v[2] blue:v[3] alpha:v[0]];
}

+(UIColor *)colorWithName:(NSString *)colorName {
  return [[THWebNamedColors webNamedColors] colorWithName:colorName];
}

+(UIColor *)colorFromString:(NSString *)string {
  string = [string trim];
  
  if ([string hasPrefix:@"#"]) {
    return [UIColor colorFromHexString:string];
  }
  
  // shifting operations
  NSRange shiftRange = [string rangeOfAny:@"<! <= << <> >> => !>".wordSet];
  if (shiftRange.location != NSNotFound) {
    CGFloat p = 0.5;
    // determine the first of the operations
    NSString *op = [string substringWithRange:shiftRange];
    if ([op isEqual:@"<>"]) {
      // this will stay 50/50
    } else if ([op isEqual:@"<!"]) {
      p = 0.95;
    } else if ([op isEqual:@"<="]) {
      p = 0.85;
    } else if ([op isEqual:@"<<"]) {
      p = 0.66;
    } else if ([op isEqual:@">>"]) {
      p = 0.33;
    } else if ([op isEqual:@"=>"]) {
      p = 0.15;
    } else if ([op isEqual:@"!>"]) {
      p = 0.05;
    }
    
    // shift operators
    NSString *head = [string substringToIndex:
                      shiftRange.location];
    NSString *tail = [string substringFromIndex:
                      shiftRange.location + shiftRange.length];
    
    UIColor *first = head.trim.colorValue;
    UIColor *second = tail.trim.colorValue;
    
    if (first != nil && second != nil) {
      return [first blendedColorWithFraction:p ofColor:second];
    }
    if (first != nil) {
      return first;
    }
    return second;
  }
  
  if ([string contains:@" "]) {
    NSArray *splat = [string splitAt:@" "];
    NSString *head = [splat objectAtIndex:0], 
             *tail = [splat objectAtIndex:1];
    
    head = head.lowercaseString;
    UIColor *tailColor = [UIColor colorFromString:tail];
    
    if (tailColor) {
      if ([head isEqualToString:@"translucent"]) {
        return tailColor.translucent;
      } else if ([head isEqualToString:@"watermark"]) {
        return tailColor.watermark;
//      } else if ([head isEqualToString:@"bright"]) {
//        return tailColor.bright;
//      } else if ([head isEqualToString:@"brighter"]) {
//        return tailColor.brighter;
//      } else if ([head isEqualToString:@"dark"]) {
//        return tailColor.dark;
//      } else if ([head isEqualToString:@"darker"]) {
//        return tailColor.darker;
      } else if ([head hasSuffix:@"%"]) {
        return [tailColor colorWithAlphaComponent:head.popped.floatValue / 100.0];
      }
    }
  }
  
  if ([string contains:@","]) {
    NSString *comp = string;
    NSString *func = @"rgb";
    
    if ([string contains:@"("] && [string hasSuffix:@")"]) {
      comp = [string substringBetweenPrefix:@"(" andSuffix:@")"];
      func = [[string substringBefore:@"("] lowercaseString];
    }
    
    NSArray *vals = [comp componentsSeparatedByString:@","];
    CGFloat values[5];
    for (int i = 0; i < 5; i++) {
      values[i] = 1.0;
    }
    
    for (int i = 0; i < vals.count; i++) {
      NSString *v = [[vals objectAtIndex:i] trim];
      if ([v hasSuffix:@"%"]) {
        values[i] = [[v substringBefore:@"%"] floatValue] / 100.0;
      } else {
        // should be a float
        values[i] = v.floatValue;
        if (values[i] > 1) {
          values[i] /= 255.0;
        }
      }
      values[i] = MIN(MAX(values[i], 0), 1);
    }
    
    if (vals.count <= 2) {
      // grayscale + alpha
      return [UIColor colorWithWhite:values[0] 
                               alpha:values[1]
              ];
    } else if (vals.count <= 5) {
      // rgba || hsba
      if ([func hasPrefix:@"rgb"]) {
        return [UIColor colorWithRed:values[0]
                               green:values[1]
                                blue:values[2]
                               alpha:values[3]
                ];
      } else if ([func hasPrefix:@"hsb"]) {
        return [UIColor colorWithHue:values[0]
                          saturation:values[1]
                          brightness:values[2]
                               alpha:values[3]
                ];
//      } else if ([func hasPrefix:@"cmyk"]) {
//        return [UIColor colorWithCyan:values[0]
//                              magenta:values[1]
//                               yellow:values[2]
//                                black:values[3]
//                                alpha:values[4]
//                ];
      } else {
        //NSLog(@"Unrecognized Prefix <%@> returning nil", func);
      }
    }
  }
  
  return [UIColor colorWithName:string];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
	BOOL useHSB = NO;
  
  if (hexString.length == 0) {
		return UIColor.blackColor;
	}
	
	hexString = hexString.trim.uppercaseString;
	
	if ([hexString hasPrefix:@"#"]) {
		hexString = hexString.shifted;
	}
  
  if ([hexString hasPrefix:@"*"]) {
    useHSB = YES;
    hexString = hexString.shifted;
  }
  
	int mul = 1;
  int max = 3;
	CGFloat v[4];
  
  // full opacity by default
  v[3] = 1.0;
	
  if (hexString.length == 8 || hexString.length == 4) {
    max++;
  }
  
	if (hexString.length == 6 || hexString.length == 8) {
		// #RRGGBB || #RRGGBBAA
		mul = 2;
	} else if (hexString.length == 3 || hexString.length == 4) {
		// #RGB || #RGBA
		mul = 1;
	} else {
		return nil;
	}
	
	for (int i = 0; i < max; i++) {
		NSString *sub = [hexString substringWithRange:NSMakeRange(i * mul, mul)];
		NSScanner *scanner = [NSScanner scannerWithString:sub];
		uint value = 0;
		[scanner scanHexInt: &value];
		v[i] = (float) value / (float) 0xFF;
	}
  
	// only at full color
	if (useHSB) {
    return [UIColor colorWithHue:v[0] 
                      saturation:v[1] 
                      brightness:v[2] 
                           alpha:v[3]
            ];
  }
  
	return [UIColor colorWithRed:v[0] 
                         green:v[1] 
                          blue:v[2] 
                         alpha:v[3]
          ];
}

+(UIColor *)blueInputColor {
  static UIColor *c = nil;
  if (!c) {
    // leek here, could this be done in a different way?
    c = [[UIColor colorWithRed:0.22 green:0.33 blue:0.53] retain];
  }
  return c;
}

@end

@implementation NSString (UIColor_TH)

-(UIColor *)colorValue {
  return [UIColor colorFromString:self];
}

@end

@implementation THWebNamedColors

static THWebNamedColors *THWebNamedColors_instance = nil;
+(void)initialize {
  [super initialize];
  [self webNamedColors];
}

+(THWebNamedColors *)webNamedColors {
  @synchronized(self) {
    if (!THWebNamedColors_instance) {
      THWebNamedColors_instance = [[self alloc] init];
    }
    
    return THWebNamedColors_instance;
  }
}

- (void)_initColors {
  if ([[colors allKeys] count] > 0) {
    return;
  }
  
#define _COLOR(V,N) [self setColor:[@"#" stringByAppendingString:@#V].colorValue forName:[@#N lowercaseString]]
  _COLOR(FFFFFF00, Transparent);
  _COLOR(FFFFFF00, Clear);
  
  _COLOR(F0F8FF, AliceBlue);	 
  _COLOR(FAEBD7, AntiqueWhite);	 
  _COLOR(AFB837, AppleGreen);	 
  _COLOR(00FFFF, Aqua);	 
  _COLOR(7FFFD4, Aquamarine);	 
  _COLOR(F0FFFF, Azure);	 
  _COLOR(F5F5DC, Beige);	 
  _COLOR(FFE4C4, Bisque);	 
  _COLOR(000000, Black);	 
  _COLOR(FFEBCD, BlanchedAlmond);	 
  _COLOR(0000FF, Blue);	 
  _COLOR(8A2BE2, BlueViolet);	 
  _COLOR(A52A2A, Brown);	 
  _COLOR(DEB887, BurlyWood);	 
  _COLOR(5F9EA0, CadetBlue);	 
  _COLOR(7FFF00, Chartreuse);	 
  _COLOR(D2691E, Chocolate);	 
  _COLOR(FF7F50, Coral);	 
  _COLOR(6495ED, CornflowerBlue);	 
  _COLOR(FFF8DC, Cornsilk);	 
  _COLOR(DC143C, Crimson);	 
  _COLOR(00FFFF, Cyan);	 
  _COLOR(00008B, DarkBlue);	 
  _COLOR(008B8B, DarkCyan);	 
  _COLOR(B8860B, DarkGoldenRod);	 
  _COLOR(A9A9A9, DarkGray);	 
  _COLOR(006400, DarkGreen);	 
  _COLOR(BDB76B, DarkKhaki);	 
  _COLOR(8B008B, DarkMagenta);	 
  _COLOR(556B2F, DarkOliveGreen);	 
  _COLOR(FF8C00, Darkorange);	 
  _COLOR(9932CC, DarkOrchid);	 
  _COLOR(8B0000, DarkRed);	 
  _COLOR(E9967A, DarkSalmon);	 
  _COLOR(8FBC8F, DarkSeaGreen);	 
  _COLOR(483D8B, DarkSlateBlue);	 
  _COLOR(2F4F4F, DarkSlateGray);	 
  _COLOR(00CED1, DarkTurquoise);	 
  _COLOR(9400D3, DarkViolet);	 
  _COLOR(FF1493, DeepPink);	 
  _COLOR(00BFFF, DeepSkyBlue);	 
  _COLOR(696969, DimGray);	 
  _COLOR(1E90FF, DodgerBlue);	 
  _COLOR(B22222, FireBrick);	 
  _COLOR(FFFAF0, FloralWhite);	 
  _COLOR(228B22, ForestGreen);	 
  _COLOR(FF00FF, Fuchsia);	 
  _COLOR(DCDCDC, Gainsboro);	 
  _COLOR(F8F8FF, GhostWhite);	 
  _COLOR(FFD700, Gold);	 
  _COLOR(DAA520, GoldenRod);	 
  _COLOR(808080, Gray);	 
  _COLOR(008000, Green);	 
  _COLOR(ADFF2F, GreenYellow);	 
  _COLOR(F0FFF0, HoneyDew);	 
  _COLOR(FF69B4, HotPink);	 
  _COLOR(CD5C5C, IndianRed);	 
  _COLOR(4B0082, Indigo);	 
  _COLOR(FFFFF0, Ivory);	 
  _COLOR(F0E68C, Khaki);	 
  _COLOR(E6E6FA, Lavender);	 
  _COLOR(FFF0F5, LavenderBlush);	 
  _COLOR(7CFC00, LawnGreen);	 
  _COLOR(FFFACD, LemonChiffon);	 
  _COLOR(ADD8E6, LightBlue);	 
  _COLOR(F08080, LightCoral);	 
  _COLOR(E0FFFF, LightCyan);	 
  _COLOR(FAFAD2, LightGoldenRodYellow);	 
  _COLOR(D3D3D3, LightGrey);	 
  _COLOR(90EE90, LightGreen);	 
  _COLOR(FFB6C1, LightPink);	 
  _COLOR(FFA07A, LightSalmon);	 
  _COLOR(20B2AA, LightSeaGreen);	 
  _COLOR(87CEFA, LightSkyBlue);	 
  _COLOR(778899, LightSlateGray);	 
  _COLOR(B0C4DE, LightSteelBlue);	 
  _COLOR(FFFFE0, LightYellow);	 
  _COLOR(00FF00, Lime);	 
  _COLOR(32CD32, LimeGreen);	 
  _COLOR(FAF0E6, Linen);	 
  _COLOR(FF00FF, Magenta);	 
  _COLOR(800000, Maroon);	 
  _COLOR(66CDAA, MediumAquaMarine);	 
  _COLOR(0000CD, MediumBlue);	 
  _COLOR(BA55D3, MediumOrchid);	 
  _COLOR(9370D8, MediumPurple);	 
  _COLOR(3CB371, MediumSeaGreen);	 
  _COLOR(7B68EE, MediumSlateBlue);	 
  _COLOR(00FA9A, MediumSpringGreen);	 
  _COLOR(48D1CC, MediumTurquoise);	 
  _COLOR(C71585, MediumVioletRed);	 
  _COLOR(191970, MidnightBlue);	 
  _COLOR(F5FFFA, MintCream);	 
  _COLOR(FFE4E1, MistyRose);	 
  _COLOR(FFE4B5, Moccasin);	 
  _COLOR(FFDEAD, NavajoWhite);	 
  _COLOR(000080, Navy);	 
  _COLOR(FDF5E6, OldLace);	 
  _COLOR(808000, Olive);	 
  _COLOR(6B8E23, OliveDrab);	 
  _COLOR(FFA500, Orange);	 
  _COLOR(FF4500, OrangeRed);	 
  _COLOR(DA70D6, Orchid);	 
  _COLOR(EEE8AA, PaleGoldenRod);	 
  _COLOR(98FB98, PaleGreen);	 
  _COLOR(AFEEEE, PaleTurquoise);	 
  _COLOR(D87093, PaleVioletRed);	 
  _COLOR(FFEFD5, PapayaWhip);	 
  _COLOR(FFDAB9, PeachPuff);	 
  _COLOR(CD853F, Peru);	 
  _COLOR(FFC0CB, Pink);	 
  _COLOR(DDA0DD, Plum);	 
  _COLOR(B0E0E6, PowderBlue);	 
  _COLOR(800080, Purple);	 
  _COLOR(FF0000, Red);	 
  _COLOR(BC8F8F, RosyBrown);	 
  _COLOR(4169E1, RoyalBlue);	 
  _COLOR(8B4513, SaddleBrown);	 
  _COLOR(FA8072, Salmon);	 
  _COLOR(F4A460, SandyBrown);	 
  _COLOR(2E8B57, SeaGreen);	 
  _COLOR(FFF5EE, SeaShell);	 
  _COLOR(A0522D, Sienna);	 
  _COLOR(C0C0C0, Silver);	 
  _COLOR(87CEEB, SkyBlue);	 
  _COLOR(6A5ACD, SlateBlue);	 
  _COLOR(708090, SlateGray);	 
  _COLOR(FFFAFA, Snow);	 
  _COLOR(00FF7F, SpringGreen);	 
  _COLOR(4682B4, SteelBlue);	 
  _COLOR(D2B48C, Tan);	 
  _COLOR(008080, Teal);	 
  _COLOR(D8BFD8, Thistle);	 
  _COLOR(FF6347, Tomato);	 
  _COLOR(40E0D0, Turquoise);	 
  _COLOR(EE82EE, Violet);	 
  _COLOR(F5DEB3, Wheat);	 
  _COLOR(FFFFFF, White);	 
  _COLOR(F5F5F5, WhiteSmoke);	 
  _COLOR(FFFF00, Yellow);	 
  _COLOR(9ACD32, YellowGreen);
#undef _COLOR
}

- (id)init {
  if (THWebNamedColors_instance != nil) {
    [NSException 
     raise:NSInternalInconsistencyException
     format:@"[WebNamedColors init] cannot be called directly;"
     ];
  } else if ((self = [super init])) {
    THWebNamedColors_instance = self;
    colors = [[NSMutableDictionary alloc] init];
    [self _initColors];
  }
  return THWebNamedColors_instance;
}

/* These probably do nothing in
 a GC app.  Keeps singleton
 as an actual singleton in a
 non CG app
 */
- (NSUInteger)retainCount {
  return NSUIntegerMax;
}

- (oneway void)release {
}

- (id)retain {
  return THWebNamedColors_instance;
}

- (id)autorelease {
  return THWebNamedColors_instance;
}

-(UIColor *)colorWithName:(NSString *)name {
  return [colors valueForKey:[name lowercaseString]];
}

-(void)setColor:(UIColor *)color forName:(NSString *)name {
  [colors setValue:color forKey:[name lowercaseString]];
}

@end