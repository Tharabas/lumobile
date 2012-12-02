//
//  NSIndexSet+TH.m
//  fruitris
//
//  Created by Benjamin Schüttler on 16.04.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import "NSIndexSet+TH.h"

@implementation NSIndexSet (TH)

+(NSIndexSet *)indexSetWithIndexes:(NSUInteger *)indexes count:(NSUInteger)count {
  NSMutableIndexSet *re = [NSMutableIndexSet indexSet];
  for (NSUInteger i = 0; i < count; i++) {
    [re addIndex:indexes[i]];
  }
  return re;
}

+(NSIndexSet *)indexSetWithIndexes:(NSUInteger)index,... {
  static const NSUInteger bufferChunkSize = 64;
  NSUInteger bufferedSize = 0;
  NSUInteger *buffer = NULL;
  
  va_list args;
  va_start(args, index);
  NSInteger v, i = 0;
  while ((v = va_arg(args, NSInteger)) != NSNotFound) {
    if (i >= bufferedSize) {
      bufferedSize += bufferChunkSize;
      buffer = realloc(buffer, sizeof(NSUInteger) * bufferedSize);
    }
    buffer[i] = v;
    i++;
  }
  va_end(args);
  
  NSIndexSet *re = [self indexSetWithIndexes:buffer count:i];
  
  free(buffer);
  
  return re;
}

-(NSIndexSet *)randomSubsetOfLength:(NSUInteger)length {
  NSUInteger c = self.count;
  if (length >= c) {
    return self;
  }
  
  NSUInteger set[c];
  NSRange range;
  
  [self getIndexes:set maxCount:c inIndexRange:&range];
  for (NSUInteger i = 0; i < length; i++) {
    NSUInteger rnd = arc4random() % c;
    NSUInteger tmp = set[i];
    set[i] = set[rnd];
    set[rnd] = tmp;
  }
  NSMutableIndexSet *re = [NSMutableIndexSet indexSet];
  for (NSUInteger i = 0; i < length; i++) {
    [re addIndex:set[i]];
  }
  return re;
}

@end
