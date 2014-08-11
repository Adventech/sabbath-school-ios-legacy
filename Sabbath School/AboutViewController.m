//
//  AboutViewController.m
//  Sabbath School
//
//  Created by Vitaliy L on 2/17/2014.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import "AboutViewController.h"
#import "FontAwesomeKit.h"
#import "Utils.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize label_author;
@synthesize instagram_icon;
@synthesize twitter_icon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.frame = CGRectMake(0, 0, 320, 140);
    }
    FAKIonIcons *twitterIcon = [FAKIonIcons socialTwitterIconWithSize:35.0f];
    [twitterIcon addAttribute:NSForegroundColorAttributeName value:[Utils colorWithHex:0x504e60 alpha:1.0]];
    twitter_icon.image = [twitterIcon imageWithSize:CGSizeMake(35.0f, 35.0f)];
    
    FAKIonIcons *instagramIcon = [FAKIonIcons socialInstagramIconWithSize:35.0f];
    [instagramIcon addAttribute:NSForegroundColorAttributeName value:[Utils colorWithHex:0x504e60 alpha:1.0]];
    instagram_icon.image = [instagramIcon imageWithSize:CGSizeMake(35.0f, 35.0f)];
    return self;
}

- (IBAction)instagramClick:(UITapGestureRecognizer *)sender{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=v1talique"];
    NSURL *instagramURLWeb = [NSURL URLWithString:@"http://instagram.com/v1talique"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    } else {
        [[UIApplication sharedApplication] openURL:instagramURLWeb];
    }
}

- (IBAction)twitterClick:(UITapGestureRecognizer *)sender{
    NSURL *twitterURL = [NSURL URLWithString:@"twitter://user?screen_name=vitalik_l"];
    NSURL *twitterURLWeb = [NSURL URLWithString:@"https://twitter.com/vitalik_l"];
    if ([[UIApplication sharedApplication] canOpenURL:twitterURL]) {
        [[UIApplication sharedApplication] openURL:twitterURL];
    } else {
        [[UIApplication sharedApplication] openURL:twitterURLWeb];
    }
}

- (IBAction)loveYourNeighborClick:(UITapGestureRecognizer *)sender{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[@"https://www.google.com/search?q=ואהבת+לרעך+כמוך" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)viewDidLoad
{
    label_author.text = [NSString stringWithFormat:NSLocalizedString(@"APP_AUTHOR", nil)];
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
