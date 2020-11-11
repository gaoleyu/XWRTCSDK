//
//  LineSignNameView.h
//  ecmc
//
//  Created by XianHong zhang on 2020/3/24.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LineSignNameView : UIView

@property (nonatomic, strong) UIBezierPath *signaturePath;
@property (nonatomic, assign) CGPoint oldPoint;

/**
 是否有签名
 */
@property (nonatomic, assign) BOOL isHaveSignature;
//绘画区域
@property (nonatomic, assign) CGFloat minX;
@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
//清除按钮
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, assign) BOOL hiddenClearBtn;
/**
 清除签名
 */
- (void)clear;



/**
 保存签名

 @return 保存在本地的图片路径
 */
- (UIImage *)saveTheSignatureWithError:(void(^)(NSString *errorMsg))errorBlock;

@end

NS_ASSUME_NONNULL_END
