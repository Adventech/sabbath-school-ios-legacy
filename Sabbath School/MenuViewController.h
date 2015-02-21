//
//  MenuViewController.h
//  Sabbath School
//
//  Created by Vitaliy L on 2/17/2014.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IASKAppSettingsViewController.h"

@class WeekSelectionViewController;
@class AboutViewController;

@interface MenuViewController : UIViewController <IASKSettingsDelegate, UITableViewDelegate, UITableViewDataSource>{
    WeekSelectionViewController * modalVC;
}

@property (nonatomic, retain) IBOutlet UITableView *rearTableView;
@property (retain, nonatomic) IBOutlet UILabel *label_title;

-(void)ssLoadLessons:(int)ssLessonSerial;

@end
