//
//  MenuViewController.m
//  Sabbath School
//
//  Created by Vitaliy L on 2/17/2014.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import "Utils.h"
#import "SWRevealViewController.h"
#import "UIViewController+KNSemiModal.h"

#import "MainViewController.h"
#import "MenuViewController.h"
#import "WeekSelectionViewController.h"
#import "AboutViewController.h"
#import "FontAwesomeKit.h"

#import "SSCore.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

NSMutableArray *ssDays = nil;
NSMutableArray *ssLesson = nil;

- (void)viewDidLoad {
	[super viewDidLoad];
    ssDays = [SSCore ssGetDays:[SSCore ssTodayDate]];
    ssLesson = [SSCore ssGetLessonByDay:[SSCore ssTodayDate]];

    [self.rearTableView setDelegate: self];
    [self.rearTableView setDataSource: self];
    
    NSString *appTitle = [NSString stringWithFormat:NSLocalizedString(@"APP_TITLE", nil)];
    
    NSMutableAttributedString* titleString = [[NSMutableAttributedString alloc] initWithString: appTitle attributes: @{ NSFontAttributeName: [UIFont fontWithName:@"GoudyOldStyleT-Regular" size:10] }];
    
    // Capitalizing Words
    NSRange range = [appTitle rangeOfString:@" "];
    if (range.location != NSNotFound){
        range.location++;
        [titleString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GoudyOldStyleT-Regular" size:13]} range: range];
    }
    
    [titleString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GoudyOldStyleT-Regular" size:13]} range:NSMakeRange(0,1)];
    
    _label_title.attributedText = titleString;
    _label_title.textColor = [Utils colorWithHex:0x504E60 alpha:1.0];
    _label_title.shadowColor = [Utils colorWithHex:0xE2E2E2 alpha:1.0];
    _label_title.shadowOffset = CGSizeMake(-0.3, 0.3);
    
    UILabel *lessonHeader = [[UILabel alloc] initWithFrame:CGRectMake(20,70,self.view.frame.size.width-110, 20)];
    lessonHeader.font = [UIFont fontWithName:@"PTSans-Narrow" size:10];
    lessonHeader.text = [ssLesson valueForKey:@"lesson_date_text"];
    lessonHeader.textColor = [Utils colorWithHex:0x504e60 alpha:1.0];
    lessonHeader.backgroundColor = [UIColor clearColor];
    lessonHeader.tag = 10;
    
    UILabel *lessonName = [[UILabel alloc] initWithFrame:CGRectMake(20,85,self.view.frame.size.width-115, 20)];
    lessonName.font = [UIFont fontWithName:@"PTSans-NarrowBold" size:16];
    lessonName.text = [ssLesson valueForKey:@"lesson_name"];
    lessonName.textColor = [Utils colorWithHex:0x504e60 alpha:1.0];
    lessonName.backgroundColor = [UIColor clearColor];
    lessonName.tag = 20;
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 115, self.view.frame.size.width, 0.5)];
    divider.backgroundColor = [Utils colorWithHex:0xb3b4b7 alpha:1.0];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 1.0f, divider.frame.size.width, 0.5f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.5f].CGColor;
    [divider.layer addSublayer:bottomBorder];
    
    UIImageView *iconSettings = [[UIImageView alloc] initWithFrame:CGRectMake(225, 77, 25, 25)];
    FAKIonIcons *gearIcon = [FAKIonIcons gearAIconWithSize:25.0f];
    [gearIcon addAttribute:NSForegroundColorAttributeName value:[Utils colorWithHex:0x504e60 alpha:1.0]];
    iconSettings.image = [gearIcon imageWithSize:CGSizeMake(25.0f, 25.0f)];
    
    UITapGestureRecognizer *aboutTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutClick)];
    UITapGestureRecognizer *settingsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingsClick)];
    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareClick)];
    
    [iconSettings addGestureRecognizer:settingsTap];
    [iconSettings setMultipleTouchEnabled:YES];
    [iconSettings setUserInteractionEnabled:YES];
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeight-35, screenWidth-85, 20)];
    
    aboutLabel.font = [UIFont fontWithName:@"PTSans-NarrowBold" size:10];
    aboutLabel.textColor = [Utils colorWithHex:0xaeaead alpha:1];
    aboutLabel.text = [NSString stringWithFormat:NSLocalizedString(@"APP_ABOUT", nil)];
    aboutLabel.textAlignment = NSTextAlignmentRight;
    aboutLabel.backgroundColor = [UIColor clearColor];
    
    
    [aboutLabel addGestureRecognizer:aboutTap];
    [aboutLabel setMultipleTouchEnabled:YES];
    [aboutLabel setUserInteractionEnabled:YES];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight-35, 100, 20)];
    
    shareLabel.font = [UIFont fontWithName:@"PTSans-NarrowBold" size:10];
    shareLabel.textColor = [Utils colorWithHex:0xaeaead alpha:1];
    shareLabel.text = [NSString stringWithFormat:NSLocalizedString(@"APP_SHARE", nil)];
    shareLabel.textAlignment = NSTextAlignmentLeft;
    shareLabel.backgroundColor = [UIColor clearColor];
    
    
    [shareLabel addGestureRecognizer:shareTap];
    [shareLabel setMultipleTouchEnabled:YES];
    [shareLabel setUserInteractionEnabled:YES];
    
    [self.view addSubview:lessonHeader];
    [self.view addSubview:lessonName];
    [self.view addSubview:divider];
    [self.view addSubview:iconSettings];
    [self.view addSubview:aboutLabel];
    [self.view addSubview:shareLabel];
    _rearTableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
}

