//
//  THEffects.h
//  frutris
//
//  Created by Benjamin Schüttler on 15.08.12.
//  Copyright (c) 2012 Rainbow Labs UG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface THEffects : NSObject

@property (nonatomic, retain) id setUp, show, hide, tearDown;
@property (nonatomic, assign) ccTime delay, displayTime;
@property (nonatomic, assign) BOOL cleanupAfterRun;

@property (readonly) id chain;

-(id)chainWithDelay:(ccTime)delay displayTime:(ccTime)displayTime;

-(THEffects *)withDelay:(ccTime)delay;
-(THEffects *)withSetup:(id)effects;
-(THEffects *)then:(id)effects;

+(THEffects *)fx;

+(THEffects *)dropEffect;
+(THEffects *)dropEffectWithOffset:(CGPoint)offset;

+(THEffects *)numSlide;
+(THEffects *)numSlideWithOffset:(CGPoint)offset;

@end
