//
//  LCHeartManager.h
//  ecmc
//
//  Created by XianHong zhang on 2020/4/21.
//  Copyright © 2020 cp9. All rights reserved.
//
#import <Foundation/Foundation.h>
@protocol LCheartManagerDelegate <NSObject>
//计时器每次走的回调，为了全局使用一个计时器
- (void)timerActionDelete;
//回调心跳成功时数据
- (void)requeSuccessWithDataDic:(NSDictionary *)dic;

@end




@interface LCHeartManager : NSObject

@property (nonatomic, weak) id<LCheartManagerDelegate> delegate;


+ (instancetype)installManager;
#pragma mark 设置请求时间间隔
//- (void)setRequestDistance:(NSInteger)distance;
#pragma mark 开启定时器
- (void)startTimer;

#pragma mark 关闭定时器
- (void)stopTimer;

@end


