//
//  NSDate+TH.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 26.10.09.
//  Copyright 2009 Rainbow Labs UG. All rights reserved.
//

#import "NSDate+TH.h"
#define SECONDS_PER_DAY 86400
#define SECONDS_PER_MONTH (30.41 * 86400)
#define CAL [NSCalendar currentCalendar]

@implementation NSDate (TH)

//static struct {
//  NSUInteger year;
//  NSUInteger weeks;
//  NSTimeInterval ref;
//  NSTimeInterval *primos;
//} NSDate_FastWeeks = { 1970, 0, 0, nil };

//+(void)cacheWeeksFromYear:(NSInteger)firstYear withLength:(NSInteger)weeks {
//  NSDate_FastWeeks.year = firstYear;
//  
//  // NOT YET
//}

static struct {
  NSUInteger year;
  NSUInteger months;
  NSTimeInterval *primos;
} _monthCache = { 1982, 0, nil };

+(void)cacheMonthsFromYear:(NSInteger)firstYear withLength:(NSInteger)months {
  if (_monthCache.primos) {
    free(_monthCache.primos);
    _monthCache.primos = nil;
  }
  
  if (months == 0) {
    return;
  }
  
  _monthCache.year = firstYear;
  _monthCache.months = months + 1;
  _monthCache.primos = malloc(sizeof(NSTimeInterval) * _monthCache.months);

  NSDateComponents *c = [[NSDateComponents alloc] init];
  c.year = firstYear;
  c.month = 1;
  c.day = 1;
  c.hour = 0;
  c.minute = 0;
  c.second = 0;
  
  for (int i = 0; i < _monthCache.months; i++) {
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:c];
    NSTimeInterval time = [date timeIntervalSinceReferenceDate];
    _monthCache.primos[i] = time;
    c.month++;
  }
  
  [c release];
}

+(void)cacheDefaultMonths {
  [self cacheMonthsFromYear:1990 withLength:12 * 40];
}

static NSDate *primo(NSDate *date) {
  if (!_monthCache.primos) {
    return nil;
  }
  
  NSTimeInterval time = [date timeIntervalSinceReferenceDate];
  NSTimeInterval d = time - _monthCache.primos[0];
  int n = floor(d / SECONDS_PER_MONTH) - 4;
  
  if (n < -4 || n > _monthCache.months) {
    return nil;
  }
  
  for (int i = MAX(0, n); i < _monthCache.months; i++) {
    if (time < _monthCache.primos[i]) {
      // hit
      if (i == 0) {
        return nil;
      }
      
      NSTimeInterval vi = _monthCache.primos[i - 1];
      return [NSDate dateWithTimeIntervalSinceReferenceDate:vi];
    }
  }
  
  return nil;
}

static BOOL positionInMonth(NSDate *date, CGFloat *pos) {
  if (!_monthCache.primos) {
    return NO; 
  }
  
  NSTimeInterval time = [date timeIntervalSinceReferenceDate];
  NSTimeInterval d = time - _monthCache.primos[0];
  int n = floor(d / SECONDS_PER_MONTH) - 4;
  
  if (n < -4 || n > _monthCache.months) {
    return NO;
  }
  
  for (int i = MAX(1, n); i < _monthCache.months; i++) {
    NSTimeInterval start = _monthCache.primos[i - 1];
    if (time == start) {
      *pos = 0.0;
      return YES;
    }
    NSTimeInterval end   = _monthCache.primos[i];
    if (time > start && time < end) {
      // hit
      NSTimeInterval d = time - start;
      NSTimeInterval t = end - start;
      *pos = d / t;
      return YES;
    }
  }
  
  return NO;
}

