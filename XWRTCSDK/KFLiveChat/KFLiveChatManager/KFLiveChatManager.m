//
//  KFLiveChatManager.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/7.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "KFLiveChatManager.h"
#import "KFLiveChatMainVC.h"
#import "LiveChatManager.h"
#import "KFConsoleViewController.h"
#import "KFWorkPlatomVC.h"
#import "SPKFUtilities.h"
@implementation KFLiveChatManager

/**
 单例
 */
+ (instancetype)installManager{
    static KFLiveChatManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KFLiveChatManager alloc] init];
    });
    return manager;
}

//显示视频通话页面
- (void)showLiveChatView{
    
  [UIApplication sharedApplication].idleTimerDisabled = YES;
   if (_liveWindow || [LiveChatManager installManager].liveWindow) {
       
       return;
   }
   
   _liveWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
   _liveWindow.windowLevel = UIWindowLevelAlert;
   _liveWindow.backgroundColor = [UIColor blackColor];
   _liveWindow.hidden = NO;
    
   
    KFWorkPlatomVC *controller = [[KFWorkPlatomVC alloc] init];
    _liveWindow.layer.masksToBounds = YES;
    _liveWindow.rootViewController = controller;
    
}

//销毁视频通话页面
- (void)closeLiveChatView{
    [UIApplication sharedApplication].idleTimerDisabled = NO;

    _liveWindow = nil;
}

//缩小视频通话页面
- (void)smallLiveChatView{
    
    //按比例缩放，缩放之后，与原尺寸比例相同
    float widthScal = 0.25;
    //SCREEN_WIDTH*0.3/(SCREEN_HEIGHT*x) = SCREEN_WIDTH/SCREEN_HEIGHT;
    float heightScal = (SCREEN_WIDTH * widthScal)*SCREEN_HEIGHT/(SCREEN_WIDTH * SCREEN_HEIGHT);
    
    [UIView animateWithDuration:0.25 animations:^{
        _liveWindow.transform = CGAffineTransformScale(_liveWindow.transform, widthScal, heightScal);
        _liveWindow.frame = CGRectMake(SCREEN_WIDTH-widthScal*SCREEN_WIDTH-10, 50, SCREEN_WIDTH*widthScal, SCREEN_HEIGHT*heightScal);
    } completion:^(BOOL finished) {
       
    }];
    
    
}

//放大视频通话页面
- (void)bigLiveChatView{
    
    [UIView animateWithDuration:0.25 animations:^{
        _liveWindow.transform = CGAffineTransformScale(_liveWindow.transform, SCREEN_WIDTH/_liveWindow.width, SCREEN_HEIGHT/_liveWindow.height);
        _liveWindow.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
         
    }];
}


@end
