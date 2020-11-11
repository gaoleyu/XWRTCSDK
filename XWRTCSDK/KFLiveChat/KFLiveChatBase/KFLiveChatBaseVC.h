//
//  KFLiveChatBaseVC.h
//  ecmc
//
//  Created by XianHong zhang on 2020/4/7.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFLiveChatBottomView.h"
#import "LiveChatAlertVC.h"
#import "KFWorkPlatformView.h"

#if TARGET_IPHONE_SIMULATOR//模拟器

@interface KFLiveChatBaseVC : UIViewController



@end

#elif TARGET_OS_IPHONE//真机
#import <ReplayKit/ReplayKit.h>
#import <SpriteKit/SpriteKit.h>

#import "Encryption.h"
#import "Settings.h"

 // 自 3.0.0 版本，SDK 使用 AgoraRtcKit 类。
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "VoiceFilemanger.h"
@interface KFLiveChatBaseVC : BaseViewController<AgoraRtcEngineDelegate>
//自动上传回调
@property (nonatomic, copy) void (^uploadFileBlock)(NSString *path);
@property (nonatomic, strong) NSString *filePath;
//客服端底部通知栏
@property (nonatomic, strong) KFLiveChatBottomView *kfBottomView;


@property (nonatomic, strong) Settings *settings;
@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;


//工作台
@property (nonatomic, strong) KFWorkPlatformView *platformView;
//是否开启摄像头
@property (nonatomic, assign) BOOL isOpencamera;
//对方是否开启摄像头
@property (nonatomic, assign) BOOL remoteIsOpencamera;

//本地视频视图
@property (nonatomic, strong) UIView *localVideoView;
//远端视频视图
@property (nonatomic, strong) UIView *remoteVideoView;
//缩放按钮
@property (nonatomic, strong) UIButton *scalBtn;

@property(nonatomic,strong)NSDictionary *resultDic; //叫号成功的信息
@property(nonatomic,assign) BOOL isJoined;   //对方是否加入
//通话用户uid
@property (nonatomic,assign) NSInteger user_uid;

#pragma mark 根据状态调整本地和远程视图
- (void)localViewUpdate;
- (void)closeLiveChat;

#pragma mark 获取摄像头、录音权限失败
-(void)audioOrCameraAuthorFail:(NSString *)failMsg;
@end


#endif
