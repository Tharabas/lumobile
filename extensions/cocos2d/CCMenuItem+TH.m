//
//  CCMenuItem+TH.m
//  frutris
//
//  Created by Benjamin Schüttler on 31.07.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import "CCMenuItem+TH.h"

@implementation CCMenuItemImage (TH)

//
// SpriteFrameName initializers
//
+(id) itemWithNormalFrame:(NSString *)normalF block:(void (^)(id))block {
  return [[[self alloc] initWithNormalFrame:normalF selectedFrame:nil disabledFrame:nil block:block] autorelease];
}

+(id) itemWithNormalFrame:(NSString *)normalF selectedFrame:(NSString *)selectedF block:(void (^)(id))block {
  return [[[self alloc] initWithNormalFrame:normalF selectedFrame:selectedF disabledFrame:nil block:block] autorelease];
}

+(id) itemWithNormalFrame:(NSString *)normalF selectedFrame:(NSString *)selectedF disabledFrame:(NSString *)disabledF block:(void (^)(id))block {
  return [[[self alloc] initWithNormalFrame:normalF selectedFrame:selectedF disabledFrame:disabledF block:block] autorelease];
}

-(id) initWithNormalFrame:(NSString *)normalF selectedFrame:(NSString *)selectedF disabledFrame:(NSString *)disabledF block:(void (^)(id))block {
	CCNode<CCRGBAProtocol> *normalImage = [CCSprite spriteWithSpriteFrameName:normalF];
	CCNode<CCRGBAProtocol> *selectedImage = nil;
	CCNode<CCRGBAProtocol> *disabledImage = nil;
  
	if (selectedF)
		selectedImage = [CCSprite spriteWithSpriteFrameName:selectedF];
	if (disabledF)
		disabledImage = [CCSprite spriteWithSpriteFrameName:disabledF];
  
	return [super initWithNormalSprite:normalImage selectedSprite:selectedImage disabledSprite:disabledImage block:block];
}

@end
