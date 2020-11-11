//
//  KFWorkPlatformView.h
//  ScreeenDemo
//
//  Created by XianHong zhang on 2020/4/13.
//  Copyright © 2020 XianHong zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFWorkPlatformView : UIView


@property (nonatomic, copy) void (^passwordBlock)();
@property (nonatomic, copy) void (^signBlock)();

//弹密码按钮
@property (nonatomic, strong) UIButton *passwordBtn;
//弹签名按钮
@property (nonatomic, strong) UIButton *signBtn;

@property (nonatomic, strong)UILabel *phoneLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *localLabel;
@property (nonatomic, strong)UILabel *ywLabel;

//用户手机号
@property (nonatomic, strong) NSString *yhid;

//更新通话时长
- (void)updateTimeLabelText;

@end


