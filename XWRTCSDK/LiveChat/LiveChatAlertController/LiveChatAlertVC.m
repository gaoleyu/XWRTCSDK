//
//  LiveChatAlertVC.m
//  ecmc
//
//  Created by XianHong zhang on 2020/3/24.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "LiveChatAlertVC.h"
#import "LineSignNameView.h"
#import "UITextField+ZYDicKey.h"
#import "SpaceCodeAlert.h"
#import "SPKFUtilities.h"
@interface LiveChatAlertVC ()
{
    NSInteger _alertType;
    /**
    * 弹框类型
    * 0 等待页面提示弹框
    * 1 共享屏幕提示弹框
    * 2 服务密码输入弹框
    * 3 电子签名弹框
    * 4 个人信息弹框
    * 5 客户签名回显
    */
}

@property (nonatomic, strong) LineSignNameView *signNameView;

@property (nonatomic,strong) NSString *servicePsd;  //服务密码
@property (nonatomic, strong) NSString *subMobile;//副号

@end

@implementation LiveChatAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    //背景试图
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor =[UIColor blackColor];
    bgView.alpha = 0.4;
    [self.view addSubview:bgView];
  
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    
}
#pragma mark 普通提示弹框
- (void)showNormalAlertWithStr:(NSString *)str{
    [self alertSingleBtnWithDes:str sureBtn:@"确定" cancelBtn:@""];
    
}

#pragma mark 等待页面弹框
- (void)showWaitVCAlert{
    _alertType = 0;
    [self alertSingleBtnWithDes:@"您确定将您的屏幕共享给柜员吗？" sureBtn:@"确定" cancelBtn:@"取消"];
}

#pragma mark 电话接通页面
- (void)showDDJTAlertWithStr:(NSString *)str{
   
    [self alertSingleBtnWithDes:str sureBtn:@"立即进入" cancelBtn:@"挂断视频"];
    
}

#pragma mark 个性签名
- (void)lineSignNameAlert{
    _alertType = 3;
    // 弹框背景图
    UIView *alertView = [UIView new];
    alertView.backgroundColor = [UIColor getColor:@"54585b"];
    alertView.layer.cornerRadius = 9;
    alertView.layer.masksToBounds = YES;
    [self.view addSubview:alertView];
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    gradient.frame =CGRectMake(0,0,kScreen_Height,kScreen_Width);
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor getColor:@"1D52CA"].CGColor,(id)[UIColor getColor:@"FFFFFF"].CGColor,nil];
    [alertView.layer insertSublayer:gradient atIndex:0];
    
    
    //标题和内容
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.text = @"请在下面输入签名";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:titleLabel];
    
    _signNameView = [[LineSignNameView alloc] initWithFrame:CGRectZero];
    _signNameView.clearBtn.hidden = YES;
    [alertView addSubview:_signNameView];
 
    UILabel *desLab = [[UILabel alloc]init];
    [alertView addSubview:desLab];
    desLab.font = [UIFont systemFontOfSize:12.5];
    desLab.textColor = [UIColor clearColor];//[UIColor getColor:@"5E8EFF"];
    desLab.textAlignment = NSTextAlignmentCenter;
    desLab.text = @"温馨提示：业务办理成功10分钟后您可在“掌厅首页-查询服务宫格-电子协议”中进行本次办理业务协议查询。";
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = RGBCOLOR(133, 130, 140);
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [alertView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.backgroundColor = RGBCOLOR(93, 161, 252);//titleLabel.textColor;
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [alertView addSubview:sureBtn];
    
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(statusHeight/2);
        make.width.mas_equalTo(kScreen_Height-statusHeight);
        make.height.mas_equalTo(kScreen_Width);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(100*m6Scale);
    }];

    [_signNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(57*m6Scale);
        make.right.mas_equalTo(-57*m6Scale);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.bottom.mas_equalTo(-186*m6Scale);
    }];
   
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.equalTo(_signNameView.mas_bottom).mas_offset(27*m6Scale);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(257*m6Scale);
        make.height.mas_equalTo(78*m6Scale);
        make.left.mas_equalTo(357*m6Scale);
        make.top.equalTo(desLab.mas_bottom).mas_offset(28*m6Scale);
       
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(257*m6Scale);
        make.height.mas_equalTo(78*m6Scale);
        make.right.mas_equalTo(-313*m6Scale);
        make.top.equalTo(desLab.mas_bottom).mas_offset(28*m6Scale);
    }];
    
    [alertView setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
}



