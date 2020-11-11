//
//  KFLiveChatRequest.h
//  ecmc
//
//  Created by XianHong zhang on 2020/4/21.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFLiveChatRequest : NSObject

#pragma mark 客服登录
+ (void)kfLiveChatLoginParams:(NSDictionary *)param Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;

#pragma mark 客服退出
+ (void)kfLiveChatLogOutResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;

#pragma mark 客服挂断
+ (void)kfLiveChatCloseExParam:(NSDictionary *)param Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;

#pragma mark 客服信息\状态 变更
+ (void)kfLiveChatUpdateStatus:(NSString *)status Params:(id)param Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;

#pragma mark 客服心跳
+ (void)kfLiveChatheartExParam:(id)param Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;

#pragma mark 客服叫号
+ (void)kfLiveChatPOPResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;

#pragma mark 客服弃号
+ (void)kfLiveChatAbandonExParam:(NSDictionary *)param Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;
#pragma mark 客服推送服务密码验证
+ (void)kfLiveChatPushSerivcePhone:(NSString*)phoneNum CodeResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;

#pragma mark 客服推送电子签名验证
+ (void)kfLiveChatPushSignExParam:(id)param Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;


#pragma mark 客服验证 用户录入信息
+(void)kfLiveChatCheckSignExParam:(id)param Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;
#pragma mark 上传文件
+ (void)upLoadVoiceFileWithPath:(NSString *)path Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock;

@end



NS_ASSUME_NONNULL_END
