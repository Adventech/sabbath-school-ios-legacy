//
//  MainViewController.h
//  Sabbath School
//
//  Created by Vitaliy L on 2/17/2014.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BibleViewController.h"

@interface MainViewController : UIViewController<UIScrollViewDelegate> {}

@property (nonatomic) UIImage *image;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (strong, nonatomic) BibleViewController *bibleViewController;

- (void)ssLoadDay:(NSString *)ssDayP;
- (void)openBible:(NSString *)verse;

@end
