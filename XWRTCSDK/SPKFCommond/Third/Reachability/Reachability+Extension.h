//
//  Reachability+Extension.h
//  EcmcFramework
//
//  Created by qihaijun on 8/18/15.
//  Copyright © 2015 XWTec. All rights reserved.
//

#import "Reachability.h"

@interface Reachability(Extension)

+ (BOOL)reachable;
+ (NSString *)networkType;

@end
