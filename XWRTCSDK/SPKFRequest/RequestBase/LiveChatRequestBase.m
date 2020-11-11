//
//  LiveChatRequestBase.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/21.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "LiveChatRequestBase.h"
#import "AFNetworking.h"
#import "LiveChatParmas.h"
#import "KFLiveChatParmas.h"
#import "SPKFUtilities.h"
@implementation LiveChatRequestBase

+ (void)AFNPostWihtRUL:(NSString *)urlString WithParmas:(NSDictionary *)parmas success:(void(^)(id response))successBlock fail:(void(^)(id response))failBlock{
    //1.创建一个请求的管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.设置请求参数的格式
    /**
     *  AFHTTPRequestSerializer : 将请求参数格式化为&符号拼接
     *  AFJSONRequestSerializer : 将请求参数格式化为json数据
     */
    //    [manager.requestSerializer setValue:@"text/html;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *apppwd = @"";
    
    if ([SPKFUtilities isValidString:[LiveChatParmas installParmas].appPwd]) {
        apppwd = [LiveChatParmas installParmas].appPwd;
        
    }
    
    [manager.requestSerializer setValue:apppwd forHTTPHeaderField:@"appPwd"];
    
    //设置10s超时
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:urlString parameters:parmas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        id repos = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        successBlock(repos);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
    
}

+ (void)AFNGetWihtRUL:(NSString *)urlString WithParmas:(NSDictionary *)parmas success:(void(^)(id response))successBlock fail:(void(^)(id response))failBlock{
    
    //1.创建一个请求的管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.设置请求参数的格式
    /**
     *  AFHTTPRequestSerializer : 将请求参数格式化为&符号拼接
     *  AFJSONRequestSerializer : 将请求参数格式化为json数据
     */
    //申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlString parameters:parmas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
    
    
}




+ (void)kfAFNPostWihtRUL:(NSString *)urlString WithParmas:(NSDictionary *)parmas success:(void(^)(id response))successBlock fail:(void(^)(id response))failBlock{
    //1.创建一个请求的管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.设置请求参数的格式
    /**
     *  AFHTTPRequestSerializer : 将请求参数格式化为&符号拼接
     *  AFJSONRequestSerializer : 将请求参数格式化为json数据
     */
    //    [manager.requestSerializer setValue:@"text/html;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //       if ([urlString containsString:@"staff/login"] ||
    //           [urlString containsString:@"staff/logout"] ||
    //           [urlString containsString:@"user/login"] ||
    //           [urlString containsString:@"/staff/hangup"]) {
    //           manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //       }
    
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *apppwd = @"";
    
    if ([SPKFUtilities isValidString:[KFLiveChatParmas installParmas].appPwd]) {
        apppwd = [KFLiveChatParmas installParmas].appPwd;
        
    }
    
    [manager.requestSerializer setValue:apppwd forHTTPHeaderField:@"appPwd"];
    
    //设置10s超时
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:urlString parameters:parmas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        id repos = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        successBlock(repos);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
    
}

+ (void)kfAFNGetWihtRUL:(NSString *)urlString WithParmas:(NSDictionary *)parmas success:(void(^)(id response))successBlock fail:(void(^)(id response))failBlock{
    
    //1.创建一个请求的管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.设置请求参数的格式
    /**
     *  AFHTTPRequestSerializer : 将请求参数格式化为&符号拼接
     *  AFJSONRequestSerializer : 将请求参数格式化为json数据
     */
    //申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlString parameters:parmas progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
    
}

+ (void)kfAFNUploadFileWithUrl:(NSString *)url path:(NSString *)path WithParmas:(NSDictionary *)parmas success:(void(^)(id response))successBlock fail:(void(^)(id response))failBlock{
    
    NSData *imageData = [NSData dataWithContentsOfFile:path];
    NSString *fileName = [path lastPathComponent];
    NSString *fileType = @"";
    NSArray *nameArr = [[path lastPathComponent] componentsSeparatedByString:@"."];
    if ([SPKFUtilities isValidArray:nameArr]) {
        
        fileType = nameArr.lastObject;
    }
    //1.创建一个请求的管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *apppwd = @"";
    
    if ([SPKFUtilities isValidString:[KFLiveChatParmas installParmas].appPwd]) {
        apppwd = [KFLiveChatParmas installParmas].appPwd;
        
    }
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:apppwd forHTTPHeaderField:@"appPwd"];
    
    //设置10s超时
    manager.requestSerializer.timeoutInterval = 10;
    [manager POST:url parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"fileName" fileName:fileName mimeType:fileType];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id repos = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        successBlock(repos);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
    
}

@end
