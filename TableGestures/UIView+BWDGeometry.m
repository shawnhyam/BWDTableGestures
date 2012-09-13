//
//  UIView+BWDGeometry.m
//  TableGestures
//
//  Created by Shawn Hyam on 2012-09-13.
//  Copyright (c) 2012 Brierwood Design Co-operative Inc. All rights reserved.
//

#import "UIView+BWDGeometry.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (BWDGeometry)

- (void)transformToVisibleHeight:(CGFloat)height rotateDown:(BOOL)rotateDown {
    CGFloat targetHeight = MAX(MIN(height, CGRectGetHeight(self.bounds)), 1);
    CGFloat proportion = targetHeight / CGRectGetHeight(self.bounds);
    CGFloat rotation = acos(proportion);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0/-400.0;
    transform = CATransform3DTranslate(transform, 0, rotateDown ? -targetHeight : targetHeight, 0);
    transform = CATransform3DRotate(transform, rotation, rotateDown ? -1 : 1, 0, 0);
    self.layer.anchorPoint = CGPointMake(0.5, rotateDown ? 0 : 1);
    // set the final position; if you want to anchor it differently, change this
    self.layer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    self.layer.transform = transform;
}


@end
