//
//  LiveChatMainBottomView.m
//  ecmc
//
//  Created by XianHong zhang on 2020/3/25.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "LiveChatMainBottomView.h"
#import <ReplayKit/ReplayKit.h>
#import "LiveChatAlertVC.h"
#import "LiveChatManager.h"
#import "SPKFUtilities.h"
@implementation LiveChatMainBottomView
{
    //ios12 系统屏幕录制
    API_AVAILABLE(ios(12.0))
    RPSystemBroadcastPickerView* pick;
    
    
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews{
    [self startScreen];
    //投屏按钮
    _screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_screenBtn addTarget:self action:@selector(screenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_screenBtn];
    //语音按钮
    _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voiceBtn addTarget:self action:@selector(voiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _voiceBtn.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_voiceBtn];
  
  
    [_voiceBtn setImage:[UIImage bundleImageNamed:@""] forState:UIControlStateNormal];
    [_voiceBtn setImage:[UIImage bundleImageNamed:@""] forState:UIControlStateSelected];
  
    
    //切换摄像头按钮
    _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_cameraBtn];
    [_cameraBtn addTarget:self action:@selector(cameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _cameraBtn.backgroundColor = _voiceBtn.backgroundColor;
   
    
    //挂断按钮
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_backBtn];
    [_backBtn addTarget:self action:@selector(closeLiveChatBtn:) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.backgroundColor = _voiceBtn.backgroundColor;
    UILabel *closeLabel = [[UILabel alloc] init];
    closeLabel.textAlignment = NSTextAlignmentCenter;
    closeLabel.textColor = [UIColor whiteColor];
    closeLabel.text = @"挂断";
    closeLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:closeLabel];
    [_screenBtn setImage:[UIImage bundleImageNamed:@"shareScreenlogo"] forState:UIControlStateNormal];
    [_screenBtn setImage:[UIImage bundleImageNamed:@"sccloseshare"] forState:UIControlStateSelected];
    
    [_voiceBtn setImage:[UIImage bundleImageNamed:@"shipin"] forState:UIControlStateNormal];
    [_voiceBtn setImage:[UIImage bundleImageNamed:@"scopencam"] forState:UIControlStateSelected];
 
    [_cameraBtn setImage:[UIImage bundleImageNamed:@"xiangji"] forState:UIControlStateNormal];
    [_cameraBtn setImage:[UIImage bundleImageNamed:@"xiangji"] forState:UIControlStateSelected];
    [_backBtn setImage:[UIImage bundleImageNamed:@"livechatclose"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage bundleImageNamed:@"livechatclose"] forState:UIControlStateSelected];
    
    
   
    [_cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.width.height.mas_equalTo(57);
    }];
    float scbtnWD = 57;
    float scoffset = 20;
    [LiveChatManager installManager].isShowShare = NO;
    if (![LiveChatManager installManager].isShowShare) {
        scbtnWD = 0;
        scoffset = 0;
    }
    [_screenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cameraBtn.mas_bottom).offset(scoffset);
        make.left.right.mas_equalTo(0);
        make.width.height.mas_equalTo(scbtnWD);
    }];
    [_voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_screenBtn.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.width.height.mas_equalTo(_screenBtn.mas_width);
    }];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_voiceBtn.mas_bottom).offset(40);
        make.left.right.mas_equalTo(0);
        make.width.height.mas_equalTo(_voiceBtn.mas_width);
    }];
   
    _scLabel = [[UILabel alloc] init];
    _scLabel.textColor = [UIColor whiteColor];
    _scLabel.text = @"分享屏幕";
    _scLabel.textAlignment = NSTextAlignmentCenter;
    _scLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_scLabel];
    
    _scLabel.hidden = ![LiveChatManager installManager].isShowShare;
    [_scLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_screenBtn.mas_bottom);
        make.left.right.mas_equalTo(0);
    }];
    UILabel *caLabel = [[UILabel alloc] init];
    caLabel.textColor = [UIColor whiteColor];
    caLabel.font = [UIFont systemFontOfSize:12];
    caLabel.text = @"切换相机";
    caLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:caLabel];
    [caLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cameraBtn.mas_bottom);
        make.left.right.mas_equalTo(0);
    }];
    
    _voLabel = [[UILabel alloc] init];
    _voLabel.textColor = [UIColor whiteColor];
    _voLabel.font = [UIFont systemFontOfSize:12];
    _voLabel.text = @"关闭相机";
    _voLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_voLabel];
    [_voLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_voiceBtn.mas_bottom);
        make.left.right.mas_equalTo(0);
    }];
    
}
- (void)screenBtnAction:(UIButton *)btn{
//    btn.selected = !btn.selected;
//    if (_delegate && [_delegate respondsToSelector:@selector(screenStatusChangeWithStatus:)]) {
//        [_delegate screenStatusChangeWithStatus:btn.selected];
//        [self startScreen];
//    }
    if (@available(iOS 13.0, *)) {
    }else{
        LiveChatAlertVC *alertVC = [[LiveChatAlertVC alloc] init];
        
        alertVC.modalPresentationStyle = UIModalPresentationCustom;
        [alertVC showNormalAlertWithStr:@"您当前系统版本过低，无法使用该功能！"];
        [[self zyViewController] presentViewController:alertVC animated:NO completion:nil];
        return;
    }
    if (btn.selected == YES) {
        [self startScreen];
        return;
    }
    LiveChatAlertVC *alert = [[LiveChatAlertVC alloc] init];
    alert.modalPresentationStyle = UIModalPresentationCustom;
    [alert alertSingleBtnWithDes:@"确认要开启屏幕共享吗？" sureBtn:@"开启" cancelBtn:@"取消"];
    [[self zyViewController] presentViewController:alert animated:NO completion:nil];
    __weak LiveChatMainBottomView *weakSelf = self;
    [alert setSureBlock:^(id  _Nonnull obj) {
        [weakSelf startScreen];
        
    }];
    
}

