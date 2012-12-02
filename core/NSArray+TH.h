//
//  NSArray+TH.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 20.05.09.
//  Copyright 2009 Rogue Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+TH.h"

@interface NSArray (TH)

/**
 * Returns an NSArray containing a number of NSNumber elements
 * that have been initialized with NSInteger values.
 *
 * As this method takes a variadic argument list you have to terminate
 * the input with a NSNotFound entry
 * This is done automatically via the $ints(...) macro
 */
+ (NSArray *)arrayWithInts:(NSInteger)i,...;

/**
 * Returns an NSArray containing a number of NSNumber elements
 * that have been initialized with double values.
 *
 * As this method takes a variadic argument list you have to terminate
 * the input with a FLOAT_MAX entry
 * This is done automatically via the $doubles(...) macro
 */
+ (NSArray *)arrayWithDoubles:(double)d,...;

/**
 * Returns an NSSet containing the same elements as the array
 * (unique of course, as the set does not keep doubled entries)
 */
@property (readonly) NSSet *set;

@property (readonly) NSArray *shifted;
@property (readonly) NSArray *popped;
@property (readonly) NSArray *reversed;

/**
 * Returns an array of the same size as the original one
 * with the result of calling the keyPath on each object
 */
- (NSArray *)arrayWithKey:(NSString *)keyPath;

/**
 * Returns an array of the same size as the original one
 * with the result of performing the selector on each object
 */
- (NSArray *)arrayPerformingSelector:(SEL)selector;

/**
 * Returns an array of the same size as the original one
 * with the result of performing the selector on each object
 */
- (NSArray *)arrayPerformingSelector:(SEL)selector withObject:(id)object;

/**
 * Returns an array of the same size as the original one
 * with the results of performing the block on each object
 */
- (NSArray *)arrayUsingBlock:(id (^)(id obj))block;

/**
 * Shortcut for the arrayUsingBlock method
 * map is better known in more functional oriented languages
 */
- (NSArray *)map:(id (^)(id obj))block;

- (NSArray *)nmap:(id (^)(id obj, NSUInteger index))block;

/**
 * performs consecutive calls of block for every pair of elements in this array
 */
- (id)reduce:(id (^)(id a, id b))block;

/**
 * Performs a flatten operation on an array
 * 
 * Each element Array will be expanded so that one level of Arrays is removed
 */
- (NSArray *)flattened;

/**
 * Will return an array that does not contain the given object
 * When the object is part of the array it will return a new array
 * Otherwise it will return the array itself
 */
- (NSArray *)replaceWithArrayByRemovingObject:(id)object;

/**
 * Will return an array dropping the object at the current index
 * When the index is out of the bounds of this array, it will return the array itself
 * Otherwise it will return a new array
 */
- (NSArray *)replaceWithArrayByRemovingObjectAtIndex:(NSUInteger)index;

/**
 * Will return a new array by adding object with retain count 1
 * Calls release on the original array
 * Used for implicit pushing of Elements
 */
- (NSArray *)replaceWithArrayByAddingObject:(id)object;

/**
 * Returns a subArray that does not contain the object at the given index
 * In case the index is outside the bounds of the array, it will return a copy of the array itself
 * The returned array is autoreleased
 */
- (NSArray *)arrayWithoutObjectAtIndex:(NSUInteger)index;

/**
 * Returns a subArray that does not contain the argument object
 */
- (NSArray *)arrayWithoutObject:(id)object;

/**
 * Returns a subArray that does not contain any of the passed arguments
 */
- (NSArray *)arrayWithoutObjects:(id)object,...;

/**
 * Returns a subArray that does not contain any value that the passed
 * NSArray contains
 */
- (NSArray *)arrayWithoutArray:(NSArray *)value;

/**
 * Returns a subArray that does not contain any value that the passed
 * NSSet contains
 */
- (NSArray *)arrayWithoutSet:(NSSet *)values;

/**
 * Returns a subArray in wich all object returned true for the block
 * Reduced version of filteredArrayUsingBlock, without the dictionary
 */
- (NSArray *)filter:(BOOL (^)(id object))block;

/**
 * Filters one element from the array that returns YES from the called block
 * might not always be the same, it just will return any match!
 * In case you are not absolutely sure that there is only ONE match
 * better use filter and grab the result manually
 * will return nil for no match
 */
- (id)filterOne:(BOOL (^)(id object))block;

/**
 * Returns YES when all members of the current array pass the isKindOfClass
 * test with the given Class
 */
- (BOOL)allKindOfClass:(Class)aClass;

/**
 * Returns a subArray with all members of the original array that pass the
 * isKindOfClass test with the given Class
 */
- (NSArray *)elementsOfClass:(Class)aClass;

/**
 * Shortcut for elementsOfClass:NSNumber.class
 */
@property (readonly) NSArray *numbers;

/**
 * Shortcut for elementsOfClass:NSString.class
 */
@property (readonly) NSArray *strings;
/**
 * Returns a subArray with all NSString members and calls trim on each
 * before returning
 */
@property (readonly) NSArray *trimmedStrings;

- (NSArray *)subarrayFromIndex:(NSInteger)start;
- (NSArray *)subarrayToIndex:(NSInteger)end;
- (NSArray *)subarrayFromIndex:(NSInteger)start toIndex:(NSInteger)end;

/**
 * Returns a random element from this array
 */
@property (readonly) id randomElement;

/**
 * Returns a random subArray of this array with up to 'size' elements
 */
- (NSArray *)randomSubarrayWithSize:(NSUInteger)size;

/**
 * Returns a shuffeled version of this array
 */
@property (readonly) NSArray *shuffeled;

/**
 * Sorts an array by defining descriptors from a definition string
 */
- (NSArray *)sortedArrayByProperties:(NSString *)definition;

/**
 * A failsave version of objectAtIndex
 * When the given index is outside the bounds of the array
 * it will be projected onto the bounds of the array
 *
 * Just imagine the array to be a ring 
 * that will have its first and last element connected to each other
 */
- (id)objectAtNormalizedIndex:(NSInteger)index;

/**
 * A failsave version of objectAtIndex
 * that will return the fallback value
 * in case an error occurrs or the value is nil
 */
- (id)objectAtIndex:(NSUInteger)index fallback:(id)fallback;

/**
 * Will at least return nil in case the index does not fit the array
 */
- (id)objectOrNilAtIndex:(NSUInteger)index;

@property (readonly) id first;
@property (readonly) id second;
@property (readonly) id third;
@property (readonly) id fourth;
@property (readonly) id fifth;
@property (readonly) id sixth;

- (NSInteger)sumIntWithKey:(NSString *)keyPath;
- (CGFloat)sumFloatWithKey:(NSString *)keyPath;

/**
 * Returns YES when this array contains any of the elements in enumerable
 */
- (BOOL)containsAny:(id <NSFastEnumeration>)enumerable;

/**
 * Returns YES when this array contains all of the elements in enumerable
 */
- (BOOL)containsAll:(id <NSFastEnumeration>)enumerable;

/**
 * dummy, just for the 'foreach' macro
 */
-(id)andExecuteEnumeratorBlock;

/**
 * Just a case study at the moment.
 *
 * Just another way of writing enumerateUsingBlock,
 * but as it's written kvc conform the foreach macro can be used
 * to write code like
 *
 * foreach (id o, array) {
 *   ...
 * }
 */
-(void)setAndExecuteEnumeratorBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

/**
 *
 */
-(NSArray *)objectsWithFormat:(NSString *)format, ...;
-(id)firstObjectWithFormat:(NSString *)format, ...;

-(NSArray *)filteredArrayUsingBlock:
  (BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;
@end