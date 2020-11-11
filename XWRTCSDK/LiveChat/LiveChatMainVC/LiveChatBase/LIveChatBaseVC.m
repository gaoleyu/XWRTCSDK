//
//  LIveChatBaseVC.m
//  ecmc
//
//  Created by XianHong zhang on 2020/3/26.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "LIveChatBaseVC.h"
#if TARGET_IPHONE_SIMULATOR//模拟器

#elif TARGET_OS_IPHONE//真机


#import "LIveChatBaseVC+RtcDelegate.h"
#import "LiveChatManager.h"
#import "LiveChatAlertVC.h"
#import "LiveChatParmas.h"
#import "KFLCHeartManager.h"
#import "SPKFUtilities.h"
@interface LIveChatBaseVC ()

{
//正在录屏提示
   UILabel *screenLabel;
}

@end

@implementation LIveChatBaseVC




- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self isScreenAndIsStopScreen:YES];
    
    _isOpencamera = YES;
    
    [self categoryLoad];
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:[self getAppID] delegate:self];
    
    // 将日志输出等级设置为 AgoraLogFilterDebug
    [self.agoraKit setLogFilter: AgoraLogFilterDebug];

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
    
    //底部按钮视图
    _bottomView = [[LiveChatMainBottomView alloc] initWithFrame:CGRectZero];
    _bottomView.delegate = self;
    _bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bottomView];
    int bottomViewbottomheight = 0;
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            bottomViewbottomheight = 30;
        }
    }
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(340);
        make.width.mas_equalTo(57);
        make.bottom.mas_equalTo(-70-bottomViewbottomheight);
    }];
   //底部广告视图
    CGFloat adViewY = kScreen_Height-30;
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            
            adViewY = kScreen_Height-50;
        }
    }
    _adView = [[LiveChatTimeBottomView alloc] initWithFrame:CGRectMake(0, adViewY, kScreen_Width, 120)];
    [self.view addSubview:_adView];
    _adView.backgroundColor = [UIColor whiteColor];
    
    //缩放按钮
    _scalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_scalBtn];
    [_scalBtn setImage:[UIImage bundleImageNamed:@"suofang"] forState:UIControlStateNormal];
    _scalBtn.frame = CGRectMake(10, 45, 40, 40);
    [_scalBtn addTarget:[LiveChatManager installManager] action:@selector(smallLiveChatView) forControlEvents:UIControlEventTouchUpInside];
    //录屏时提示文字
    screenLabel = [[UILabel alloc] init];
    [self.view addSubview:screenLabel];
    [screenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
    
    screenLabel.textAlignment = NSTextAlignmentCenter;
    screenLabel.text = @"正在录制屏幕";
    screenLabel.font = [UIFont systemFontOfSize:30];
    screenLabel.hidden = YES;
    _bottomView.hidden = NO;
    
    //增加监听->监听截图事件
    if (@available(iOS 11.0, *)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSceenShot:) name:UIScreenCapturedDidChangeNotification object:nil];
        
    } else {
        // Fallback on earlier versions
    }
 
}
#pragma mark 是否是正在录制屏幕 决定是否停止
- (BOOL)isScreenAndIsStopScreen:(BOOL)isStop{
    
    //监测当前设备是否处于录屏状态
    UIScreen * sc = [UIScreen mainScreen];
    if (@available(iOS 11.0, *)) {
        if (sc.isCaptured) {
            NSLog(@"正在录制~~~~~~~~~%d",sc.isCaptured);
            if (isStop) {
                
            }
            return YES;
        }
    } else {
        // Fallback on earlier versions
    }
    return NO;
}
//当用户截屏了 怎么办 目前来说 只能进行提示。
-(void)handleSceenShot:(NSNotification *)noti {
    
    //监测当前设备是否处于录屏状态
    UIScreen * sc = [UIScreen mainScreen];
    if (@available(iOS 11.0, *)) {
        if (sc.isCaptured) {
            //正在录制
            
            [self screenStatusChangeWithStatus:1];
        }else{
            //结束录制
            [self screenStatusChangeWithStatus:0];
        }
    } else {
        // Fallback on earlier versions
    }
}
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
    NSString *channelId = [LiveChatParmas installParmas].roomNum;
    
//    channelId = @"111";
    NSString *token = [LiveChatParmas installParmas].sdktoken;
    
    #pragma mark 存储当前的房间号和token，供屏幕共享使用
    
    #ifdef  Enterprise
    NSUserDefaults*userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.jsmcc.ZP7267A6E"];
    #else
       
    NSUserDefaults* userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.jsmcc.ZP7267A6ES"];
    #endif
    
    [userDefault setObject:channelId forKey:@"screensharechannelId"];
    if ([SPKFUtilities isValidString:token]) {
        [userDefault setObject:token forKey:@"screensharetoken"];
    }
    NSString *appid = [self getAppID];
    if ([SPKFUtilities isValidString:appid]) {
        [userDefault setObject:appid forKey:@"screenshareappid"];
    }
    
   
    
    
    [self.agoraKit joinChannelByToken:token channelId:channelId info:nil uid:nil joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        
    }];
    
}

