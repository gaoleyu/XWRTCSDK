//
//  Settings.m
//  OpenVideoCall
//
//  Created by CavanSu on 2019/6/4.
//  Copyright © 2019 Agora. All rights reserved.
//

#import "Settings.h"
#if TARGET_IPHONE_SIMULATOR//模拟器

#elif TARGET_OS_IPHONE//真机
@implementation Settings
- (instancetype)init {
    if (self = [super init]) {
        self.encryption = [[Encryption alloc] init];
    }
    return self;
}
@end
#endif
