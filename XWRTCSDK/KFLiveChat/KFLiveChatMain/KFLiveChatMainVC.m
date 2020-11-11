//
//  KFLiveChatMainVC.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/7.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "KFLiveChatMainVC.h"
#import "KFLCHeartManager.h"
#import "KFLiveChatRequest.h"
#import "SPKFUtilities.h"

@interface KFLiveChatMainVC ()<KFLCheartManagerDelegate>


@end

@implementation KFLiveChatMainVC
#if TARGET_IPHONE_SIMULATOR//模拟器

#elif TARGET_OS_IPHONE//真机
- (void)viewDidLoad {
    [super viewDidLoad];

    if ([SPKFUtilities isValidDictionary:self.resultDic] && [SPKFUtilities isValidDictionary:self.resultDic[@"userInfo"]]) {
        if ([SPKFUtilities isValidString:self.resultDic[@"userInfo"][@"userNum"]]) {
            self.platformView.yhid = self.resultDic[@"userInfo"][@"userNum"];
            self.platformView.phoneLabel.text = [@"当前号码:" stringByAppendingString: self.resultDic[@"userInfo"][@"userNum"]];
        }
        if ([SPKFUtilities isValidString:self.resultDic[@"userInfo"][@"serviceNums"]]) {
            self.platformView.ywLabel.text =[@"拟办业务:" stringByAppendingString: self.resultDic[@"userInfo"][@"serviceNums"]];
        }
        if ([SPKFUtilities isValidString:self.resultDic[@"userInfo"][@"userName"]]) {
            self.platformView.nameLabel.text =[@"客户姓名:" stringByAppendingString: self.resultDic[@"userInfo"][@"userName"]];
        }
        if ([SPKFUtilities isValidString:self.resultDic[@"userInfo"][@"userDz"]]) {
                   self.platformView.localLabel.text =[@"所属地市:" stringByAppendingString: self.resultDic[@"userInfo"][@"userDz"]];
               }
    }
    
    
    __weak KFLiveChatMainVC *weakSelf = self;

    [self.platformView setSignBlock:^{
        [weakSelf sendSignOrPasswordOrder:1];
    }];
    [self.platformView setPasswordBlock:^{
        [weakSelf sendSignOrPasswordOrder:0];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [KFLCHeartManager installManager].delegate = self;
    [[KFLCHeartManager installManager] startTimer];
    
    
    
}

/****************************************************************************************
                        分割线 以下为客服端逻辑
 **************************************************************************************************/

#pragma mark manger delegate
- (void)timerActionDelete{
    [self.platformView updateTimeLabelText];
    
}

-(void)kfHeartRequestCallBack:(NSDictionary *)repDic{
    [KFLCHeartManager liveHeartDataType:repDic controller:self];
}

-(void)closeLiveChat{
    [super closeLiveChat];
}

#pragma mark 客服发送弹密码或者弹签名页面
- (void)sendSignOrPasswordOrder:(int)type{
    __weak KFLiveChatMainVC *weakSelf = self;
    if (type == 1) {
        NSDictionary *exParam = @{};
        
        if ([SPKFUtilities isValidDictionary:self.resultDic] && [SPKFUtilities isValidDictionary:self.resultDic[@"acceptInfo"]]) {
            exParam = self.resultDic[@"acceptInfo"];
        }
        [KFLiveChatRequest kfLiveChatPushSignExParam:exParam Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
            //成功：toast提示，失败：弹框提示，重新推送按钮
            if (isSuccess) {
                [KFLCHeartManager showToast:message duration:2];
            }else{
                LiveChatAlertVC *alertVC = [[LiveChatAlertVC alloc]init];
                alertVC.modalPresentationStyle = UIModalPresentationCustom;
                NSString *des = message?message:@"签名推送失败，是否重新推送？";
                [alertVC alertSingleBtnWithDes:des sureBtn:@"重新推送" cancelBtn:@""];
                alertVC.sureBlock = ^(id  _Nonnull obj) {
                    [weakSelf sendSignOrPasswordOrder:1];
                };
                [weakSelf presentViewController:alertVC animated:NO completion:nil];
            }
        }];
    }else if (type == 0){
        [KFLiveChatRequest kfLiveChatPushSerivcePhone:self.resultDic[@"userInfo"][@"userNum"]  CodeResult:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
            if (isSuccess) {
                [weakSelf showAlert:@"推送成功"];
            }else{
                [weakSelf showAlert:@"推送失败"];
            }
        }];
    }

}

-(void)showKHSignName:(NSDictionary *)content{
    if ([SPKFUtilities isValidDictionary:content]) {
        UIImage *dataImg;
        if ([SPKFUtilities isValidString:content[@"transactSign1"]]) {
            NSString *imgStr = content[@"transactSign1"];
            NSData *data = [[NSData alloc]initWithBase64EncodedString:imgStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            dataImg = [UIImage imageWithData:data];
        }
       
        LiveChatAlertVC *alertVC = [[LiveChatAlertVC alloc]init];
        __weak LiveChatAlertVC *weakAlert = alertVC;
        alertVC.modalPresentationStyle = UIModalPresentationCustom;
        [alertVC showBackSignNameAlert:dataImg];
        __weak KFLiveChatMainVC *weakSelf = self;
        alertVC.sureBlock = ^(id  _Nonnull obj) {
            [weakSelf passSignName:content andAlert:weakAlert];
        };
        alertVC.signAgainBlock = ^{
            [weakSelf sendSignOrPasswordOrder:1];
        };
    
        [self presentViewController:alertVC animated:NO completion:nil];
    }
}

#pragma mark 通过电子签名
-(void)passSignName:(NSDictionary *)dic andAlert:(LiveChatAlertVC *)alert{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [KFLiveChatRequest kfLiveChatCheckSignExParam:@{@"content":str} Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
        if (isSuccess) {
            [alert dismissViewControllerAnimated:NO completion:nil];
            [KFLCHeartManager showToast:message duration:2];
        }else{
//            [weakSelf showKHSignName:dic];
            [KFLCHeartManager showToast:message duration:2];
        }
    }];
}

-(void)showAlert:(NSString *)des{
    LiveChatAlertVC *alert = [[LiveChatAlertVC alloc]init];
    alert.modalPresentationStyle = UIModalPresentationCustom;
    [alert showNormalAlertWithStr:des];
    [self presentViewController:alert animated:NO completion:nil];
}

- (void)dealloc{
    
}
#endif
@end

