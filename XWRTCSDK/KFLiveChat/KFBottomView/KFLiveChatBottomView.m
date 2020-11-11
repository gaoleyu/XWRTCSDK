//
//  KFLiveChatBottomView.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/3.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "KFLiveChatBottomView.h"
#import "SPKFUtilities.h"
@implementation KFLiveChatBottomView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews{
   
    //挂断按钮
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_backBtn];
    [_backBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
 
    UILabel *closeLabel = [[UILabel alloc] init];
    closeLabel.textAlignment = NSTextAlignmentCenter;
    closeLabel.textColor = [UIColor whiteColor];
    closeLabel.text = @"挂断";
    closeLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:closeLabel];

    [_backBtn setImage:[UIImage bundleImageNamed:@"livechatclose"] forState:UIControlStateNormal];
    
    
   

    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.right.mas_equalTo(0);
        
        make.width.height.mas_equalTo(57);
    }];
    [closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_backBtn.mas_centerX);
        make.top.mas_equalTo(_backBtn.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    
}



- (void)closeBtnAction:(UIButton *)btn{
    if (_closeBtnBlock) {
        _closeBtnBlock();
    }
}


@end
