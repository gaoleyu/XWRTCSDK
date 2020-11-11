//
//  SPKFUtilities.h
//  ecmc
//
//  Created by zxh on 2020/7/7.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThirdManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface SPKFUtilities : NSObject

//! 是否是有效的字典
+ (BOOL)isValidDictionary:(id)object;
//! 是否是有效的数组
+ (BOOL)isValidArray:(id)object;
//! 是否是有效的字符串
+ (BOOL)isValidString:(id)object;
//! 是否是有效的内存二进制数据
+ (BOOL)isValidData:(id)object;


@end

NS_ASSUME_NONNULL_END
