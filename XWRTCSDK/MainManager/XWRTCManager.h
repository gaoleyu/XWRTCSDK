//
//  XWRTCManager.h
//  XWRTC
//
//  Created by zxh on 2020/10/10.
//  Copyright © 2020 zxh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface XWRTCManager : NSObject

/**
 单例
 */
+ (instancetype)installManager;
- (void)showLiveChatWith:(NSString *)mobile regionNum:(NSString *)regionNum controller:(UIViewController *)controller;
- (void)showKFLiveChatWith:(NSString *)mobile userNum:(NSString *)userNum;

@end

NS_ASSUME_NONNULL_END
