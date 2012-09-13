//
//  BWDFoldingView.m
//  TableGestures
//
//  Created by Shawn Hyam on 2012-09-13.
//  Copyright (c) 2012 Brierwood Design Co-operative Inc. All rights reserved.
//

#import "BWDFoldingView.h"
#import "UIView+BWDGeometry.h"
#import <QuartzCore/QuartzCore.h>

@implementation BWDFoldingView


- (void)setTopView:(UIView *)topView {
    _topView = topView;
    
    [self addSubview:topView];
    [self sendSubviewToBack:topView];
    
    topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/2);
    topView.clipsToBounds = YES;
}

- (void)setBottomView:(UIView *)bottomView {
    
    _bottomView = bottomView;
    
    [self addSubview:bottomView];
    [self sendSubviewToBack:bottomView];
    
    bottomView.frame = CGRectMake(0, CGRectGetHeight(self.bounds)/2, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/2);
    bottomView.clipsToBounds = YES;
}


- (void)foldToHeight:(CGFloat)height {
    CGFloat targetHeight = MAX(MIN(height, CGRectGetHeight(self.bounds)), 1);
    CGFloat proportion = targetHeight / CGRectGetHeight(self.bounds);
    
    self.bottomView.layer.opacity = proportion;
    self.topView.layer.opacity = proportion;
    
    [self.topView transformToVisibleHeight:height/2 rotateDown:YES];
    [self.bottomView transformToVisibleHeight:height/2 rotateDown:NO];
}


@end
