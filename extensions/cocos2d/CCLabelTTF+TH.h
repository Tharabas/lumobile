//
//  CCLabelTTF+TH.h
//  frutris
//
//  Created by Benjamin Schüttler on 28.05.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import "cocos2d.h"
#import "CCLabelTTF.h"
#import "CCMenuItem.h"

@interface CCLabelTTF (TH)

-(CCRenderTexture*)createStrokeWithSize:(float)size color:(ccColor3B)color;
-(void)setStrokeWithSize:(float)size;
-(void)setStrokeWithSize:(float)size color:(ccColor3B)color;
-(void)removeStroke;

@end

@interface CCMenuItemFont (TH)

-(void)setStrokeWithSize:(float)size;
-(void)setStrokeWithSize:(float)size color:(ccColor3B)color;
-(void)removeStroke;

@end
