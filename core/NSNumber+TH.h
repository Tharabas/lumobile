//
//  NSNumber+TH.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 11.11.09.
//  Copyright 2009 Rogue Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber(TH)

+(NSNumber *)zero;
+(NSNumber *)one;
+(NSNumber *)two;

-(NSNumber *)abs;
-(NSNumber *)negate;
-(NSNumber *)transpose;

-(NSArray *)times:(id (^)(void))block;

-(NSArray *)to:(NSNumber *)to;
-(NSArray *)to:(NSNumber *)to by:(NSNumber *)by;

@property (readonly) NSString *localDecimal;

@end
