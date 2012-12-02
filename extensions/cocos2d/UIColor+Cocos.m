//
//  UIColor+Cocos.m
//  cocotut
//
//  Created by Benjamin Schüttler on 12.07.11.
//  Copyright 2011 Rainbow Labs UG. All rights reserved.
//

#import "UIColor+Cocos.h"
#import "UIColor+TH.h"

@implementation UIColor (UIColor_Cocos)

-(ccColor3B)c3b {
  CGFloat *rgba = self.components;
  return ccc3(0xFF * rgba[0], 0xFF * rgba[1], 0xFF * rgba[2]);
}

-(ccColor4B)c4b {
  CGFloat *rgba = self.components;
  return ccc4(0xFF * rgba[0], 0xFF * rgba[1], 0xFF * rgba[2], 0xFF * rgba[3]);
}

-(ccColor4F)c4f {
  CGFloat *rgba = self.components;
  return (ccColor4F) { (GLfloat) rgba[0], (GLfloat) rgba[1], (GLfloat) rgba[2], (GLfloat) rgba[3] };
}

-(void)setCCDrawColor {
  CGFloat *rgba = self.components;
  ccDrawColor4F(rgba[0], rgba[1], rgba[2], rgba[3]);
}

@end
