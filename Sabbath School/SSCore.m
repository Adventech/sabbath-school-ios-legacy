//
//  SSCore.m
//  Sabbath School
//
//  Created by Vitaliy L on 3/14/2014.
//  Copyright (c) 2014 Vitaliy Lim. All rights reserved.
//

#import "SSCore.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "AFHTTPRequestOperationManager.h"

static NSString *ssCurrentDay = nil;
static NSString *ssCurrentLesson = nil;


@implementation SSCore

- (id)init {
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

+ (SSCore *)instance {
    static SSCore *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[SSCore alloc] init];
        }
    }
    
    return instance;
}

+ (FMDatabase *)ssDatabase {
    static FMDatabase *ssDatabase = nil;
    if (ssDatabase == nil){
        ssDatabase = [FMDatabase databaseWithPath:[self ssDatabasePath]];
    }
    
    return ssDatabase;
}

+ (NSString *)getLang{
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ([settings objectForKey:@"Lesson Language"]){
        return [settings objectForKey:@"Lesson Language"];
    }
    
    return @"en";
}

+ (NSString *)ssDatabasePath {
    static NSString *ssDatabasePath = nil;
    if (ssDatabasePath == nil){
        ssDatabasePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SabbathSchool.sqlite"];
    }
    
    return ssDatabasePath;
}

+ (NSString *)ssCurrentQuarterId {
    static NSString *ssCurrentQuarterId = nil;
    if (ssCurrentQuarterId == nil) {
        NSDateFormatter *ssCurrentQuarterIdFormat = [[NSDateFormatter alloc] init];
        [ssCurrentQuarterIdFormat setDateFormat:@"yyyy-qq"];
        ssCurrentQuarterId = [ssCurrentQuarterIdFormat stringFromDate:[NSDate date]];
    }
    return ssCurrentQuarterId;
}

+ (NSString *)ssTodayDate {
    static NSString *ssTodayDate = nil;
    
    if (ssTodayDate == nil){
        NSDateFormatter *ssCurrentDayFormat = [[NSDateFormatter alloc] init];
        [ssCurrentDayFormat setDateFormat:@"yyyy-MM-dd"];
        ssTodayDate = [ssCurrentDayFormat stringFromDate:[NSDate date]];
        
        [[self ssDatabase] open];
        
        NSUInteger count = [[self ssDatabase] intForQuery:@"SELECT COUNT(*) FROM ss_days, ss_lessons, ss_quarters WHERE ss_days.day_date = ? AND ss_days.day_lesson_serial = ss_lessons.serial AND ss_lessons.lesson_quarter_serial = ss_quarters.serial AND ss_quarters.quarter_lang = ?", ssTodayDate, [self getLang]];
        
        if (!count){
            NSMutableArray *ssDayRet = [[NSMutableArray alloc] init];
            
            FMResultSet *ssDayResult = [[self ssDatabase] executeQuery:@"SELECT ss_days.day_date FROM ss_days, ss_lessons, ss_quarters WHERE ss_days.day_lesson_serial = ss_lessons.serial AND ss_lessons.lesson_quarter_serial = ss_quarters.serial AND ss_quarters.quarter_lang = ? ORDER BY ss_days.day_date DESC LIMIT 1", [self getLang]];
            while ([ssDayResult next]) {
                [ssDayRet addObject:[ssDayResult resultDictionary]];
            }
            
            ssTodayDate = [[ssDayRet objectAtIndex:0] valueForKey:@"day_date"];
        }
        
        [[self ssDatabase] close];
    }
    
    return ssTodayDate;
}

+ (NSMutableArray *)ssGetDays:(NSString *)ssDay {
    NSMutableArray *ssDays = [[NSMutableArray alloc] init];

    [[self ssDatabase] open];
    
    NSUInteger ssDayLessonId = [[self ssDatabase] intForQuery:@"SELECT ss_days.day_lesson_serial FROM ss_days, ss_lessons, ss_quarters WHERE ss_days.day_date = ? AND ss_days.day_lesson_serial = ss_lessons.serial AND ss_lessons.lesson_quarter_serial = ss_quarters.serial AND ss_quarters.quarter_lang = ?", ssDay, [self getLang]];
    
    FMResultSet *ssDaysResult = [[self ssDatabase] executeQuery:@"SELECT day_date, day_name, day_date_text FROM ss_days WHERE day_lesson_serial = ? ORDER BY serial ASC", [NSNumber numberWithInt:ssDayLessonId]];
    
    while ([ssDaysResult next]) {
        [ssDays addObject: [ssDaysResult resultDictionary]];
    }
    
    [[self ssDatabase] close];
    
    return ssDays;
}

