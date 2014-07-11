//
//  QBRateLimit.m
//  QBRateLimitDemo
//
//  Created by Tanaka Katsuma on 2014/07/11.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import "QBRateLimit.h"

@interface QBRateLimit ()

@property (nonatomic, assign) NSUInteger numberOfPerformedRequests;

@property (nonatomic, weak) NSTimer *periodTimer;
@property (nonatomic, strong, readwrite) NSDate *periodStartDate;

@end

@implementation QBRateLimit

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Rate limit from Twitter API 1.1
        self.interval = 60.0 * 15.0; // 15 minutes
        self.limit = 15;
    }
    
    return self;
}


#pragma mark - Accessors

- (void)setNumberOfPerformedRequests:(NSUInteger)numberOfPerformedRequests
{
    _numberOfPerformedRequests = MAX(0, MIN(numberOfPerformedRequests, self.limit));
}

- (void)setRemaining:(NSUInteger)remaining
{
    remaining = MAX(0, MIN(remaining, self.limit));
    
    self.numberOfPerformedRequests = self.limit - remaining;
}

- (NSUInteger)remaining
{
    return (self.limit - self.numberOfPerformedRequests);
}

- (void)setInterval:(NSTimeInterval)interval
{
    _interval = interval;
    
    if (self.periodStartDate) {
        if ([[NSDate date] timeIntervalSinceDate:self.periodStartDate] >= interval) {
            [self reset];
        } else {
            [self startPeriodTimer];
        }
    }
}


#pragma mark - Convenience Setters

- (void)setPerHour:(NSUInteger)perHour
{
    self.interval = 60.0 * 60.0;
    self.limit = perHour;
}

- (void)setPerMinute:(NSUInteger)perMinute
{
    self.interval = 60.0;
    self.limit = perMinute;
}

- (void)setPerSecond:(NSUInteger)perSecond
{
    self.interval = 1.0;
    self.limit = perSecond;
}


#pragma mark - Updating Rate Limit

- (BOOL)isExceeded
{
    return (self.numberOfPerformedRequests >= self.limit);
}

- (BOOL)performReqeust
{
    if ([self isExceeded]) {
        return NO;
    }
    
    self.numberOfPerformedRequests++;
    
    if (self.periodStartDate == nil) {
        self.periodStartDate = [NSDate date];
        
        [self startPeriodTimer];
    }
    
    return YES;
}

- (void)reset
{
    [self stopPeriodTimer];
    
    self.numberOfPerformedRequests = 0;
    self.periodStartDate = nil;
    
    // Delegate
    if ([self.delegate respondsToSelector:@selector(rateLimitDidReset:)]) {
        [self.delegate rateLimitDidReset:self];
    }
}


#pragma mark - Period Timer

- (void)startPeriodTimer
{
    [self stopPeriodTimer];
    
    NSTimer *periodTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                            target:self
                                                          selector:@selector(periodTimerFired:)
                                                          userInfo:nil
                                                           repeats:NO];
    self.periodTimer = periodTimer;
}

- (void)stopPeriodTimer
{
    if (self.periodTimer) {
        [self.periodTimer invalidate];
        self.periodTimer = nil;
    }
}

- (void)periodTimerFired:(id)sender
{
    [self reset];
}

@end
