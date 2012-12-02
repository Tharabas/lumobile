//
//  NSDate+TH.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 26.10.09.
//  Copyright 2009 Rainbow Labs UG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _THSeason {
  THSeasonSpring,
  THSeasonSummer,
  THSeasonAutumn,
  THSeasonWinter
} THSeason;

@interface NSDate (TH)

//+(void)cacheWeeksFromYear:(NSInteger)firstYear withLength:(NSInteger)weeks;
+(void)cacheMonthsFromYear:(NSInteger)firstYear withLength:(NSInteger)months;
+(void)cacheDefaultMonths;

+(NSDate *)dateWithYear:(NSInteger)year 
                  month:(NSUInteger)month 
                    day:(NSUInteger)day;

+(NSDate *)dateWithDaysFromToday:(NSTimeInterval)dateDifference;
-(NSDate *)dateWithDaysFromToday:(NSTimeInterval)dateDifference;

+(NSDate *)dateWithMonthsFromToday:(NSTimeInterval)dateDifference;
-(NSDate *)dateWithMonthsFromToday:(NSTimeInterval)dateDifference;

+(NSDate *)today;
@property (readonly) NSDate *today;

+(NSDate *)yesterday;
@property (readonly) NSDate *yesterday;

+(NSDate *)tomorrow;
@property (readonly) NSDate *tomorrow;

-(NSDate *)oneSecondAgo;
-(NSDate *)oneSecondLater;

+(NSDate *)primo;
@property (readonly) NSDate *primo;

+(NSDate *)ultimo;
@property (readonly) NSDate *ultimo;

+(NSDate *)firstDayOfWeek;
@property (readonly) NSDate *firstDayOfWeek;

@property (readonly) NSString *sqlDate;
@property (readonly) NSString *sqlDay;
@property (readonly) NSString *sqlTime;

-(NSDateComponents *)components:(NSUInteger)unitFlags;
-(NSDateComponents *)components;
-(NSDateComponents *)ymdComponents;

+(BOOL)isLeapYear:(NSInteger)year;
@property (readonly) BOOL isLeapYear;

+(NSUInteger)daysInMonth:(NSUInteger)month;
+(NSUInteger)daysInMonth:(NSUInteger)month inYear:(NSInteger)year;
@property (readonly) NSUInteger daysInMonth;

@property (readonly) NSInteger  era;
@property (readonly) NSInteger  year;
@property (readonly) NSUInteger quarter;
@property (readonly) NSUInteger month;
@property (readonly) NSUInteger week;
@property (readonly) NSUInteger day;
@property (readonly) NSUInteger dayOfWeek;
@property (readonly) NSUInteger dayOfYear;
@property (readonly) NSUInteger hour;
@property (readonly) NSUInteger minute;
@property (readonly) NSUInteger second;
@property (readonly) NSUInteger secondOfDay;
@property (readonly) NSUInteger secondOfHour;

@property (readonly) BOOL isMonday;
@property (readonly) BOOL isTuesday;
@property (readonly) BOOL isWednesday;
@property (readonly) BOOL isThursday;
@property (readonly) BOOL isFriday;
@property (readonly) BOOL isSaturday;
@property (readonly) BOOL isSunday;

@property (readonly) BOOL isWorkday;
@property (readonly) BOOL isWeekend;

@property (readonly) BOOL isUltimo;

@property (readonly) BOOL isToday;
@property (readonly) BOOL isTomorrow;
@property (readonly) BOOL isYesterday;

@property (readonly) BOOL isSameYear;
@property (readonly) BOOL isSameMonth;
@property (readonly) BOOL isSameWeek;

/*
 * This will map the months to their seasons
 * Starting with spring
 * mar, apr, may = Spring = 0
 * jun, jul, aug = Supper = 1
 * sep, oct, nov = Autumn = 2
 * dec, jan, feb = Winter = 3
 */
@property (readonly) THSeason season;

@property (readonly) BOOL isWinter;
@property (readonly) BOOL isSpring;
@property (readonly) BOOL isSummer;
@property (readonly) BOOL isAutumn;

/*
 * comparisons
 */

-(BOOL)isBefore:(NSDate *)other;
-(BOOL)isAfter:(NSDate *)other;

/*
 * will count full days that have passed
 * since a given date
 */
-(NSInteger)daysSinceDate:(NSDate *)date;
-(NSInteger)quickDaysSinceDate:(NSDate *)date;

/*
 * will count full months that have passed
 * since a given date
 */
-(NSInteger)monthsSinceDate:(NSDate *)date;

@property (readonly) CGFloat partOfDay;
@property (readonly) CGFloat partOfWeek;
@property (readonly) CGFloat partOfMonth;

-(CGFloat)daysDistanceWithDate:(NSDate *)date;
-(CGFloat)monthsDistanceWithDate:(NSDate *)date;

-(NSString *)format:(NSString *)format;
-(NSString *)format:(NSString *)format withLocale:(NSLocale *)locale;

@end
