//
//  KFLiveChatRequest.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/21.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "KFLiveChatRequest.h"
#import "LiveChatRequestBase.h"
#import "KFLiveChatParmas.h"
#import "LiveChatParmas.h"
#import "SPKFUtilities.h"
#import "Reachability+Extension.h"
@implementation KFLiveChatRequest

#pragma mark 客服登录
+ (void)kfLiveChatLoginParams:(NSDictionary *)param Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock{   //http://wap.js.10086.cn/ex/vhall
    
    [[LiveChatParmas installParmas] clearAllParams];
    //    [[KFLiveChatParmas installParmas] clearAllParams];
    
    NSString *url = [NSString stringWithFormat:@"%@/staff/login",baseUrl];
    [KFLiveChatParmas installParmas].requestNum = @"staff.login";
    NSMutableDictionary *parmas = [[KFLiveChatParmas installParmas] getParmas];
    [parmas addEntriesFromDictionary:param];
    
    [LiveChatRequestBase kfAFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
        if ([SPKFUtilities isValidDictionary:response]) {
            NSString *resCode = response[@"resCode"];
            if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                
                [[KFLiveChatParmas installParmas] updateParmas:response];
                
                resultBlock(response,YES,@"请求成功");
            }else{
                NSString *resMsg = response[@"resMessage"];
                if (![SPKFUtilities isValidString:resMsg]) {
                    resMsg = @"请求失败";
                }
                resultBlock(response,NO,resMsg);
            }
        }else{
            resultBlock(response,NO,@"请求失败");
        }
    } fail:^(id  _Nonnull response) {
        resultBlock(response,NO,@"请求失败");
    }];
    
    
}

#pragma mark 客服退出
+(void)kfLiveChatLogOutResult:(void (^)(id _Nonnull, BOOL, NSString * _Nonnull))resultBlock{
    NSString *url = [NSString stringWithFormat:@"%@/staff/logout",baseUrl];
    [KFLiveChatParmas installParmas].requestNum = @"staff.logout";
    NSMutableDictionary *parmas = [[KFLiveChatParmas installParmas] getParmas];
    
    [LiveChatRequestBase kfAFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
        if ([SPKFUtilities isValidDictionary:response]) {
            NSString *resCode = response[@"resCode"];
            if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                [[KFLiveChatParmas installParmas] clearAllParams];
                resultBlock(response,YES,@"请求成功");
            }else{
                NSString *resMsg = response[@"resMessage"];
                if (![SPKFUtilities isValidString:resMsg]) {
                    resMsg = @"请求失败";
                }
                resultBlock(response,NO,resMsg);
            }
        }else{
            resultBlock(response,NO,@"请求失败");
        }
    } fail:^(id  _Nonnull response) {
        resultBlock(response,NO,@"请求失败");
    }];
}

#pragma mark 客服挂断
+(void)kfLiveChatCloseExParam:(NSDictionary *)param Result:(void (^)(id _Nonnull, BOOL, NSString * _Nonnull))resultBlock{
    NSString *url = [NSString stringWithFormat:@"%@/staff/hangup",baseUrl];
    [KFLiveChatParmas installParmas].requestNum = @"staff.hangup";
    NSMutableDictionary *parmas = [[KFLiveChatParmas installParmas] getParmas];
    if ([SPKFUtilities isValidDictionary:param]) {
        [parmas addEntriesFromDictionary:param];
    }
    [LiveChatRequestBase kfAFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
        if ([SPKFUtilities isValidDictionary:response]) {
            NSString *resCode = response[@"resCode"];
            if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                
                resultBlock(response,YES,@"请求成功");
            }else{
                NSString *resMsg = response[@"resMessage"];
                if (![SPKFUtilities isValidString:resMsg]) {
                    resMsg = @"请求失败";
                }
                resultBlock(response,NO,resMsg);
            }
        }else{
            resultBlock(response,NO,@"请求失败");
        }
    } fail:^(id  _Nonnull response) {
        resultBlock(response,NO,@"请求失败");
    }];
}

#pragma mark 客服信息\状态 变更
+(void)kfLiveChatUpdateStatus:(NSString *)status Params:(id)param Result:(void (^)(id _Nonnull, BOOL, NSString * _Nonnull))resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/staff/update",baseUrl];
    [KFLiveChatParmas installParmas].requestNum = @"staff.update";
    
    NSMutableDictionary *parmas = [[KFLiveChatParmas installParmas] getParmas];
    
    if ([SPKFUtilities isValidDictionary:param]) {
        [parmas addEntriesFromDictionary:param];
    }
    
    if ([SPKFUtilities isValidString:status]) {
        [parmas setValue:status forKey:@"status"];
    }
    
    [LiveChatRequestBase kfAFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
        if ([SPKFUtilities isValidDictionary:response]) {
            NSString *resCode = response[@"resCode"];
            if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                
                resultBlock(response,YES,@"请求成功");
            }else{
                NSString *resMsg = response[@"resMessage"];
                if (![SPKFUtilities isValidString:resMsg]) {
                    resMsg = @"请求失败";
                }
                resultBlock(response,NO,resMsg);
            }
        }else{
            resultBlock(response,NO,@"请求失败");
        }
    } fail:^(id  _Nonnull response) {
        resultBlock(response,NO,@"请求失败");
    }];
}


