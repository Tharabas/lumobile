//
//  NSMutableString+TH.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 24.10.09.
//  Copyright 2009 Rogue Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+TH.h"

@interface NSMutableString (TH)

- (NSString *)shift;
- (NSString *)pop;

- (BOOL)removePrefix:(NSString *)prefix;
- (BOOL)removeSuffix:(NSString *)suffix;
- (BOOL)removePrefix:(NSString *)prefix andSuffix:(NSString *)suffix;

- (NSMutableString *)camelize;
- (NSMutableString *)hyphonize;
- (NSMutableString *)underscorize;
- (NSMutableString *)replaceAll:(NSString *)needle 
                     withString:(NSString *)replacement;

@end