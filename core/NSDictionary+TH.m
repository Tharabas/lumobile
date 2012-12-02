//
//  NSDictionary+TH.m
//  frutris
//
//  Created by Benjamin Schüttler on 12.09.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import "NSDictionary+TH.h"

#define ASSERT_CLASS(OBJECT, KEY, CLASS) NSAssert([OBJECT isKindOfClass:CLASS.class], @"Expected %@ to be %@ but found '%@'", KEY, @#CLASS, [OBJECT class]);

@implementation NSDictionary (TH)

-(BOOL)boolForKey:(NSString *)key {
  id o = [self objectForKey:key];
  if (!o) return NO;
  ASSERT_CLASS(o, key, NSNumber);
  return [o boolValue];
}

-(int)intForKey:(NSString *)key {
  id o = [self objectForKey:key];
  if (!o) return 0;
  ASSERT_CLASS(o, key, NSNumber);
  return [o intValue];
}

-(float)floatForKey:(NSString *)key {
  id o = [self objectForKey:key];
  if (!o) return 0.0;
  ASSERT_CLASS(o, key, NSNumber);
  return [o floatValue];
}

-(NSString *)stringForKey:(NSString *)key {
  id o = [self objectForKey:key];
  if (!o) return nil;
  ASSERT_CLASS(o, key, NSString);
  return o;
}

-(NSArray *)arrayForKey:(NSString *)key {
  id o = [self objectForKey:key];
  if (!o) return nil;
  ASSERT_CLASS(o, key, NSArray);
  return o;
}

@end
