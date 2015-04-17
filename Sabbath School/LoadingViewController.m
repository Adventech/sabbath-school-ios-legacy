//
//  LoadingViewController.m
//  Sabbath School
//
//  Created by Vitaliy L on 3/26/2014.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import "LoadingViewController.h"
#import "SabbathSchoolAppDelegate.h"
#import "SWRevealViewController.h"
#import "SSCore.h"
#import "Utils.h"

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

@interface LoadingViewController ()

@end

@implementation LoadingViewController

UILabel *downloadingLabel = nil;
UILabel *retryLabel = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if (![settings objectForKey:@"Lesson Language"]){
        NSString *bPath = [[NSBundle mainBundle] bundlePath];
        NSString *settingsPath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
        NSString *plistFile = [settingsPath stringByAppendingPathComponent:@"Root.plist"];
        NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
        NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
        NSArray *values = [[preferencesArray objectAtIndex:0] objectForKey:@"Values"];    
        NSString *lang = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        if (![values containsObject:lang]) {
            lang = @"en";
        }
        [[NSUserDefaults standardUserDefaults] setObject:lang forKey:@"Lesson Language"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, ([[UIScreen mainScreen] bounds].size.height))];
    
    downloadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    downloadingLabel.font = [UIFont fontWithName:@"PTSans-Narrow" size:10];
    downloadingLabel.textColor = [Utils colorWithHex:0x504e60 alpha:1.0];
    downloadingLabel.backgroundColor = [UIColor clearColor];
    downloadingLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 80);
    downloadingLabel.textAlignment = NSTextAlignmentCenter;
    
    retryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    retryLabel.text = [NSString stringWithFormat:NSLocalizedString(@"APP_RETRY", nil)];
    retryLabel.font = [UIFont fontWithName:@"PTSans-BoldItalic" size:17];
    retryLabel.textColor = [Utils colorWithHex:0x0077cc alpha:1.0];
    retryLabel.backgroundColor = [UIColor clearColor];
    retryLabel.userInteractionEnabled = YES;
    retryLabel.hidden = YES;
    retryLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
    retryLabel.textAlignment = NSTextAlignmentCenter;
    
    UITapGestureRecognizer *retryGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startDownLoad)];
    [retryLabel addGestureRecognizer:retryGesture];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    if (!isiPhone5) {
        self.imageView.image = [UIImage imageNamed:@"blur_background.jpg"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"blur_background_568.jpg"];        
    }
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.activityIndicatorView.center = CGPointMake(self.view.center.x, self.view.center.y + 50);

    [self.view addSubview:self.imageView];
    [self.view addSubview:self.activityIndicatorView];
    [self.view addSubview:downloadingLabel];
    [self.view addSubview:retryLabel];
}

- (void)startDownLoad {
    retryLabel.hidden = YES;
    [self.activityIndicatorView startAnimating];
    downloadingLabel.text = [NSString stringWithFormat:NSLocalizedString(@"APP_DOWNLOADING", nil)];
    [SSCore downloadIfNeeded:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startDownLoad];
}

- (void)downloadFinished:(BOOL)ret {
    [self.activityIndicatorView stopAnimating];
    
    if (!ret) {
        downloadingLabel.text = [NSString stringWithFormat:NSLocalizedString(@"APP_ERROR_DOWNLOADING", nil)];
        retryLabel.hidden = NO;
    } else {
        if ([NSThread isMainThread]) {
            SabbathSchoolAppDelegate *appDelegate = (SabbathSchoolAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loadMainViewController];
        } else {
            [self performSelectorOnMainThread:@selector(downloadFinished:) withObject:[NSNumber numberWithBool:ret] waitUntilDone:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
