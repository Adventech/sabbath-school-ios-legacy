//
//  MainViewController.m
//  Sabbath School
//
//  Created by Vitaliy L on 2/17/2014.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import "SWRevealViewController.h"
#import "BibleViewController.h"
#import "WebViewJavascriptBridge.h"
#import "LoadingViewController.h"
#import "MainViewController.h"
#import "SSCore.h"
#import "Utils.h"
#import "FontAwesomeKit.h"
#import "Base64.h"
#import <Parse/Parse.h>

static CGFloat kImageOriginHeight = 68.f;

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *expandZoomImageView;
@property WebViewJavascriptBridge* bridge;
@property UIActivityIndicatorView *activityIndicatorView;
@end

@implementation MainViewController

@synthesize ssDayDate;
NSMutableArray *ssDayA = nil;
NSString *textSize = @"small.css";
UIBarButtonItem *goToTodayButtonItem = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ([settings objectForKey:@"Text Size"]){
        textSize = [[settings objectForKey:@"Text Size"] stringByAppendingString:@".css"];
    }
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];

    FAKIonIcons *revealIcon = [FAKIonIcons androidSortIconWithSize:25.0f];
    [revealIcon addAttribute:NSForegroundColorAttributeName value:[Utils colorWithHex:0x504e60 alpha:1.0]];
    
    FAKIonIcons *moreIcon = [FAKIonIcons ios7MoreIconWithSize:25.0f];
    [moreIcon addAttribute:NSForegroundColorAttributeName value:[Utils colorWithHex:0x504e60 alpha:1.0]];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[revealIcon imageWithSize:CGSizeMake(25.0f, 25.0f)] style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];

    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], UITextAttributeTextColor, [UIColor whiteColor], UITextAttributeTextShadowColor, nil]];

    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.opaque = YES;
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor: [UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.alpha = 0.0f;
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    goToTodayButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"APP_TODAY", nil)  style:UIBarButtonItemStylePlain target:self action:@selector(ssLoadToday:)];
    self.navigationItem.rightBarButtonItem = goToTodayButtonItem;

    self.title = NSLocalizedString(@"Sabbath School", nil);
    
    UIMenuItem *highlightMenu = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"APP_HIGHLIGHT", nil) action:@selector(highlightClicked:)];
    UIMenuItem *unHighlightMenu = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"APP_REMOVE_HIGHLIGHT", nil) action:@selector(unHighlightClicked:)];
    UIMenuItem *shareMenu = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"APP_SHARE_SELECTION", nil) action:@selector(shareClicked:)];
    [UIMenuController sharedMenuController].menuItems = @[highlightMenu, unHighlightMenu, shareMenu];
    
    
    self.expandZoomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kImageOriginHeight, self.view.frame.size.width, kImageOriginHeight)];
    self.expandZoomImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.webView.scrollView.delegate = self;
    [self.webView setUserInteractionEnabled:YES];
    self.webView.hidden = YES;
    [self.webView.scrollView addSubview:self.expandZoomImageView];
    [self.webView.scrollView sendSubviewToBack:self.expandZoomImageView];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(kImageOriginHeight*2, 0.0, 0.0, 0.0);
    
    if (_bridge) { return; }
    
//    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([[data valueForKey:@"message"] isEqualToString:@"saveComments"]){
            [SSCore ssSaveComments:[ssDayA valueForKey:@"serial"] :[data valueForKey:@"serializedComments"]];
        }

        if ([[data valueForKey:@"message"] isEqualToString:@"openBible"]){
            [self openBible: [[NSJSONSerialization JSONObjectWithData:[[ssDayA valueForKey:@"day_verses"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil] valueForKey:[data valueForKey:@"verse"]]];
        }
        
    }];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    if (ssDayDate){
        [self ssLoadDay:ssDayDate];
    } else {
        [self ssLoadDay:[SSCore ssTodayDate]];
    }
}

- (void)openBible:(NSString *)verse {
    self.bibleViewController = [[BibleViewController alloc] init];
    [self.bibleViewController showInView:self.revealViewController.view animated:YES verse:verse];
}

- (void)ssLoadToday:(id)sender {
    [self ssLoadDay:[SSCore ssTodayDate]];

}

