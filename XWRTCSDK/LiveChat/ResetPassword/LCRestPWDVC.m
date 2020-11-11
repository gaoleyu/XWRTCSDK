//
//  LCRestPWDVC.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/22.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "LCRestPWDVC.h"
#import "SPKFUtilities.h"
@interface LCRestPWDVC ()

@end

@implementation LCRestPWDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updatebgviewframe];
    
   
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage bundleImageNamed:@"WebViewCustom_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction:)];
}

- (void)backBtnAction:(UIButton *)btn{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)ButtonLogin{
    
    [self updatebgviewframe];
}

- (void)tap{
    
    [self updatebgviewframe];
}
- (void)updatebgviewframe{
    float bgViewTop = 64;
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            bgViewTop = bgViewTop + [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        }
    }
   
}

@end
