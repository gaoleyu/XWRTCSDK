//
//  LiveChatRequest.h
//  ecmc
//
//  Created by XianHong zhang on 2020/4/21.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LiveChatParmas.h"
NS_ASSUME_NONNULL_BEGIN

@interface LiveChatRequest : NSObject

#pragma mark 用户登录
+ (void)liveChatLoginResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;
#pragma mark 用户退出
+ (void)liveChatLogOutResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;
#pragma mark 用户挂断
//+ (void)liveChatCloseResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;
#pragma mark 服务密码验证 recId流水号
+ (void)liveChatValidPWDWithPwd:(NSString *)pwd mobile:(NSString *)mobile recId:(NSString *)recId Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;
#pragma mark 签名验证
+ (void)liveChatValidSign:(UIImage *)image Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;
#pragma mark 获取业务列表
+ (void)liveChatgetYWListResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;
#pragma mark 取号即业务内容上传
+ (void)liveChatUpSelectYW:(NSString *)yw Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;
#pragma mark 弃号
+ (void)liveChatGiveUpNumResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;
#pragma mark 用户进入聊天室
+ (void)liveChatJoinRoomResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;

@end

NS_ASSUME_NONNULL_END
