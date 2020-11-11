//
//  KFLiveChatBaseVC.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/7.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "KFLiveChatBaseVC.h"
#if TARGET_IPHONE_SIMULATOR//模拟器

#elif TARGET_OS_IPHONE//真机

#import "KFLiveChatBaseVC+RtcDelegate.h"
#import "KFLiveChatManager.h"
#import "KFLiveChatRequest.h"
#import "LiveChatAlertVC.h"
#import "KFLiveChatParmas.h"
#import "KFLCHeartManager.h"
#import "SPKFUtilities.h"

@interface KFLiveChatBaseVC ()
{
    UIView *bgView;
    
    NSDictionary *endType; //挂断类型  //60s倒计时自动挂断：endType:OV
    BOOL isShOrAutoClose;    //是否是客服自己手动挂断或倒计时超时自动挂断
    LiveChatAlertVC *closeAlert; //挂断弹框
    //站位图提示文字
    UILabel *bgViewsignLabel;
}
@property(nonatomic,strong)NSTimer *timer; //进入房间倒计时 60秒自动挂断
@end

@implementation KFLiveChatBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _isOpencamera = YES;
    [self categoryLoad];
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:[self getAppID] delegate:self];
    
    [self.agoraKit setLogFilter: AgoraLogFilterDebug];

    // 将日志输出等级设置为 AgoraLogFilterDebug
      // 获取当前目录
      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
      // 获取文件路径
      // 获取时间戳
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      [formatter setDateFormat:@"ddMMyyyyHHmm"];
      NSDate *currentDate = [NSDate date];
      NSString *dateString = [formatter stringFromDate:currentDate];
      NSString *logFilePath = [NSString stringWithFormat:@"%@/%@.log", [paths objectAtIndex:0], dateString];
      // 设置日志文件的默认地址
      [self.agoraKit setLogFile:logFilePath];
    
    
     self.remoteVideoView.hidden = YES;
    self.localVideoView.hidden = NO;
   
    [self setupLocalVideo];
    
    
    //客服底部按钮视图
    _kfBottomView = [[KFLiveChatBottomView alloc] initWithFrame:CGRectZero];
    _kfBottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_kfBottomView];
    __weak KFLiveChatBaseVC *weakSelf = self;
    [_kfBottomView setCloseBtnBlock:^{
        [weakSelf shCloseLiveChat]; //手动关闭
    }];
    //工作台
    //底部输入框
    float platviewheight = 290;
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            platviewheight = platviewheight + [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom-20;
        }
    }
    _platformView = [[KFWorkPlatformView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-platviewheight, SCREEN_WIDTH, platviewheight)];
   
    [self.view addSubview:_platformView];
   
    [_kfBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(70);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(40);
    }];
    
    
    //缩放按钮    
//    _scalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:_scalBtn];
//    [_scalBtn setImage:[UIImage bundleImageNamed:@"suofang"] forState:UIControlStateNormal];
//    _scalBtn.frame = CGRectMake(10, 45, 40, 40);
//    [_scalBtn addTarget:self action:@selector(smallVC) forControlEvents:UIControlEventTouchUpInside];
   
    
    //60s后自动关闭
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//    });
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(autoClose) userInfo:nil repeats:NO];
       
}

#pragma mark 手动挂断
-(void)shCloseLiveChat{
    if ([KFLiveChatParmas installParmas].isOpenRecordForI) {
        //停止录音
        [_agoraKit stopAudioRecording];
    }
    
    __weak KFLiveChatBaseVC *weakSelf = self;
    if (!closeAlert) {
        closeAlert = [[LiveChatAlertVC alloc]init];
    }
    isShOrAutoClose = YES;
    closeAlert.sureBlock = ^(id  _Nonnull obj) {
        if ([weakSelf.timer isValid]) {   //等待接通状态
            endType = @{@"endType":@"SH"};
        }
        [weakSelf closeLiveChat];
    };
    
    [closeAlert alertSingleBtnWithDes:@"是否确认结束当前视频服务？" sureBtn:@"确定挂断" cancelBtn:@"取消关闭"];
    closeAlert.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:closeAlert animated:NO completion:nil];
    
}

#pragma mark 60S自动挂断
-(void)autoClose{
    if ([KFLiveChatParmas installParmas].isOpenRecordForI) {
        //停止录音
        [_agoraKit stopAudioRecording];
    }
    
    
    isShOrAutoClose = YES;
    [KFLCHeartManager showToast:@"客户在60S内未接通，自动挂断" duration:2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        endType = @{@"endType":@"OV"};
//           [self staffAbandon];
           [self closeLiveChat];
    });
   
}

