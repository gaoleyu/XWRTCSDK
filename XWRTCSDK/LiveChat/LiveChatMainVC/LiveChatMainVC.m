//
//  LiveChatMainVC.m
//  ecmc
//
//  Created by XianHong zhang on 2020/3/25.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "LiveChatMainVC.h"
#import "KFLCHeartManager.h"
#if TARGET_IPHONE_SIMULATOR//模拟器
@interface LiveChatMainVC ()
{
    //流水号
    NSString *rctId;
}
@end

@implementation LiveChatMainVC

@end
#elif TARGET_OS_IPHONE//真机


#import "LCHeartManager.h"
#import "LCRestPWDVC.h"
#import "LiveChatAlertVC.h"
#import "LiveChatRequest.h"
#import "KFLCHeartManager.h"
#import "LiveChatManager.h"
#import "SPKFWebVC.h"
#import "SPKFUtilities.h"
#import "LiveChatParmas.h"
@interface LiveChatMainVC ()<LCheartManagerDelegate>
{
    //流水号
    NSString *rctId;
}
@end

@implementation LiveChatMainVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [LCHeartManager installManager].delegate = self;
    [[LCHeartManager installManager] startTimer];
    self.adView.kfid = [LiveChatParmas installParmas].staffNum;
   
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([LiveChatParmas installParmas].isOpenRecordForI) {
        [KFLCHeartManager showToast:@"为保证服务质量，本次服务将进行录音" duration:3];
    }
    
}
/****************************************************************************************
                       分割线 以下为用户端端逻辑
**************************************************************************************************/
#pragma mark LCHeartMangerDelegate
- (void)timerActionDelete{
    
    [self.adView updateTimeLabelText];
    
}
- (void)requeSuccessWithDataDic:(NSDictionary *)dic{
    if ([SPKFUtilities isValidDictionary:dic]) {
        NSDictionary *dataDic = dic[@"result"];
        if ([SPKFUtilities isValidDictionary:dataDic]) {
            //处理心跳状态
            [KFLCHeartManager liveHeartDataType:dataDic controller:self];
            NSDictionary *userDic = dataDic[@"forUser"];
            if ([SPKFUtilities isValidDictionary:userDic]) {
                if ([SPKFUtilities isValidString:userDic[@"staffNum"]]) {
                    [LiveChatParmas installParmas].staffNum = userDic[@"staffNum"];
                }
                if ([SPKFUtilities isValidString:userDic[@"recId"]] &&
                    [SPKFUtilities isValidString:userDic[@"notifyType"]] &&
                    [SPKFUtilities isValidString:userDic[@"isSmsVertify"]] &&
                    [userDic[@"notifyType"] isEqualToString:@"VALIDSMS"] &&
                    [userDic[@"isSmsVertify"] isEqualToString:@"1"]) {
                    rctId = userDic[@"recId"];
                }
                
            }
        }
    }
}


#pragma mark 数字签名 新的h5含电子协议和签名控件
-(void)signwebLoad:(NSString *)urlString{
    if (![SPKFUtilities isValidString:urlString] && ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"])) {
        return;
    }
    
    SPKFWebVC *vc = [[SPKFWebVC alloc]init];
    vc.spkfUrlString = urlString;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:nav animated:NO completion:nil];
}

#pragma mark show Alert

/**
 * 0是服务密码
 * 1是签名
 * 2副号密码验证
 */
