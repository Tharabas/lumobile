//
//  NSMutableDictionary+TH.m
//  frutris
//
//  Created by Benjamin Schüttler on 11.09.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import "NSMutableDictionary+TH.h"

@implementation NSMutableDictionary (TH)

-(void)addInteger:(NSInteger)addition toKey:(NSString *)key {
  id value = [self objectForKey:key];
  if (!value) value = NSNumber.zero;
  NSAssert([value isKindOfClass:NSNumber.class], @"Incremented value must be NSNumber, but is %@", [value class]);

  [self setValue:[NSNumber numberWithInt:[value intValue] + addition] forKey:key];
}

-(NSInteger)incrementIntAtKey:(NSString *)key {
  [self addInteger:1 toKey:key];
  return [[self objectForKey:key] intValue];
}

-(void)updateObjectAtKey:(NSString *)key withBlock:(id(^)(id object))block {
  id value = [self objectForKey:key];
  id newValue = block(value);
  [self setObject:newValue forKey:key];
}

@end
