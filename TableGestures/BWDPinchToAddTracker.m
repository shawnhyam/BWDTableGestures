//
//  BWDPinchToAddTracker.m
//  TableGestures
//
//  Created by Shawn Hyam on 2012-09-13.
//  Copyright (c) 2012 Brierwood Design Co-operative Inc. All rights reserved.
//

#import "BWDPinchToAddTracker.h"
#import <QuartzCore/QuartzCore.h>
#import "BWDFoldingView.h"


@implementation BWDPinchToAddTracker

- (void)setup {
    UIView *hiddenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), self.tableView.rowHeight)];
    hiddenView.backgroundColor = [UIColor whiteColor];
    self.hiddenView = hiddenView;
    self.shouldAdd = NO;
}

- (void)teardown {
    [UIView animateWithDuration:0.3 animations:^{
        for (UITableViewCell *cell in self.tableView.visibleCells) {
            cell.layer.affineTransform = CGAffineTransformIdentity;
        }
    }];
    
    [self.foldingView removeFromSuperview];
    self.foldingView = nil;
    self.shouldAdd = NO;
}

- (void)didPinch:(UIPinchGestureRecognizer*)pgr {
    NSLog(@"state: %d", pgr.state);
    
    if (pgr.state == UIGestureRecognizerStateBegan) {
        [self setup];
        
        // get the two touches
        CGPoint location1 = [pgr locationOfTouch:0 inView:self.tableView];
        CGPoint location2 = [pgr locationOfTouch:1 inView:self.tableView];
        
        if (location1.y < location2.y) {
            self.topAnchor = location1;
            self.bottomAnchor = location2;
        } else {
            self.topAnchor = location2;
            self.bottomAnchor = location1;
        }
        
        // mark the index path where the new row will be added
        CGFloat y = (location1.y + location2.y) / 2.0;
        self.addingIndexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(50, y + self.tableView.rowHeight/2)];
        
        //
        UIGraphicsBeginImageContextWithOptions(self.hiddenView.bounds.size, self.hiddenView.opaque, 0.0);
        [self.hiddenView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView *iv1 = [[UIImageView alloc] initWithImage:viewImage];
        UIImageView *iv2 = [[UIImageView alloc] initWithImage:viewImage];
        iv1.contentMode = UIViewContentModeTop;
        iv2.contentMode = UIViewContentModeBottom;
        
        CGRect f = [self.tableView rectForRowAtIndexPath:self.addingIndexPath];
        self.foldingView = [[BWDFoldingView alloc] initWithFrame:f];
        self.foldingView.topView = iv1;
        self.foldingView.bottomView = iv2;
        [self.tableView addSubview:self.foldingView];
        [self.foldingView foldToHeight:0];
        
        self.shouldAdd = NO;
        
    } else if (pgr.state == UIGestureRecognizerStateChanged) {
        // possible there is only one touch going on, we aren't going to think about that
        if (pgr.numberOfTouches != 2) return;
        
        // get the two touches
        CGPoint location1 = [pgr locationOfTouch:0 inView:self.tableView];
        CGPoint location2 = [pgr locationOfTouch:1 inView:self.tableView];
        
        // make the first one the 'higher' one
        if (location1.y > location2.y) {
            CGPoint tmp = location1;
            location1 = location2;
            location2 = tmp;
        }
        
        // calculate how far the user has pinched 'up'
        CGFloat top_delta =  location1.y - self.topAnchor.y;   // should be negative
        CGFloat bottom_delta = location2.y - self.bottomAnchor.y;   // hopefully will be positive
        
        if (bottom_delta < top_delta) bottom_delta = top_delta;
        
        for (UITableViewCell *cell in self.tableView.visibleCells) {
            NSIndexPath *ip = [self.tableView indexPathForCell:cell];
            if (ip.row < self.addingIndexPath.row) {
                cell.layer.affineTransform = CGAffineTransformMakeTranslation(0, top_delta);
            } else  {
                cell.layer.affineTransform = CGAffineTransformMakeTranslation(0, bottom_delta);
            }
        }
        
        
        // want to even out room below and above
        CGFloat total_room = bottom_delta - top_delta;
        CGFloat gap = (total_room - self.tableView.rowHeight) / 2.0;
        [self.foldingView foldToHeight:total_room];
        self.foldingView.layer.affineTransform = CGAffineTransformMakeTranslation(0, top_delta + gap);
        
        self.tableOffset = top_delta + gap;
        
        self.shouldAdd = (total_room >= self.tableView.rowHeight);
    } else if (pgr.state == UIGestureRecognizerStateEnded) {
        // however, we may not have pinched far enough
        if (self.shouldAdd) {
            [self.tableView beginUpdates];
            [self.delegate addTableRowAtIndexPath:self.addingIndexPath];
            [self teardown];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y-self.tableOffset);
            }];
            [self.tableView endUpdates];
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.addingIndexPath];
            cell.layer.affineTransform = CGAffineTransformMakeTranslation(0, self.tableOffset);
            
            [UIView animateWithDuration:0.3 animations:^{
                cell.layer.affineTransform = CGAffineTransformIdentity;
            }];
        } else {
            [self teardown];
        }
    } else if (pgr.state == UIGestureRecognizerStateFailed) {
        [self teardown];
    }
}

@end
