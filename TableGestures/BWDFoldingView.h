//
//  BWDFoldingView.h
//  TableGestures
//
//  Created by Shawn Hyam on 2012-09-13.
//  Copyright (c) 2012 Brierwood Design Co-operative Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWDFoldingView : UIView

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) CGFloat apparentHeight;

- (void)foldToHeight:(CGFloat)height;

@end
