//
//  VoiceFilemanger.m
//  ecmc
//
//  Created by zxh on 2020/8/11.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "VoiceFilemanger.h"

#import "SPKFUtilities.h"
#import "KFLiveChatParmas.h"
@implementation VoiceFilemanger


+ (instancetype)install{
    static VoiceFilemanger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VoiceFilemanger alloc] init];
    });
    return manager;
}
//创建文件夹,获取沙盒目录
- (NSString *)creatFileDic{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //test文件夹
    documentsDir = [documentsDir stringByAppendingPathComponent:@"SPKF"];
    //是否是文件夹
    BOOL isDir;
    BOOL isExit = [filemanager fileExistsAtPath:documentsDir isDirectory:&isDir];
    //文件夹是否存在
    if (!isExit || !isDir) {
        [filemanager createDirectoryAtPath:documentsDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //判断子目录是否存在
    NSString *subPathName = [KFLiveChatParmas installParmas].staffNum;
    if (![SPKFUtilities isValidString:subPathName]) {
        return nil;
    }
    NSString *subPath = [NSString stringWithFormat:@"%@/%@",documentsDir,subPathName];
    
    //是否是文件夹
    BOOL subisDir;
    BOOL subisExit = [filemanager fileExistsAtPath:subPath isDirectory:&subisDir];
    //文件夹是否存在
    if (!subisExit || !subisDir) {
        [filemanager createDirectoryAtPath:subPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return subPath;
}
//获取目录下文件
- (NSArray *)getFileList{
   NSString *filePath = [self creatFileDic];
    NSFileManager *fileManager = [NSFileManager defaultManager];
  NSError *error;
  NSArray *fileList = [fileManager contentsOfDirectoryAtPath:filePath error:&error];
  if (error) {
      NSLog(@"getFileList Failed:%@",[error localizedDescription]);
  }
  return fileList;
}

//获取存入文件路径
- (NSString *)getSaveVoiceFilePaht:(NSString *)userMobile{
    NSString *documentPath = [self creatFileDic];
    NSString *fileLastName = [NSString stringWithFormat:@"%@/%@_%@.aac",documentPath,[KFLiveChatParmas installParmas].acceptNum,userMobile];
    return fileLastName;
}
//获取文件的信息(包含了上面文件大小)
- (NSDictionary*)getFileInfo:(NSString*)path{
    NSError *error;
    NSDictionary *reslut =  [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (error) {
        NSLog(@"getFileInfo Failed:%@",[error localizedDescription]);
    }
    return reslut;
}

@end
