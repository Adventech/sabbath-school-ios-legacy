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
#import "AboutViewController.h"
#import "FontAwesomeKit.h"
#import "IASKAppSettingsViewController.h"
#import "IASKSettingsReader.h"
#import "LoadingViewController.h"
#import "SSCore.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

NSMutableArray *ssDays = nil;
NSMutableArray *ssLesson = nil;
NSMutableArray *ssLessonsInner = nil;
NSMutableArray *staticMenu = nil;
NSString *ssDaySelected = nil;

NSInteger expanded = 0;
NSInteger expanding = 0;
NSString *lang = nil;
- (void)viewDidLoad {
	[super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingDidChange:) name:kIASKAppSettingChanged object:nil];

    ssDays = [SSCore ssGetDays:[SSCore ssTodayDate]];
    ssLesson = [SSCore ssGetLessonByDay:[SSCore ssTodayDate]];
    ssLessonsInner = [SSCore ssGetLessons];

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
    
    [ssDays addObject:@{@"menu_name": @"share", @"menu_value": [NSString stringWithFormat:NSLocalizedString(@"APP_MENU_SHARE", nil)]}];

    [ssDays addObject:@{@"menu_name": @"settings", @"menu_value": [NSString stringWithFormat:NSLocalizedString(@"APP_MENU_SETTINGS", nil)]}];
    
    [ssDays addObject:@{@"menu_name": @"about", @"menu_value": [NSString stringWithFormat:NSLocalizedString(@"APP_MENU_ABOUT", nil)]}];
    
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
    

    _rearTableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
}

