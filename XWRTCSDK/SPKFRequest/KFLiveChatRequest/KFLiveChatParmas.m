//
//  KFLiveChatParmas.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/21.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "KFLiveChatParmas.h"

#import "SPKFUtilities.h"
#import "Reachability.h"

@implementation KFLiveChatParmas

+ (instancetype)installParmas{
    static KFLiveChatParmas *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KFLiveChatParmas alloc] init];
    });
    return manager;
}
- (NSString *)userNum{
    return _userNum;
    
}
- (NSString *)mobile{
   
    return _mobile;
}
- (NSString *)appid{
    if (!_appid) {
        _appid = @"videohall";
    }
    return _appid;
}

//-(NSString *)sessionId{
//    self.sessionId =  @"4399B2332F5B4BC1877BA3F02FEDA6D5@js.ac.10086.cn";
//    return _sessionId;
//}

- (NSString *)appPwd{
//    NSString *strs = [NSString stringWithFormat:@"%@--%@--%@",self.sessionId,self.requestNum,self.appid];
    NSString *str = [NSString stringWithFormat:@"%@%@%@",self.sessionId,self.requestNum,self.appid];
    _appPwd = [str md5Value];
    return _appPwd;
}
- (NSString *)token{
    
    return self.sessionId;
}
- (NSString *)userOs{
    return @"iOS";
}
- (NSString *)userAppVer{
    return SYS_CLIENTVER;
}
- (NSString *)regionNum{
    if (!_regionNum) {
        _regionNum = @"14";
    }
    return _regionNum;
}
- (NSString *)role{
    if (!_role) {
        _role = @"STAFF";
    }
    return _role;
}
- (NSString *)uniNum{
    if (!_uniNum) {
        _uniNum = _userNum;
    }
    return _uniNum;
}

-(NSString *)staffNum{
    if (![SPKFUtilities isValidString:_staffNum]) {
        return @"";
    }
    return _staffNum;
}

-(NSString *)userNetwork{
    NSString *userNetwork = [self networkType];//[[HSNormTool  sharedNormTool]getPhoneNetType];
    _userNetwork = userNetwork;
    return _userNetwork;
}

-(NSString *)status{
    if (![SPKFUtilities isValidString:_status]) {
        return @"";
    }
    return _status;
}

- (NSString *)deviceId{
    if (!_deviceId) {
    //    _deviceId = [Utility UUID];
    }
    return _deviceId;
}

-(NSString *)chatToken{
    if (!_chatToken) {
        return @"";
    }
    return _chatToken;
}

-(NSString *)channelId{
    if (!_channelId) {
        return @"";
    }
    return _channelId;
}

-(NSString *)heartFeq{
    if (!_heartFeq) {
        return @"3";
    }
    return _heartFeq;
}

