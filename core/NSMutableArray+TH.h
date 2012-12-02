//
//  NSMutableArray+PHP.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 18.06.09.
//  Copyright 2009 Rainbow Labs UG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (TH)

// sugar properties
@property (retain) id last;
@property (retain) id first;

// alike removeLastObject
-(void)removeFirstObject;

//
// shift & pop for stacklike operations
// they will return the removed objects
//

// removes and returns the first object in the array
// if no elements are present, nil will be returned
-(id)shift;

// removes and returns the last object in the array
// if no elements are present, nil will be returned
-(id)pop;

// shortcut for the default sortUsingSelector:@selector(compare:)
-(NSMutableArray *)sort;

// reverses the whole array
-(NSMutableArray *)reverse;

// randomizes the order of the array
-(NSMutableArray *)shuffle;

@end