+ (NSMutableArray *)ssGetDaysBySerial:(int)ssLessonSerial {
    NSMutableArray *ssDays = [[NSMutableArray alloc] init];
    
    [[self ssDatabase] open];
    
    FMResultSet *ssDaysResult = [[self ssDatabase] executeQuery:@"SELECT day_date, day_name, day_date_text FROM ss_days WHERE day_lesson_serial = ? ORDER BY serial ASC", [NSNumber numberWithInt:ssLessonSerial]];
    
    while ([ssDaysResult next]) {
        [ssDays addObject: [ssDaysResult resultDictionary]];
    }
    
    [[self ssDatabase] close];
    
    return ssDays;
}

+ (NSMutableArray *)ssGetLessons {
    NSMutableArray *ssLessons = [[NSMutableArray alloc] init];
    
    [[self ssDatabase] open];
    
    NSUInteger ssQuarterSerial = [[self ssDatabase] intForQuery:@"SELECT ss_quarters.serial FROM ss_quarters, ss_lessons, ss_days WHERE ss_days.day_date = ? AND ss_days.day_lesson_serial = ss_lessons.serial AND ss_lessons.lesson_quarter_serial = ss_quarters.serial AND ss_quarters.quarter_lang = ?", [self ssTodayDate], [self getLang]];
    
    
    FMResultSet *ssLessonsResult = [[self ssDatabase] executeQuery:@"SELECT ss_lessons.serial, ss_lessons.lesson_name, ss_lessons.lesson_date_text FROM ss_lessons WHERE ss_lessons.lesson_quarter_serial = ?", [NSNumber numberWithInt:ssQuarterSerial]];
    
    while ([ssLessonsResult next]) {
        [ssLessons addObject:[ssLessonsResult resultDictionary]];
    }
    
    [[self ssDatabase] close];
    
    return ssLessons;
}

+ (NSMutableArray *)ssGetLessonByDay:(NSString *)ssDay {
    NSMutableArray *ssLessonRet = [[NSMutableArray alloc] init];
    
    [[self ssDatabase] open];
    
    FMResultSet *ssLessonResult = [[self ssDatabase] executeQuery:@"SELECT ss_lessons.* FROM ss_lessons, ss_days, ss_quarters WHERE ss_days.day_date = ? AND ss_days.day_lesson_serial = ss_lessons.serial AND ss_lessons.lesson_quarter_serial = ss_quarters.serial AND ss_quarters.quarter_lang = ? ORDER BY ss_lessons.serial ASC LIMIT 1", ssDay, [self getLang]];
    while ([ssLessonResult next]) {
        [ssLessonRet addObject:[ssLessonResult resultDictionary]];
    }
    
    [[self ssDatabase] close];
    return [ssLessonRet objectAtIndex:0];
}

+ (NSMutableArray *)ssGetLessonBySerial:(int)ssLessonSerial {

    NSMutableArray *ssLessonRet = [[NSMutableArray alloc] init];
    
    [[self ssDatabase] open];
    
    FMResultSet *ssLessonResult = [[self ssDatabase] executeQuery:@"SELECT * FROM ss_lessons WHERE serial = ?", [NSNumber numberWithInt:ssLessonSerial]];
    
    while ([ssLessonResult next]) {
        [ssLessonRet addObject:[ssLessonResult resultDictionary]];
    }
    
    [[self ssDatabase] close];
    return [ssLessonRet objectAtIndex:0];
}


+ (NSMutableArray *)ssGetDay:(NSString *)ssDay {
    NSMutableArray *ssDayRet = [[NSMutableArray alloc] init];
    
    [[self ssDatabase] open];
    
    FMResultSet *ssDayResult = [[self ssDatabase] executeQuery:@"SELECT ss_days.*, ss_lessons.lesson_image as lesson_image FROM ss_days, ss_lessons, ss_quarters WHERE ss_days.day_date = ? AND ss_days.day_lesson_serial = ss_lessons.serial AND ss_lessons.lesson_quarter_serial = ss_quarters.serial AND ss_quarters.quarter_lang = ? LIMIT 1", ssDay, [self getLang]];
    while ([ssDayResult next]) {
        [ssDayRet addObject:[ssDayResult resultDictionary]];
    }
    
    [[self ssDatabase] close];

    return [ssDayRet objectAtIndex:0];
}

+ (void)ssSaveHighlights:(NSInteger *)ssDaySerial :(NSString *)ssHighlights {
    [[self ssDatabase] open];    
    [[self ssDatabase] executeUpdate:@"UPDATE ss_days SET day_highlights = ? WHERE serial = ?", ssHighlights, ssDaySerial];
    [[self ssDatabase] close];
}

+ (void)ssSaveComments:(NSInteger *)ssDaySerial :(NSString *)ssComments {
    [[self ssDatabase] open];
    [[self ssDatabase] executeUpdate:@"UPDATE ss_days SET day_comments = ? WHERE serial = ?", ssComments, ssDaySerial];
    [[self ssDatabase] close];
}

