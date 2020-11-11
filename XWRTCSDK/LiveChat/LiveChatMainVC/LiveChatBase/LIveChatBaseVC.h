//
//  LIveChatBaseVC.h
//  ecmc
//
//  Created by XianHong zhang on 2020/3/26.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "BaseViewController.h"

#import "LiveChatMainBottomView.h"
#import "KFLiveChatBottomView.h"
#import "LiveChatAlertVC.h"
#import "LiveChatTimeBottomView.h"

#if TARGET_IPHONE_SIMULATOR//模拟器

#elif TARGET_OS_IPHONE//真机

#import <ReplayKit/ReplayKit.h>
#import <SpriteKit/SpriteKit.h>
// 自 3.0.0 版本，SDK 使用 AgoraRtcKit 类。

#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "Encryption.h"
#import "Settings.h"

@interface LIveChatBaseVC : BaseViewController<LiveChatMainBottomViewDelegate,AgoraRtcEngineDelegate>

@property (nonatomic, strong) Settings *settings;
@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;



//用户端底部通知栏
@property (nonatomic, strong) LiveChatMainBottomView *bottomView;
//用户端底部时间和广告
@property (nonatomic, strong) LiveChatTimeBottomView *adView;

//是否开启摄像头
@property (nonatomic, assign) BOOL isOpencamera;
//对方是否开启摄像头
@property (nonatomic, assign) BOOL remoteIsOpencamera;
//是否正在进行屏幕录制
@property (nonatomic, assign) BOOL isShareScreen;
//本地视频视图
@property (nonatomic, strong) UIView *localVideoView;
//远端视频视图
@property (nonatomic, strong) UIView *remoteVideoView;
//缩放按钮
@property (nonatomic, strong) UIButton *scalBtn;
//通话用户uid
@property (nonatomic,assign) NSInteger user_uid;

#pragma mark 根据状态调整本地和远程视图
- (void)localViewUpdate;

- (void)closeLiveChat;


#pragma mark 获取摄像头、录音权限失败
-(void)audioOrCameraAuthorFail:(NSString *)failMsg;



@end
#endif