#pragma mark 获取摄像头麦克风权限失败挂断
-(void)authorFailClose{
//    [self staffAbandon];
    [self closeLiveChat];
}

//#pragma mark  客服弃号 （60s到时）
//-(void)staffAbandon{
//    [KFLiveChatRequest kfLiveChatAbandonExParam:self.resultDic[@"acceptInfo"] Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
//
//     }];
//}

- (UIView *)localVideoView{
    if (!_localVideoView) {
        _localVideoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_localVideoView];
        
    }
    return _localVideoView;
}
- (UIView *)remoteVideoView{
    if (!_remoteVideoView) {
        _remoteVideoView = [[UIView alloc] init];
        [self.view addSubview:_remoteVideoView];
        
    }
    return _remoteVideoView;
}
#pragma mark 启用视频模块，并将视频加入本地模块
- (void)setupLocalVideo {
    self.localVideoView.hidden = NO;
    //默认设置为主播模式
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
    
    
    [self.agoraKit enableVideo];
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    videoCanvas.view = self.localVideoView;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    // 设置本地视图。
    [self.agoraKit setupLocalVideo:videoCanvas];
    
    //加入频道
    NSString *token = [KFLiveChatParmas installParmas].chatToken;
    if ([SPKFUtilities isValidDictionary:_resultDic] &&
        [SPKFUtilities isValidDictionary:self.resultDic[@"acceptInfo"]] &&
        [SPKFUtilities isValidString:self.resultDic[@"acceptInfo"][@"roomNum"]]) {
        [self.agoraKit joinChannelByToken:token channelId:self.resultDic[@"acceptInfo"][@"roomNum"]/*[KFLiveChatParmas installParmas].channelId*/ info:nil uid:nil joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        }];
    }
    [self localViewUpdate];
}