#pragma mark 根据状态调整本地和远程视图
- (void)localViewUpdate{
    self.localVideoView.frame = CGRectMake(SCREEN_WIDTH-126, 50, 106, 139);
    self.remoteVideoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //添加默认图
    UIImageView *remoteBgImgV = [self.view viewWithTag:20200508202501];
    UIImageView *localBgImgV = [self.view viewWithTag:20200508202502];
    if (!remoteBgImgV) {
        remoteBgImgV = [[UIImageView alloc] initWithFrame:self.remoteVideoView.frame];
        [self.view addSubview:remoteBgImgV];
        remoteBgImgV.image = [UIImage bundleImageNamed:@"carmaClose"];
        remoteBgImgV.tag = 20200508202501;
        [remoteBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(218);
            make.height.mas_equalTo(313);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo(self.view.mas_centerY);
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
    localBgImgV.hidden = _isOpencamera;
    remoteBgImgV.hidden = _remoteIsOpencamera;
    [self.view addSubview:_remoteVideoView];
    [self.view addSubview:localBgImgV];
    [self.view addSubview:_localVideoView];
    [self.view addSubview:_bottomView];
    [self.view addSubview:_adView];
    [self.view addSubview:_scalBtn];
    
    return;//以下为下版本预留功能
    if (_isShareScreen) {
        self.remoteVideoView.hidden = YES;
        self.localVideoView.hidden = YES;
        screenLabel.hidden = NO;
        return;
    }
    screenLabel.hidden = YES;
    self.remoteVideoView.hidden = !_remoteIsOpencamera;
    self.localVideoView.hidden = !_isOpencamera;
    if (_remoteIsOpencamera && _isOpencamera) {//双方都开启摄像头
        //调整视图位置
        self.localVideoView.frame = CGRectMake(SCREEN_WIDTH-126, 50, 106, 139);
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
    [self.view addSubview:_bottomView];
    [self.view addSubview:_adView];
    [self.view addSubview:_scalBtn];
}

#pragma mark LiveChatMainBottomViewDelegate
- (void)screenStatusChangeWithStatus:(int)status{
   
    if (status == 1) {

    
        _bottomView.screenBtn.selected = YES;
        _bottomView.scLabel.text = @"关闭分享";
        _isShareScreen = YES;
        [[LiveChatManager installManager] smallLiveChatView];
        [self.agoraKit muteLocalVideoStream:YES];
        [self.agoraKit enableLocalVideo:NO];
        //断掉远端视频流
        [self.agoraKit muteAllRemoteVideoStreams:YES];
        [self localViewUpdate];
        
    }else{
        _bottomView.screenBtn.selected = NO;
        _bottomView.scLabel.text = @"屏幕共享";
        _isShareScreen = NO;
        _remoteIsOpencamera = YES;
        if (_isOpencamera) {//如果本地摄像头之前是打开的，则开启本地流
            //关闭投屏，打开摄像头摄像头
            [self.agoraKit muteLocalVideoStream:NO];
            [self.agoraKit enableLocalVideo:YES];
            
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //接受远端视频流
            [self.agoraKit muteAllRemoteVideoStreams:NO];
            if (!_isOpencamera){
                //开启摄像头
                [self voiceStatusChangeWithStatus:0];
            }
            
            [self localViewUpdate];
            
        });
        
    }
}
- (void)voiceStatusChangeWithStatus:(int)status{
    if (_isShareScreen) {
        _bottomView.voiceBtn.selected = YES;
        _bottomView.voLabel.text = @"开启相机";
        [KFLCHeartManager showToast:@"屏幕共享期间无法开启摄像头" duration:2];
        return;
    }
    if (status == 1) {
        _isOpencamera = NO;
        self.bottomView.voiceBtn.selected = YES;
        _bottomView.voLabel.text = @"开启相机";
        
        [self.agoraKit muteLocalVideoStream:YES];
        [self.agoraKit enableLocalVideo:NO];
        //停止接受远端视频流
       // [self.agoraKit muteAllRemoteVideoStreams:YES];
    }else{
        _isOpencamera = YES;
        self.bottomView.voiceBtn.selected = NO;
        _bottomView.voLabel.text = @"关闭相机";
        
        [self.agoraKit muteLocalVideoStream:NO];
        [self.agoraKit enableLocalVideo:YES];
        //接受远端视频流
        //[self.agoraKit muteAllRemoteVideoStreams:NO];
    }
    [self localViewUpdate];
}
- (void)cameraStatusChangeWithStatus:(int)status{
    if (_isShareScreen) {
        _bottomView.cameraBtn.selected = NO;
        [KFLCHeartManager showToast:@"屏幕共享期间无法切换摄像头" duration:2];
        return;
    }
    //切换摄像头
    [self.agoraKit switchCamera];
}

- (void)closeLiveChat{
#pragma mark 发送通知，退出屏幕共享
    if (self.isShareScreen) {
        CFNotificationCenterRef notification = CFNotificationCenterGetDarwinNotifyCenter ();
        CFNotificationCenterPostNotification(notification, CFSTR("screensharesexit"), NULL,NULL, YES);
    }
    
    [self isScreenAndIsStopScreen:YES];
    // 离开频道。
    [self.agoraKit setupLocalVideo:nil];
   
    [self.agoraKit stopPreview];
    
    [self.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
     
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [AgoraRtcEngineKit destroy];
        [[LiveChatManager installManager] closeLiveChatView];
    });
    
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
           [self closeLiveChat];
       }];
}

- (NSString *)getAppID{
    
//    NSArray *dbArray = [[HomeDatabaseManager getDatabaseManager] getSettingData];
//    NSString *str = @"SPKFAPPID";
//    __block NSString *APPID = @"";
//    if([SPKFUtilities isValidArray:dbArray] && [SPKFUtilities isValidString:str]) {
//        [dbArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//            if ([SPKFUtilities isValidDictionary:obj]) {
//                if ([[obj objectForKey:@"name"] isEqualToString:str]) {
//                    APPID = [NSString stringWithFormat:@"%@", [obj objectForKey:@"showContent"]];
//
//                    *stop = YES;
//                }
//            }
//        }];
//    }
    
    return XWRTCAppID;
}

@end
#endif
