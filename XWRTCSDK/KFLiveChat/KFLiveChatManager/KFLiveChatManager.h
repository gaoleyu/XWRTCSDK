//
//  KFLiveChatManager.h
//  ecmc
//
//  Created by XianHong zhang on 2020/4/7.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface KFLiveChatManager : NSObject

@property (nonatomic, strong) UIWindow *liveWindow;
//是否是客服端
@property (nonatomic, assign) BOOL isKF;

/**
 单例
 */
+ (instancetype)installManager;

//显示视频通话页面
- (void)showLiveChatView;
//销毁视频通话页面
- (void)closeLiveChatView;
//缩小视频通话页面
- (void)smallLiveChatView;
//放大视频通话页面
- (void)bigLiveChatView;


@end

NS_ASSUME_NONNULL_END
