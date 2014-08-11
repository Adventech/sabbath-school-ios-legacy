//
//  BibleViewController.m
//  Sabbath School
//
//  Created by Vitaliy L on 2014-05-09.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import "BibleViewController.h"
#import "FontAwesomeKit.h"
#import "Utils.h"

@interface BibleViewController ()
@property UIActivityIndicatorView *activityIndicatorView;
@end

@implementation BibleViewController

NSString *ssDayVerse = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    self.popUpView.layer.cornerRadius = 5;
    self.popUpView.layer.shadowOpacity = 0.8;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.webView.layer.cornerRadius = 5;
    self.webView.clipsToBounds = YES;
    [super viewDidLoad];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"bible" ofType:@"html" inDirectory:@"/html" ];
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    [self.webView loadHTMLString:[html stringByReplacingOccurrencesOfString:@"<body>" withString:[NSString stringWithFormat:@"<body>%@", ssDayVerse]] baseURL:[NSURL fileURLWithPath: [NSString stringWithFormat:@"%@/html/", [[NSBundle mainBundle] bundlePath]]]];
    
    UIImageView *closeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(257, -15, 30, 30)];
    closeIcon.backgroundColor = [UIColor whiteColor];
    closeIcon.layer.cornerRadius = 30;
    
    FAKIonIcons *close_icon = [FAKIonIcons ios7CloseIconWithSize:35.0f];
    [close_icon addAttribute:NSForegroundColorAttributeName value:[Utils colorWithHex:0x504e60 alpha:1.0]];
    
    closeIcon.image = [close_icon imageWithSize:CGSizeMake(35.0f, 35.0f)];
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopup:)];
    [closeIcon addGestureRecognizer:closeTap];
    [closeIcon setMultipleTouchEnabled:YES];
    [closeIcon setUserInteractionEnabled:YES];

    [self.popUpView addSubview:closeIcon];
    
}

- (void)showAnimate {
    self.view.alpha = 0;
    
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)removeAnimate {
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (IBAction)closePopup:(id)sender {
    [self removeAnimate];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated verse:(NSString *)verse {
    dispatch_async(dispatch_get_main_queue(), ^{
        ssDayVerse = verse;
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
    });
}

- (void)readyState:(NSString *)str {
    if ([str isEqualToString:@"complete"]||[str isEqualToString:@"interactive"]) {
        [self.activityIndicatorView stopAnimating];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self readyState:[self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
