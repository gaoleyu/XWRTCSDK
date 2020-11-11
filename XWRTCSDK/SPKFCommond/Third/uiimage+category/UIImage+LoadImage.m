//
//  UIImage+LoadImage.m
//  AFNetworking
//
//  Created by XianHong zhang on 2020/11/5.
//

#import "UIImage+LoadImage.h"
#import "UIImageNameClass.h"
@implementation UIImage (LoadImage)
+ (nullable UIImage *)bundleImageNamed:(NSString *)name
{
    //开发
    NSBundle *frameworkBundle = [NSBundle bundleForClass:UIImageNameClass.class];
    //打包
//    NSBundle *frameworkBundle = [NSBundle mainBundle];

    NSURL *bundleUrl = [frameworkBundle.resourceURL URLByAppendingPathComponent:@"XWRTCImage.bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleUrl];
    if (resourceBundle) {
        
        UIImage *image = [UIImage imageWithContentsOfFile:[resourceBundle pathForResource:[NSString stringWithFormat:@"%@@2x",name] ofType:@"png"]];
        return image;
    }
    
    return [UIImage bundleImageNamed:name];
    
}
@end
