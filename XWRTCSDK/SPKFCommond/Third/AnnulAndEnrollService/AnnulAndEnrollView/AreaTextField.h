//
//  AreaTextField.h
//  TestNewPro
//
//  Created by zhangtao on 2020/2/6.
//  Copyright © 2020 zt.td. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AreaTextField : UITextField

///// 实例化方块输入框（位数，明文或密文显示）
//- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count textEntry:(BOOL)isSecureText editDone:(void (^)(NSString *text))done deleteTxt:(void(^)(void))delTxt;

/// 方块输入框（位数,允许第三方输入，明文或密文显示）
- (void)boxInput:(NSInteger)count allowThird:(BOOL)thirdInput textEntry:(BOOL)isSecureText editDone:(void (^)(NSString *text))done
    deleteTxt:(void (^)(void))delTxt;

@property(nonatomic,assign)BOOL showSecure;

/// 限制字符（默认只能输入数字）
@property (nonatomic, strong) NSString *limitStr;


/// 字符方框背景色（默认白色）
@property (nonatomic, strong) UIColor *textBackgroundColor;

/// 字符方框圆角（默认3.0）
@property (nonatomic, assign) CGFloat textCornerRadius;

/// 字符方框边框颜色（默认黑色）
@property (nonatomic, strong) UIColor *textBorderColor;

/// 字体颜色
@property (nonatomic, strong) UIColor *color;


////  方框宽度
@property (nonatomic,assign)CGFloat areaWidth;
//   方框间隔
@property(nonatomic,assign)CGFloat originX;


/// 清空输入
- (void)clearInput;


@end

NS_ASSUME_NONNULL_END