- (void)showAlertWithType:(NSString *)type str:(NSString *)str{
    [[LiveChatManager installManager] bigLiveChatView];
    
    LiveChatAlertVC *alert = [[LiveChatAlertVC alloc] init];
    alert.modalPresentationStyle = UIModalPresentationCustom;
    if ([type isEqualToString:@"0"]) {
        [alert showServicePsdEnterAlert];
    }else if ([type isEqualToString:@"1"]){
        [alert lineSignNameAlert];
    }else if ([type isEqualToString:@"2"]){
        
        [alert showSubMobilePsdEnterAlertWithMobile:str];
    } else{
        [alert showNormalAlertWithStr:str];
    }
    [self presentViewController:alert animated:NO completion:nil];
    if ([type isEqualToString:@"0"] || [type isEqualToString:@"1"] || [type isEqualToString:@"2"]) {
        __weak LiveChatMainVC *weakSelf = self;
        __weak LiveChatAlertVC *weakAlert = alert;
        [alert setSureBlock:^(id  _Nonnull obj) {
            if ([SPKFUtilities isValidString:obj]) {
                [LiveChatRequest liveChatValidPWDWithPwd:obj mobile:@"" recId:rctId Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
                    if (isSuccess) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kf_service_psd_cutdown_invalidate" object:nil];//关闭倒计时的 NSTimer
                        [weakAlert dismissViewControllerAnimated:NO completion:nil];
//                        [weakSelf showAlertWithType:nil str:message];
                        [KFLCHeartManager showToast:message duration:2];
                    }else{
                        NSString *errorCode = response[@"errorCode"];
                        if ([SPKFUtilities isValidString:errorCode] && [errorCode isEqualToString:@"-2302"]) {//-2302->密码错误输入三次锁定解锁
                            [weakAlert dismissViewControllerAnimated:NO completion:nil];
                            [weakSelf unlockPsd:message];
                        }else{
                            
                            [KFLCHeartManager showToast:message duration:2];
//                            [weakSelf showAlertWithType:nil str:message];
//                            [self inputPsdAgainAlertDes:message];
                        }
                    }
                }];
            }else if ([SPKFUtilities isValidDictionary:obj]){//副号密码验证
                
                [LiveChatRequest liveChatValidPWDWithPwd:obj[@"pwd"] mobile:obj[@"mobile"] recId:rctId Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
                                    if (isSuccess) {
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kf_service_psd_cutdown_invalidate" object:nil];//关闭倒计时的 NSTimer
                                        [weakAlert dismissViewControllerAnimated:NO completion:nil];
                //                        [weakSelf showAlertWithType:nil str:message];
                                        [KFLCHeartManager showToast:message duration:2];
                                    }else{
                                        NSString *errorCode = response[@"errorCode"];
                                        if ([SPKFUtilities isValidString:errorCode] && [errorCode isEqualToString:@"-2302"]) {//-2302->密码错误输入三次锁定解锁
                                            [weakAlert dismissViewControllerAnimated:NO completion:nil];
                                            [weakSelf unlockPsd:message];
                                        }else{
                                            
                                            [KFLCHeartManager showToast:message duration:2];
                //                            [weakSelf showAlertWithType:nil str:message];
                //                            [self inputPsdAgainAlertDes:message];
                                        }
                                    }
                                }];
            } else/* if ([obj isKindOfClass:[UIImage class]])*/{  //要求：没有签名，客服也有回显
                [LiveChatRequest liveChatValidSign:obj Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
                
//                    [weakSelf showAlertWithType:nil str:message];
                    [KFLCHeartManager showToast:message duration:2];
                }];
            }
            
                
        }];
        [alert setPsdOverTimeBlock:^{
            [weakSelf psdOverTimeAlert];
        }];
        [alert setCancelBlock:^{
            
        }];
        [alert setResetPWDBlock:^{
            [weakSelf resetPWD];
        }];
    }
    
}

-(void)psdOverTimeAlert{
    [self showAlertWithType:nil str:@"尊敬的客户，您好。您的密码输入已超时，请等待营业员重新发起密码校验。"];
}

-(void)inputPsdAgainAlertDes:(NSString *)des{
    LiveChatAlertVC *alertVC = [[LiveChatAlertVC alloc]init];
    alertVC.modalPresentationStyle = UIModalPresentationCustom;
    [alertVC alertSingleBtnWithDes:des sureBtn:@"重新输入" cancelBtn:@"取消"];
    __weak LiveChatMainVC *weakSelf = self;
    [alertVC setSureBlock:^(id  _Nonnull obj) {
        [weakSelf showAlertWithType:@"0" str:nil];
    }];
    [self presentViewController:alertVC animated:NO completion:nil];
}

#pragma mark 密码错误输入三次后，弹框锁定提醒
-(void)unlockPsd:(NSString *)des{
    __weak LiveChatMainVC *weakSelf = self;
    LiveChatAlertVC *vc = [[LiveChatAlertVC alloc]init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [vc alertSingleBtnWithDes:des sureBtn:@"重置密码" cancelBtn:@""];
    [vc setSureBlock:^(id  _Nonnull obj) {
        [weakSelf resetPWD];
    }];
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark 重置密码
-(void)resetPWD{
    LCRestPWDVC *VC = [[LCRestPWDVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:NO completion:nil];
}

- (void)closeLiveChat{
    
    [LCHeartManager installManager].delegate = nil;
    [[LCHeartManager installManager] stopTimer];
    
    [LiveChatRequest liveChatLogOutResult:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
        [super closeLiveChat];
    }];
}

-(void)dealloc{
    
}

@end
#endif
