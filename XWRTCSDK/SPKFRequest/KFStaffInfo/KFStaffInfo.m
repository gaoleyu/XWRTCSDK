//
//  KFStaffInfo.m
//  ecmc
//
//  Created by zhangtao on 2020/4/26.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "KFStaffInfo.h"

@implementation KFStaffInfo

+(instancetype)shareInstall{
    __strong static KFStaffInfo *staff = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staff = [[KFStaffInfo alloc]init];
    });
    return staff;
}

-(void)clear{
    _mobile = nil;
    _staffNum = nil;
    _sessionId = nil;
}

@end