-(void)ssLoadLessons:(int)ssLessonSerial {
    ssLesson = [SSCore ssGetLessonBySerial:ssLessonSerial];
    ssDays = [SSCore ssGetDaysBySerial:ssLessonSerial];
    [(UILabel *)[self.view viewWithTag:10] setText: [ssLesson valueForKey:@"lesson_date_text"]];
    [(UILabel *)[self.view viewWithTag:20] setText: [ssLesson valueForKey:@"lesson_name"]];

    [self.rearTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0 && [[ssDays objectAtIndex:indexPath.row-1] valueForKey:@"menu_name"]){
        return 35;
    }
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [ssDays count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	NSInteger row = indexPath.row;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    

    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,3,cell.frame.size.width-100, 20)];
    headerLabel.font = [UIFont fontWithName:@"PTSans-Narrow" size:10];
    headerLabel.tag = 2;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,19,cell.frame.size.width-100, 20)];
    textLabel.font = [UIFont fontWithName:@"PTSans-NarrowBold" size:13];
    textLabel.tag = 1;
    
    if (row == 0){
        
        UIImageView *iconHolder = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-100,15,15,15)];
        FAKIonIcons *icon = nil;
        if (!expanded){
            icon = [FAKIonIcons chevronDownIconWithSize:15.0f];
        } else {
            icon = [FAKIonIcons chevronUpIconWithSize:15.0f];
        }
        
        [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        iconHolder.image = [icon imageWithSize:CGSizeMake(15.0f, 15.0f)];

        
        textLabel.text = [ssLesson valueForKey:@"lesson_name"];
        textLabel.textColor = [UIColor whiteColor];
        headerLabel.text = [ssLesson valueForKey:@"lesson_date_text"];
        headerLabel.textColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"bg_default_profile_art.png"]];
        cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        cell.backgroundView.clipsToBounds = YES;

        [cell.contentView addSubview:textLabel];
        [cell.contentView addSubview:headerLabel];
        [cell.contentView addSubview:iconHolder];
    } else {
        UIView *cellBackgroundView = [[UIView alloc] initWithFrame:cell.frame];

        if ([[ssDays objectAtIndex:row-1] valueForKey:@"lesson_name"]){
            cellBackgroundView.backgroundColor = [Utils colorWithHex:0x000000 alpha:0.8];
            textLabel.text = [[ssDays objectAtIndex:row-1] valueForKey:@"lesson_name"];
            headerLabel.text = [[ssDays objectAtIndex:row-1] valueForKey:@"lesson_date_text"];
            
            textLabel.textColor = [UIColor whiteColor];
            headerLabel.textColor = [UIColor whiteColor];
            
            [cell.contentView setBackgroundColor:[Utils colorWithHex:0x333333 alpha:1.0]];
            [cell.contentView addSubview:textLabel];
            [cell.contentView addSubview:headerLabel];
        } else if ([[ssDays objectAtIndex:row-1] valueForKey:@"menu_name"]) {
            cellBackgroundView.backgroundColor = [Utils colorWithHex:0x000000 alpha:0.2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            textLabel.text = [[ssDays objectAtIndex:row-1] valueForKey:@"menu_value"];
            
            textLabel.textColor = [Utils colorWithHex:0x504e60 alpha:1.0];
            headerLabel.textColor = [Utils colorWithHex:0x504e60 alpha:1.0];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            
            UIImageView *menuIconHolder = [[UIImageView alloc] initWithFrame:CGRectMake(18,10,15,15)];
            
            FAKIonIcons *menuIcon = nil;
            if ([[[ssDays objectAtIndex:row-1] valueForKey:@"menu_name"] isEqualToString:@"share"]){
                menuIcon = [FAKIonIcons shareIconWithSize:15.0f];
            } else if ([[[ssDays objectAtIndex:row-1] valueForKey:@"menu_name"] isEqualToString:@"settings"]) {
                menuIcon = [FAKIonIcons gearAIconWithSize:15.0f];
            } else {
                menuIcon = [FAKIonIcons ios7InformationIconWithSize:15.0f];
            }
            
            [menuIcon addAttribute:NSForegroundColorAttributeName value:[Utils colorWithHex:0x504e60 alpha:1.0]];
            menuIconHolder.image = [menuIcon imageWithSize:CGSizeMake(15.0f, 15.0f)];
            
            textLabel.frame = CGRectMake(40,8,cell.frame.size.width-100, 20);
            textLabel.font = [UIFont fontWithName:@"PTSans-Narrow" size:12];
            [cell.contentView addSubview:textLabel];
            [cell.contentView addSubview:menuIconHolder];
        } else {
            cellBackgroundView.backgroundColor = [Utils colorWithHex:0x000000 alpha:0.2];
            textLabel.text = [[ssDays objectAtIndex:row-1] valueForKey:@"day_name"];
            headerLabel.text = [[ssDays objectAtIndex:row-1] valueForKey:@"day_date_text"];
            
            textLabel.textColor = [Utils colorWithHex:0x504e60 alpha:1.0];
            headerLabel.textColor = [Utils colorWithHex:0x504e60 alpha:1.0];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];

            [cell.contentView addSubview:textLabel];
            [cell.contentView addSubview:headerLabel];
        }
        cell.selectedBackgroundView = cellBackgroundView;
    }
    
	return cell;
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    NSString *langAfterSettings = [settings objectForKey:@"Lesson Language"];
    if (![lang isEqualToString:langAfterSettings]){
        LoadingViewController *lwc = [[LoadingViewController alloc] init];
//        [[[UIApplication sharedApplication] delegate].window setRootViewController:lwc];
        [self presentViewController:lwc animated:YES completion:nil];

    } else {
        MainViewController *mainViewController = [[MainViewController alloc] init];
        mainViewController.ssDayDate = ssDaySelected;
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        [frontNavigationController.navigationBar setTintColor:[Utils colorWithHex:0x504e60 alpha:1.0]];
        [self.revealViewController pushFrontViewController:frontNavigationController animated:YES];
    }
}

