//
//  KFLiveChatBaseVC+RtcDelegate.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/7.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "KFLiveChatBaseVC+RtcDelegate.h"
#if TARGET_IPHONE_SIMULATOR//模拟器

#elif TARGET_OS_IPHONE//真机

#import "KFLCHeartManager.h"

#import "LiveChatManager.h"
#import "KFLCHeartManager.h"
#import "KFLiveChatParmas.h"
@implementation KFLiveChatBaseVC (RtcDelegate)


- (void)categoryLoad{
    
}

// 监听 firstRemoteVideoDecodedOfUid 回调。
// SDK 接收到第一帧远端视频并成功解码时，会触发该回调。
// 可以在该回调中调用 setupRemoteVideo 方法设置远端视图。
#pragma mark AgoraRtcEngineKitDelegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size: (CGSize)size elapsed:(NSInteger)elapsed {
    if (self.user_uid <= 0) {
        self.user_uid = uid;
        if ([KFLiveChatParmas installParmas].isOpenRecordForI) {
            self.filePath = [[VoiceFilemanger install] getSaveVoiceFilePaht:self.resultDic[@"userInfo"][@"userNum"]];
            [self.agoraKit startAudioRecording:[[VoiceFilemanger install] getSaveVoiceFilePaht:self.resultDic[@"userInfo"][@"userNum"]] quality:AgoraAudioRecordingQualityMedium];
        }
        
        
    }
    if (self.remoteVideoView.hidden) {
        self.remoteVideoView.hidden = NO;
    }
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    videoCanvas.view = self.remoteVideoView;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    // 设置远端视图。
    [self.agoraKit setupRemoteVideo:videoCanvas];
    //对方开启摄像头
    self.remoteIsOpencamera = YES;
    [self localViewUpdate];
}
#pragma mark //进入频道失败
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode{
    if (errorCode == AgoraErrorCodeNoPermission) {
        //没有操作权限，检查音视频设备权限
        [self audioOrCameraAuthorFail:@"该功能需要相机和录音权限，请设置"];
    }else if(errorCode == AgoraErrorCodeAdmNoPermission){
        //拒绝录音权限
         [self audioOrCameraAuthorFail:@"该功能需要相机和录音权限，请设置"];
    }
    else if (errorCode == AgoraErrorCodeVdmCameraNotAuthorized){
        //没有摄像头权限
         [self audioOrCameraAuthorFail:@"该功能需要相机和录音权限，请设置"];
    }else{
        [self closeLiveChat];
    }
}
#pragma mark //加入指定频道成功
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed{
    
}
#pragma mark //重新加入频道回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didRejoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed{
    
}
#pragma mark //通信场景下，该回调提示有远端用户加入了频道，并返回新加入用户的 ID；如果加入之前，已经有其他用户在频道中了，新加入的用户也会收到这些已有用户加入频道的回调。
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed{
    self.isJoined = YES;
}
#pragma mark //当用户调用 leaveChannel 离开频道后，SDK 会触发该回调。在该回调方法中，App 可以得到此次通话的总通话时长、SDK 收发数据的流量等信息。
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didLeaveChannelWithStats:(AgoraChannelStats *)stats{
    
}
#pragma mark //远端用户（通信场景）/主播（直播场景）离开当前频道回调
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason{
    if (uid == self.user_uid) {
        [KFLCHeartManager showToast:@"用户已挂断视频服务" duration:2];
        [self closeLiveChat];
        self.user_uid = 0;
    }
    

}
#pragma mark //网络连接状态已改变回调
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine connectionChangedToState:(AgoraConnectionStateType)state reason:(AgoraConnectionChangedReason)reason{
    
}
#pragma mark //本地网络类型发生改变回调
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine networkTypeChangedToType:(AgoraNetworkType)type{
    
}
#pragma mark //网络连接中断，且 SDK 无法在 10 秒内连接服务器回调
- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *_Nonnull)engine{
    
}
#pragma mark //Token 服务即将过期回调
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine tokenPrivilegeWillExpire:(NSString *_Nonnull)token{
    
}
#pragma mark //Token 过期回调
- (void)rtcEngineRequestToken:(AgoraRtcEngineKit *_Nonnull)engine{
    
}
#pragma mark 远端音频流状态发生改变回调
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine remoteAudioStateChangedOfUid:(NSUInteger)uid state:(AgoraAudioRemoteState)state reason:(AgoraAudioRemoteStateReason)reason elapsed:(NSInteger)elapsed{
    
}
#pragma mark 远端用户暂停/重新发送视频回调
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid{
    if (!muted){
        AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        videoCanvas.uid = uid;
        videoCanvas.view = self.remoteVideoView;
        videoCanvas.renderMode = AgoraVideoRenderModeHidden;
        // 设置远端视图。
        [self.agoraKit setupRemoteVideo:videoCanvas];
        //对方开启摄像头
        self.remoteIsOpencamera = YES;
        [self localViewUpdate];
    }
}
#pragma mark 其他用户启用/关闭本地视频的回调
//对方关闭、打开摄像头走此回调
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine didLocalVideoEnabled:(BOOL)enabled byUid:(NSUInteger)uid{
 
    
}
#pragma mark 远端视频状态发生改变回调。
//对方关闭、打开摄像头，退出都会走此回调
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine remoteVideoStateChangedOfUid:(NSUInteger)uid state:(AgoraVideoRemoteState)state reason:(AgoraVideoRemoteStateReason)reason elapsed:(NSInteger)elapsed{
    if (uid != self.user_uid) {
        //不是视频通话的，不做任何操作
        return;
    }
    //对方关闭摄像头，或者退出
    if (state == AgoraVideoRemoteStateStopped) {
        if (self.remoteIsOpencamera != NO) {
            self.remoteIsOpencamera = NO;
            [self localViewUpdate];
        }
        
    }else if (state == AgoraVideoRemoteStateStarting){
        
    }else if (state == AgoraVideoRemoteStateDecoding){//对方开启摄像头
        if (self.remoteIsOpencamera != YES) {
            self.remoteIsOpencamera = YES;
            [self localViewUpdate];
        }
    }
}
#pragma mark API 方法已执行回调
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine didApiCallExecute:(NSInteger)error api:(NSString *_Nonnull)api result:(NSString *_Nonnull)result{
    
}

@end
#endif
