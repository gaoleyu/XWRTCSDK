//
//  LiveChatRequest.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/21.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "LiveChatRequest.h"
#import "LiveChatRequestBase.h"
#import "KFLiveChatParmas.h"
#import "SPKFUtilities.h"
@implementation LiveChatRequest
#pragma mark 用户登录
+ (void)liveChatLoginResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock{
    [[LiveChatParmas installParmas] clearAllParams];
    [[KFLiveChatParmas installParmas] clearAllParams];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/user/login",baseUrl];
    [LiveChatParmas installParmas].requestNum = @"user.login";
    NSMutableDictionary *parmas = [[LiveChatParmas installParmas] getParmas];
    
    [LiveChatRequestBase AFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
        if ([SPKFUtilities isValidDictionary:response]) {
            NSString *resCode = response[@"resCode"];
            if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                
                [[LiveChatParmas installParmas] updateParmas:response];
                resultBlock(response,YES,@"请求成功");
            }else{
                NSString *resMsg = response[@"resMessage"];
                if (![SPKFUtilities isValidString:resMsg]) {
                    resMsg = @"请求失败";
                }
                resultBlock(response,NO,resMsg);
            }
        }else{
            resultBlock(response,NO,@"登录失败");
        }
    } fail:^(id  _Nonnull response) {
        resultBlock(response,NO,@"登录失败");
    }];
}
#pragma mark 用户退出
+ (void)liveChatLogOutResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/user/logout",baseUrl];
    [LiveChatParmas installParmas].requestNum = @"user.logout";
    NSMutableDictionary *parmas = [[LiveChatParmas installParmas] getParmas];
    
    [LiveChatRequestBase AFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
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
#pragma mark 用户挂断
+ (void)liveChatCloseResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/user/hangup",baseUrl];
    [LiveChatParmas installParmas].requestNum = @"user.hangup";
    NSMutableDictionary *parmas = [[LiveChatParmas installParmas] getParmas];
    [LiveChatRequestBase AFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
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
#pragma mark 服务密码验证 recId流水号
+ (void)liveChatValidPWDWithPwd:(NSString *)pwd mobile:(NSString *)mobile recId:(NSString *)recId Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/user/scode",baseUrl];
    [LiveChatParmas installParmas].requestNum = @"user.scode";
    NSMutableDictionary *parmas = [[LiveChatParmas installParmas] getParmas];
    if ([SPKFUtilities isValidString:pwd]) {
        parmas[@"servicePwd"] = pwd;
    }
    if ([SPKFUtilities isValidString:recId]) {
        parmas[@"recId"] = recId;
    }
    if ([SPKFUtilities isValidString:mobile]) {
        parmas[@"memMobile"] = mobile;
    }
    
    
    [LiveChatRequestBase AFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
           if ([SPKFUtilities isValidDictionary:response]) {
               NSString *resCode = response[@"resCode"];
               NSString *resMsg = response[@"resMessage"];
               if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                   resMsg = [SPKFUtilities isValidString:resMsg]?resMsg:@"请求成功";
                   resultBlock(response,YES,resMsg);
               }else{
                   if (![SPKFUtilities isValidString:resMsg]) {
                       resMsg = @"发送失败";
                   }
                   resultBlock(response,NO,resMsg);
               }
           }else{
               resultBlock(response,NO,@"发送失败");
           }
       } fail:^(id  _Nonnull response) {
           resultBlock(response,NO,@"发送失败");
       }];
}
#pragma mark 签名验证
+ (void)liveChatValidSign:(UIImage *)image Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/user/sign",baseUrl];
    [LiveChatParmas installParmas].requestNum = @"user.sign";
    NSMutableDictionary *parmas = [[LiveChatParmas installParmas] getParmas];
    //图片转base64
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    parmas[@"transactSign1"] = encodedImageStr;
    //Base64字符串转UIImage图片：
//    NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    
    [LiveChatRequestBase AFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
           if ([SPKFUtilities isValidDictionary:response]) {
               NSString *resCode = response[@"resCode"];
               NSString *resMsg = response[@"resMessage"];
               if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                   resMsg = @"签名提交成功！";//resMsg?resMsg:@"提交成功";
                   resultBlock(response,YES,resMsg);
               }else{
                   resMsg = @"签名提交失败！";//resMsg?resMsg:@"提交失败";
                   resultBlock(response,NO,resMsg);
               }
           }else{
               resultBlock(response,NO,@"提交失败！");
           }
       } fail:^(id  _Nonnull response) {
           resultBlock(response,NO,@"提交失败！");
       }];
}
#pragma mark 用户进入聊天室
+ (void)liveChatJoinRoomResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/public/room/join",baseUrl];
    [LiveChatParmas installParmas].requestNum = @"room.join";
    NSMutableDictionary *parmas = [[LiveChatParmas installParmas] getParmas];
    [LiveChatRequestBase AFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
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
#pragma mark 获取业务列表
+ (void)liveChatgetYWListResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/public/service/list",baseUrl];
    [LiveChatParmas installParmas].requestNum = @"service.list";
    NSMutableDictionary *parmas = [[LiveChatParmas installParmas] getParmas];
    parmas[@"count"] = @"100";
    [LiveChatRequestBase AFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
           if ([SPKFUtilities isValidDictionary:response]) {
               NSString *resCode = response[@"resCode"];
               if ([SPKFUtilities isValidString:resCode] && [resCode isEqualToString:@"0"]) {
                   NSDictionary *resultDic = response[@"result"];
                   if ([SPKFUtilities isValidDictionary:resultDic]) {
                       NSArray *dataArr = resultDic[@"records"];
                       if ([SPKFUtilities isValidArray:dataArr]) {
                           resultBlock(dataArr,YES,@"请求成功");
                       }else{
                           
                           resultBlock(response,NO,@"无业务数据");
                       }
                   }else{
                       resultBlock(response,NO,@"无业务数据");
                   }
           
               }else{
                   NSString *resMsg = response[@"resMessage"];
                   if (![SPKFUtilities isValidString:resMsg]) {
                       resMsg = @"请求失败";
                   }
                   resultBlock(response,NO,resMsg);
               }
           }else{
               resultBlock(response,NO,@"登录失败");
           }
       } fail:^(id  _Nonnull response) {
           resultBlock(response,NO,@"登录失败");
       }];
}
#pragma mark 取号即业务内容上传
+ (void)liveChatUpSelectYW:(NSString *)yw Result:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/public/queue/push",baseUrl];
    [LiveChatParmas installParmas].requestNum = @"queue.push";
    NSMutableDictionary *parmas = [[LiveChatParmas installParmas] getParmas];
    if ([SPKFUtilities isValidString:yw]) {
        parmas[@"serviceNums"] = yw;
    }
    
    [LiveChatRequestBase AFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
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
#pragma mark 弃号
+ (void)liveChatGiveUpNumResult:(void(^)(id response ,BOOL isSuccess ,NSString *message))resultBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/public/queue/abandon",baseUrl];
    [LiveChatParmas installParmas].requestNum = @"queue.abandon";
    NSMutableDictionary *parmas = [[LiveChatParmas installParmas] getParmas];
    [LiveChatRequestBase AFNPostWihtRUL:url WithParmas:parmas success:^(id  _Nonnull response) {
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


@end
