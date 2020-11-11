//
//  LineSignNameView.m
//  ecmc
//
//  Created by XianHong zhang on 2020/3/24.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "LineSignNameView.h"
#import "SPKFUtilities.h"
@implementation LineSignNameView

#pragma mark - set & get
- (UIBezierPath *)signaturePath {
    if (!_signaturePath) {
        _signaturePath = [UIBezierPath bezierPath];
    }
    return _signaturePath;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
        //清除按钮
        _clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_clearBtn setTitle:@"重置" forState:UIControlStateNormal];
        _clearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
        if (!_hiddenClearBtn) {
            [self addSubview:_clearBtn];
        }
        
        [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(30);
            make.right.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
       [self config];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.signaturePath.lineWidth = 2;
    [[UIColor blackColor] setStroke];
    [self.signaturePath stroke];
}

#pragma mark - 基础配置
- (void)config {
    self.backgroundColor = [UIColor whiteColor];
    self.oldPoint = CGPointZero;
    self.isHaveSignature = NO;
    self.minX = 0;
    self.maxX = 0;
    self.minY = 0;
    self.maxY = 0;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    [self.signaturePath moveToPoint:currentPoint];
    self.oldPoint = currentPoint;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    [self.signaturePath addQuadCurveToPoint:currentPoint controlPoint:self.oldPoint];
    self.oldPoint = currentPoint;
    //设置剪切图片的区域
    [self getImageRect:currentPoint];
    //设置签名存在
    if (!self.isHaveSignature) {
        self.isHaveSignature = YES;
    }
    [self setNeedsDisplay];
}

- (void)getImageRect:(CGPoint)currentPoint {
    if (self.maxX == 0 && self.minX == 0) {
        self.maxX = currentPoint.x;
        self.minX = currentPoint.x;
    } else {
        if (self.maxX <= currentPoint.x) {
            self.maxX = currentPoint.x;
        }
        if (self.minX >= currentPoint.x) {
            self.minX = currentPoint.x;
        }
    }
    if (self.maxY == 0 && self.minY == 0) {
        self.maxY = self.minY = currentPoint.y;
    } else {
        if (self.maxY <= currentPoint.y) {
            self.maxY = currentPoint.y;
        }
        if (self.minY >= currentPoint.y) {
            self.minY = currentPoint.y;
        }
    }

}
#pragma mark - 清理
- (void)clear {
    self.signaturePath = [UIBezierPath bezierPath];
    self.isHaveSignature = NO;
    self.oldPoint = CGPointZero;
    self.minX = 0;
    self.maxX = 0;
    self.minY = 0;
    self.maxY = 0;
    [self setNeedsDisplay];
}

#pragma mark - 确认
- (UIImage *)saveTheSignatureWithError:(void(^)(NSString *errorMsg))errorBlock {
    if (self.isHaveSignature) {
        [_clearBtn removeFromSuperview];
        
        //开启上下文
        UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO, [UIScreen mainScreen].scale);
        //获取上下文
        CGContextRef ref = UIGraphicsGetCurrentContext();
        //截图
        [self.layer drawInContext:ref];
        //获取整个视图图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        //获取绘画区域图片
        //需要获取图片真正的像素，求出比例
        NSInteger scale = CGImageGetHeight(image.CGImage) / image.size.height;
        //区域
        CGFloat space = 4;
        CGFloat x = self.minX * scale - space;
        CGFloat y = self.minY * scale - space;
        CGFloat width = (self.maxX - self.minX + space) * scale;
        CGFloat height = (self.maxY - self.minY + space) * scale;
        UIImage *drawImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(x, y, width, height))];
        if (!_hiddenClearBtn) {
            [self addSubview:_clearBtn];
        }
        
        //再次处理   压缩成比例像素
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(CGSizeMake( 324,151));
        // 绘制改变大小的图片
        [drawImage drawInRect:CGRectMake(0, 0, 324,151)];
        // 从当前context中创建一个改变大小后的图片
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片
        
//         UIImageWriteToSavedPhotosAlbum(scaledImage, self, nil, (__bridge void *)self);  //存到相册查看大小用的
        
        
        //清除签名
        [self clear];
        return scaledImage;
//        return filePath;
    } else {
        if (errorBlock) {
            errorBlock(@"签名不存在");
        }
        return nil;
    }

}
@end