#pragma mark 获取请求参数
- (NSMutableDictionary *)getParmas{
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    if ([SPKFUtilities isValidString:self.appid]) {
        parmas[@"appId"] = self.appid;
    }
    if ([SPKFUtilities isValidString:self.appPwd]) {
        parmas[@"appPwd"] = self.appPwd;
    }
    if ([SPKFUtilities isValidString:self.userNum]) {
        parmas[@"userNum"] = self.userNum;
    }
    if ([SPKFUtilities isValidString:self.mobile]) {
        parmas[@"mobile"] = self.mobile;
    }
    if ([SPKFUtilities isValidString:self.sessionId]) {
        parmas[@"sessionId"] = self.sessionId;
    }
    if ([SPKFUtilities isValidString:self.userOs]) {
        parmas[@"userOs"] = self.userOs;
    }
    if ([SPKFUtilities isValidString:self.userAppVer]) {
        parmas[@"userAppVer"] = self.userAppVer;
    }
    if ([SPKFUtilities isValidString:self.role]) {
        parmas[@"role"] = self.role;
    }
    if ([SPKFUtilities isValidString:self.roomNum]) {
        parmas[@"roomNum"] = self.roomNum;
    }
    if ([SPKFUtilities isValidString:self.acceptNum]) {
        parmas[@"acceptNum"] = self.acceptNum;
    }
//    if ([SPKFUtilities isValidString:self.regionNum]) {
//        parmas[@"regionNum"] = self.regionNum;
//    }
    if ([SPKFUtilities isValidString:self.uniNum]) {
        parmas[@"uniNum"] = self.uniNum;
    }
    if ([SPKFUtilities isValidString:self.staffNum]) {
        parmas[@"staffNum"] = self.staffNum;
    }
    if ([SPKFUtilities isValidString:self.userNetwork]) {
        parmas[@"userNetwork"] = self.userNetwork;
    }
    if ([SPKFUtilities isValidString:self.status]){
        parmas[@"status"] = self.status;
    }
    if ([SPKFUtilities isValidString:self.deviceId]) {
        parmas[@"deviceId"] = self.deviceId;
    }
    return parmas;
}
#pragma mark 更新参数
- (void)updateParmas:(NSDictionary *)responseObj{
    if (![SPKFUtilities isValidDictionary:responseObj]) {
           return;
       }
   
    if ([SPKFUtilities isValidDictionary:responseObj]) {
        NSDictionary *result = responseObj[@"result"];
        if ([SPKFUtilities isValidDictionary:result]) {
            NSString *seesinid = result[@"sessionId"];
            if ([SPKFUtilities isValidString:seesinid]) {
                self.sessionId = seesinid;
            }
            NSString *status =result[@"status"];
            if ([SPKFUtilities isValidString:status]) {
                self.status = status;
            }
            NSString *chatToken =result[@"chatToken"];
            if ([SPKFUtilities isValidString:chatToken]) {
                self.chatToken = chatToken;
            }
            NSString *heartFeq =result[@"heartFeq"];
            if ([SPKFUtilities isValidString:heartFeq]) {
                self.heartFeq = heartFeq;
            }
            
            NSString *staffNum =result[@"staffNum"];
            if ([SPKFUtilities isValidString:staffNum]) {
                self.staffNum = staffNum;
                self.uniNum = staffNum;
            }
            
            NSString *staffName =result[@"staffName"];
            if ([SPKFUtilities isValidString:staffName]) {
                self.staffName = staffName;
            }
               
        }
        
        
//        if ([SPKFUtilities isValidDictionary:responseObj[@"result"][@"forStaff"]]) {
//            NSString *notifyType = responseObj[@"result"][@"forStaff"][@"notifyType"];
//            if ([SPKFUtilities isValidString:notifyType]) {
//                self.status = notifyType;
//            }
//        }
    }
}
/**
 获取cookie中统一认证token
 @param
 */
- (NSString*)getUnifyAuthToken
{
    NSString* authToken = @"";
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        //        NSLog(@"%@: %@", cookie.name, cookie.value);
        if([SPKFUtilities isValidString:cookie.name]
           && [cookie.name isEqualToString:@"cmtokenid"])
        {
            authToken = [SPKFUtilities isValidString:cookie.value]? cookie.value : @"";
            break;
        }
    }
    
    return authToken;
}

- (NSString *)networkType{
    if (!_userNetwork) {
        _userNetwork = [[NSString alloc] init];
        Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        switch ([reachability currentReachabilityStatus]) {
            case NotReachable: {
                _userNetwork = @"0";
            }
                break;
            case ReachableViaWiFi: {
                _userNetwork = @"1";
            }
                break;
            case ReachableVia2G: {
                _userNetwork = @"2";
            }
                break;
            case ReachableVia3G: {
                _userNetwork = @"3";
            }
                break;
            case ReachableVia4G: {
                _userNetwork = @"4";
            }
            
                break;
            default: {
                _userNetwork = @"0";
            }
                break;
        }
    }
    
    return _userNetwork;
}

#pragma mark 清空所有参数
- (void)clearAllParams{
    _acceptNum = nil;
    _roomNum = nil;
    _userNum = nil;
    _appPwd = nil;
    _appid = nil;
    _sessionId = nil;
    _status = nil;
    _isOpenRecordForI = NO;
}


@end
