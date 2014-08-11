//
//  BibleViewController.h
//  Sabbath School
//
//  Created by Vitaliy L on 2014-05-09.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BibleViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *popUpView;

- (void)showInView:(UIView *)aView animated:(BOOL)animated verse:(NSString *)verse;

@end
