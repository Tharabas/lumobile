//
//  NSString+TH.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 20.05.09.
//  Copyright 2009 Rogue Coding. All rights reserved.
//

#import "NSString+TH.h"

@implementation NSString (TH)

- (NSString *)trim {
  NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  return [self stringByTrimmingCharactersInSet:cs];
}

- (NSString *)shifted {
  return [self substringFromIndex:1];
}

- (NSString *)popped {
  return [self substringWithRange:NSMakeRange(0, self.length - 1)];
}

- (NSString *)chopped {
  return [self substringWithRange:NSMakeRange(1, self.length - 2)];
}

- (NSString *)camelized {
  return [[[self mutableCopy] autorelease] camelize];
}

- (NSString *)hyphonized {
  return [[[self mutableCopy] autorelease] hyphonize];
}

- (NSString *)underscored {
  return [[[self mutableCopy] autorelease] underscorize];
}

- (BOOL)isEmpty {
  return (self == nil) || [self.trim isEqualToString:@""];
}

- (BOOL)hasValue {
  return !self.isEmpty;
}

/**
 * Actually this should be called stringByReversingThisString,
 * but that appeared to be too much sugar-free
 *
 * reverse ist non-destructive
 */
- (NSString *)reversed
{
	NSMutableString *re = NSMutableString.string;

	for (int i = self.length - 1; i >= 0; i--) {
		[re appendString:[self substringWithRange:NSMakeRange(i, 1)]];
	}
	
	return re;
}

- (NSUInteger)count:(NSString *)s options:(NSStringCompareOptions)mask {
  NSUInteger re = 0;
  NSRange r = NSMakeRange(0, self.length);
  
  NSRange rr;
  
  while ((rr = [self rangeOfString:s options:mask range:r]).location != NSNotFound) {
    re++;
    r.location = rr.location + 1;
    r.length = self.length - r.location;
  }
  
  return re;
}

- (NSUInteger)count:(NSString *)aString {
  return [self count:aString options:0];
}

- (NSString *)repeat:(NSUInteger)times {
  return [@"" stringByPaddingToLength:[self length] * times withString:self startingAtIndex:0];
}

- (NSUInteger)indentationLevel {
  NSUInteger re = 0;
  
  while (re < self.length 
         && [[self substringWithRange:NSMakeRange(re, 1)] isEqualToString:@" "]) 
  {
    re++;
  }
  
  return re;
}

- (BOOL)contains:(NSString *)aString {
  return [self rangeOfString:aString].location != NSNotFound;
}

- (BOOL)containsAnyOf:(NSArray *)array {
  for (id v in array) {
    NSString *s = [v description];
    
    if ([v isKindOfClass:[NSString class]]) {
      s = (NSString *)v;
    }
    
    if ([self contains:s]) {
      return YES;
    }
  }
           
  return NO;         
}

- (BOOL)containsAllOf:(NSArray *)array {
  for (id v in array) {
    NSString *s = [v description];
    
    if ([v isKindOfClass:[NSString class]]) {
      s = (NSString *)v;
    }
    
    if (![self contains:s]) {
      return NO;
    }
  }
  
  return YES;
}

- (BOOL)startsWith:(NSString *)aString {
  return [self hasPrefix:aString];
}

- (BOOL)endsWith:(NSString *)aString {
  return [self hasSuffix:aString];
}

- (BOOL)hasPrefix:(NSString *)prefix andSuffix:(NSString *)suffix {
  return [self hasPrefix:prefix] && [self hasSuffix:suffix];
}

- (NSString *)substringBetweenPrefix:(NSString *)prefix
                           andSuffix:(NSString *)suffix
{
  NSRange pre = [self rangeOfString:prefix];
  NSRange suf = [self rangeOfString:suffix];
  
  if (pre.location == NSNotFound || suf.location == NSNotFound) {
    return nil;
  }
  
  NSUInteger loc = pre.location  + pre.length;
  NSUInteger len = self.length - loc - (self.length - suf.location);
  NSRange r = NSMakeRange(loc, len);
  
  //NSLog(@"Substring with range %i, %i, %@", loc, len, NSStringFromRange(r));
  
  return [self substringWithRange:r];
}