static BOOL monthsDistance(NSDate *first, NSDate *second, NSInteger *delta) {
  if (!_monthCache.primos) {
    return NO;
  }
  
  NSTimeInterval fti = [first timeIntervalSinceReferenceDate];
  NSTimeInterval sti = [second timeIntervalSinceReferenceDate];
  NSTimeInterval dti;
  
  BOOL flip = NO;
  if (fti > sti) {
    // switch
    dti = fti;
    fti = sti;
    sti = dti;
    flip = YES;
  }
  
  dti = sti - fti;
  
  if (fti < _monthCache.primos[0] || dti == 0) {
    *delta = 0;
    return YES;
  }
  
  int fi = -1, si = -1;
  int i;
  for (i = 0; i < _monthCache.months; i++) {
    if (_monthCache.primos[i] > fti) {
      fi = i;
      i = MAX(i, (dti / SECONDS_PER_MONTH) - 4);
      break;
    }
  }
  for (; i < _monthCache.months; i++) {
    if (_monthCache.primos[i] > sti) {
      si = i;
      break;
    }
  }
  
  if (fi > -1 && si > -1) {
    *delta = fi - si;
    if (flip) {
      *delta *= -1;
    }
    return YES;
  }
  
  return NO;
}

//
// real dates
//

+(NSDate *)dateWithYear:(NSInteger)year 
                  month:(NSUInteger)month 
                    day:(NSUInteger)day
{
  NSDateComponents *c = NSDateComponents.new;
  c.year = year;
  c.month = month;
  c.day = day;
  
  NSDate *re = [CAL dateFromComponents:c];
  [c release];
  return re;
}

+(NSDate *)dateWithDaysFromToday:(NSTimeInterval)dateInterval {
  return [[self date] dateWithDaysFromToday:dateInterval];
}

-(NSDate *)dateWithDaysFromToday:(NSTimeInterval)delta {
  NSDateComponents *c = self.components;
  c.day += delta;
  //return [NSDate dateWithYear:c.year month:c.month day:c.day + delta];
  return [CAL dateFromComponents:c];
}

+(NSDate *)dateWithMonthsFromToday:(NSTimeInterval)dateDifference {
  return [[self today] dateWithMonthsFromToday:dateDifference];
}

-(NSDate *)dateWithMonthsFromToday:(NSTimeInterval)dateDifference {
  NSDateComponents *c = self.components;
  NSInteger year = c.year, month = c.month + dateDifference;//, day = c.day;
  
  while (month <= 0) {
    month += 12;
    year--;
  }
  
  while (month > 12) {
    month -= 12;
    year++;
  }
  
  c.year = year;
  c.month = month;
  
  //return [NSDate dateWithYear:year month:month day:day];
  return [CAL dateFromComponents:c];
}

+(NSDate *)today {
  return [self.date today];
}

-(NSDate *)today {
  NSDateComponents *c = self.ymdComponents;
  c.hour = 0;
  c.minute = 0;
  c.second = 0;
  return [CAL dateFromComponents:c];
}

+(NSDate *)yesterday {
  return [self.date yesterday];
}

-(NSDate *)yesterday {
  NSDateComponents *c = self.ymdComponents;
  c.day--;
  c.hour = 0;
  c.minute = 0;
  c.second = 0;
  return [CAL dateFromComponents:c];
}

+(NSDate *)tomorrow {
  return [self.date tomorrow];
}

-(NSDate *)tomorrow {
  NSDateComponents *c = self.ymdComponents;
  c.day++;
  c.hour = 0;
  c.minute = 0;
  c.second = 0;
  return [CAL dateFromComponents:c];
}

-(NSDate *)oneSecondAgo {
  return [NSDate dateWithTimeInterval:-1 sinceDate:self];
}

-(NSDate *)oneSecondLater {
  return [NSDate dateWithTimeInterval:1 sinceDate:self];
}

+(NSDate *)primo {
  return [[self today] primo];
}

-(NSDate *)primo {
  NSDate *re = primo(self);
  if (re) {
    return re;
  }
  NSDateComponents *c = self.ymdComponents;
  return [NSDate dateWithYear:c.year month:c.month day:1];
}

+(NSDate *)ultimo {
  return [[self today] ultimo];
}

-(NSDate *)ultimo {
  
  NSDateComponents *c = self.ymdComponents;
  NSUInteger day = [NSDate daysInMonth:c.month inYear:c.year];
  return [NSDate dateWithYear:c.year month:c.month day:day];
}

