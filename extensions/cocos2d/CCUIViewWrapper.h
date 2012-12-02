//
//  CCUIViewWrapper.h
//  frutris
//
//  Created by Benjamin Schüttler on 08.07.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//
//  Taken from http://www.cocos2d-iphone.org/forum/topic/6889
//  So no credits to me for this one ;)
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface CCUIViewWrapper : CCSprite {
	UIView *uiItem;
	float rotation;
}

@property (nonatomic, retain) UIView *uiItem;

+ (id) wrapperForUIView:(UIView*)ui;
- (id) initForUIView:(UIView*)ui;

- (void) updateUIViewTransform;

@end
