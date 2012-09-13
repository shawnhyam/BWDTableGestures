//
//  BWDLongPressReorderTracker.h
//  TableGestures
//
//  Created by Shawn Hyam on 2012-09-13.
//  Copyright (c) 2012 Brierwood Design Co-operative Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWDLongPressReorderTracker : NSObject

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *startIndexPath;
@property (nonatomic, assign) CGFloat startY;

@end