#pragma mark 服务密码输入弹框
-(void)showServicePsdEnterAlert{
    _alertType = 2;
    CGFloat alertWidth = 556*m6Scale;
    CGFloat alertHeight = 498*m6Scale;
    SpaceCodeAlert *alert = [[SpaceCodeAlert alloc]initWithFrame:CGRectMake(kScreen_Width/2-alertWidth/2, kScreen_Height/2-alertHeight/2-56*m6Scale, alertWidth, alertHeight)];
    [self.view addSubview:alert];
    __weak LiveChatAlertVC *weakSelf = self;
    [alert setSpaceCodeCallBack:^(NSInteger btnTag, id  _Nonnull psd) {
        if(btnTag == service_code_overtime){
            //输入超时
            [weakSelf psdOverTime];
        }else if (btnTag == service_code_cancel) {
            [weakSelf cancelBtnAction:nil];
        }else if (btnTag == service_code_sure){
            self.servicePsd = psd;
            [weakSelf sureBtnAction:nil];
        }else if (btnTag == service_code_forget){
            [weakSelf forgetServicePsd];
        }
    }];
}
#pragma mark 副号服务密码输入弹框
-(void)showSubMobilePsdEnterAlertWithMobile:(NSString *)mobile{
    _alertType = 2;
    _subMobile = mobile;
    CGFloat alertWidth = 556*m6Scale;
    CGFloat alertHeight = 498*m6Scale;
    SpaceCodeAlert *alert = [[SpaceCodeAlert alloc]initWithFrame:CGRectMake(kScreen_Width/2-alertWidth/2, kScreen_Height/2-alertHeight/2-56*m6Scale, alertWidth, alertHeight)];
    alert.showMobile = mobile;
    [alert hiddenForgetBtn];
    [self.view addSubview:alert];
    __weak LiveChatAlertVC *weakSelf = self;
    [alert setSpaceCodeCallBack:^(NSInteger btnTag, id  _Nonnull psd) {
        if(btnTag == service_code_overtime){
            //输入超时
            [weakSelf psdOverTime];
        }else if (btnTag == service_code_cancel) {
            [weakSelf cancelBtnAction:nil];
        }else if (btnTag == service_code_sure){
            self.servicePsd = psd;
            [weakSelf sureBtnAction:nil];
        }else if (btnTag == service_code_forget){
            [weakSelf forgetServicePsd];
        }
    }];
}

-(void)showBackSignNameAlert:(UIImage *)image{
    // 弹框背景图
    _alertType = 5;
    UIView *alertView = [UIView new];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 8;
    alertView.layer.masksToBounds = YES;
    [self.view addSubview:alertView];
    
    //上半部背景
    UIImageView *topbgImgv = [[UIImageView alloc]init];
    topbgImgv.image = [UIImage bundleImageNamed:@"signNameBackHead"];
    [alertView addSubview:topbgImgv];
    
    UILabel *titleLab = [[UILabel alloc]init];
    [alertView addSubview:titleLab];
    titleLab.text = @"电子签名验证";
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textColor = [UIColor getColor:@"FFFFFF"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    
    UIImageView *signNameImg = [[UIImageView alloc]init];
    [alertView addSubview:signNameImg];
    if (image) {
        signNameImg.image = image;
    }
    signNameImg.layer.borderColor = [UIColor getColor:@"5B8CFF"].CGColor;
    signNameImg.layer.borderWidth = 2;
    signNameImg.layer.masksToBounds = YES;
    
      //右上角X按钮
    UIButton *xBtn = [[UIButton alloc]init];
    [xBtn setBackgroundImage:[UIImage bundleImageNamed:@"alertclose"] forState:UIControlStateNormal];
    [xBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:xBtn];
         
      //确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setBackgroundImage:[UIImage bundleImageNamed:@"alertSure"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"通过" forState:UIControlStateNormal];
    [alertView addSubview:sureBtn];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];;
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(signAgainClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage bundleImageNamed:@"alertSure"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitle:@"重新签名" forState:UIControlStateNormal];
    [alertView addSubview:cancelBtn];
    
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(546*m6Scale);
        make.height.mas_equalTo(522*m6Scale);
    }];
      
    [topbgImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(122*m6Scale);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topbgImgv.mas_centerX);
        make.centerY.equalTo(topbgImgv.mas_centerY);
    }];

         
    [xBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(22);
        make.top.mas_equalTo(9);
        make.right.mas_equalTo(-9);
    }];
    
    [signNameImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.top.mas_equalTo(topbgImgv.mas_bottom).mas_offset(9);
        make.right.mas_equalTo(-22);
        make.bottom.mas_equalTo(-66);
    }];
      
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(alertView.centerX).multipliedBy(1.5);
        make.bottom.mas_equalTo(-18);
        make.width.mas_equalTo(106);
        make.height.mas_equalTo(38);
    }];
         
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(alertView.centerX).multipliedBy(.5);
        make.bottom.mas_equalTo(-18);
        make.width.mas_equalTo(106);
        make.height.mas_equalTo(38);
    }];
      
}
#pragma mark  超时
-(void)psdOverTime{
    [self dismissViewControllerAnimated:NO completion:nil];
    if (_psdOverTimeBlock) {
        _psdOverTimeBlock();
    }
}

#pragma mark  重新推送签名
-(void)signAgainClick{
    [self dismissViewControllerAnimated:NO completion:nil];
    if (_signAgainBlock) {
        _signAgainBlock();
    }
}