- (void)ssLoadDay:(NSString *)ssDay {
    self.ssDayDate = ssDay;
    if ([ssDay isEqual:[SSCore ssTodayDate]]){
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = goToTodayButtonItem;
    }

    [self.activityIndicatorView startAnimating];
    ssDayA = [SSCore ssGetDay:ssDay];
    self.expandZoomImageView.image = [UIImage imageWithData: [NSData dataWithBase64EncodedString:[ssDayA valueForKey:@"lesson_image"]]];

    NSString *embedHTML = [ssDayA valueForKey:@"day_text"];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"app" ofType:@"html" inDirectory:@"/html" ];
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    html = [html stringByReplacingOccurrencesOfString:@"{{platform}}" withString:@"ios"];
    html = [html stringByReplacingOccurrencesOfString:@"small.css" withString:textSize];
    
    [self.webView loadHTMLString:[html stringByReplacingOccurrencesOfString:@"<div class=\"wrapper\">" withString:[NSString stringWithFormat:@"<div class=\"wrapper\">%@", embedHTML]] baseURL:[NSURL fileURLWithPath: [NSString stringWithFormat:@"%@/html/", [[NSBundle mainBundle] bundlePath]]]];
}

- (void)highlightClicked:(id)sender {
    [_bridge callHandler:@"bridgeHandler" data:@{ @"message": @"highlight" } responseCallback:^(id responseData) {
        if ([[responseData valueForKey:@"message"] isEqual: @"highlightFinished"]){
            self.webView.userInteractionEnabled = NO;
            self.webView.userInteractionEnabled = YES;
            [self saveHighlights];
        }
    }];
}

- (void)unHighlightClicked:(id)sender {
    [_bridge callHandler:@"bridgeHandler" data:@{ @"message": @"unHighlight" } responseCallback:^(id responseData) {
        if ([[responseData valueForKey:@"message"] isEqual: @"unHighlightFinished"]){
            self.webView.userInteractionEnabled = NO;
            self.webView.userInteractionEnabled = YES;
            [self saveHighlights];
        }
    }];
}

- (void)shareClicked:(id)sender {
    NSMutableArray *sharingItems = [NSMutableArray new];
    [[UIApplication sharedApplication] sendAction:@selector(copy:) to:nil from:self forEvent:nil];
    NSString *shareText =  [UIPasteboard generalPasteboard].string;
    
    [sharingItems addObject:shareText];
    [sharingItems addObject:self.expandZoomImageView.image];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)saveHighlights {
    [_bridge callHandler:@"bridgeHandler" data:@{ @"message": @"getHighlight" } responseCallback:^(id responseData){
        if ([[responseData valueForKey:@"message"] isEqual: @"getHighlightFinished"]){
            [SSCore ssSaveHighlights:[ssDayA valueForKey:@"serial"] :[responseData valueForKey:@"serializedHighlight"]];
        }
    }];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < -kImageOriginHeight) {
        CGRect f = self.expandZoomImageView.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        self.expandZoomImageView.frame = f;
        
        if (self.navigationController.navigationBar.alpha != 0.0f){
            [UIView animateWithDuration:0.5 animations:^{
                self.navigationController.navigationBar.alpha = 0.0f;
            }];
        }    
    } else if (yOffset < kImageOriginHeight){
        CGRect f = self.expandZoomImageView.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset/1.0000010;
        self.expandZoomImageView.frame = f;
        
        if (self.navigationController.navigationBar.alpha == 0.0f){
            [UIView animateWithDuration:0.5 animations:^{
                self.navigationController.navigationBar.alpha = 1.0f;
            }];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(highlightClicked:) || action == @selector(unHighlightClicked:) || action == @selector(shareClicked:)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)readyState:(NSString *)str {
    if ([str isEqualToString:@"complete"]||[str isEqualToString:@"interactive"]) {
        [self.activityIndicatorView stopAnimating];
        
        [_bridge callHandler:@"bridgeHandler" data:@{ @"message": @"setHighlight", @"serializedHighlight": [ssDayA valueForKey:@"day_highlights"] } responseCallback:^(id responseData) {
            if ([[responseData valueForKey:@"message"] isEqual: @"setHighlightFinished"]){
                self.webView.userInteractionEnabled = NO;
                self.webView.userInteractionEnabled = YES;
                [PFAnalytics trackEvent:@"text_highlighted"];
            }
        }];
        
        [_bridge callHandler:@"bridgeHandler" data:@{ @"message": @"setComments", @"serializedComments": [ssDayA valueForKey:@"day_comments"] } responseCallback:^(id responseData) {
            if ([[responseData valueForKey:@"message"] isEqual: @"setCommentsFinished"]){
                self.webView.userInteractionEnabled = NO;
                self.webView.userInteractionEnabled = YES;
                [PFAnalytics trackEvent:@"comment_added"];
            }
        }];
        
        self.webView.hidden = NO;
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self readyState:[self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState"]];
}


@end