+(NSDate *)firstDayOfWeek {
  return [[self today] firstDayOfWeek];
}

-(NSDate *)firstDayOfWeek {
  static NSInteger fow = -1;
  if (fow == -1) {
    fow = [[NSCalendar currentCalendar] firstWeekday];
  }
  NSInteger dow = self.dayOfWeek;
  NSTimeInterval ti = fow - dow;
  
  if (ti == 0) {
    return self;
  }
  
  if (dow < fow) {
    ti -= 7;
  }
  
  return [self dateWithDaysFromToday:ti];
}

//
// String output
//

-(NSString *)sqlDate {
  NSDateComponents *c = self.components;
  
  return [NSString 
          stringWithFormat:@"%.4i-%.2i-%.2i %.2i:%.2i:%.2i",
          c.year, c.month, c.day,
          c.hour, c.minute, c.second,
          nil
          ];
}

-(NSString *)sqlDay {
  NSDateComponents *c = self.ymdComponents;
  
  return [NSString 
          stringWithFormat:@"%.4i-%.2i-%.2i",
          c.year, c.month, c.day,
          nil
          ];
}

-(NSString *)sqlTime {
  NSDateComponents *c = self.components;
  
  return [NSString 
          stringWithFormat:@"%.2i:%.2i:%.2i",
          c.hour, c.minute, c.second,
          nil
          ];
}

//
// Component stuff
//

static const NSUInteger NSYMDCalendarUnits = 
    NSYearCalendarUnit
  | NSMonthCalendarUnit
  | NSDayCalendarUnit
;

static const NSUInteger NSAllCalendarUnits =           
    NSEraCalendarUnit
  | NSYearCalendarUnit
  | NSMonthCalendarUnit
  | NSDayCalendarUnit
  | NSHourCalendarUnit
  | NSMinuteCalendarUnit
  | NSSecondCalendarUnit
  | NSWeekCalendarUnit
  | NSWeekdayCalendarUnit
  | NSWeekdayOrdinalCalendarUnit
  | NSQuarterCalendarUnit
;

-(NSDateComponents *)components:(NSUInteger)unitFlags {
  return [CAL components:unitFlags fromDate:self];
}

-(NSDateComponents *)components {
  return [CAL components:NSAllCalendarUnits fromDate:self];
}

-(NSDateComponents *)ymdComponents {
  return [CAL components:NSYMDCalendarUnits fromDate:self];
}

+(BOOL)isLeapYear:(NSInteger)year {
  if (year % 400 == 0) {
    return YES;
  }
  if (year % 100 == 0) {
    return NO;
  }
  if (year % 4 == 0) {
    return YES;
  }
  return NO;
}

-(BOOL)isLeapYear {
  return [NSDate isLeapYear:self.year];
}

+(NSUInteger)daysInMonth:(NSUInteger)month {
  // the array starts with december as 0 == 12
  static const NSUInteger _d[12] = { 
    31, // DEC
    31, // JAN
    28, // FEB
    31, // MAR
    30, // APR
    31, // MAY
    30, // JUN
    31, // JUL
    31, // AUG
    30, // SEP
    31, // OCT
    30  // NOV
  };
  return _d[month % 12];
}

+(NSUInteger)daysInMonth:(NSUInteger)month inYear:(NSInteger)year {
  return [self daysInMonth:month] + (month == 2 && [self isLeapYear:year] ? 1 : 0);
}

-(NSUInteger)daysInMonth {
  NSDateComponents *c = self.ymdComponents;
  return [NSDate daysInMonth:c.month inYear:c.year];
}

-(NSInteger)era {
  return [[self components:NSEraCalendarUnit] era];
}

-(NSInteger)year {
  return [[self components:NSYearCalendarUnit] year];
}

-(NSUInteger)quarter {
  //return [[self components:NSQuarterCalendarUnit] quarter];
  return ceil((self.month) / 3.0);
}

-(NSUInteger)month {
  return [[self components:NSMonthCalendarUnit] month];
}

