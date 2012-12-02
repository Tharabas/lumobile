//
//  NSIndexPath+TH.m
//  TK-Suite
//
//  Created by Benjamin Schüttler on 10.05.11.
//  Copyright 2011 Rainbow Labs UG. All rights reserved.
//

#import "NSIndexPath+TH.h"
#import "THSugar.h"

@implementation NSIndexPath (TH)

+(NSIndexPath *)indexPathWithSection:(NSUInteger)section row:(NSUInteger)row {
  return [[NSIndexPath indexPathWithIndex:section] indexPathByAddingIndex:row];
}

-(NSString *)path {
  NSString *re = $(@"%u", [self indexAtPosition:0]);
  for (int i = 1; i < self.length; i++) {
    re = $(@"%@.%u", re, [self indexAtPosition:i]);
  }
  return re;
}

@end
