//
//  LiveChatMainVC.h
//  ecmc
//
//  Created by XianHong zhang on 2020/3/25.
//  Copyright © 2020 cp9. All rights reserved.
//



//#import "RoomViewController.h"
#import "LIveChatBaseVC.h"
#if TARGET_IPHONE_SIMULATOR//模拟器
@interface LiveChatMainVC : UIViewController

@property (nonatomic, strong) UIView *bottomView,*adView,*scalBtn,*isShareScreen;

@end

#elif TARGET_OS_IPHONE//真机
@interface LiveChatMainVC : LIveChatBaseVC

@end

#endif
