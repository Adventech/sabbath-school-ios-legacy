//
//  Globals.h
//  Sabbath School
//
//  Created by Vitaliy L on 3/14/2014.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@protocol SSCoreDelegate
- (void)downloadFinished:(BOOL)ret;
@end

@interface SSCore : NSObject {
    
}

+ (SSCore *)instance;
+ (FMDatabase *)ssDatabase;
+ (NSString *)ssDatabasePath;
+ (NSString *)ssCurrentQuarterId;
+ (NSString *)ssTodayDate;
+ (NSMutableArray *)ssGetDays:(NSString *)ssDay;
+ (NSMutableArray *)ssGetDaysBySerial:(int)ssLessonSerial;
+ (NSMutableArray *)ssGetLessons;
+ (NSMutableArray *)ssGetDay:(NSString *)ssDay;
+ (NSMutableArray *)ssGetLessonBySerial:(int)ssLessonSerial;
+ (NSMutableArray *)ssGetLessonByDay:(NSString *)ssDay;
+ (void)ssSaveHighlights:(NSString *)ssDay :(NSString *)ssHighlights;
+ (void)ssSaveComments:(NSString *)ssDay :(NSString *)ssComments;
+ (void) downloadIfNeeded:(id<SSCoreDelegate>)delegate;
+ (NSString *)getLang;
@end
