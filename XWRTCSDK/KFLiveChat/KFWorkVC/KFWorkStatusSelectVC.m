//
//  KFWorkStatusSelectVC.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/22.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "KFWorkStatusSelectVC.h"
#import "SPKFUtilities.h"
@interface KFWorkStatusSelectVC ()

@end

@implementation KFWorkStatusSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    //背景试图
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor =[UIColor blackColor];
    bgView.alpha = 0.4;
    [self.view addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeViewWithTap:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [bgView addGestureRecognizer:tap];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    //底部按钮
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    [bottomView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"切换工作状态";
    //工作按钮
    UIButton *workBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [workBtn setTitle:@"工  作" forState:UIControlStateNormal];
    [bottomView addSubview:workBtn];
    workBtn.backgroundColor = [UIColor getColor:@"5b91ff"];
    workBtn.layer.cornerRadius = 6;
    workBtn.layer.masksToBounds = YES;
    [workBtn addTarget:self action:@selector(workBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //休息按钮
    UIButton *sleepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:sleepBtn];
    sleepBtn.layer.cornerRadius = 6;
    sleepBtn.layer.masksToBounds = YES;
    [sleepBtn setTitle:@"休  息" forState:UIControlStateNormal];
    [sleepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sleepBtn.backgroundColor = RGBCOLOR(139, 136, 145);
    [sleepBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
   
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];
    [workBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-45);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(54);
    }];
    [sleepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-45);
        make.top.mas_equalTo(workBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(54);
    }];
}
- (void)closeViewWithTap:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark 取消按钮点击方法
- (void)cancelBtnAction:(UIButton *)btn{
    [self dismissViewControllerAnimated:NO completion:nil];
    if (_sleepBlock) {
        _sleepBlock();
    }
}
#pragma mark 工作按钮点击方法
- (void)workBtnClick:(UIButton *)btn{
    [self dismissViewControllerAnimated:NO completion:nil];
   
    if (_workBlock) {
        _workBlock();
    }
}


@end
