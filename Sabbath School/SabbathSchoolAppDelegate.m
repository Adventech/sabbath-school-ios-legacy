//
//  SabbathSchoolAppDelegate.m
//  Sabbath School
//
//  Created by Vitaliy L on 2/17/2014.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import "SabbathSchoolAppDelegate.h"

#import "SWRevealViewController.h"
#import "MainViewController.h"
#import "MenuViewController.h"
#import "LoadingViewController.h"
#import "SSCore.h"
#import "Utils.h"
#import "FMDatabase.h"
#import "GAI.h"
#import "GAIFields.h"

@interface SabbathSchoolAppDelegate()<SWRevealViewControllerDelegate>
@end

@implementation SabbathSchoolAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self createCopyOfDatabaseIfNeeded];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window = window;
    LoadingViewController *lwc = [[LoadingViewController alloc] init];
    self.window.rootViewController = lwc;
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 4;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-60193683-1"];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)loadMainViewController {
    MainViewController *mainViewController = [[MainViewController alloc] init];
	MenuViewController *menuViewController = [[MenuViewController alloc] init];

    UINavigationController *mainViewNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:menuViewController frontViewController:mainViewNavigationController];
    
    [mainViewNavigationController.navigationBar setTintColor:[Utils colorWithHex:0x504e60 alpha:1.0]];

    mainRevealController.delegate = self;
    
    self.viewController = mainRevealController;
    self.window.rootViewController = self.viewController;
}

- (void)createCopyOfDatabaseIfNeeded {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString* cachesPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appDBPath = [cachesPath stringByAppendingPathComponent:@"SabbathSchool.sqlite"];

    success = [fileManager fileExistsAtPath:appDBPath];
    if (success){
        return;
    }
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SabbathSchool.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:appDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