+ (void)downloadIfNeeded:(id<SSCoreDelegate>)delegate {
    [[self ssDatabase] open];
    
    NSString *ssTodayDate = nil;
    NSDateFormatter *ssCurrentDayFormat = [[NSDateFormatter alloc] init];
    [ssCurrentDayFormat setDateFormat:@"yyyy-MM-dd"];
    ssTodayDate = [ssCurrentDayFormat stringFromDate:[NSDate date]];
    
    
    NSUInteger count = [[self ssDatabase] intForQuery:@"SELECT COUNT(*) FROM ss_days, ss_lessons, ss_quarters WHERE ss_days.day_date = ? AND ss_days.day_lesson_serial = ss_lessons.serial AND ss_lessons.lesson_quarter_serial = ss_quarters.serial AND ss_quarters.quarter_lang = ?", ssTodayDate, [self getLang]];
    
    if (!count) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[NSString stringWithFormat:@"https://s3-us-west-2.amazonaws.com/com.cryart.sabbathschool/latest_%@.json?%@", [self getLang], [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]] parameters:nil success:^(AFHTTPRequestOperation *operation, id ssQuarterly) {

            NSString *ssQuarterName = [ssQuarterly objectForKey:@"quarter_name"];
            NSString *ssQuarterImage = [ssQuarterly objectForKey:@"quarter_image"];
            NSString *ssQuarterId = [ssQuarterly objectForKey:@"quarter_id"];
            NSString *ssQuarterLang = [ssQuarterly objectForKey:@"quarter_lang"];
            
            NSUInteger quarterCount = [[self ssDatabase] intForQuery:@"SELECT COUNT(1) FROM ss_quarters WHERE quarter_id = ? AND quarter_lang = ?", ssQuarterId, ssQuarterLang];
            
            if (quarterCount){
                [[self ssDatabase] close];
                [delegate downloadFinished:true];
                return;
            }
            
            [[self ssDatabase] executeUpdate:@"INSERT INTO ss_quarters (quarter_id, quarter_name, quarter_image, quarter_lang) VALUES (?, ?, ?, ?)", ssQuarterId, ssQuarterName, ssQuarterImage, ssQuarterLang];
            
            int ssQuarterSerial = [[self ssDatabase] lastInsertRowId];
            
            NSArray *ssQuarterlyLessons = [ssQuarterly objectForKey:@"quarter_lessons"];
            
            for (NSDictionary *ssQuarterlyLesson in ssQuarterlyLessons){
                NSString *ssLessonName = [ssQuarterlyLesson objectForKey:@"lesson_name"];
                NSString *ssLessonImage = [ssQuarterlyLesson objectForKey:@"lesson_image"];
                NSString *ssLessonDateText = [ssQuarterlyLesson objectForKey:@"lesson_date_text"];
                NSArray *ssLessonDays = [ssQuarterlyLesson objectForKey:@"lesson_days"];
                
                [[self ssDatabase] executeUpdate:@"INSERT INTO ss_lessons (lesson_quarter_serial, lesson_name, lesson_image, lesson_date_text) VALUES (?, ?, ?, ?)", [NSNumber numberWithInt:ssQuarterSerial], ssLessonName, ssLessonImage, ssLessonDateText];
                
                int ssLessonSerial = [[self ssDatabase] lastInsertRowId];
                
                for (NSDictionary *ssLessonDay in ssLessonDays){
                    NSString *ssDayName = [ssLessonDay objectForKey:@"day_name"];
                    NSString *ssDayText = [ssLessonDay objectForKey:@"day_text"];
                    NSString *ssDayDate = [ssLessonDay objectForKey:@"day_date"];
                    NSString *ssDayDateText = [ssLessonDay objectForKey:@"day_date_text"];
                    NSString *ssDayVerses = [ssLessonDay objectForKey:@"day_verses"];
                    NSString *ssDayComments = @"";
                    NSString *ssDayHighlights = @"";
                    
                    [[self ssDatabase] executeUpdate:@"INSERT INTO ss_days (day_lesson_serial, day_date, day_name, day_text, day_comments, day_highlights, day_date_text, day_verses) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", [NSNumber numberWithInt:ssLessonSerial], ssDayDate, ssDayName,ssDayText, ssDayComments, ssDayHighlights, ssDayDateText, ssDayVerses];
                }
            }
            [[self ssDatabase] close];
            [delegate downloadFinished:true];
            return;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[self ssDatabase] close];
            [delegate downloadFinished:false];
        }];
    } else {
        [[self ssDatabase] close];
        [delegate downloadFinished:true];
    }
}


@end
