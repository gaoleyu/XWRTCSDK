//
//  LiveChatMainBottomView.h
//  ecmc
//
//  Created by XianHong zhang on 2020/3/25.
//  Copyright © 2020 cp9. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@protocol LiveChatMainBottomViewDelegate <NSObject>
/**
 * 投屏状态改变
 * 0 关闭
 * 1 打开
 */
- (void)screenStatusChangeWithStatus:(int)status;
/**
 * 语音状态改变
 * 0 关闭
 * 1 打开
 */
- (void)voiceStatusChangeWithStatus:(int)status;
/**
 * 摄像头状态改变
 * 0 前置
 * 1 后置
 */
- (void)cameraStatusChangeWithStatus:(int)status;
/**挂断按钮*/
- (void)closeLiveChat;

@end



@interface LiveChatMainBottomView : UIView

@property (nonatomic, weak) id<LiveChatMainBottomViewDelegate> delegate;

@property (nonatomic, strong) UIButton *screenBtn;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *voLabel;
@property (nonatomic, strong) UILabel *scLabel;

@end