-(void)ssLoadLessons:(int)ssLessonSerial {
    ssLesson = [SSCore ssGetLessonBySerial:ssLessonSerial];
    ssDays = [SSCore ssGetDaysBySerial:ssLessonSerial];
    [(UILabel *)[self.view viewWithTag:10] setText: [ssLesson valueForKey:@"lesson_date_text"]];
    [(UILabel *)[self.view viewWithTag:20] setText: [ssLesson valueForKey:@"lesson_name"]];

    [self.rearTableView reloadData];
}

-(void)aboutClick {
    aboutViewController = [[AboutViewController alloc] init];
    [self presentSemiViewController:aboutViewController withOptions:@{
                                                          KNSemiModalOptionKeys.pushParentBack : @(NO),
                                                          KNSemiModalOptionKeys.parentAlpha : @(0.5),
                                                          KNSemiModalOptionKeys.transitionStyle : @(KNSemiModalTransitionStyleSlideUp),
                                                          KNSemiModalOptionKeys.shadowOpacity : @(0.5)
                                                          }];
}

-(void)settingsClick {
    modalVC = [[WeekSelectionViewController alloc] initWithStyle:UITableViewStylePlain];
    [self presentSemiViewController:modalVC withOptions:@{
                                                          KNSemiModalOptionKeys.pushParentBack : @(NO),
                                                          KNSemiModalOptionKeys.parentAlpha : @(0.5),
                                                          KNSemiModalOptionKeys.transitionStyle : @(KNSemiModalTransitionStyleSlideUp),
                                                          KNSemiModalOptionKeys.shadowOpacity : @(0.5)
                                                          }];
}

-(void)shareClick {
    NSMutableArray *sharingItems = [NSMutableArray new];
    NSURL *url = [NSURL URLWithString:@"http://vitalikl.github.io/"];
    
    [sharingItems addObject:[NSString stringWithFormat:NSLocalizedString(@"APP_SHARE_TEXT", nil)]];
    [sharingItems addObject:url];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [ssDays count];
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
        
        textLabel.text = [[ssDays objectAtIndex:row] valueForKey:@"day_name"];
        headerLabel.text = [[ssDays objectAtIndex:row] valueForKey:@"day_date_text"];
        [cell.contentView addSubview:textLabel];
        [cell.contentView addSubview:headerLabel];
        
    } else {
        [(id)[cell.contentView viewWithTag:1] setText:[[ssDays objectAtIndex:row] valueForKey:@"day_name"]];
        [(id)[cell.contentView viewWithTag:2] setText:[[ssDays objectAtIndex:row] valueForKey:@"day_date_text"]];
    }
    if ([[[ssDays objectAtIndex:row] valueForKey:@"day_date"] isEqualToString:[SSCore ssTodayDate]]){
        [self.rearTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWRevealViewController *revealController = [self revealViewController];
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    MainViewController *mainViewController = [frontNavigationController.viewControllers objectAtIndex:0];
    
    [mainViewController ssLoadDay: [[ssDays objectAtIndex:indexPath.row] valueForKey:@"day_date"]];
    [revealController setFrontViewController:revealController.frontViewController animated:YES];
}

@end
