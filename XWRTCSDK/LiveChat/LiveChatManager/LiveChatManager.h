//
//  LiveChatManager.h
//  ecmc
//
//  Created by XianHong zhang on 2020/3/27.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LiveChatManager : NSObject

@property (nonatomic, strong) UIWindow *liveWindow;
//业务id
@property (nonatomic, strong) NSString *ywID;
//是否展示屏幕共享
@property (nonatomic, assign) BOOL isShowShare;
@property(nonatomic,strong) NSDictionary *ywResultDic;  //根据ywID 取号的结果
/**
 单例
 */
+ (instancetype)installManager;
//显示视频通话等待页面
- (void)showLiveChatWaitView;
//显示视频通话页面
- (void)showLiveChatView;
//销毁视频通话页面
- (void)closeLiveChatView;
//缩小视频通话页面
- (void)smallLiveChatView;
//放大视频通话页面
- (void)bigLiveChatView;


@end

