//
//  AboutViewController.h
//  Sabbath School
//
//  Created by Vitaliy L on 2/17/2014.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface AboutViewController : GAITrackedViewController <UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *aboutTableView;
@property (nonatomic, retain) IBOutlet UILabel *aboutNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *loveThyNeighborLabel;
@property (nonatomic, retain) IBOutlet UITapGestureRecognizer *loveThyNeighborTap;
@property (nonatomic, readwrite, assign) NSString *ssDayDate;

- (void)instagramClick;
- (void)twitterClick;
- (void)webClick;
- (void)instagramAmaraClick;

@end
