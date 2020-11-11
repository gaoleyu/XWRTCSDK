//
//  LCHeartManager.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/21.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "LCHeartManager.h"
#import "LiveChatRequestBase.h"
#import "LiveChatParmas.h"
#import "SPKFUtilities.h"
@implementation LCHeartManager
{
    NSTimer *timer;
    //创建信号量 设置最多访问资源
    dispatch_semaphore_t semaphore;
    dispatch_queue_t quene;
    
    NSInteger timeValue;
}
+ (instancetype)installManager{
    static LCHeartManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LCHeartManager alloc] init];
        
    });
    return manager;
}
- (id)init{
    if (self = [super init]) {
        //创建信号量 设置最多访问资源
        semaphore = dispatch_semaphore_create(3);
        quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
    }
    return self;
}

#pragma mark 开启定时器
- (void)startTimer{
    if (timer && timer.isValid) {
        [timer invalidate];
    }
    timeValue = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

#pragma mark 关闭定时器
- (void)stopTimer{
    if (timer && timer.isValid) {
        [timer invalidate];
    }
}

#pragma mark timerAction
- (void)timerAction:(NSTimer *)timer{
    if (_delegate && [_delegate respondsToSelector:@selector(timerActionDelete)]) {
        [_delegate timerActionDelete];
    }
    timeValue ++;
    if (timeValue >= [LiveChatParmas installParmas].requestCount) {
        dispatch_async(quene, ^{
            [self requestService];
        });
        timeValue = 0;
    }
    
    
}
- (void)requestService{
    //设置10秒超时时间
    dispatch_semaphore_wait(semaphore, 10);
    //网络请求
    NSString *url = [NSString stringWithFormat:@"%@/public/userheart",baseUrl];
    LiveChatParmas *parmas = [LiveChatParmas installParmas];
    parmas.requestNum = @"public.userheart";
    parmas.role = @"USER";
    NSMutableDictionary *parmasDic = [parmas getParmas];
    [LiveChatRequestBase AFNPostWihtRUL:url WithParmas:parmasDic success:^(id response) {
        if ([SPKFUtilities isValidDictionary:response]) {
            NSString *resCode = response[@"resCode"];
            if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                if (_delegate && [_delegate respondsToSelector:@selector(requeSuccessWithDataDic:)]) {
                    [_delegate requeSuccessWithDataDic:response];
                }
            }
        }
        //释放信号量资源
        dispatch_semaphore_signal(semaphore);
    } fail:^(id response) {
        
        //释放信号量资源
        dispatch_semaphore_signal(semaphore);
    }];
    
}


@end
