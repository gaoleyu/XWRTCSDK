//
//  PlayGIF.m
//  ARDemo
//
//  Created by XianHong zhang on 2020/1/14.
//  Copyright © 2020 XianHong zhang. All rights reserved.
//

#import "PlayGIF.h"
#import "UIImage+GIF.h"
#import "SPKFUtilities.h"
@implementation PlayGIF
{
    UIImageView *imgeV;
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        imgeV = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imgeV];
        
        [imgeV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        [self showWaitGif:@"kfwait"];
    }
    return self;
}
- (void)showWaitGif:(NSString *)gifName{
    NSString *path = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIImage *image = [UIImage sd_imageWithGIFData:data];
        imgeV.image = image;
    }];
}

//获取图片数组
- (NSMutableArray *)loadGifArray
   {
   NSString *path = [[NSBundle mainBundle] pathForResource:@"kfwait" ofType:@"gif"];
   NSData *data = [NSData dataWithContentsOfFile:path];
   //目标数组
   NSMutableArray *images = [self praseGIFDataToImageArray:data];
   
   return images;
   }
   
//gif转化为imageView动画数组
- (NSMutableArray *)praseGIFDataToImageArray:(NSData *)data;
   {
   NSMutableArray *frames = [[NSMutableArray alloc] init];
   CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
   CGFloat animationTime = 0.f;
   if (src) {
       size_t l = CGImageSourceGetCount(src);
       frames = [NSMutableArray arrayWithCapacity:l];
       for (size_t i = 0; i < l; i++) {
           CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
           NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
           NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
           NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
           animationTime += [delayTime floatValue];
           if (img) {
               [frames addObject:[UIImage imageWithCGImage:img]];
               CGImageRelease(img);
           }
       }
       CFRelease(src);
   }
   return frames;
}

@end
