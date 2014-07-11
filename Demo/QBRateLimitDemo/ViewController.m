//
//  ViewController.m
//  QBRateLimitDemo
//
//  Created by Tanaka Katsuma on 2014/07/11.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import "ViewController.h"

#import "QBRateLimit.h"

@interface ViewController () <QBRateLimitDelegate>

@property (weak, nonatomic) IBOutlet UILabel *remainingLabel;
@property (weak, nonatomic) IBOutlet UIButton *performRequestButton;

@property (nonatomic, strong) QBRateLimit *rateLimit;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create rate limit
    QBRateLimit *rateLimit = [[QBRateLimit alloc] init];
    rateLimit.delegate = self;
    rateLimit.interval = 10.0;
    rateLimit.limit = 3;
    
    self.rateLimit = rateLimit;
    
    [self updateRemainingLabel];
}

- (void)updateRemainingLabel
{
    self.remainingLabel.text = [NSString stringWithFormat:@"Remaining: %lu", self.rateLimit.remaining];
}


#pragma mark - Actions

- (IBAction)performRequest:(id)sender
{
    [self.rateLimit performReqeust];
    
    [self updateRemainingLabel];
    
    if ([self.rateLimit isExceeded]) {
        self.performRequestButton.enabled = NO;
    }
}


#pragma mark - QBRateLimitDelegage

- (void)rateLimitDidReset:(QBRateLimit *)rateLimit
{
    [self updateRemainingLabel];
    
    self.performRequestButton.enabled = YES;
}

@end