#pragma mark 客服心跳
+(void)kfLiveChatheartExParam:(id)param Result:(void (^)(id _Nonnull, BOOL, NSString * _Nonnull))resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/public/staffheart",baseUrl];
    [KFLiveChatParmas installParmas].requestNum = @"public.staffheart";
    NSMutableDictionary *parmas = [[KFLiveChatParmas installParmas] getParmas];
    if ([SPKFUtilities isValidString: parmas[@"staffNum"]]) {
        [parmas setValue:parmas[@"staffNum"] forKey:@"uniNum"];
    }
    if ([SPKFUtilities isValidDictionary:param]) {
        [parmas addEntriesFromDictionary:param];
    }
    
    [LiveChatRequestBase kfAFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
        if ([SPKFUtilities isValidDictionary:response]) {
            NSString *resCode = response[@"resCode"];
            if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                
                if ([SPKFUtilities isValidDictionary:response[@"result"]]) {
                    if ([SPKFUtilities isValidDictionary:response[@"result"][@"forStaff"]]) {
                        NSString *notifyType = response[@"result"][@"forStaff"][@"notifyType"];
                        if ([SPKFUtilities isValidString:notifyType]) {
                            [KFLiveChatParmas installParmas].status = notifyType;
                        }
                    }
                }
                
                resultBlock(response,YES,@"请求成功");
            }else{
                NSString *resMsg = response[@"resMessage"];
                if (![SPKFUtilities isValidString:resMsg]) {
                    resMsg = @"请求失败";
                }
                resultBlock(response,NO,resMsg);
            }
        }else{
            resultBlock(response,NO,@"请求失败");
        }
    } fail:^(id  _Nonnull response) {
        resultBlock(response,NO,@"请求失败");
    }];
}

#pragma mark 客服叫号
+(void)kfLiveChatPOPResult:(void (^)(id _Nonnull, BOOL, NSString * _Nonnull))resultBlock{
    NSString *url = [NSString stringWithFormat:@"%@/public/queue/pop",baseUrl];
    [KFLiveChatParmas installParmas].requestNum = @"queue.pop";
    NSMutableDictionary *parmas = [[KFLiveChatParmas installParmas] getParmas];
    if ([SPKFUtilities isValidString: parmas[@"staffNum"]]) {
        [parmas setValue:parmas[@"staffNum"] forKey:@"uniNum"];
    }
    [LiveChatRequestBase kfAFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
        if ([SPKFUtilities isValidDictionary:response]) {
            NSString *resCode = response[@"resCode"];
            if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                
                resultBlock(response,YES,@"请求成功");
            }else{
                NSString *resMsg = response[@"resMessage"];
                if (![SPKFUtilities isValidString:resMsg]) {
                    resMsg = @"请求失败";
                }
                resultBlock(response,NO,resMsg);
            }
        }else{
            resultBlock(response,NO,@"请求失败");
        }
    } fail:^(id  _Nonnull response) {
        resultBlock(response,NO,@"请求失败");
    }];
}

#pragma mark 客服弃号
+ (void)kfLiveChatAbandonExParam:(NSDictionary *)param Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock{
    NSString *url = [NSString stringWithFormat:@"%@/public/queue/abandon",baseUrl];
    [KFLiveChatParmas installParmas].requestNum = @"queue.abandon";
    NSMutableDictionary *parmas = [[KFLiveChatParmas installParmas] getParmas];
    
    if ([SPKFUtilities isValidDictionary:param]) {
        [parmas addEntriesFromDictionary:param];
    }
    
    [LiveChatRequestBase kfAFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
        if ([SPKFUtilities isValidDictionary:response]) {
            NSString *resCode = response[@"resCode"];
            if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                
                resultBlock(response,YES,@"请求成功");
            }else{
                NSString *resMsg = response[@"resMessage"];
                if (![SPKFUtilities isValidString:resMsg]) {
                    resMsg = @"请求失败";
                }
                resultBlock(response,NO,resMsg);
            }
        }else{
            resultBlock(response,NO,@"请求失败");
        }
    } fail:^(id  _Nonnull response) {
        resultBlock(response,NO,@"请求失败");
    }];
}

