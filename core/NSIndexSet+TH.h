//
//  NSIndexSet+TH.h
//  fruitris
//
//  Created by Benjamin Schüttler on 16.04.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexSet (TH)
+(NSIndexSet *)indexSetWithIndexes:(NSUInteger *)indexes count:(NSUInteger)count;
+(NSIndexSet *)indexSetWithIndexes:(NSUInteger)index,...;
-(NSIndexSet *)randomSubsetOfLength:(NSUInteger)length;
@end
