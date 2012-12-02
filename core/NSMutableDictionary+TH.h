//
//  NSMutableDictionary+TH.h
//  frutris
//
//  Created by Benjamin Schüttler on 11.09.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (TH)

-(void)addInteger:(NSInteger)value toKey:(NSString *)key;
-(NSInteger)incrementIntAtKey:(NSString *)key;
-(void)updateObjectAtKey:(NSString *)key withBlock:(id(^)(id object))block;

@end
