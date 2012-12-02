//
//  sugar.h
//  TK-Suite
//
//  Created by Benjamin Schüttler on 09.05.11.
//  Copyright 2012 Benjamin Schüttler Softwareentwicklung. All rights reserved.
//
//  Port from Lumumba Mobile (lumobile)
//

#define $(...)        ((NSString *)[NSString stringWithFormat:__VA_ARGS__,nil])
#define $array(...)   ((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])
#define $set(...)     ((NSSet *)[NSSet setWithObjects:__VA_ARGS__,nil])
#define $map(...)     ((NSDictionary *)[NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__,nil])
#define $int(A)       [NSNumber numberWithInt:(A)]
#define $ints(...)    ((NSArray *)[NSArray arrayWithInts:__VA_ARGS__,NSNotFound])
#define $float(A)     [NSNumber numberWithFloat:(A)]
#define $double(A)    [NSNumber numberWithDouble:(A)]
#define $doubles(...) ((NSArray *)[NSArray arrayWithDoubles:__VA_ARGS__,MAXFLOAT])
#define $indexes(...) ((NSIndexSet *)[NSIndexSet indexSetWithIndexes:__VA_ARGS__,NSNotFound])
#define $bool(A)      [NSNumber numberWithBool:(A)]
#define $words(...)   ((NSArray *)[@#__VA_ARGS__ words])
#define $csv(...)     ((NSArray *)[[@#__VA_ARGS__ splitByComma] trimmedStrings])
#define $concat(A,...) { A = [A arrayByAddingObjectsFromArray:((NSArray *)[NSArray arrayWithObjects:__VA_ARGS__,nil])]; }

#define nilease(A) [A release]; A = nil
#define NIL_A_NULL(A) (A == [NSNull null] ? nil : A)
#define APP [UIApplication sharedApplication]
#define APPDEL [APP delegate]

// Localization
#define __(N) NSLocalizedString(@#N, @"")

#if !defined(FLIP)
#define FLIP(A,B) ({ __typeof__(B) __tmp = (B); __typeof__(A) *__pt_a = &(A); (B) = *__pt_a; *__pt_a = __tmp; })
#endif

#define RANDOM2(A,B) (arc4random() % 2 == 0 ? A : B)
#define RANDOM3(A,B,C) RANDOM2(A,RANDOM2(B,C))
#define RANDOM4(A,B,C,D) RANDOM2(RANDOM(A,B),RANDOM2(C,D))

#define IS_PHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_PAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define MINMAX(LOWER_BOUND, VALUE, UPPER_BOUND) MIN(UPPER_BOUND, MAX(LOWER_BOUND, VALUE))

#define FALLBACK(VALUE,ALT) ({ __typeof__(VALUE) __tmp = (VALUE); !!__tmp ? __tmp : (ALT); })