#pragma mark 服务密码推送
+(void)kfLiveChatPushSerivcePhone:(NSString*)phoneNum  CodeResult:(void (^)(id _Nonnull, BOOL, NSString * _Nonnull))resultBlock{
    NSString *url = [NSString stringWithFormat:@"%@/user/valid/servicecode/wait",baseUrl];
    [KFLiveChatParmas installParmas].requestNum = @"valid.serviceCode.wait";
    NSMutableDictionary *parmas = [[KFLiveChatParmas installParmas] getParmas];
    
    [parmas setValue:@"1000001204" forKey:@"RECID"];
    [parmas setValue:@"18091103" forKey:@"OPERID"];
    [parmas setValue:@"18870892" forKey:@"ORGID"];
    [parmas setValue:@"18" forKey:@"REGION"];
    [parmas setValue:@"202004119182404356" forKey:@"REQTIME"];
    [parmas setValue:phoneNum forKey:@"MOBILE"];
    [LiveChatRequestBase kfAFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
        if ([SPKFUtilities isValidDictionary:response]) {
            NSString *resCode = response[@"RETCODE"];
            if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                
                resultBlock(response,YES,@"请求成功");
            }else{
                NSString *resMsg = response[@"resMessage"];
                if (![SPKFUtilities isValidString:resMsg]) {
                    resMsg = @"请求失败";
                }
                resultBlock(response,NO,resMsg);
            }
        }else{
            resultBlock(response,NO,@"请求失败");
        }
    } fail:^(id  _Nonnull response) {
        resultBlock(response,NO,@"请求失败");
    }];
}

#pragma mark 签名推送
+(void)kfLiveChatPushSignExParam:(id)param Result:(void (^)(id _Nonnull, BOOL, NSString * _Nonnull))resultBlock{
    NSString *url = [NSString stringWithFormat:@"%@/user/valid/sign/wait",baseUrl];
    [KFLiveChatParmas installParmas].requestNum = @"valid.sign.wait";
    NSMutableDictionary *parmas = [[KFLiveChatParmas installParmas] getParmas];
    
    if ([SPKFUtilities isValidDictionary:param]) {
        [parmas addEntriesFromDictionary:param];
    }
    
    [LiveChatRequestBase kfAFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
        if ([SPKFUtilities isValidDictionary:response]) {
            NSString *resCode = response[@"resCode"];
            NSString *resMsg = response[@"resMessage"];
            
            if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                resMsg = [SPKFUtilities isValidString:resMsg]?resMsg:@"请求成功";
                resultBlock(response,YES,resMsg);
            }else{
                if (![SPKFUtilities isValidString:resMsg]) {
                    resMsg = @"请求失败";
                }
                resultBlock(response,NO,resMsg);
            }
        }else{
            resultBlock(response,NO,@"请求失败");
        }
    } fail:^(id  _Nonnull response) {
        NSString *des = @"请求失败。";
        if (![Reachability reachable]) {
            des = @"网络连接失败，请检查网络设置。";
        }
        resultBlock(response,NO,des);
    }];
}

#pragma mark 客服验证 用户录入信息
+(void)kfLiveChatCheckSignExParam:(id)param Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/staff/checkUserInput",baseUrl];
    [KFLiveChatParmas installParmas].requestNum = @"staff.checkUserInput";
    NSMutableDictionary *parmas = [[KFLiveChatParmas installParmas] getParmas];
    
    if ([SPKFUtilities isValidDictionary:param]) {
        [parmas addEntriesFromDictionary:param];
    }
    [parmas setValue:@"USERSIGN" forKey:@"type"];
    [LiveChatRequestBase kfAFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
        if ([SPKFUtilities isValidDictionary:response]) {
            NSString *resCode = response[@"resCode"];
            NSString *resMsg = response[@"resMessage"];
            
            if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                resMsg = [SPKFUtilities isValidString:resMsg]?resMsg:@"发送成功";
                resultBlock(response,YES,resMsg);
            }else{
                if (![SPKFUtilities isValidString:resMsg]) {
                    resMsg = @"发送失败，请重新发送。";
                }
                resultBlock(response,NO,resMsg);
            }
        }else{
            resultBlock(response,NO,@"请求失败");
        }
    } fail:^(id  _Nonnull response) {
        resultBlock(response,NO,@"请求失败");
    }];
}
#pragma mark 上传文件
+ (void)upLoadVoiceFileWithPath:(NSString *)path Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/staff/record",baseUrl];
    [KFLiveChatParmas installParmas].requestNum = @"staff.record";
    NSMutableDictionary *parmas = [[KFLiveChatParmas installParmas] getParmas];
    NSArray *nameArr = [[path lastPathComponent] componentsSeparatedByString:@"."];
    NSString *vcstr = @"";
    if ([SPKFUtilities isValidArray:nameArr]) {
        
        vcstr = [nameArr.firstObject md5Value];
    }
    
    parmas[@"vc"] = vcstr;
    [LiveChatRequestBase kfAFNUploadFileWithUrl:url path:path WithParmas:parmas success:^(id response) {
        
        if ([SPKFUtilities isValidDictionary:response]) {
            NSString *resCode = response[@"resCode"];
            NSString *resMsg = response[@"resMessage"];
            
            if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                resMsg = [SPKFUtilities isValidString:resMsg]?resMsg:@"发送成功";
                resultBlock(response,YES,resMsg);
            }else{
                if (![SPKFUtilities isValidString:resMsg]) {
                    resMsg = @"发送失败，请重新发送。";
                }
                resultBlock(response,NO,resMsg);
            }
        }else{
            resultBlock(response,NO,@"请求失败");
        }
        
        
    } fail:^(id response) {
        resultBlock(response,NO,@"请求失败");
    }];
    
}

@end
