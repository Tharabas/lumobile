//
//  NSNumber+TH.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 11.11.09.
//  Copyright 2009 Rogue Coding. All rights reserved.
//

#import "NSNumber+TH.h"

@implementation NSNumber(TH)

+(NSNumber *)zero {
  return [NSNumber numberWithInt:0];
}

+(NSNumber *)one {
  return [NSNumber numberWithInt:1];
}

+(NSNumber *)two {
  return [NSNumber numberWithInt:2];
}

-(NSNumber *)abs {
  return [NSNumber numberWithDouble:fabs(self.doubleValue)];
}

-(NSNumber *)negate {
  return [NSNumber numberWithDouble:-self.doubleValue];
}

-(NSNumber *)transpose {
  return [NSNumber numberWithDouble:(1 / self.doubleValue)];
}

-(NSArray *)times:(id (^)(void))block {
  int n = self.intValue;
  
  if (n < 0) {
    return nil;
  }
  
  NSMutableArray *re = [[[NSMutableArray alloc] initWithCapacity:n] autorelease];
  
  for (int i = 0; i < n; i++) {
    id o = block();
    if (o) {
      [re addObject:o];
    }
  }
  
  return re;
}

-(NSArray *)to:(NSNumber *)to {
  return [self to:to by:[NSNumber numberWithDouble:1.0]];
}

-(NSArray *)to:(NSNumber *)to by:(NSNumber *)by {
  double alpha = self.doubleValue;
  double omega = to.doubleValue;
  double delta = by.doubleValue;
  
  if ((alpha > omega && delta > 0)
   || (alpha < omega && delta < 0)
  ) {
    delta = -delta;
  }
  
  BOOL (^_)(double) = delta > 0
  ? ^(double g){ return (BOOL) (g <= omega); }
  : ^(double g){ return (BOOL) (g >= omega); }
  ;
  
  NSMutableArray *re = NSMutableArray.new;
  
  for (double gamma = alpha; _(gamma); gamma += delta) {
    [re addObject:[NSNumber numberWithDouble:gamma]];
  }
  
  return re;
}

-(NSString *)localDecimal {
  return [NSNumberFormatter localizedStringFromNumber:self numberStyle:NSNumberFormatterDecimalStyle];
}

@end