-(NSUInteger)week {
  return [[self components:NSWeekCalendarUnit] week];
}

-(NSUInteger)day {
  return [[self components:NSDayCalendarUnit] day];
}

-(NSUInteger)dayOfWeek {
  return [[self components:NSWeekdayCalendarUnit] weekday];
}

-(NSUInteger)dayOfYearWithComponents:(NSDateComponents *)c {
  static const NSUInteger daysSinceFirstOfYear[11] = {
    31, // JAN
    59, // FEB
    90, // MAR
    120, // APR
    151, // MAY
    181, // JUN
    212, // JUL
    243, // AUG
    273, // SEP
    304, // OCT
    334, // NOV
  };
  NSUInteger re = c.day;
  NSUInteger m = c.month;
  if (m > 1) {
    re += daysSinceFirstOfYear[m - 1];
    if (m > 2 && [NSDate isLeapYear:c.year]) {
      re++;
    }
  }
  return re;
}

-(NSUInteger)dayOfYear {
  NSDateComponents *c = self.ymdComponents;
  return [self dayOfYearWithComponents:c];
}

-(NSUInteger)hour {
  return [[self components:NSHourCalendarUnit] hour];
}

-(NSUInteger)minute {
  return [[self components:NSMinuteCalendarUnit] minute];
}

-(NSUInteger)second {
  return [[self components:NSSecondCalendarUnit] second];
}

-(NSUInteger)secondOfDay {
  NSDateComponents *c = [self components:
                         NSSecondCalendarUnit 
                         | NSHourCalendarUnit 
                         | NSMinuteCalendarUnit];
  return c.hour * 3600 + c.minute * 60 + c.second;
}

-(NSUInteger)secondOfHour {
  NSDateComponents *c = [self components:
                         NSSecondCalendarUnit
                         | NSHourCalendarUnit];
  return c.minute * 60 + c.second;
}

-(BOOL)isMonday {
  return self.dayOfWeek == 2;
}
-(BOOL)isTuesday {
  return self.dayOfWeek == 3;
}
-(BOOL)isWednesday {
  return self.dayOfWeek == 4;
}
-(BOOL)isThursday {
  return self.dayOfWeek == 5;
}
-(BOOL)isFriday {
  return self.dayOfWeek == 6;
}
-(BOOL)isSaturday {
  return self.dayOfWeek == 7;
}
-(BOOL)isSunday {
  return self.dayOfWeek == 1;
}
-(BOOL)isWorkday {
  return (self.dayOfWeek + 5) % 7 < 6;
}
-(BOOL)isWeekend {
  NSUInteger dow = self.dayOfWeek;
  return dow == 1 || dow == 7;
}
-(BOOL)isUltimo {
  return self.day == self.daysInMonth;
}

-(BOOL)isSameYear {
  NSDate *cd = [[NSDate alloc] init];
  BOOL re = self.year == cd.year;
  [cd release];
  return re;
}

-(BOOL)isSameMonth {
  NSDate *cd = [[NSDate alloc] init];
  NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit;
  NSDateComponents *c = [self components:flags];
  NSDateComponents *cdc = [cd components:flags];
  
  BOOL re = c.year == cdc.year && c.month == cdc.month;
  [cd release];
  return re;
}

-(BOOL)isSameWeek {
  NSDate *cd = [[NSDate alloc] init];
  NSUInteger flags = NSYearCalendarUnit | NSWeekCalendarUnit;
  NSDateComponents *c = [self components:flags];
  NSDateComponents *cdc = [cd components:flags];
  
  BOOL re = c.year == cdc.year && c.week == cdc.week;
  [cd release];
  return re;
}

-(BOOL)isToday {
  NSDate *cd = [[NSDate alloc] init];
  NSDateComponents *c = self.ymdComponents;
  NSDateComponents *cdc = cd.ymdComponents;
  
  BOOL re = 
    c.year == cdc.year 
    && c.month == cdc.month
    && c.day == cdc.day;
  
  [cd release];
  return re;
}

