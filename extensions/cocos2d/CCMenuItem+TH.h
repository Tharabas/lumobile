//
//  CCMenuItem+TH.h
//  frutris
//
//  Created by Benjamin Schüttler on 31.07.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import "CCMenuItem.h"
#import "cocos2d.h"

@interface CCMenuItemImage (TH)

+(id) itemWithNormalFrame:(NSString *)normalF block:(void (^)(id))block;
+(id) itemWithNormalFrame:(NSString *)normalF selectedFrame:(NSString *)selectedF block:(void (^)(id))block;
+(id) itemWithNormalFrame:(NSString *)normalF selectedFrame:(NSString *)selectedF disabledFrame:(NSString *)disabledF block:(void (^)(id))block;
-(id) initWithNormalFrame:(NSString *)normalF selectedFrame:(NSString *)selectedF disabledFrame:(NSString *)disabledF block:(void (^)(id))block;

@end
