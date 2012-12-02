//
//  NSSet+TH.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 25.10.09.
//  Copyright 2009 Rogue Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (TH)

- (NSSet *)subsetWithoutSet:(NSSet *)set;
- (NSSet *)subsetWithoutObject:(id)object;
- (NSSet *)subsetWithoutObjects:(id)object, ...;

/**
 * Returns YES when all members of the current array pass the isKindOfClass
 * test with the given Class
 */
- (BOOL)allKindOfClass:(Class)aClass;

/**
 * Returns a subArray with all members of the original array that pass the
 * isKindOfClass test with the given Class
 */
- (NSSet *)elementsOfClass:(Class)aClass;

@property (readonly) NSArray *array;
//- (NSArray *)arraySortedBy:(NSString *)sortDescription;

@property (readonly) id randomElement;
- (NSSet *)randomSubsetWithSize:(NSUInteger)size;

- (NSSet *)setWithKey:(NSString *)keyPath;
- (NSSet *)setPerformingSelector:(SEL)selector;
- (NSSet *)setPerformingSelector:(SEL)selector withObject:(id)object;

- (BOOL)containsAny:(id <NSFastEnumeration>)enumerable;
- (BOOL)containsAll:(id <NSFastEnumeration>)enumerable;

@end

@interface NSMutableSet (TH)

- (id)addSet:(NSSet *)set;

@end

