//
//  LiveChatRequestBase.h
//  ecmc
//
//  Created by XianHong zhang on 2020/4/21.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>
//http://wap.js.10086.cn/vhall/api/v1
//http://wap.js.10086.cn/ex/vhall
static NSString *baseUrl = @"http://wap.js.10086.cn/ex/vhall/api/v1";

@interface LiveChatRequestBase : NSObject

+ (void)AFNPostWihtRUL:(NSString *)urlString WithParmas:(NSDictionary *)parmas success:(void(^)(id response))successBlock fail:(void(^)(id response))failBlock;
+ (void)AFNGetWihtRUL:(NSString *)urlString WithParmas:(NSDictionary *)parmas success:(void(^)(id response))successBlock fail:(void(^)(id response))failBlock;


+ (void)kfAFNPostWihtRUL:(NSString *)urlString WithParmas:(NSDictionary *)parmas success:(void(^)(id response))successBlock fail:(void(^)(id response))failBlock;
+ (void)kfAFNGetWihtRUL:(NSString *)urlString WithParmas:(NSDictionary *)parmas success:(void(^)(id response))successBlock fail:(void(^)(id response))failBlock;
+ (void)kfAFNUploadFileWithUrl:(NSString *)url path:(NSString *)path WithParmas:(NSDictionary *)parmas success:(void(^)(id response))successBlock fail:(void(^)(id response))failBlock;


@end


