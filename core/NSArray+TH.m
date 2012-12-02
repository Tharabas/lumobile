//
//  NSArray+TH.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 20.05.09.
//  Copyright 2009 Rogue Coding. All rights reserved.
//

#import "NSArray+TH.h"
#import "NSMutableArray+TH.h"
#import "NSString+TH.h"

@implementation NSArray (TH)

// an array of NSNumbers with Integer values, NSNotFound is the terminator
+ (NSArray *)arrayWithInts:(NSInteger)i,... {
  NSMutableArray *re = NSMutableArray.array;
  
  [re addObject:[NSNumber numberWithInt:i]];
  
  va_list args;
  va_start(args, i);
  NSInteger v;
  while ((v = va_arg(args, NSInteger)) != NSNotFound) {
    [re addObject:[NSNumber numberWithInt:v]];
  }
  va_end(args);
  
  return re;
}

// an array of NSNUmbers with double values, MAXFLOAT is the terminator
+ (NSArray *)arrayWithDoubles:(double)f,... {
  NSMutableArray *re = NSMutableArray.array;
  
  [re addObject:[NSNumber numberWithDouble:f]];
  
  va_list args;
  va_start(args, f);
  double v;
  while ((v = va_arg(args, double)) != MAXFLOAT) {
    [re addObject:[NSNumber numberWithDouble:v]];
  }
  va_end(args);
  
  return re;
}

//
// NSArray instance methods
//

// set-version of this array
- (NSSet *)set {
  return [NSSet setWithArray:self];
}

- (NSArray *)shifted {
  NSMutableArray *re = [[self mutableCopy] autorelease];
  [re removeFirstObject];
  return re;
}

- (NSArray *)popped {
  NSMutableArray *re = [[self mutableCopy] autorelease];
  [re removeLastObject];
  return re;
}

- (NSArray *)reversed {
  return [[[self mutableCopy] autorelease] reverse];
}

// array evaluating the keyPath
- (NSArray *)arrayWithKey:(NSString *)keyPath {
  NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
  for (id o in self) {
    id v = [o valueForKeyPath:keyPath];
    if (v) {
      [re addObject:v];
    }
  }
  return re;
}

// array evaluating a selector
- (NSArray *)arrayPerformingSelector:(SEL)selector {
  NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
  for (id o in self) {
    id v = [o performSelector:selector];
    if (v) {
      [re addObject:v];
    }
  }
  return re;
}

- (NSArray *)arrayPerformingSelector:(SEL)selector withObject:(id)object {
  NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
  for (id o in self) {
    id v = [o performSelector:selector withObject:object];
    if (v) {
      [re addObject:v];
    }
  }
  return re;
}

- (NSArray *)arrayUsingBlock:(id (^)(id obj))block {
  return [self map:block];
}

- (NSArray *)map:(id (^)(id obj))block {
  NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
  for (id o in self) {
    id v = block(o);
    if (v) [re addObject:v];
  }
  return re;
}

- (NSArray *)nmap:(id (^)(id obj, NSUInteger index))block {
  NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
  for (int i = 0; i < self.count; i++) {
    id v, o = [self objectAtIndex:i];
    if ((v = block(o,i))) [re addObject:v];
  }
  return re;
}

- (id)reduce:(id (^)(id a, id b))block {
  if (!self.count) {
    return nil;
  }
  
  id re = self.first;
  
  for (int i = 1; i < self.count; i++) {
    re = block(re, [self objectAtIndex:i]);
  }
  
  return re;
}

- (NSArray *)flattened {
  return [self reduce:^(id a, id b) {
    if ([b isKindOfClass:NSArray.class]) {
      return (id) [a arrayByAddingObjectsFromArray:b];
    }
    return (id) [a arrayByAddingObject:b];
  }];
}

- (NSArray *)replaceWithArrayByRemovingObject:(id)object {
  NSUInteger index = [self indexOfObject:object];
  return [self replaceWithArrayByRemovingObjectAtIndex:index];
}

- (NSArray *)replaceWithArrayByRemovingObjectAtIndex:(NSUInteger)index {
  if (index >= self.count) return self;
  NSArray *re = [[self arrayWithoutObjectAtIndex:index] retain];
  [self release];
  return re;
}

- (NSArray *)replaceWithArrayByAddingObject:(id)object {
  NSArray *re = [[self arrayByAddingObject:object] retain];
  [self release];
  return re;
}

