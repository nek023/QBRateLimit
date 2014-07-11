# QBRateLimit
Rate limit controller.


## Installation
Install with CocoaPods.

```
pod 'QBRateLimit'
```

Then import the header file.

```
#import "QBRateLimit.h"
```


## Example
Basic usage is setting `interval` and `limit` property and using `performRequest` to decrease the remaining count.

```
QBRateLimit *rateLimit = [[QBRateLimit alloc] init];
rateLimit.interval = 10.0;
rateLimit.limit = 2;

NSLog(@"Remaining: %lu", rateLimit.remaining); // 2
NSLog(@"Exceeded: %@", [rateLimit isExceeded] ? @"YES" : @"NO"); // NO

[rateLimit performReqeust];

NSLog(@"Remaining: %lu", rateLimit.remaining); // 1
NSLog(@"Exceeded: %@", [rateLimit isExceeded] ? @"YES" : @"NO"); // NO

[rateLimit performReqeust];

NSLog(@"Remaining: %lu", rateLimit.remaining); // 0
NSLog(@"Exceeded: %@", [rateLimit isExceeded] ? @"YES" : @"NO"); // YES
```

You can use convenience setter.

```
QBRateLimit *rateLimit = [[QBRateLimit alloc] init];
rateLimit.perHour = 60;
```

`perHour` sets `interval` to `3600.0` and `limit` to `60`.

You can get noticed when the rate limit is reset.

```
- (void)somewhere
{
	...
	
	self.rateLimit.delegate = self;
}

...

// QBRateLimitDelegage
- (void)rateLimitDidReset:(QBRateLimit *)rateLimit
{
	// Rate limit was reset
}
```


## License
QBRateLimit is available under the MIT license.  
See the LICENSE file for more info.
