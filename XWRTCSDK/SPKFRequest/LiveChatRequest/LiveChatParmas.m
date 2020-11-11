//
//  LiveChatParmas.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/21.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "LiveChatParmas.h"

#import "Reachability.h"
#import "SPKFUtilities.h"

@implementation LiveChatParmas

+ (instancetype)installParmas{
    static LiveChatParmas *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LiveChatParmas alloc] init];
    });
    return manager;
}
- (NSInteger)requestCount{
    if (!_requestCount) {
        _requestCount = 2;
    }
    return _requestCount;
}
- (NSString *)userNum{
//    if ([UserInfo currentUser].isLogin) {
//        return [self getUnifyAuthToken];
//    }
    return self.mobile;
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
- (NSString *)appPwd{
     NSString *str = [NSString stringWithFormat:@"%@%@%@",self.sessionId,self.requestNum,self.appid];
    _appPwd = [str md5Value];
    return _appPwd;
}
- (NSString *)deviceId{
    if (!_deviceId) {
        _deviceId = [LiveChatParmas generateUUID];
    }
    return _deviceId;
}
+ (NSString *)generateUUID
{
    CFUUIDRef puuid = CFUUIDCreate (nil);
    CFStringRef uuidString = CFUUIDCreateString (nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease (CFStringCreateCopy (NULL, uuidString));
    CFRelease (puuid);
    CFRelease (uuidString);
    return result;
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
        _role = @"USER";
    }
    return _role;
}
- (NSString *)uniNum{
   
    return self.userNum;
}
- (NSString *)userNetwork{
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
#pragma mark 获取请求参数
- (NSMutableDictionary *)getParmas{
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
//    if ([SPKFUtilities isValidString:self.appid]) {
//        parmas[@"appId"] = self.appid;
//    }
//    if ([SPKFUtilities isValidString:self.appPwd]) {
//        parmas[@"appPwd"] = self.appPwd;
//    }
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
    if ([SPKFUtilities isValidString:self.ch]) {
        parmas[@"ch"] = _ch;
    }
//    if ([SPKFUtilities isValidString:self.regionNum]) {
//        parmas[@"regionNum"] = self.regionNum;
//    }
    if ([SPKFUtilities isValidString:self.uniNum]) {
        parmas[@"uniNum"] = self.uniNum;
    }
    if ([SPKFUtilities isValidString:self.userNetwork]) {
        parmas[@"userNetWork"] = self.userNetwork;
    }
    if ([SPKFUtilities isValidString:self.deviceId]) {
        parmas[@"deviceId"] = self.deviceId;
    }
//    if (self.queue) {
//        parmas[@"queue"] = [NSNumber numberWithBool:self.queue];
//    }
//    if (self.serviceNums) {
//        parmas[@"serviceNums"] = self.serviceNums;
//    }
    return parmas;
}
#pragma mark 更新参数
- (void)updateParmas:(NSDictionary *)responseObj{
    if (![SPKFUtilities isValidDictionary:responseObj]) {
        return;
    }
    NSDictionary *resultDic = responseObj[@"result"];
    if (![SPKFUtilities isValidDictionary:resultDic]) {
        return;
    }
    NSString *seesinid = resultDic[@"sessionId"];
    if ([SPKFUtilities isValidString:seesinid]) {
        self.sessionId = seesinid;
    }
    NSString *sdktoken = resultDic[@"chatToken"];
    if ([SPKFUtilities isValidString:sdktoken]) {
        self.sdktoken = sdktoken;
    }
    NSString *distance = resultDic[@"heartFeq"];
    if ([SPKFUtilities isValidString:distance] || [distance isKindOfClass:[NSNumber class]]) {
        self.requestCount = distance.integerValue;
    }
    
//    if (resultDic[@"queue"]) {
//        self.queue = resultDic[@"queue"];
//    }
//    NSString *serviceNums = resultDic[@"serviceNums"];
//    if ([SPKFUtilities isValidString:serviceNums]) {
//        self.serviceNums = serviceNums;
//    }
    
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

#pragma mark 清空所有参数
- (void)clearAllParams{
    _acceptNum = nil;
    _roomNum = nil;
    _userNum = nil;
    _appPwd = nil;
    _sessionId = nil;
    _appid = nil;
    _roomNum = nil;
    _staffNum = nil;
    _sdktoken = nil;
    _ch = nil;
    _isOpenRecordForI = NO;
}

@end
