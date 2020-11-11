//
//  KFLiveChatBaseVC+RtcDelegate.h
//  ecmc
//
//  Created by XianHong zhang on 2020/4/7.
//  Copyright © 2020 cp9. All rights reserved.
//


#import "KFLiveChatBaseVC.h"

#if TARGET_IPHONE_SIMULATOR//模拟器

#elif TARGET_OS_IPHONE//真机

@interface KFLiveChatBaseVC (RtcDelegate)

- (void)categoryLoad;

@end
#endif