/**
 * Unlike the Object-C default rangeOfString
 * this method will return -1 if the String could not be found, not NSNotFound
 */
- (NSInteger)indexOf:(NSString *)aString
{
	return [self indexOf:aString afterIndex:0];
}

- (NSInteger)indexOf:(NSString *)aString afterIndex:(NSInteger)index
{
	NSRange lookupRange = NSMakeRange(0, self.length);
	
	if (index < 0 && -index < self.length) {
		lookupRange.location = self.length + index;
	} else {
		if (index > self.length) {
      NSString *reason = [NSString stringWithFormat:
                          @"LookupIndex %i is not within range: Expected 0-%i", 
                          index, 
                          self.length];
			@throw [NSException exceptionWithName:@"ArrayIndexOutOfBoundsExceptions" 
																		 reason:reason
																	 userInfo:nil];
		}
		lookupRange.location = index;
	}

	NSRange range = [self rangeOfString:aString	options:0 range:lookupRange];
	return (range.location == NSNotFound ? -1 : range.location);
}

- (NSInteger)lastIndexOf:(NSString *)aString
{
	NSString *reversed = self.reversed;
	NSInteger pos = [reversed indexOf:aString];
	
	return pos == -1 ? -1 : self.length - pos;
}

- (NSRange)rangeOfAny:(NSSet *)strings {
  NSRange re = NSMakeRange(NSNotFound, 0);
  
  for (NSString *s in strings) {
    NSRange r = [self rangeOfString:s];
    if (r.location < re.location) {
      re = r;
    }
  }
  
  return re;
}

- (NSArray *)lines {
	return [self componentsSeparatedByString:@"\n"];
}

- (NSArray *)trimmedLines {
  return [self trimmedComponentsSeparatedByString:@"\n"];
}

- (NSArray *)words
{
  NSMutableArray *re = NSMutableArray.array;
  for (NSString *s in [self componentsSeparatedByString:@" "]) {
    if (!s.isEmpty) {
      [re addObject:s];
    }
  }
	return re;
}

- (NSSet *)wordSet {
  return [NSMutableSet setWithArray:self.words];
}

- (NSArray *)trimmedComponentsSeparatedByString:(NSString *)separator {
  NSMutableArray *re = NSMutableArray.array;
  
  for (NSString *s in [self componentsSeparatedByString:separator]) {
    s = s.trim;
    if (!s.isEmpty) {
      [re addObject:s];
    }
  }
  
  return re;
}

- (NSArray *)decolonize {
	return [self componentsSeparatedByString:@":"];
}

- (NSArray *)splitByComma {
	return [self componentsSeparatedByString:@","];
}

- (NSString *)substringBefore:(NSString *)delimiter {
  NSInteger index = [self indexOf:delimiter];
  if (index == -1) {
    return self;
  }
  return [self substringToIndex:index];
}

- (NSString *)substringAfter:(NSString *)delimiter {
  NSInteger index = [self indexOf:delimiter];
  if (index == -1) {
    return self;
  }
  return [self substringFromIndex:index + delimiter.length];
}

- (NSArray *)splitAt:(NSString *)delimiter {
  NSRange index = [self rangeOfString:delimiter];
  if (index.location == NSNotFound) {
    return [NSArray arrayWithObjects:self, nil];
  }
  return [NSArray arrayWithObjects:
          [self substringToIndex:index.location],
          [self substringFromIndex:index.location + index.length],
          nil
          ];
}

- (BOOL)splitAt:(NSString *)delimiter 
           head:(NSString **)head 
           tail:(NSString **)tail
{
  NSRange index = [self rangeOfString:delimiter];
  if (index.location == NSNotFound) {
    return NO;
  }
  
  NSString *copy = self.copy;
  
  *head = [copy substringToIndex:index.location];
  *tail = [copy substringFromIndex:index.location + index.length];
  
  [copy release];
  
  return YES;
}

