//
//  NSDictionary+TH.h
//  frutris
//
//  Created by Benjamin Schüttler on 12.09.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (TH)

-(BOOL)boolForKey:(NSString *)key;
-(int)intForKey:(NSString *)key;
-(float)floatForKey:(NSString *)key;
-(NSString *)stringForKey:(NSString *)key;
-(NSArray *)arrayForKey:(NSString *)key;

@end
