//
//  NSMutableArray+PHP.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 18.06.09.
//  Copyright 2009 Rogue Coding. All rights reserved.
//

#import "NSMutableArray+TH.h"
#import "NSArray+TH.h"

@implementation NSMutableArray (TH)

-(id)last {
	return self.lastObject;
}

-(void)setLast:(id)anObject {
  if (anObject) {
    [self willChangeValueForKey:@"last"];
    [self addObject:anObject];
    [self didChangeValueForKey:@"last"];
  }
}

-(id)first {
  return [super first];
}

-(void)setFirst:(id)anObject {
  if (anObject == nil) {
    return;
  }
  [self willChangeValueForKey:@"first"];
	[self insertObject:anObject atIndex:0];
  [self didChangeValueForKey:@"first"];
}

- (void)removeFirstObject {
  [self shift];
}

-(id)shift {
  if (self.count == 0) {
		return nil;
	}
	
	id re = [self.first retain];
	[self removeObjectAtIndex:0];
	return [re autorelease];
}

-(id)pop {
  if (self.count == 0) {
    return nil;
  }
  
  id o = [self.lastObject retain];
  [self removeLastObject];
  return [o autorelease];
}

-(NSMutableArray *)sort {
  [self sortUsingSelector:@selector(compare:)];
  return self;
}

-(NSMutableArray *)reverse {
  @synchronized (self) {
    for (NSUInteger i = 0; i < floor(self.count / 2); i++) {
      [self exchangeObjectAtIndex:i withObjectAtIndex:(self.count - i - 1)];
    }
  }
  return self;
}

-(NSMutableArray *)shuffle {
  @synchronized (self) {
    for (NSUInteger i = 0; i < self.count; i++) {
      NSUInteger one = random() % self.count;
      NSUInteger two = random() % self.count;
      [self exchangeObjectAtIndex:one withObjectAtIndex:two];
    }
  }
  return self;
}

@end
