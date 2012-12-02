//
//  UIColor+Cocos.h
//  cocotut
//
//  Created by Benjamin Schüttler on 12.07.11.
//  Copyright 2011 Rainbow Labs UG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface UIColor (UIColor_Cocos)

@property (readonly) ccColor3B c3b;
@property (readonly) ccColor4B c4b;
@property (readonly) ccColor4F c4f;

-(void)setCCDrawColor;

@end
