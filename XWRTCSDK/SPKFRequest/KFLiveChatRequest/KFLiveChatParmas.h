//
//  KFLiveChatParmas.h
//  ecmc
//
//  Created by XianHong zhang on 2020/4/21.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFLiveChatParmas : NSObject
//应用id
@property (nonatomic, strong) NSString *appid;
//应用密钥
@property (nonatomic, strong) NSString *appPwd;
//用户编码
@property (nonatomic, strong) NSString *userNum;
//版本号
@property (nonatomic, strong) NSString *userAppVer;
//操作系统
@property (nonatomic, strong) NSString *userOs;
//用户手机号
@property (nonatomic, strong) NSString *mobile;
//会话id
@property (nonatomic, strong) NSString *sessionId;
//token
@property (nonatomic, strong) NSString *token;
//角色 USER用户   STAFF客服
@property (nonatomic, strong) NSString *role;
//房间编码
@property (nonatomic, strong) NSString *roomNum;
//受理编码
@property (nonatomic, strong) NSString *acceptNum;
//地区编码
@property (nonatomic, strong) NSString *regionNum;
//取号叫号弃号聊天室管理参数 与用户编码一致
@property (nonatomic, strong) NSString *uniNum;
//接口编码
@property (nonatomic, strong) NSString *requestNum;

//客服编号
@property (nonatomic, strong) NSString *staffNum;
@property (nonatomic,strong)NSString *staffName;
//userNetwork网络制式
@property (nonatomic, strong) NSString *userNetwork;
//工作状态
@property(nonatomic, strong) NSString *status;
@property(nonatomic,strong) NSString *deviceId;
@property(nonatomic, strong) NSString *chatToken;
@property(nonatomic, strong) NSString *channelId;
//心跳时间
@property(nonatomic,strong) NSString *heartFeq;
//是否录音
@property (nonatomic, assign) BOOL isOpenRecordForI;
#pragma mark 获取请求参数
- (NSMutableDictionary *)getParmas;
#pragma mark 更新参数
- (void)updateParmas:(NSDictionary *)responseObj;

+ (instancetype)installParmas;
#pragma mark 清空所有参数
- (void)clearAllParams;

@end

NS_ASSUME_NONNULL_END