#pragma mark kIASKAppSettingChanged notification
- (void)settingDidChange:(NSNotification*)notification {
//    NSLog(@"FSDFDSFDSDFSFDSFDSFDSFDSFDS");
//    if ([notification.object isEqual:@"Lesson Language"]) {
//
//        LoadingViewController *lwc = [[LoadingViewController alloc] init];
//        [[[UIApplication sharedApplication] delegate].window setRootViewController:lwc];
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 0){
        
        if ([[ssDays objectAtIndex:indexPath.row-1] valueForKey:@"lesson_name"]){
            ssLesson = [SSCore ssGetLessonBySerial:[[[ssDays objectAtIndex:indexPath.row-1] valueForKey:@"serial"] intValue]];
            ssDays = [SSCore ssGetDaysBySerial:[[[ssDays objectAtIndex:indexPath.row-1] valueForKey:@"serial"] intValue]];


            [ssDays addObject:@{@"menu_name": @"share", @"menu_value": [NSString stringWithFormat:NSLocalizedString(@"APP_MENU_SHARE", nil)]}];
            
            [ssDays addObject:@{@"menu_name": @"settings", @"menu_value": [NSString stringWithFormat:NSLocalizedString(@"APP_MENU_SETTINGS", nil)]}];
            
            [ssDays addObject:@{@"menu_name": @"about", @"menu_value": [NSString stringWithFormat:NSLocalizedString(@"APP_MENU_ABOUT", nil)]}];
            
            expanded = 0;
            [self.rearTableView reloadData];
        } else {
            SWRevealViewController *revealController = [self revealViewController];
            UINavigationController *frontNavigationController = (id)revealController.frontViewController;
            
            if ([[ssDays objectAtIndex:indexPath.row-1] valueForKey:@"day_date"]){
                MainViewController *mainViewController = [[MainViewController alloc] init];
                mainViewController.ssDayDate = [[ssDays objectAtIndex:indexPath.row-1] valueForKey:@"day_date"];
                
                frontNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
                [frontNavigationController.navigationBar setTintColor:[Utils colorWithHex:0x504e60 alpha:1.0]];
                [revealController pushFrontViewController:frontNavigationController animated:YES];

            } else if ([[ssDays objectAtIndex:indexPath.row-1] valueForKey:@"menu_name"]){
                
                if ([[frontNavigationController.viewControllers objectAtIndex:0] isKindOfClass:[MainViewController class]]){
                    MainViewController *mvc = [frontNavigationController.viewControllers objectAtIndex:0];
                    ssDaySelected = mvc.ssDayDate;
                }
                
                if ([[[ssDays objectAtIndex:indexPath.row-1] valueForKey:@"menu_name"] isEqualToString:@"settings"]){
                    IASKAppSettingsViewController *settings = [[IASKAppSettingsViewController alloc] init];
                    settings.title = NSLocalizedString(@"APP_MENU_SETTINGS", nul);
                    settings.delegate = self;
                    
                    lang = [SSCore getLang];
                    
                    frontNavigationController = [[UINavigationController alloc] initWithRootViewController:settings];
                    [revealController pushFrontViewController:frontNavigationController animated:YES];
                }
                
                if ([[[ssDays objectAtIndex:indexPath.row-1] valueForKey:@"menu_name"] isEqualToString:@"share"]){
                    NSMutableArray *sharingItems = [NSMutableArray new];
                    NSURL *url = [NSURL URLWithString:@"http://vitalikl.github.io/ss"];
                    
                    [sharingItems addObject:[NSString stringWithFormat:NSLocalizedString(@"APP_SHARE_TEXT", nil)]];
                    [sharingItems addObject:url];
                    
                    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
                    [self presentViewController:activityController animated:YES completion:nil];
                }
                
                if ([[[ssDays objectAtIndex:indexPath.row-1] valueForKey:@"menu_name"] isEqualToString:@"about"]){
                    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
                    
                    frontNavigationController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
                    
                    aboutViewController.ssDayDate = ssDaySelected;
                    [frontNavigationController.navigationBar setTintColor:[Utils colorWithHex:0x504e60 alpha:1.0]];
                    [revealController pushFrontViewController:frontNavigationController animated:YES];
                }
            }
        }
    } else {
        if (!expanding){
            NSUInteger count = 0;
            NSMutableArray *arCells = [NSMutableArray array];
            for(NSDictionary *ssLessonInner in ssLessonsInner) {
                [arCells addObject:[NSIndexPath indexPathForRow:count+1 inSection:0]];
                if (!expanded){
                    [ssDays insertObject:ssLessonInner atIndex:count++];
                } else {
                    [ssDays removeObjectAtIndex:0];
                    count++;
                }
            }
            
            [CATransaction begin];
            [self.rearTableView beginUpdates];
            expanding = 1;
            
            [CATransaction setCompletionBlock: ^{
                expanding = 0;
                NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
                NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                [self.rearTableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
            }];
          
            if (expanded){
                expanded = 0;
                [self.rearTableView deleteRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationTop];
            } else {
                expanded = 1;
                [self.rearTableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationBottom];
            }
            
            [self.rearTableView endUpdates];
            [CATransaction commit];
        }
    }
}

@end