- (void)voiceBtnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(voiceStatusChangeWithStatus:)]) {
        [_delegate voiceStatusChangeWithStatus:btn.selected];
    }
}
- (void)cameraBtnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(cameraStatusChangeWithStatus:)]) {
        [_delegate cameraStatusChangeWithStatus:btn.selected];
    }
}
- (void)closeLiveChatBtn:(UIButton *)btn{
    LiveChatAlertVC *alertVC = [[LiveChatAlertVC alloc] init];
    
    alertVC.modalPresentationStyle = UIModalPresentationCustom;
    [alertVC alertSingleBtnWithDes:@"是否确认结束当前视频服务？" sureBtn:@"确定挂断" cancelBtn:@"取消关闭"];
    [[self zyViewController] presentViewController:alertVC animated:NO completion:nil];
    __weak LiveChatMainBottomView *weakSelf = self;
    [alertVC setSureBlock:^(id  _Nonnull obj) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(closeLiveChat)]) {
            [weakSelf.delegate closeLiveChat];
       }
        
    }];

}
#pragma mark 开始投屏
- (void)startScreen{
   
    if (@available(iOS 13.0, *)) {
        if (!_voiceBtn.selected) {
            //关闭本地视频流
            [self voiceBtnAction:_voiceBtn];
        }
        if (!pick) {
            
            pick = [[RPSystemBroadcastPickerView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-140, 0, 0, 0)];
            [self addSubview:pick];
            
            #ifdef  Enterprise
                pick.preferredExtension = @"com.jsmcc.ZP7267A6E.ecmcScreenShare";
            #else
               pick.preferredExtension = @"com.jsmcc.ZP7267A6ES.ecmcScreenShare";
            #endif
            
            pick.showsMicrophoneButton = NO;
            //        [[RPScreenRecorder sharedRecorder] setMicrophoneEnabled:NO];
            //        [[RPScreenRecorder sharedRecorder] setCameraEnabled:YES];
            //        [self.view addSubview:pick];
//            pick.backgroundColor = [UIColor redColor];
         
            UIButton* actionButton;
            for (UIView *item in pick.subviews) {
                if ([item isKindOfClass:UIButton.class] == YES) {
                    actionButton = (UIButton*)item;
                    [actionButton setImage:[UIImage bundleImageNamed:@""] forState:UIControlStateNormal];
                    break;
                }
            }
        }else{
          UIButton* actionButton;
          for (UIView *item in pick.subviews) {
              if ([item isKindOfClass:UIButton.class] == YES) {
                  actionButton = (UIButton*)item;
                  break;
              }
          }
//            dispatch_async(dispatch_get_main_queue(), ^{
            [actionButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [actionButton sendActionsForControlEvents:UIControlEventTouchDown];
//            });
        }
   
        
    } else {
        LiveChatAlertVC *alertVC = [[LiveChatAlertVC alloc] init];
        
        alertVC.modalPresentationStyle = UIModalPresentationCustom;
        [alertVC showNormalAlertWithStr:@"抱歉，当前系统暂不支持此功能"];
        [[self zyViewController] presentViewController:alertVC animated:NO completion:nil];
        
    }
}
/**获取主控制器*/
- (UIViewController *)zyViewController{
    UIResponder *next = self.nextResponder;
    do{
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }while (next!=nil);
    return nil;
}

@end
