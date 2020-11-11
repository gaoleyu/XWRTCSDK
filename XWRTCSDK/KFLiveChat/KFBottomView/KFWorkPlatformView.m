//
//  KFWorkPlatformView.m
//  ScreeenDemo
//
//  Created by XianHong zhang on 2020/4/13.
//  Copyright © 2020 XianHong zhang. All rights reserved.
//

#import "KFWorkPlatformView.h"
#import "Masonry.h"
#import "SPKFUtilities.h"
@implementation KFWorkPlatformView
{
    
    //创建时期的时间戳
    NSTimeInterval creatTimeLength;
    //提示label
    UILabel *timeLabel;
    //标题
    UILabel *titleLabel;
    UIButton *closeBtn;
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews{
    _yhid = @"";
    timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor getColor:@"999999"];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.text = @"当前服务客户，通话时长00:00";
    [self addSubview:timeLabel];
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage bundleImageNamed:@"my_homeV_xialajiantou"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage bundleImageNamed:@"my_homeV_shanglajiantou"] forState:UIControlStateSelected];
    [closeBtn addTarget:self action:@selector(openCloseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:closeBtn];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineView];
    [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(closeBtn.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    creatTimeLength = [[NSDate date] timeIntervalSince1970];
    //标题
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"用户信息";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:titleLabel];
    //phone
    _phoneLabel = [[UILabel alloc] init];
    [self addSubview:_phoneLabel];
    _phoneLabel.font = [UIFont systemFontOfSize:14];
    _phoneLabel.text = @"当前号码:--";
    _phoneLabel.textColor = [UIColor getColor:@"717171"];
    //name
    
    _nameLabel = [[UILabel alloc] init];
    [self addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.text = @"客户姓名:--";
    _nameLabel.textColor = _phoneLabel.textColor;
    
    //属地
    _localLabel = [[UILabel alloc]init];
    [self addSubview:_localLabel];
    _localLabel.font = [UIFont systemFontOfSize:14];
    _localLabel.text = @"所属地市:--";
    _localLabel.textColor = _phoneLabel.textColor;
    
    
    //业务
    
    _ywLabel = [[UILabel alloc] init];
    [self addSubview:_ywLabel];
    _ywLabel.text = @"拟办业务:宽带，充值";
    _ywLabel.font = [UIFont systemFontOfSize:14];
    _ywLabel.textColor = _phoneLabel.textColor;
    //工作台
    UILabel *workLabel = [[UILabel alloc] init];
    [self addSubview:workLabel];
    workLabel.text = @"工作台";
    workLabel.font = [UIFont boldSystemFontOfSize:20];
    
    UIButton *overCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [overCloseBtn addTarget:self action:@selector(openCloseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:overCloseBtn];
    [overCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
   [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.right.mas_equalTo(0);
       make.width.mas_equalTo(50);
       make.height.mas_equalTo(40);
   }];
   [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.mas_equalTo(-50);
       make.left.mas_equalTo(50);
       make.top.mas_equalTo(0);
       make.height.mas_equalTo(40);
   }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLabel.mas_bottom);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phoneLabel.mas_bottom);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    [_localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(_nameLabel.mas_bottom);
           make.left.mas_equalTo(20);
           make.right.mas_equalTo(0);
           make.height.mas_equalTo(25);
       }];
    [_ywLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_localLabel.mas_bottom);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    [workLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ywLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    //推密码，推签名
    _passwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_passwordBtn];
    _signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_signBtn];
    
//    _passwordBtn.layer.cornerRadius = 15;
//    _passwordBtn.layer.masksToBounds = YES;
    _passwordBtn.backgroundColor = [UIColor orangeColor];
    [_passwordBtn addTarget:self action:@selector(sendPassword) forControlEvents:UIControlEventTouchUpInside];
    _passwordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
//    _signBtn.layer.cornerRadius = 15;
//    _signBtn.layer.masksToBounds = YES;
//    _signBtn.backgroundColor = [UIColor orangeColor];
    [_signBtn addTarget:self action:@selector(sendSign) forControlEvents:UIControlEventTouchUpInside];
    _signBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_passwordBtn setTitle:@"推密码" forState:UIControlStateNormal];
    [_signBtn setTitle:@"推送电子签名" forState:UIControlStateNormal];
    [_signBtn setBackgroundImage:[UIImage bundleImageNamed:@"platworkbtnbg"] forState:UIControlStateNormal];
    [_passwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.mas_equalTo(workLabel.mas_bottom).offset(10);
    }];
    [_signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_passwordBtn.mas_right).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(285);
        make.top.mas_equalTo(workLabel.mas_bottom).offset(10);
    }];
    _passwordBtn.hidden = YES;
}

//隐藏展示按钮
- (void)openCloseBtnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    closeBtn.selected = !closeBtn.selected;
    CGFloat frameY = 0;
    CGFloat titleLabelFrameY = 0;
    if (btn.selected) {
        frameY = kScreen_Height-40;
        if (@available(iOS 11.0, *)) {
            if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
                titleLabelFrameY = btn.bottom + [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
                frameY = kScreen_Height-40-[[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
            }
        }
    }else{
        frameY = kScreen_Height-self.height;
        titleLabelFrameY = btn.bottom;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, frameY, self.width, self.height);
    }];
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(titleLabelFrameY);
                make.left.mas_equalTo(20);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(40);
            }];
        }
    }
}
#pragma mark 更新通话时长
- (void)updateTimeLabelText{
    NSTimeInterval currentTimeLength = [[NSDate date] timeIntervalSince1970];
    NSInteger distance = currentTimeLength - creatTimeLength;
    //计算时长
    //分钟
    NSInteger min = distance/60;
    //秒
    NSInteger s = distance%60;
    
    timeLabel.text = [NSString stringWithFormat:@"当前服务客户%@，通话时长%02ld:%02ld",_yhid,min,s];
    
}
- (void)sendPassword{
    if (_passwordBlock) {
        _passwordBlock();
    }
}
- (void)sendSign{
    if (_signBlock) {
        _signBlock();
    }
}

@end
