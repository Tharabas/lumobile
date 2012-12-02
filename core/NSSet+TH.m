//
//  NSSet+TH.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 25.10.09.
//  Copyright 2009 Rainbow Labs UG. All rights reserved.
//

#import "NSSet+TH.h"
#import "NSArray+TH.h"
#import "NSMutableArray+TH.h"

@implementation NSSet (TH)

- (NSArray *)array {
  return [self sortedArrayUsingDescriptors:NSArray.array];
}

//- (NSArray *)arraySortedBy:(NSString *)sortDescription {
//  return [self sortedArrayUsingDescriptors:[NSArray arrayForSorting:sortDescription]];
//}

- (NSSet *)subsetWithoutSet:(NSSet *)set {
  NSMutableSet *re = [NSMutableSet set];
  
  for (id o in self) {
    if (![set member:o]) {
      [re addObject:o];
    }
  }
  
  return re;
}

- (NSSet *)subsetWithoutObject:(id)object {
  return [self subsetWithoutSet:[NSSet setWithObject:object]];
}

- (NSSet *)subsetWithoutObjects:(id)object, ... {
  NSMutableSet *exclude = [NSMutableSet set];
  va_list args;
  va_start(args, object);
  for (id arg = object; arg != nil; arg = va_arg(args, id))
  {
    [exclude addObject:arg];
  }
  va_end(args);
  
  return [self subsetWithoutSet:exclude];
}

- (BOOL)allKindOfClass:(Class)aClass {
  for (id o in self) {
    if (![o isKindOfClass:aClass]) {
      return NO;
    }
  }
  
  return YES;
}

- (NSSet *)elementsOfClass:(Class)aClass {
  return [self objectsPassingTest:^(id o, BOOL *stop) {
    return [o isKindOfClass:aClass];
  }];
}

- (id)randomElement {
  if (!self.count) {
    return nil;
  }
  
  NSUInteger index = random() % self.count;
  
  for (id o in self) {
    if (index == 0) {
      return o;
    }
    index--;
  }
  
  return nil;
}

- (NSSet *)randomSubsetWithSize:(NSUInteger)size {
  NSUInteger capacity = MIN(size, self.count);
  if (capacity == 0) {
    return [NSSet set];
  }
  if (capacity == self.count) {
    return self;
  }
  
  NSMutableArray *a = [[self array] mutableCopy];
  [a shuffle];
  while (a.count > capacity) {
    [a removeLastObject];
  }
  
  NSSet *re = [NSSet setWithArray:a];
  [a release];
  
  return re;
}

- (NSSet *)setWithKey:(NSString *)keyPath {
  NSMutableSet *re = [[NSMutableSet alloc] initWithCapacity:self.count];
  
  for (id o in self) {
    id v = [o valueForKeyPath:keyPath];
    if (v) {
      [re addObject:v];
    }
  }
  
  return [re autorelease];
}

- (NSSet *)setPerformingSelector:(SEL)selector {
  NSMutableSet *re = [[NSMutableSet alloc] initWithCapacity:self.count];
  
  for (id o in self) {
    id v = [o performSelector:selector];
    if (v) {
      [re addObject:v];
    }
  }
  
  return [re autorelease];
}

- (NSSet *)setPerformingSelector:(SEL)selector withObject:(id)object {
  NSMutableSet *re = [[NSMutableSet alloc] initWithCapacity:self.count];
  
  for (id o in self) {
    id v = [o performSelector:selector withObject:object];
    if (v) {
      [re addObject:v];
    }
  }
  
  return [re autorelease];
}

//
// contains
//
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

@end

@implementation NSMutableSet (TH)

-(id)addSet:(NSSet *)set {
  for (id o in set) {
    [self addObject:o];
  }
  
  return self;
}

@end
