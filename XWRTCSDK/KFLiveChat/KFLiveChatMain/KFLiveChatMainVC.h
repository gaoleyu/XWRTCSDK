//
//  KFLiveChatMainVC.h
//  ecmc
//
//  Created by XianHong zhang on 2020/4/7.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "KFLiveChatBaseVC.h"

#if TARGET_IPHONE_SIMULATOR//模拟器
@interface KFLiveChatMainVC : UIViewController
//自动上传回调
@property (nonatomic, copy) void (^uploadFileBlock)(NSString *path);
@property (nonatomic, strong) NSDictionary *resultDic;

@end

#elif TARGET_OS_IPHONE//真机



@interface KFLiveChatMainVC : KFLiveChatBaseVC

#pragma mark  --显示客户签名   //通过心跳调用
-(void)showKHSignName:(NSDictionary *)content;

@end
#endif


