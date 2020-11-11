//
//  VoiceFilemanger.h
//  ecmc
//
//  Created by zxh on 2020/8/11.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceFilemanger : NSObject

+ (instancetype)install;
//创建文件夹,获取沙盒目录
- (NSString *)creatFileDic;
//获取目录下文件
- (NSArray *)getFileList;
//获取存入文件路径
- (NSString *)getSaveVoiceFilePaht:(NSString *)userMobile;
//获取文件的信息(包含了上面文件大小)
- (NSDictionary*)getFileInfo:(NSString*)path;

@end

NS_ASSUME_NONNULL_END
