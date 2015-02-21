//
//  AboutViewController.m
//  Sabbath School
//
//  Created by Vitaliy L on 2/17/2014.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import "AboutViewController.h"
#import "FontAwesomeKit.h"
#import "MainViewController.h"
#import "Utils.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize aboutTableView;
@synthesize aboutNameLabel;
@synthesize loveThyNeighborLabel;
@synthesize loveThyNeighborTap;
@synthesize ssDayDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)instagramClick {
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=v1talique"];
    NSURL *instagramURLWeb = [NSURL URLWithString:@"http://instagram.com/v1talique"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    } else {
        [[UIApplication sharedApplication] openURL:instagramURLWeb];
    }
}

- (void)twitterClick {
    NSURL *twitterURL = [NSURL URLWithString:@"twitter://user?screen_name=vitalik_l"];
    NSURL *twitterURLWeb = [NSURL URLWithString:@"https://twitter.com/vitalik_l"];
    if ([[UIApplication sharedApplication] canOpenURL:twitterURL]) {
        [[UIApplication sharedApplication] openURL:twitterURL];
    } else {
        [[UIApplication sharedApplication] openURL:twitterURLWeb];
    }
}

- (void)webClick {
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[@"https://vitalik.github.io/ss" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)instagramAmaraClick {
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=asimsness"];
    NSURL *instagramURLWeb = [NSURL URLWithString:@"http://instagram.com/asimsness"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    } else {
        [[UIApplication sharedApplication] openURL:instagramURLWeb];
    }
}

- (IBAction)loveThyNeighborTap:(UITapGestureRecognizer *)sender{
    [PFAnalytics trackEvent:@"about_window_love_thy_neighbor_clicked"];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[@"https://www.google.com/search?q=ואהבת+לרעך+כמוך" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    
    int aboutMenuIconSize = 15;
    
    UIImageView *aboutMenuIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, aboutMenuIconSize, aboutMenuIconSize)];
    UILabel *aboutMenuText = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, cell.frame.size.width, cell.frame.size.height)];
    aboutMenuText.textColor = [UIColor blackColor];
    
    FAKIonIcons *_aboutMenuIcon = nil;
    
    switch (indexPath.row){
        case 0: {
            _aboutMenuIcon = [FAKIonIcons socialInstagramIconWithSize:aboutMenuIconSize];
            aboutMenuText.text = @"@v1talique";
            break;
        }
            
        case 1: {
            _aboutMenuIcon = [FAKIonIcons socialTwitterIconWithSize:aboutMenuIconSize];
            aboutMenuText.text = @"@vitalik_l";
            break;
        }
            
        case 2: {
            _aboutMenuIcon = [FAKIonIcons ios7WorldIconWithSize:aboutMenuIconSize];
            aboutMenuText.text = @"vitalikl.github.io/ss";
            break;
        }
            
        case 3: {
            _aboutMenuIcon = [FAKIonIcons socialInstagramIconWithSize:aboutMenuIconSize];
            aboutMenuText.text = NSLocalizedString(@"APP_ABOUT_PHOTO_CREDITS", nil);
            break;
        }
    }
    
    aboutMenuText.font = [UIFont fontWithName:@"PTSans-Narrow" size:13];
    [_aboutMenuIcon addAttribute:NSForegroundColorAttributeName value:[Utils colorWithHex:0x504e60 alpha:1.0]];
    aboutMenuIcon.image = [_aboutMenuIcon imageWithSize:CGSizeMake(aboutMenuIconSize, aboutMenuIconSize)];

    [cell.contentView addSubview:aboutMenuText];
    [cell.contentView addSubview:aboutMenuIcon];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [aboutTableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row){
        case 0: {
            self.instagramClick;
            [PFAnalytics trackEvent:@"about_window_instagram_clicked"];
            break;
        }
            
        case 1: {
            self.twitterClick;
            [PFAnalytics trackEvent:@"about_window_twitter_clicked"];
            break;
        }
            
        case 2: {
            self.webClick;
            [PFAnalytics trackEvent:@"about_window_web_clicked"];
            break;
        }
            
        case 3: {
            self.instagramAmaraClick;
            [PFAnalytics trackEvent:@"about_window_instagram_amara_clicked"];
            break;
        }
    }

}

- (void)closeButtonAction:(id)sender {
    MainViewController *mainViewController = [[MainViewController alloc] init];
    mainViewController.ssDayDate = ssDayDate;
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [frontNavigationController.navigationBar setTintColor:[Utils colorWithHex:0x504e60 alpha:1.0]];
    [self.revealViewController pushFrontViewController:frontNavigationController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [PFAnalytics trackEvent:@"about_window_opened"];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"APP_CLOSE", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonAction:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    self.title = NSLocalizedString(@"APP_MENU_ABOUT", nil);
    aboutTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    aboutNameLabel.text = NSLocalizedString(@"Sabbath School", nil);
    aboutNameLabel.textColor = [Utils colorWithHex:0x504e60 alpha:1.0];
    aboutNameLabel.font = [UIFont fontWithName:@"PTSans-NarrowBold" size:22];
    
    loveThyNeighborLabel.text = @"ואהבת לרעך כמוך";
    loveThyNeighborLabel.textColor = [Utils colorWithHex:0xcccccc alpha:1.0];
    loveThyNeighborLabel.font = [UIFont fontWithName:@"PTSans-Narrow" size:12];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
