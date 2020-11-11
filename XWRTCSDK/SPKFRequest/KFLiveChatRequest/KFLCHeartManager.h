//
//  KFLCHeartManager.h
//  ecmc
//
//  Created by XianHong zhang on 2020/4/21.
//  Copyright © 2020 cp9. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol KFLCheartManagerDelegate <NSObject>
//计时器每次走的回调，为了全局使用一个计时器
- (void)timerActionDelete;
//客服心跳返回的数据
-(void)kfHeartRequestCallBack:(NSDictionary *)repDic;
@end



@interface KFLCHeartManager : NSObject

@property (nonatomic, weak) id<KFLCheartManagerDelegate> delegate;

+ (instancetype)installManager;
#pragma mark 开启定时器
- (void)startTimer;

#pragma mark 关闭定时器
- (void)stopTimer;
#pragma mark 心跳类型处理
+ (void)liveHeartDataType:(NSDictionary *)dic controller:(UIViewController *)controller;

+(NSString *)checkAuthor;

#pragma mark 弹框
+(void)showToast:(NSString *)text duration:(NSInteger) duration;
@end

