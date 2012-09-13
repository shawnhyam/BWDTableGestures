//
//  BWDTableViewController.m
//  TableGestures
//
//  Created by Shawn Hyam on 2012-09-11.
//  Copyright (c) 2012 Brierwood Design Co-operative Inc. All rights reserved.
//

#import "BWDTableViewController.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <QuartzCore/QuartzCore.h>
#import "UIView+BWDGeometry.h"
#import "BWDLongPressReorderTracker.h"
#import "BWDPinchToAddTracker.h"


@interface BWDTableViewController ()

@property (nonatomic, strong) BWDPinchToAddTracker *pinchTracker;
@property (nonatomic, strong) BWDLongPressReorderTracker *longPressTracker;

@end

@implementation BWDTableViewController {
    int _numRows;
}

- (void)addTableRowAtIndexPath:(NSIndexPath*)indexPath {
    _numRows++;
    [self.tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.pinchTracker = [[BWDPinchToAddTracker alloc] init];
    self.pinchTracker.tableView = self.tableView;
    self.pinchTracker.delegate = self;
    
    UIPinchGestureRecognizer *pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self.pinchTracker action:@selector(didPinch:)];
    [self.tableView addGestureRecognizer:pgr];
    
    
    self.longPressTracker = [[BWDLongPressReorderTracker alloc] init];
    self.longPressTracker.tableView = self.tableView;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self.longPressTracker action:@selector(didLongPress:)];
    [self.tableView addGestureRecognizer:lpgr];
 
    
    _numRows = 8;
    
    self.tableView.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.tableView.backgroundView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _numRows;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = [[UIView alloc] init];
    cell.backgroundView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%d", rand()%100];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WorkoutsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    // Configure the cell...
    return cell;
}


@end
