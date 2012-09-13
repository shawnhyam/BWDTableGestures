//
//  BWDPinchToAddTracker.h
//  TableGestures
//
//  Created by Shawn Hyam on 2012-09-13.
//  Copyright (c) 2012 Brierwood Design Co-operative Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BWDFoldingView;

@protocol BWDPinchTrackerDelegate <NSObject>
- (void)addTableRowAtIndexPath:(NSIndexPath*)indexPath;
@end





@interface BWDPinchToAddTracker : NSObject

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *hiddenView;
@property (nonatomic, strong) BWDFoldingView *foldingView;

@property (nonatomic, assign) CGFloat tableOffset;
@property (nonatomic, assign) CGPoint topAnchor, bottomAnchor;
@property (nonatomic, strong) NSIndexPath *addingIndexPath;
@property (nonatomic, assign) BOOL shouldAdd;
@property (nonatomic, retain) id<BWDPinchTrackerDelegate> delegate;


@end
