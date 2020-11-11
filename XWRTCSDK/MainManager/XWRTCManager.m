//
//  XWRTCManager.m
//  XWRTC
//
//  Created by zxh on 2020/10/10.
//  Copyright © 2020 zxh. All rights reserved.
//

#import "XWRTCManager.h"
#import "KFLiveChatParmas.h"
#import "LiveChatParmas.h"
#import "KFLiveChatManager.h"
#import "LiveChatManager.h"
#import "LiveChatRequest.h"
#import "SPKFUtilities.h"
#import "ChatSelectVC.h"
#import "LiveChatAlertVC.h"

@implementation XWRTCManager

/**
 单例
 */
+ (instancetype)installManager{
    static XWRTCManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XWRTCManager alloc] init];
    });
    return manager;
}

- (void)showLiveChatWith:(NSString *)mobile regionNum:(NSString *)regionNum controller:(UIViewController *)controller{
    [KFLiveChatParmas installParmas].mobile = mobile;
    [KFLiveChatParmas installParmas].regionNum = regionNum;
    
    [LiveChatRequest liveChatLoginResult:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
        
        if (isSuccess) {
            
            if ([SPKFUtilities isValidDictionary:response]) {
                NSDictionary *resultDic = response[@"result"];
                if ([SPKFUtilities isValidDictionary:resultDic]) {
                    //isShareScreen
                    NSString *isShareScreen = resultDic[@"isShareScreen"];
                    if ([SPKFUtilities isValidString:isShareScreen]){
                        if ([isShareScreen isEqualToString:@"0"]) {
                            [LiveChatManager installManager].isShowShare = NO;
                        }else if ([isShareScreen isEqualToString:@"1"]) {
                            [LiveChatManager installManager].isShowShare = YES;
                        }
                    }
                    NSString *isOpenRecordForI = resultDic[@"isOpenRecordForI"];
                    if ([SPKFUtilities isValidString:isOpenRecordForI]) {
                        if ([isOpenRecordForI isEqualToString:@"0"]) {
                            [LiveChatParmas installParmas].isOpenRecordForI = NO;
                        }else if ([isOpenRecordForI isEqualToString:@"1"]) {
                            [LiveChatParmas installParmas].isOpenRecordForI = YES;
                        }

                    }
                    
                    
                }
                
            }
            if ([SPKFUtilities isValidDictionary:response] &&
                [SPKFUtilities isValidDictionary:response[@"result"]] &&
                [SPKFUtilities isValidString:response[@"result"][@"serviceNums"]] &&
                response[@"result"][@"queue"]){
                [LiveChatManager installManager].ywID = response[@"result"][@"serviceNums"];
                [[LiveChatManager installManager] showLiveChatWaitView];
            }
            
            else{//说明没有业务id
                //处理返回参数
                [LiveChatRequest liveChatgetYWListResult:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
                    if (isSuccess) {
                        
                        ChatSelectVC *vc = [[ChatSelectVC alloc] init];
                        vc.modalPresentationStyle = UIModalPresentationCustom;
                        vc.dataArray = response;
                        [controller presentViewController:vc animated:NO completion:nil];
                    }
                }];
            }
            
        }else{
            LiveChatAlertVC *alertVC = [[LiveChatAlertVC alloc] init];
            alertVC.modalPresentationStyle = UIModalPresentationCustom;
            [alertVC showNormalAlertWithStr:message];
            [controller presentViewController:alertVC animated:NO completion:nil];
        }
    }];
}
- (void)showKFLiveChatWith:(NSString *)mobile userNum:(NSString *)userNum{
    [KFLiveChatParmas installParmas].mobile = mobile;
    [KFLiveChatParmas installParmas].userNum = userNum;
    [[KFLiveChatManager installManager] showLiveChatView];
}

@end
