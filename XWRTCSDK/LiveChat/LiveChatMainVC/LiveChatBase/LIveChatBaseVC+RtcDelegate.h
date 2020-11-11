//
//  LIveChatBaseVC+RtcDelegate.h
//  ecmc
//
//  Created by XianHong zhang on 2020/3/26.
//  Copyright © 2020 cp9. All rights reserved.
//

#if TARGET_IPHONE_SIMULATOR//模拟器

#elif TARGET_OS_IPHONE//真机
#import "LIveChatBaseVC.h"

@interface LIveChatBaseVC (RtcDelegate)


- (void)categoryLoad;

@end
#endif
