//
//  ThirdManager.h
//  XWRTC
//
//  Created by zxh on 2020/10/10.
//  Copyright © 2020 zxh. All rights reserved.
//

#ifndef ThirdManager_h
#define ThirdManager_h


#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define statusHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define m6Scale (kScreen_Width/750)
// 获取APP带4位版本号  可带4位版本号
#define SYS_CLIENTVER  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"sys-clientVersion"]

#import "UIColor+extend.h"
#import "UIView+HSExtension.h"
#import "Masonry.h"
#import "NSString+Extension.h"
#import "NSData+Extension.h"
#import "XWAPPID.h"
#import "UIImage+LoadImage.h"

#endif /* ThirdManager_h */
