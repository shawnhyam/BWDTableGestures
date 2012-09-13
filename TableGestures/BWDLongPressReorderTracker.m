//
//  BWDLongPressReorderTracker.m
//  TableGestures
//
//  Created by Shawn Hyam on 2012-09-13.
//  Copyright (c) 2012 Brierwood Design Co-operative Inc. All rights reserved.
//

#import "BWDLongPressReorderTracker.h"
#import <QuartzCore/QuartzCore.h>

@implementation BWDLongPressReorderTracker

- (void)didLongPress:(UILongPressGestureRecognizer*)longPressGR {
    CGPoint location1 = [longPressGR locationOfTouch:0 inView:self.tableView];
    
    if (longPressGR.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *ip = [self.tableView indexPathForRowAtPoint:location1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
        
        self.startIndexPath = ip;
        self.startY = location1.y;
        
        [self.tableView bringSubviewToFront:cell];
        [UIView animateWithDuration:0.2 animations:^{
            cell.layer.affineTransform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.2, 1.2), 40, 0);
        }];
        
    } else if (longPressGR.state == UIGestureRecognizerStateEnded) {
        NSIndexPath *ip2 = [self.tableView indexPathForRowAtPoint:location1];
        
        [self.tableView beginUpdates];
        [self.tableView moveRowAtIndexPath:self.startIndexPath toIndexPath:ip2];
        
        [UIView animateWithDuration:0.3 animations:^{
            for (UITableViewCell *cell in self.tableView.visibleCells) {
                cell.layer.affineTransform = CGAffineTransformIdentity;
            }
        }];
        
        
        [self.tableView endUpdates];
        
    } else if (longPressGR.state == UIGestureRecognizerStateChanged) {
        NSIndexPath *ip2 = [self.tableView indexPathForRowAtPoint:location1];
        
        [UIView animateWithDuration:0.3 animations:^{
            for (UITableViewCell *cell in self.tableView.visibleCells) {
                NSIndexPath *index = [self.tableView indexPathForCell:cell];
                if ([index isEqual:self.startIndexPath]) continue;
                
                if (index.row >= self.startIndexPath.row && index.row <= ip2.row) {
                    cell.layer.affineTransform = CGAffineTransformMakeTranslation(0, -self.tableView.rowHeight);
                    
                } else if (index.row >= ip2.row && index.row <= self.startIndexPath.row) {
                    cell.layer.affineTransform = CGAffineTransformMakeTranslation(0, self.tableView.rowHeight);
                } else {
                    cell.layer.affineTransform = CGAffineTransformIdentity;
                }
            }
        }];
        
        CGFloat d = location1.y-self.startY;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.startIndexPath];
        cell.layer.affineTransform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.2, 1.2), 40, d);
    }
}


@end