-(BOOL)isYesterday {
  return [[self yesterday] isToday];
}

-(BOOL)isTomorrow {
  return [[self tomorrow] isToday];
}

//
// seasons
//

-(THSeason)season {
  return (int)(floor((self.month % 12) / 3) + 3) % 4;
}

-(BOOL)isWinter {
  return self.season == THSeasonWinter;
}

-(BOOL)isSpring {
  return self.season == THSeasonSpring;
}

-(BOOL)isSummer {
  return self.season == THSeasonSummer;
}

-(BOOL)isAutumn {
  return self.season == THSeasonAutumn;
}

//
// comparisons
//

-(BOOL)isBefore:(NSDate *)other {
  return [self compare:other] == NSOrderedAscending;
}

-(BOOL)isAfter:(NSDate *)other {
  return [self compare:other] == NSOrderedDescending;
}

-(NSInteger)daysSinceDate:(NSDate *)date {
  if (!date) {
    // failsave return
    return NSNotFound;
  }
  
  if ([self isBefore:date]) {
    return -[date daysSinceDate:self];
  }
  
  NSDateComponents *mc = self.ymdComponents;
  NSDateComponents *oc = date.ymdComponents;
  
  NSInteger sd = [self dayOfYearWithComponents:mc];
  NSInteger od = [date dayOfYearWithComponents:oc];
  
  NSInteger re = sd - od;
  
  NSInteger sy = mc.year;
  NSInteger oy = oc.year;
  
  if (sy != oy) {
    re += 365 * (sy - oy);
    for (NSInteger y = oy; y < sy; y++) {
      if ([NSDate isLeapYear:y]) {
        re++;
      }
    }
  }
  return re;
}

-(NSInteger)quickDaysSinceDate:(NSDate *)date {
  return round([self timeIntervalSinceDate:date] / SECONDS_PER_DAY);
}

-(NSInteger)monthsSinceDate:(NSDate *)date {
  if (!date) {
    // failsave return
    return NSNotFound;
  }
  
  NSInteger monthDelta;
  if (!monthsDistance(self, date, &monthDelta)) {
    NSDateComponents *myc = self.ymdComponents;
    NSDateComponents *oc  = date.ymdComponents;
    
    NSInteger yearDelta  = myc.year  - oc.year;
    monthDelta = (12 * yearDelta) + (myc.month - oc.month);
  }
  
  return monthDelta;
}

-(CGFloat)partOfDay {
  NSTimeInterval ti = [self timeIntervalSinceDate:self.today];
  return ti / (double)SECONDS_PER_DAY;
}

-(CGFloat)partOfWeek {
  NSTimeInterval ti = [self timeIntervalSinceDate:self.firstDayOfWeek];
  return ti / 7.0 * (double)SECONDS_PER_DAY;
}

-(CGFloat)partOfMonth {
  CGFloat re;
  if (positionInMonth(self, &re)) {
    return re;
  }
  NSTimeInterval ti = [self timeIntervalSinceDate:self.primo];
  NSTimeInterval max = self.daysInMonth * SECONDS_PER_DAY;
  return ti / (double)max;
}

-(CGFloat)daysDistanceWithDate:(NSDate *)date {
  CGFloat re = [self daysSinceDate:date];
  
  re += self.partOfDay;
  re -= date.partOfDay;
  
  return re;
}

-(CGFloat)monthsDistanceWithDate:(NSDate *)date {
  CGFloat re = [self monthsSinceDate:date];
  
  re += self.partOfMonth;
  re -= date.partOfMonth;
  
  return re;
}

-(NSString *)format:(NSString *)format {
  return [self format:format withLocale:[NSLocale currentLocale]];
}

-(NSString *)format:(NSString *)format withLocale:(NSLocale *)locale {
  NSDateFormatter *f = [NSDateFormatter new];
  f.calendar = [NSCalendar currentCalendar];
  f.locale = locale;
  f.dateFormat = format;
  NSString *re = [f stringFromDate:self];
  [f release];
  return re;
}


@end
