//
//  KFLiveChatWaitVC.m
//  ScreeenDemo
//
//  Created by XianHong zhang on 2020/4/13.
//  Copyright © 2020 XianHong zhang. All rights reserved.
//

#import "KFLiveChatWaitVC.h"
#import "SPKFUtilities.h"
#import "KFLiveChatMainVC.h"
@interface KFLiveChatWaitVC ()


@end

@implementation KFLiveChatWaitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIImageView *imgV = [[UIImageView alloc] init];
    [self.view addSubview:imgV];
    //75/49
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    CGFloat sh = [UIScreen mainScreen].bounds.size.height;
    CGFloat imgHeight = sw*286/375;
    imgV.frame = CGRectMake(0, 0, sw, imgHeight);
    imgV.image = [UIImage bundleImageNamed:@"waitheaderbg"];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:25];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    titleLabel.text = @"正在等待客户确认";
    //副标题
    UILabel *subLabel = [[UILabel alloc] init];
    [self.view addSubview:subLabel];
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.font = [UIFont systemFontOfSize:17];
    subLabel.text = @"183****9916接入中...";
    
    //底部提示
    UILabel *tsLabel = [[UILabel alloc] init];
    tsLabel.font = [UIFont systemFontOfSize:17];
    tsLabel.textAlignment = NSTextAlignmentCenter;
    tsLabel.textColor = [UIColor redColor];
    tsLabel.backgroundColor = [UIColor whiteColor];
    tsLabel.text = @"温馨提示：客户端60s内未确认，将自动挂断";
    [self.view addSubview:tsLabel];
    
    
    titleLabel.frame = CGRectMake(0, sh/2, sw, 40);
    subLabel.frame = CGRectMake(0, titleLabel.frame.origin.y+40, sw, 30);
    tsLabel.frame = CGRectMake(0, sh-60, sw, 60);
    
//60s后自动关闭
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self openSPChatViewController];
    });
    
}


//打开视频客服页面
- (void)openSPChatViewController{
    
    UIViewController *presentVC = self.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:nil];
    KFLiveChatMainVC *mainVC = [[KFLiveChatMainVC alloc] init];
//    mainVC.acceptDic = nil;
    mainVC.modalPresentationStyle = 0;
    [presentVC presentViewController:mainVC animated:NO completion:nil];
}

- (void)dealloc{
  
}

@end