- (NSArray *)decapitate {
  NSRange index = [self rangeOfString:@" "];
  if (index.location == NSNotFound) {
    return [NSArray arrayWithObjects:self, nil];
  }
  return [NSArray arrayWithObjects:
          [[self substringToIndex:index.location] trim],
          [[self substringFromIndex:index.location + index.length] trim],
          nil
          ];
}

- (NSUInteger)minutesValue {
  NSArray *split = [self componentsSeparatedByString:@":"];

  if (split.count > 1) {
    return [[split objectAtIndex:0] intValue] * 60 
      + [[split objectAtIndex:1] intValue];
  }
  
  return [self intValue];
}

- (NSUInteger)secondsValue {
  NSArray *split = [self componentsSeparatedByString:@":"];
  
  if (split.count > 2) {
    return [[split objectAtIndex:0] intValue] * 3600 
    + [[split objectAtIndex:1] intValue] * 60
    + [[split objectAtIndex:2] intValue];
  } else if (split.count == 2) {
    return [[split objectAtIndex:0] intValue] * 3600 
    + [[split objectAtIndex:1] intValue] * 60;
  }
  
  return [self intValue];
}

-(NSURL *)url {
  return [NSURL URLWithString:self];
}

-(NSURL *)fileURL {
  return [NSURL fileURLWithPath:self];
}

- (NSString *)ucfirst {
  NSString *head = [[self substringToIndex:1] uppercaseString];
  NSString *tail = [self substringFromIndex:1];
  return [NSString stringWithFormat:@"%@%@", head, tail];
}

- (NSString *)lcfirst {
  NSString *head = [[self substringToIndex:1] lowercaseString];
  NSString *tail = [self substringFromIndex:1];
  return [NSString stringWithFormat:@"%@%@", head, tail];
}

@end

@implementation NSString (TH_UserDefaults)

#define UVAL(T,N) -(T) N##InDefaults { \
  return [[NSUserDefaults standardUserDefaults] N##ForKey:self]; \
}

UVAL(id, object)
UVAL(BOOL, bool)
UVAL(NSInteger, integer)
UVAL(double, double)
UVAL(NSString *, string)
UVAL(NSURL *, URL)
UVAL(NSArray *, array)

-(NSDictionary *)dictionaryInDefaults {
  return [[NSUserDefaults standardUserDefaults] dictionaryForKey:self];
}

-(id)objectWithPathInDefaults {
  NSArray *segments = [self componentsSeparatedByString:@"."];
  if (segments.count == 1) {
    return [self objectInDefaults];
  }

  NSDictionary *here = [self dictionaryInDefaults];
  int i = 1, max = segments.count - 1;
  for (; i < max; i++) {
    here = [here objectForKey:[segments objectAtIndex:i]];
  }
  return [here objectForKey:[segments objectAtIndex:i]];
}

-(void)setObjectInDefaults:(id)object {
  NSArray *segments = [self componentsSeparatedByString:@"."];
  if (segments.count == 1) {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:self];
    return;
  }

  NSAssert1(segments.count == 2, @"A key-path must be one or two segments deep, not more: %@", self);

  NSString *dictKey = [segments first];
  NSString *valueKey = [segments second];

  NSMutableDictionary *dict = FALLBACK([dictKey.dictionaryInDefaults mutableCopy], [NSMutableDictionary new]);

  if (!object) {
    [dict removeObjectForKey:valueKey];
  } else {
    [dict setObject:object forKey:valueKey];
  }

  [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:dict] forKey:dictKey];

  [dict release];
}

-(void)setFloatInDefaults:(float)value {
  [self setObjectInDefaults:[NSNumber numberWithFloat:value]];
}

-(void)unsetObjectInDefaults {
  [self setObjectInDefaults:nil];
}

@end