#pragma mark 根据状态调整本地和远程视图
- (void)localViewUpdate{
    
    [_timer invalidate];
    _timer = nil;
    self.localVideoView.frame = CGRectMake(SCREEN_WIDTH-120, 50, 100, 150);
    self.remoteVideoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    //添加默认图
    UIImageView *remoteBgImgV = [self.view viewWithTag:20200508202501];
    UIImageView *localBgImgV = [self.view viewWithTag:20200508202502];
    if (!remoteBgImgV) {
        remoteBgImgV = [[UIImageView alloc] initWithFrame:self.remoteVideoView.frame];
        [self.view addSubview:remoteBgImgV];
        remoteBgImgV.tag = 20200508202501;
        remoteBgImgV.image = [UIImage bundleImageNamed:@"carmaClose"];
        [remoteBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(218);
            make.height.mas_equalTo(313);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo(self.view.mas_centerY);
        }];
        //提示文字
        bgViewsignLabel = [[UILabel alloc] init];
        bgViewsignLabel.text = @"等待用户接通中...";
        bgViewsignLabel.textAlignment = NSTextAlignmentCenter;
        bgViewsignLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:bgViewsignLabel];
        [bgViewsignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(remoteBgImgV.mas_bottom).offset(10);
        }];
    }
    if (!localBgImgV) {
        localBgImgV = [[UIImageView alloc] initWithFrame:self.localVideoView.frame];
        localBgImgV.backgroundColor = [UIColor whiteColor];
        localBgImgV.tag = 20200508202502;
        [self.view addSubview:localBgImgV];
        localBgImgV.contentMode = UIViewContentModeScaleAspectFit;
        localBgImgV.image = [UIImage bundleImageNamed:@"carmaClose"];
    }
    
    self.remoteVideoView.hidden = !_remoteIsOpencamera;
    
    self.localVideoView.hidden = !_isOpencamera;
    bgViewsignLabel.hidden = _remoteIsOpencamera;
    
    localBgImgV.hidden = _isOpencamera;
    remoteBgImgV.hidden = _remoteIsOpencamera;
    [self.view addSubview:_remoteVideoView];
    
    [self.view addSubview:localBgImgV];
    [self.view addSubview:_localVideoView];

    [self.view addSubview:_kfBottomView];
    [self.view addSubview:_platformView];
    [self.view addSubview:_scalBtn];
    //更改提示文字内容
    if (self.user_uid) {
        bgViewsignLabel.text = @"客户已关闭摄像头";
    }else{
        bgViewsignLabel.text = @"等待用户接通中...";
    }
    return;//以下为下版本预留功能
    ///////////////
    self.remoteVideoView.hidden = !_remoteIsOpencamera;
    self.localVideoView.hidden = !_isOpencamera;
    if (_remoteIsOpencamera && _isOpencamera) {//双方都开启摄像头
        //调整视图位置
        self.localVideoView.frame = CGRectMake(SCREEN_WIDTH-120, 50, 100, 150);
        self.remoteVideoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
    }else if (_isOpencamera && !_remoteIsOpencamera){//自己开启对方未开启
        self.localVideoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else if (!_isOpencamera && _remoteIsOpencamera){//自己未开启，对方开启
        self.remoteVideoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else{
        //都关闭，则都隐藏了
    }
    
    [self.view addSubview:_remoteVideoView];
    [self.view addSubview:_localVideoView];

    [self.view addSubview:_kfBottomView];
    [self.view addSubview:_platformView];
    [self.view addSubview:_scalBtn];
}
//缩小视图
- (void)smallVC{
    if (!bgView) {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgView.hidden = YES;
        bgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:bgView];
           UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigVC)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [bgView addGestureRecognizer:tap];
    }
    bgView.hidden = NO;
       
    
    [[KFLiveChatManager installManager] smallLiveChatView];
    self.kfBottomView.hidden = YES;
    self.platformView.hidden = YES;
    self.scalBtn.hidden = YES;
}
//放大视图
- (void)bigVC{
    bgView.hidden = YES;
    [[KFLiveChatManager installManager] bigLiveChatView];
    self.kfBottomView.hidden = NO;
    self.platformView.hidden = NO;
    self.scalBtn.hidden = NO;
    
}
//关闭对话
- (void)closeLiveChat{
    if ([KFLiveChatParmas installParmas].isOpenRecordForI) {
        if (_uploadFileBlock) {
            _uploadFileBlock(_filePath);
        }
    }
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (closeAlert) {
        [closeAlert dismissViewControllerAnimated:NO completion:nil];
        closeAlert = nil;
    }
    
    if(!_isJoined && !isShOrAutoClose){
        [KFLCHeartManager showToast:@"客户已挂断" duration:2];
    }
    
//    [KFLiveChatParmas installParmas].status = @"ONLINE";
    
     NSMutableDictionary *exParam = [NSMutableDictionary dictionaryWithCapacity:0];
     
     if ([SPKFUtilities isValidDictionary:self.resultDic] && [SPKFUtilities isValidDictionary:self.resultDic[@"acceptInfo"]]) {
         [exParam addEntriesFromDictionary:self.resultDic[@"acceptInfo"]];
     }
   
    if ([SPKFUtilities isValidDictionary:endType]) {
        [exParam addEntriesFromDictionary:endType];
    }
    __weak KFLiveChatBaseVC *weakSelf = self;
    [KFLiveChatRequest kfLiveChatCloseExParam:exParam Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {

        [self.agoraKit setupLocalVideo:nil];
                
        [self.agoraKit stopPreview];
        // 离开频道。
        [self.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
           
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [AgoraRtcEngineKit destroy];
            //                  [[KFLiveChatManager installManager] closeLiveChatView];
            
            UIViewController *vced = weakSelf;
            while (vced.presentedViewController != nil) {
                vced = vced.presentedViewController;
                [vced dismissViewControllerAnimated:NO completion:nil];
            }
            
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        
        });
    }];
}

-(void)showNormalAlert:(NSString *)des{
    LiveChatAlertVC *alert = [[LiveChatAlertVC alloc]init];
    alert.modalPresentationStyle = UIModalPresentationCustom;
    [alert showNormalAlertWithStr:des];
    [self presentViewController:alert animated:NO completion:nil];
    __weak KFLiveChatBaseVC *weakSelf = self;
    [alert setSureBlock:^(id  _Nonnull obj) {
//        [[KFLiveChatManager installManager] closeLiveChatView];
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)dealloc{
    
    
}

-(void)audioOrCameraAuthorFail:(NSString *)failMsg{
    LiveChatAlertVC *alert = [[LiveChatAlertVC alloc]init];
       alert.modalPresentationStyle = UIModalPresentationCustom;
       [alert showNormalAlertWithStr:failMsg];
       [self presentViewController:alert animated:NO completion:nil];
       
       [alert setSureBlock:^(id  _Nonnull obj) {
//           [self closeLiveChat];
           [self authorFailClose];//获取摄像头麦克风权限失败挂断  // 退出
       }];
    [alert setCancelBlock:^{
        [self authorFailClose];
    }];
}


- (NSString *)getAppID{
    
   
    
    return XWRTCAppID;
}





@end
#endif
