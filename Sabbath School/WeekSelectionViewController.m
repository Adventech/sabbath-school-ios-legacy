//
//  WeekSelectionViewController.m
//  Sabbath School
//
//  Created by Vitaliy L on 2/17/2014.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import "WeekSelectionViewController.h"
#import "SSCore.h"
#import "Utils.h"
#import "UIViewController+KNSemiModal.h"
#import "MenuViewController.h"
#import "SWRevealViewController.h"

NSMutableArray *ssLessons = nil;

@interface WeekSelectionViewController ()

@end

@implementation WeekSelectionViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.view.frame = CGRectMake(0, 0, 320, 200);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ssLessons = [SSCore ssGetLessons];
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [ssLessons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	NSInteger row = indexPath.row;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        UIView *cellBackgroundView = [[UIView alloc] init];
        cellBackgroundView.backgroundColor = [Utils colorWithHex:0x000000 alpha:0.2];
        cell.selectedBackgroundView = cellBackgroundView;
        
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,3,cell.frame.size.width-100, 20)];
        headerLabel.font = [UIFont fontWithName:@"PTSans-Narrow" size:10];
        headerLabel.textColor = [Utils colorWithHex:0x504e60 alpha:1.0];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.tag = 2;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,19,cell.frame.size.width-100, 20)];
        textLabel.font = [UIFont fontWithName:@"PTSans-NarrowBold" size:13];
        textLabel.textColor = [Utils colorWithHex:0x504e60 alpha:1.0];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.tag = 1;
        
        textLabel.text = [[ssLessons objectAtIndex:row] valueForKey:@"lesson_name"];
        headerLabel.text = [[ssLessons objectAtIndex:row] valueForKey:@"lesson_date_text"];
        [cell.contentView addSubview:textLabel];
        [cell.contentView addSubview:headerLabel];
    } else {
        [(id)[cell.contentView viewWithTag:1] setText:[[ssLessons objectAtIndex:row] valueForKey:@"lesson_name"]];
        [(id)[cell.contentView viewWithTag:2] setText:[[ssLessons objectAtIndex:row] valueForKey:@"lesson_date_text"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuViewController *menuViewController = (MenuViewController *)((SWRevealViewController *)self.parentViewController).rearViewController;

    [menuViewController ssLoadLessons:[[[ssLessons objectAtIndex:indexPath.row] valueForKey:@"serial"] intValue]];
    [self dismissSemiModalView];
}


@end
