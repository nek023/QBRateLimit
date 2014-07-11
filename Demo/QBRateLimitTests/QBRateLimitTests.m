//
//  QBRateLimitTests.m
//  QBRateLimitTests
//
//  Created by Tanaka Katsuma on 2014/07/11.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TKRGuard.h"

#import "QBRateLimit.h"

@interface QBRateLimitTests : XCTestCase

@end

@implementation QBRateLimitTests

- (void)setUp
{
    [super setUp];
    
    [TKRGuard setDefaultTimeoutInterval:10.0];
}

- (void)tearDown
{
    [super tearDown];
}


#pragma mark - Tests

- (void)testConfiguringRateLimit
{
    QBRateLimit *rateLimit = [[QBRateLimit alloc] init];
    
    rateLimit.perSecond = 1;
    XCTAssertTrue(rateLimit.interval == 1.0);
    XCTAssertTrue(rateLimit.limit == 1);
    
    rateLimit.perMinute = 2;
    XCTAssertTrue(rateLimit.interval == 60.0);
    XCTAssertTrue(rateLimit.limit == 2);
    
    rateLimit.perHour = 3;
    XCTAssertTrue(rateLimit.interval == 60.0 * 60.0);
    XCTAssertTrue(rateLimit.limit == 3);
}

- (void)testPeformingRequest
{
    QBRateLimit *rateLimit = [[QBRateLimit alloc] init];
    rateLimit.perMinute = 2;
    
    XCTAssertTrue(rateLimit.remaining == 2);
    XCTAssertFalse([rateLimit isExceeded]);
    
    [rateLimit performReqeust];
    XCTAssertTrue(rateLimit.remaining == 1);
    XCTAssertFalse([rateLimit isExceeded]);
    
    [rateLimit performReqeust];
    XCTAssertTrue(rateLimit.remaining == 0);
    XCTAssertTrue([rateLimit isExceeded]);
    
    [rateLimit reset];
    XCTAssertTrue(rateLimit.remaining == 2);
    XCTAssertFalse([rateLimit isExceeded]);
}

- (void)testPeriod
{
    QBRateLimit *rateLimit = [[QBRateLimit alloc] init];
    rateLimit.perSecond = 1;
    
    [rateLimit performReqeust];
    XCTAssertTrue([rateLimit isExceeded]);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssertFalse([rateLimit isExceeded]);
        
        RESUME;
    });
    
    WAIT;
}

- (void)testResettingPeriod
{
    QBRateLimit *rateLimit = [[QBRateLimit alloc] init];
    rateLimit.interval = 10.0;
    rateLimit.limit = 1;
    
    [rateLimit performReqeust];
    XCTAssertTrue([rateLimit isExceeded]);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [rateLimit reset];
        
        XCTAssertFalse([rateLimit isExceeded]);
        
        RESUME;
    });
    
    WAIT;
}

- (void)testSettingIntervalToShorterThanOriginal
{
    QBRateLimit *rateLimit = [[QBRateLimit alloc] init];
    rateLimit.interval = 10.0;
    rateLimit.limit = 1;
    
    [rateLimit performReqeust];
    XCTAssertTrue([rateLimit isExceeded]);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        rateLimit.interval = 1.0;
        
        XCTAssertFalse([rateLimit isExceeded]);
        
        RESUME;
    });
    
    WAIT;
}

- (void)testSettingIntervalToLongerThanOriginal
{
    QBRateLimit *rateLimit = [[QBRateLimit alloc] init];
    rateLimit.interval = 2.0;
    rateLimit.limit = 1;
    
    [rateLimit performReqeust];
    XCTAssertTrue([rateLimit isExceeded]);
    
    rateLimit.interval = 10.0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssertTrue([rateLimit isExceeded]);
        
        RESUME;
    });
    
    WAIT;
}

@end
