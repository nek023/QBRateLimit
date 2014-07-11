//
//  QBRateLimit.h
//  QBRateLimitDemo
//
//  Created by Tanaka Katsuma on 2014/07/11.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBRateLimit;

@protocol QBRateLimitDelegate <NSObject>

@optional
- (void)rateLimitDidReset:(QBRateLimit *)rateLimit;

@end

@interface QBRateLimit : NSObject

@property (nonatomic, weak) id<QBRateLimitDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) NSUInteger limit;
@property (nonatomic, assign) NSUInteger remaining;

@property (nonatomic, strong, readonly) NSDate *periodStartDate;

- (void)setPerHour:(NSUInteger)perHour;
- (void)setPerMinute:(NSUInteger)perMinute;
- (void)setPerSecond:(NSUInteger)perSecond;

- (BOOL)isExceeded;
- (BOOL)performReqeust;
- (void)reset;

@end
