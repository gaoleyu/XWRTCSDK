//
//  Reachability+Extension.m
//  EcmcFramework
//
//  Created by qihaijun on 8/18/15.
//  Copyright © 2015 XWTec. All rights reserved.
//

#import "Reachability+Extension.h"

@implementation Reachability(Extension)

+ (BOOL)reachable;
{
    BOOL reachable = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if (r.currentReachabilityStatus == NotReachable) {
        reachable = NO;
    }
    return reachable;
}

+ (NSString *)networkType
{
    NSString *type = @"";
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
        {
            type = @"";
        }
            break;
        case ReachableViaWiFi:
        {
            type = @"WiFi";
        }
            break;
        case ReachableVia2G:
        {
            type = @"2G";
        }
            break;
        case ReachableVia3G:
        {
            type = @"3G";
        }
            break;
        case ReachableVia4G:
        {
            type = @"4G";
        }
            break;
        case ReachableViaWWAN:
        {
            type = @"WWAN";
        }
            break;
    }
    return type;
}

@end