- (NSArray *)arrayWithoutObjectAtIndex:(NSUInteger)index {
  NSArray *re = NSArray.array;
  for (NSUInteger i = 0; i < self.count; i++) {
    if (i != index) re = [re arrayByAddingObject:[self objectAtIndex:i]];
  }
  return re;
}

- (NSArray *)arrayWithoutObject:(id)object {
  NSArray *re = NSArray.array;
  for (id o in self) { 
    if (o != object) re = [re arrayByAddingObject:o];
  }
  return re;
}

- (NSArray *)arrayWithoutObjects:(id)object,... {
  NSSet *s = NSSet.set;

  va_list args;
  va_start(args, object);
  id o = nil;
  while ((o = va_arg(args,id)) != nil) {
    s = [s setByAddingObject:o];
  }
  va_end(args);
  
  NSArray *re = [self arrayWithoutSet:s];
  
  return re;
}

- (NSArray *)arrayWithoutArray:(NSArray *)value {
  return [self arrayWithoutSet:value.set];
}

- (NSArray *)arrayWithoutSet:(NSSet *)values {
  NSArray *re = NSArray.array;
  
  for (id o in self) {
    if (![values containsObject:o]) {
      re = [re arrayByAddingObject:o];
    }
  }
  
  return re;
}

- (NSArray *)filter:(BOOL (^)(id object))block {
  return [self filteredArrayUsingBlock:^(id o, NSDictionary *d) {
    return (BOOL) block(o);
  }];
}

- (id)filterOne:(BOOL (^)(id object))block {
  __block id re = nil;
  
  [self enumerateObjectsUsingBlock:^(id o, NSUInteger i, BOOL *stop) {
    if (block(o)) {
      *stop = YES;
      re = o;
    }
  }];
  
  return re;
}

- (BOOL)allKindOfClass:(Class)aClass {
  for (id o in self) {
    if (![o isKindOfClass:aClass]) {
      return NO;
    }
  }
  
  return YES;
}

- (NSArray *)elementsOfClass:(Class)aClass {
  NSMutableArray *re = NSMutableArray.array;
  
  for (id o in self) {
    if ([o isKindOfClass:aClass]) {
      [re addObject:o];
    }
  }
  
  return re;
}

- (NSArray *)numbers {
  return [self elementsOfClass:NSNumber.class];
}

- (NSArray *)strings {
  return [self elementsOfClass:NSString.class];
}

- (NSArray *)trimmedStrings {
  NSMutableArray *re = NSMutableArray.array;
  
  for (id o in self) {
    if ([o isKindOfClass:NSString.class]) {
      NSString *s = [o trim];
      if (!s.isEmpty) {
        [re addObject:s];
      }
    }
  }
  
  return re;
}

//
// accessing
//

- (id)objectAtIndex:(NSUInteger)index fallback:(id)fallback {
  if (self.count <= index) {
    return fallback;
  }
  
  @try {
    id re = [self objectAtIndex:index];
    return !re ? fallback : re;
  }
  @catch (NSException *e) {
    return fallback;
  }
}

- (id)objectOrNilAtIndex:(NSUInteger)index {
  if (self.count <= index) {
    return nil;
  }
  
  return [self objectAtIndex:index];
}


- (id)first {
  return [self objectOrNilAtIndex:0];
}

- (id)second { 
	return [self objectOrNilAtIndex:1]; 
}

- (id)third {
	return [self objectOrNilAtIndex:2];
}

- (id)fourth {
	return [self objectOrNilAtIndex:3];
}

- (id)fifth {
	return [self objectOrNilAtIndex:4];
}

- (id)sixth {
	return [self objectOrNilAtIndex:5];
}

- (NSArray *)subarrayFromIndex:(NSInteger)start
{
	return [self subarrayFromIndex:start toIndex:(self.count - 1)];
}

- (NSArray *)subarrayToIndex:(NSInteger)end
{
	return [self subarrayFromIndex:0 toIndex:end];
}

- (NSArray *)subarrayFromIndex:(NSInteger)start toIndex:(NSInteger)end
{
	NSInteger from = start;
	while (from < 0) {
		from += self.count;
	}
	if (from > self.count) {
		return nil;
	}
	NSInteger to = end;
	while (to < 0) {
		to += self.count;
	}
	
	if (from >= to) {
		// this behaviour is somewhat different
		// it will return anything from this array except the passed range
		NSArray *re = [NSArray array];
		
		if (from > 0) {
			re = [self subarrayWithRange:NSMakeRange(0, from - 1)];
		}
		if (to < self.count) {
			if (re != nil) {
				re = [re arrayByAddingObjectsFromArray:[self subarrayWithRange:NSMakeRange(to - 1, self.count - 1)]];
			}
		}
    
    return re;
	}

	return [self subarrayWithRange:NSMakeRange(from, to)];
}

