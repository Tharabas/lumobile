//
//  CCLabelTTF+TH.m
//  frutris
//
//  Created by Benjamin Schüttler on 28.05.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

//
// Ideas and some code taken from http://www.cocos2d-iphone.org/forum/topic/12126
// Thanks for the help, guys
//

#import "CCLabelTTF+TH.h"
#import "THGeometricFunctions.h"
#import "UIColor+TH.h"

#define kTagStroke 1029384756

@implementation CCLabelTTF (TH)

-(CCRenderTexture *)createStrokeWithSize:(float)size color:(ccColor3B)color  {
	CGPoint originalPos = [self position];
	ccColor3B originalColor = [self color];
	BOOL originalVisibility = [self visible];
	ccBlendFunc originalBlend = [self blendFunc];
  float originalRotation = [self rotation];

  self.rotation = 0;
  CGSize contentSize = self.texture.contentSize;
	CCRenderTexture* rt = [CCRenderTexture renderTextureWithWidth:contentSize.width + size * 2 
                                                         height:contentSize.height + size * 2];
  
  CGPoint ptAnchor = THMultiplyPointBySize(self.anchorPoint, contentSize);
  
	[self setColor:color];
	[self setVisible:YES];
	[self setBlendFunc:(ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];

	CGPoint bottomLeft = ccp(ptAnchor.x + size, ptAnchor.y + size);
	CGPoint positionOffset = ccp(ptAnchor.x - contentSize.width  / 2, 
                               ptAnchor.y - contentSize.height / 2);
	CGPoint position = ccpSub(originalPos, positionOffset);
  
	[rt begin];
   // you should optimize that for your needs
	for (int i = 0; i < 360; i += 30) {
    float rot = CC_DEGREES_TO_RADIANS(i);
    self.position = ccp(bottomLeft.x + sin(rot) * size, 
                        bottomLeft.y + cos(rot) * size);
		[self visit];
	}
	[rt end];
  
  // restore old values
  [self setRotation:originalRotation];
	[self setPosition:originalPos];
	[self setColor:originalColor];
	[self setBlendFunc:originalBlend];
	[self setVisible:originalVisibility];
  
	[rt setPosition:position];
	return rt;
}

-(void)setStrokeWithSize:(float)size {
  UIColor *c = [UIColor colorWithRed:self.color.r green:self.color.g blue:self.color.b];
  ccColor3B contrastColor = c.isDark ? ccc3(0xF0, 0xF0, 0xF0) : ccc3(0x10, 0x10, 0x10);
  [self setStrokeWithSize:size color:contrastColor];
}

-(void)setStrokeWithSize:(float)size color:(ccColor3B)color {
  [self removeStroke];
  CCRenderTexture *texture = [self createStrokeWithSize:size color:color];
  texture.position = THMultiplyPointBySize(THHalfPoint, self.contentSize);
  texture.scale = self.scale;
  
  [self addChild:texture z:-1 tag:kTagStroke];
}

-(void)removeStroke {
  if ([self getChildByTag:kTagStroke]) {
    [self removeChildByTag:kTagStroke cleanup:YES];
  }
}

@end

@implementation CCMenuItemFont (TH)

-(void)setStrokeWithSize:(float)size {
  if (![[self label] isKindOfClass:CCLabelTTF.class]) return;
  [(CCLabelTTF *)self.label setStrokeWithSize:size];
}

-(void)setStrokeWithSize:(float)size color:(ccColor3B)color {
  if (![[self label] isKindOfClass:CCLabelTTF.class]) return;
  [(CCLabelTTF *)self.label setStrokeWithSize:size color:color];
}

-(void)removeStroke {
  if (![[self label] isKindOfClass:CCLabelTTF.class]) return;
  [(CCLabelTTF *)self.label removeStroke];
}

@end
