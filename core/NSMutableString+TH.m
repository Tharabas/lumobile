//
//  NSMutableString+TH.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 24.10.09.
//  Copyright 2009 Rogue Coding. All rights reserved.
//

#import "NSMutableString+TH.h"

@implementation NSMutableString (TH)

- (NSString *)shift {
  NSString *re = [self substringToIndex:1];
  [self setString:[self substringFromIndex:1]];
  return re;
}

- (NSString *)pop {
  NSUInteger index = self.length - 1;
  NSString *re = [self substringFromIndex:index];
  [self setString:[self substringToIndex:index]];
  return re;
}

- (BOOL)removePrefix:(NSString *)prefix {
  if (![self hasPrefix:prefix]) {
    return NO;
  }

  NSRange range = NSMakeRange(0, prefix.length);
  [self replaceCharactersInRange:range withString:@""];
  
  return YES;
}

- (BOOL)removeSuffix:(NSString *)suffix {
  if (![self hasSuffix:suffix]) {
    return NO;
  }
  
  NSRange range = NSMakeRange(self.length - suffix.length, suffix.length);
  [self replaceCharactersInRange:range withString:@""];
  
  return YES;
}

- (BOOL)removePrefix:(NSString *)prefix andSuffix:(NSString *)suffix {
  if (![self hasPrefix:prefix andSuffix:suffix]) {
    return NO;
  }

  NSRange range = NSMakeRange(0, prefix.length);
  [self replaceCharactersInRange:range withString:@""];

  range = NSMakeRange(self.length - suffix.length, suffix.length);
  [self replaceCharactersInRange:range withString:@""];
  
  return YES;
}

- (NSMutableString *)camelize {
  unichar c;
  unichar us = [@"_" characterAtIndex:0];
  unichar hy = [@"-" characterAtIndex:0];
  NSMutableString *r = [NSMutableString string];
  
  for (NSUInteger i = 0; i < self.length; i++) {
    c = [self characterAtIndex:i];
    if (c == us || c == hy) {
      [r setString:[self substringWithRange:NSMakeRange(i, 1)]];
      
      [self replaceCharactersInRange:NSMakeRange(i, 2) 
                          withString:[r uppercaseString]];
      i++;
    }
  }
  
  return self;
}

- (NSMutableString *)hyphonize {
  return [self replaceAll:@"_" withString:@"-"];
}

- (NSMutableString *)underscorize {
  return [self replaceAll:@"-" withString:@"_"];
}

- (NSMutableString *)constantize {
  [self setString:[[self underscorize] uppercaseString]];
  return self;
}

- (NSMutableString *)replaceAll:(NSString *)needle 
                     withString:(NSString *)replacement 
{
  [self replaceOccurrencesOfString:needle
                        withString:replacement
                           options:0
                             range:NSMakeRange(0, self.length)
   ];
  return self;
}

@end
