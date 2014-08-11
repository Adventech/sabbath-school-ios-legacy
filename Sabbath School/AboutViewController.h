//
//  AboutViewController.h
//  Sabbath School
//
//  Created by Vitaliy L on 2/17/2014.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController{
    IBOutlet UILabel *label_author;
}

@property (retain, nonatomic) IBOutlet UILabel *label_author;
@property (retain, nonatomic) IBOutlet UIImageView *instagram_icon;
@property (retain, nonatomic) IBOutlet UIImageView *twitter_icon;

- (IBAction)instagramClick:(UITapGestureRecognizer *)sender;
- (IBAction)twitterClick:(UITapGestureRecognizer *)sender;
- (IBAction)loveYourNeighborClick:(UITapGestureRecognizer *)sender;

@end
