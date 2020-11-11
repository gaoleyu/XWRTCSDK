//
//  KFStaffInfo.h
//  ecmc
//
//  Created by zhangtao on 2020/4/26.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFStaffInfo : NSObject

@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *staffNum;  //客服编码   工号

@property(nonatomic,strong)NSString *sessionId;
+(instancetype)shareInstall;

-(void)clear;

@end

NS_ASSUME_NONNULL_END
