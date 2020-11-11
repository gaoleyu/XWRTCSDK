//
//  LiveChatManager.m
//  ecmc
//
//  Created by XianHong zhang on 2020/3/27.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "LiveChatManager.h"
#import "LiveChatMainVC.h"
#import "ChatWaitViewController.h"
#import <UIKit/UIKit.h>
#import "KFLiveChatManager.h"
#import "LCHeartManager.h"
#import "LiveChatWindowBgView.h"
#import "SPKFUtilities.h"
@implementation LiveChatManager

{
    LiveChatWindowBgView *bgView;
   
}
/**
 单例
 */
+ (instancetype)installManager{
    static LiveChatManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LiveChatManager alloc] init];
    });
    return manager;
}
//显示视频通话等待页面
- (void)showLiveChatWaitView{
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    if (_liveWindow || [KFLiveChatManager installManager].liveWindow) {
        
        return;
    }
    
    ChatWaitViewController *viewC = [[ChatWaitViewController alloc] init];
    viewC.ywID = _ywID;
    
    _liveWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _liveWindow.windowLevel = UIWindowLevelAlert;
    _liveWindow.backgroundColor = [UIColor blackColor];
    _liveWindow.hidden = NO;
    
    _liveWindow.rootViewController = viewC;
    
    bgView = [[LiveChatWindowBgView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.hidden = YES;
    bgView.backgroundColor = [UIColor clearColor];
    [_liveWindow addSubview:bgView];
    __weak LiveChatManager *weakSelf = self;
    [bgView setPointBlock:^(CGPoint p) {
        CGPoint newP = weakSelf.liveWindow.center;
        if (p.x > weakSelf.liveWindow.width/2) {
            if (p.x < kScreen_Width - weakSelf.liveWindow.width/2) {
                newP.x = p.x;
            }
        }
        if (p.y > weakSelf.liveWindow.height/2) {
            if (p.y < kScreen_Height - weakSelf.liveWindow.height/2) {
                newP.y = p.y;
            }
        }
        weakSelf.liveWindow.center = newP;
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigLiveChatView)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [bgView addGestureRecognizer:tap];
    
}
//显示视频通话页面
- (void)showLiveChatView{
    //客服端直接进入，是没有等待页面的，所以要先创建下liveWindow
    if (!_liveWindow ) {
        [self showLiveChatWaitView];
    }

    if (![_liveWindow.rootViewController isKindOfClass:[LiveChatMainVC class]]) {
        LiveChatMainVC *controller = [[LiveChatMainVC alloc] init];
       
        _liveWindow.rootViewController = controller;
        //切换主控制器时，要重新调节遮挡图层
        [_liveWindow addSubview:bgView];
        //如果遮挡图没有隐藏，则说明窗口是被缩小的状态，隐藏通话界面部分视图内容
        if (bgView.hidden == NO) {
            
            controller.bottomView.hidden = YES;
            controller.adView.hidden = YES;
            controller.scalBtn.hidden = YES;
        }
    }    
}

//销毁视频通话页面
- (void)closeLiveChatView{
    [UIApplication sharedApplication].idleTimerDisabled = NO;

    [[LCHeartManager installManager] stopTimer];
    _liveWindow = nil;
    _ywID = nil;
    _isShowShare = NO;
    _ywResultDic = nil;
}

//缩小视频通话页面
- (void)smallLiveChatView{
    if (bgView.hidden == NO) {
        return;
    }
     LiveChatMainVC *controller = (LiveChatMainVC *)_liveWindow.rootViewController;

    //当是分享屏幕状态下缩小视图改为直接隐藏视图
    if ([controller isKindOfClass:[LiveChatMainVC class]] && controller.isShareScreen) {
    
    }
    //按比例缩放，缩放之后，与原尺寸比例相同
    float widthScal = 0.25;
    //SCREEN_WIDTH*0.3/(SCREEN_HEIGHT*x) = SCREEN_WIDTH/SCREEN_HEIGHT;
    float heightScal = (SCREEN_WIDTH * widthScal)*SCREEN_HEIGHT/(SCREEN_WIDTH * SCREEN_HEIGHT);
    
    [UIView animateWithDuration:0.25 animations:^{
        _liveWindow.transform = CGAffineTransformScale(_liveWindow.transform, widthScal, heightScal);
        _liveWindow.frame = CGRectMake(SCREEN_WIDTH-widthScal*SCREEN_WIDTH-10, 50, SCREEN_WIDTH*widthScal, SCREEN_HEIGHT*heightScal);
    } completion:^(BOOL finished) {
        bgView.hidden = NO;
        //如果主窗口是视频通话，则隐藏视频通话页面部分按钮
       if ([_liveWindow.rootViewController isKindOfClass:[LiveChatMainVC class]]) {
           controller.bottomView.hidden = YES;
           controller.adView.hidden = YES;
           controller.scalBtn.hidden = YES;
       }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutApp) name:@"APP_LOGOUT_CLOSE_LIVE" object:nil];

    }];
    
    
}

//放大视频通话页面
- (void)bigLiveChatView{
    
    if (bgView.hidden == YES) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _liveWindow.transform = CGAffineTransformScale(_liveWindow.transform, SCREEN_WIDTH/_liveWindow.width, SCREEN_HEIGHT/_liveWindow.height);
        _liveWindow.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
         bgView.hidden = YES;
        //如果主窗口是视频通话，则显示视频通话页面部分按钮
        if ([_liveWindow.rootViewController isKindOfClass:[LiveChatMainVC class]]) {
            
            LiveChatMainVC *controller = (LiveChatMainVC *)_liveWindow.rootViewController;
            controller.bottomView.hidden = NO;
            controller.adView.hidden = NO;
            controller.scalBtn.hidden = NO;
        }
        
          [[NSNotificationCenter defaultCenter] removeObserver:self name:@"APP_LOGOUT_CLOSE_LIVE" object:nil];
    }];
}


-(void)logoutApp{
      [[NSNotificationCenter defaultCenter] removeObserver:self name:@"APP_LOGOUT_CLOSE_LIVE" object:nil];
    
    if ([_liveWindow.rootViewController isKindOfClass:[LiveChatMainVC class]]) {
         LiveChatMainVC *controller = (LiveChatMainVC *)_liveWindow.rootViewController;
              controller.bottomView.hidden = YES;
              controller.adView.hidden = YES;
              controller.scalBtn.hidden = YES;
              if ([controller respondsToSelector:@selector(closeLiveChat)]) {
                  [controller performSelector:@selector(closeLiveChat)];
              }
             
    }else{
        [self closeLiveChatView];
    }
  
}

@end
