//
//  NSIndexPath+TH.h
//  TK-Suite
//
//  Created by Benjamin Schüttler on 10.05.11.
//  Copyright 2011 Rainbow Labs UG. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSIndexPath (TH)

+(NSIndexPath *)indexPathWithSection:(NSUInteger)section row:(NSUInteger)row;

@property (readonly) NSString *path;

@end