- (id)randomElement {
  if (!self.count) {
    return nil;
  }
  NSUInteger index = arc4random() % self.count;
  
  return [self objectAtIndex:index];
}

- (NSArray *)shuffeled {
  if (self.count < 2) {
    return self;
  }
  
  return ((NSMutableArray *) self.mutableCopy).shuffle.autorelease;
}

- (NSArray *)randomSubarrayWithSize:(NSUInteger)size {
  if (self.count == 0) {
    return [NSArray array];
  }

  NSUInteger capacity = MIN(size, self.count);
  NSMutableArray *re = [NSMutableArray arrayWithCapacity:capacity];
  
  while (re.count < capacity) {
    NSUInteger index = arc4random() % (self.count - re.count);
    id e = [self objectAtIndex:index];
    while ([re containsObject:e]) {
      e = [self objectAtIndex:++index];
    }
    [re addObject:e];
  }
  
  return re;
}

- (NSArray *)sortedArrayByProperties:(NSString *)definition {
  NSMutableArray *descriptors = NSMutableArray.array;
  
  for (NSString *def in definition.splitByComma) {
    BOOL ascending = YES;
    NSString *key, *direction;
    if ([def splitAt:@" " head:&key tail:&direction]) {
      ascending = ![direction.lowercaseString isEqualToString:@"desc"];
    } else {
      key = def.trim;
    }

    descriptors.last = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
  }

  return [self sortedArrayUsingDescriptors:descriptors];
}

- (id)objectAtNormalizedIndex:(NSInteger)index {
  if (self.count == 0) {
    return nil;
  }
  
  while (index < 0) {
    index += self.count;
  }
  
  return [self objectAtIndex:index % self.count];
}

- (NSInteger)sumIntWithKey:(NSString *)keyPath {
  NSInteger re = 0;
  for (id v in self) {
    id k = v;
    if (keyPath != nil) {
      k = [v valueForKeyPath:keyPath];
    }
    if ([k isKindOfClass:NSNumber.class]) {
      re += [k intValue];
    }
  }

  return re;
}

- (CGFloat)sumFloatWithKey:(NSString *)keyPath {
  CGFloat re = 0;
  for (id v in self) {
    id k = v;
    if (keyPath != nil) {
      k = [v valueForKeyPath:keyPath];
    }
    if ([k isKindOfClass:NSNumber.class]) {
      re += [k floatValue];
    }
  }
  
  return re;
}

- (BOOL)containsAny:(id <NSFastEnumeration>)enumerable {
  for (id o in enumerable) {
    if ([self containsObject:o]) {
      return YES;
    }
  }
  
  return NO;
}
- (BOOL)containsAll:(id <NSFastEnumeration>)enumerable {
  for (id o in enumerable) {
    if (![self containsObject:o]) {
      return NO;
    }
  }
  
  return YES;
}

// will always return nil
-(id)andExecuteEnumeratorBlock {
  return nil;
}

-(void)setAndExecuteEnumeratorBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
  [self enumerateObjectsUsingBlock:block];
}

-(NSArray *)objectsWithFormat:(NSString *)format, ... {
  va_list args;
  va_start(args, format);
  NSPredicate *p = [NSPredicate predicateWithFormat:format arguments:args];
  va_end(args);
  
  return [self filteredArrayUsingPredicate:p];
}

-(id)firstObjectWithFormat:(NSString *)format, ... {
  va_list args;
  va_start(args, format);
  NSPredicate *p = [NSPredicate predicateWithFormat:format arguments:args];
  va_end(args);
  
  NSArray *lookup = [self filteredArrayUsingPredicate:p];
  
  if (lookup.count) {
    return lookup.first; 
  }
  
  return nil;
}

-(NSArray *)filteredArrayUsingBlock:
  (BOOL (^)(id evaluatedObject, NSDictionary *bindings))block
{
  NSPredicate *p = [NSPredicate predicateWithBlock:block];
  return [self filteredArrayUsingPredicate:p];
}
@end