#pragma mark 服务密码输入弹框--忘记服务密码
-(void)forgetServicePsd{
    [self dismissViewControllerAnimated:NO completion:nil];
    if (_resetPWDBlock) {
        _resetPWDBlock();
    }
}

#pragma mark 取消按钮
- (void)cancelBtnAction:(UIButton *)cancelBtn{
    [self dismissViewControllerAnimated:NO completion:nil];
    if (_cancelBlock) {
        _cancelBlock();
    }
}
#pragma mark 确定按钮
- (void)sureBtnAction:(UIButton *)sureBtn{
    if (_alertType !=2 && _alertType != 5) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    if (_sureBlock) {
        if (_alertType == 2) {
            if (_subMobile) {
                _sureBlock(@{@"pwd":_servicePsd,@"mobile":_subMobile});
            }else{
                _sureBlock(_servicePsd);
            }
            
        }else if (_alertType == 3){
            UIImage *img =  [_signNameView saveTheSignatureWithError:^(NSString * _Nonnull errorMsg) {
                
            }];
            _sureBlock(img);
            
        }else if (_alertType == 4){
            
        }else{
            _sureBlock(@"");
        }
    }
}
#pragma mark 协议按钮点击方法
- (void)xyBtnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    
}
- (void)xyContentBtnAction:(UIButton *)btn{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



#pragma mark  统一按钮弹框
/// @param des 提示信息
/// @param sureBtnTitle  确定按钮文字
/// @param cancelBtnTitle 取消按钮文字
-(void)alertSingleBtnWithDes:(NSString *)des sureBtn:(NSString *)sureBtnTitle cancelBtn:(NSString *)cancelBtnTitle{
        
    // 弹框背景图
    UIView *alertView = [UIView new];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 8;
    alertView.layer.masksToBounds = YES;
    [self.view addSubview:alertView];
    
    //上半部背景
    UIImageView *topbgImgv = [[UIImageView alloc]init];
    topbgImgv.image = [UIImage bundleImageNamed:@"KFAlertTopbgImg"];
    [alertView addSubview:topbgImgv];
    
       //内容
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [UIColor getColor:@"333333"];
    [alertView addSubview:self.contentLabel];
    self.contentLabel.text = des;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
       
    //右上角X按钮
    UIButton *xBtn = [[UIButton alloc]init];
    [xBtn setBackgroundImage:[UIImage bundleImageNamed:@"alertclose"] forState:UIControlStateNormal];
    [xBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:xBtn];
       
    //确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setBackgroundImage:[UIImage bundleImageNamed:@"alertSure"] forState:UIControlStateNormal];
    [sureBtn setTitle:sureBtnTitle forState:UIControlStateNormal];
    [alertView addSubview:sureBtn];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];;
    if (![SPKFUtilities isValidString:sureBtnTitle]) {
        sureBtn.hidden = YES;
    }
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage bundleImageNamed:@"livechatcancel"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
    [alertView addSubview:cancelBtn];
    if (![SPKFUtilities isValidString:cancelBtnTitle]) {
        cancelBtn.hidden = YES;
    }

    CGSize contentSize = [self.contentLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-100-30, MAXFLOAT)];
    CGFloat btmBtnH = ((![SPKFUtilities isValidString:sureBtnTitle] && ![SPKFUtilities isValidString:cancelBtnTitle])?0:38+18);
    
    CGFloat alertH = (SCREEN_WIDTH-100)*.48 + 22 + contentSize.height + 16+ btmBtnH;
    
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH-100);
        make.height.mas_equalTo(alertH);
    }];
    
    [topbgImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(alertView.mas_width).multipliedBy(.48);
    }];
     
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(topbgImgv.mas_bottom).mas_offset(22);
        make.height.mas_equalTo(contentSize.height);
    }];
       
    [xBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(22);
        make.top.mas_equalTo(9);
        make.right.mas_equalTo(-9);
    }];
    
    if (![SPKFUtilities isValidString:cancelBtnTitle] && [SPKFUtilities isValidString:sureBtnTitle]) {
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(alertView.centerX);
            make.bottom.mas_equalTo(-18);
            make.width.mas_equalTo(106);
            make.height.mas_equalTo(38);
        }];
    }else if ([SPKFUtilities isValidString:cancelBtnTitle] && ![SPKFUtilities isValidString:sureBtnTitle]){
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(alertView.centerX);
            make.bottom.mas_equalTo(-18);
            make.width.mas_equalTo(106);
            make.height.mas_equalTo(38);
        }];
    }
    else if([SPKFUtilities isValidString:cancelBtnTitle] && [SPKFUtilities isValidString:sureBtnTitle]){
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(alertView.centerX).multipliedBy(1.5);
                  make.bottom.mas_equalTo(-18);
                  make.width.mas_equalTo(106);
                  make.height.mas_equalTo(38);
        }];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(alertView.centerX).multipliedBy(.5);
            make.bottom.mas_equalTo(-18);
            make.width.mas_equalTo(106);
            make.height.mas_equalTo(38);
        }];
    }
    
    
      
}
- (void)dealloc{
    
    
}

@end
