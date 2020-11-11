//
//  LiveChatAlertVC.h
//  ecmc
//
//  Created by XianHong zhang on 2020/3/24.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface LiveChatAlertVC : BaseViewController

@property (nonatomic, copy) void (^cancelBlock)();      //点击取消回调
@property (nonatomic, copy) void (^sureBlock)(id obj);  //点击确定回调
@property (nonatomic,copy) void  (^psdOverTimeBlock)(); //密码输入超时回调

@property (nonatomic, copy) void (^resetPWDBlock)();    //点击忘记密码回调
@property (nonatomic, copy) void (^signAgainBlock)();   //点击重新签名回调
@property (nonatomic ,strong) UILabel *contentLabel;    //页面显示的信息,用于动态修改

#pragma mark 普通提示弹框 只有确定按钮
- (void)showNormalAlertWithStr:(NSString *)str;
#pragma mark 电话接通页面
- (void)showDDJTAlertWithStr:(NSString *)str;
#pragma mark 个性签名
- (void)lineSignNameAlert;
#pragma mark 输入服务密码弹框
-(void)showServicePsdEnterAlert;
#pragma mark 副号服务密码输入弹框
-(void)showSubMobilePsdEnterAlertWithMobile:(NSString *)mobile;
#pragma mark 忘记服务密码
-(void)forgetServicePsd;
#pragma mark  签名回显弹框
-(void)showBackSignNameAlert:(UIImage *)image;
#pragma mark  统一按钮弹框
/// @param des 提示信息
/// @param sureBtnTitle  确定按钮文字
/// @param cancelBtnTitle 取消按钮文字
-(void)alertSingleBtnWithDes:(NSString *)des sureBtn:(NSString *)sureBtnTitle cancelBtn:(NSString *)cancelBtnTitle;

@end

NS_ASSUME_NONNULL_END
