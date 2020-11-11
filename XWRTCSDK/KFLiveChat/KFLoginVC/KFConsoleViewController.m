//
//  KFConsoleViewController.m
//  ecmc
//
//  Created by zhangtao on 2020/4/13.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "KFConsoleViewController.h"
#import "KFLiveChatMainVC.h"
#import "KFLiveChatManager.h"
#import "KFWorkPlatomVC.h"
#import "KFLiveChatRequest.h"
#import "KFLiveChatParmas.h"
#import "LiveChatAlertVC.h"
#import "LiveChatRequest.h"
#import "SPKFUtilities.h"
@interface KFConsoleViewController ()<UITextFieldDelegate>

@property(nonatomic,assign)NSTimer *timer;

@end

@implementation KFConsoleViewController
{
    UITextField *crmTF;
    UITextField *phoneTF;
    UITextField *codeTF;
    UIButton *codeBtn;
    UIButton *logBtn;
    NSInteger countTime;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客服工作台";
     countTime = 60;
    [self createUI];

     [self createNavBack];
}

-(void)createNavBack{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
       [button addTarget:self
                  action:@selector(backBtn)
        forControlEvents:UIControlEventTouchUpInside];
       UIImage *imageBg = [UIImage bundleImageNamed:@"newnavbar_back"];
       button.frame = CGRectMake(0, 44, imageBg.size.width+15, imageBg.size.height);
       [button setImage:imageBg forState:UIControlStateNormal];
       [button setAdjustsImageWhenHighlighted:NO];
       button.titleLabel.textColor = [UIColor blueColor];
       [self.view addSubview:button];
}

-(void)createUI{
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(490*m6Scale);
    }];
    
    UIImageView *topImgV = [[UIImageView alloc]init];
    [topView addSubview:topImgV];
    topImgV.image = [UIImage bundleImageNamed:@"platworkheaderbg"];
    [topImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(topView);
    }];
    
    UILabel *topLab1 = [[UILabel alloc]init];
         topLab1.text = @"江苏移动";
         topLab1.font = [UIFont boldSystemFontOfSize:25];
         topLab1.textColor = [UIColor whiteColor];
         [topView addSubview:topLab1];
         [topLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerX.equalTo(topView.mas_centerX);
             make.top.mas_equalTo(50);
             make.height.mas_equalTo(40);
         }];
    
       UILabel *topLab = [[UILabel alloc]init];
       topLab.text = @"视频客服工作台";
       topLab.font = [UIFont boldSystemFontOfSize:25];
       topLab.textColor = [UIColor whiteColor];
       [topView addSubview:topLab];
       [topLab mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(topView.mas_centerX);
           make.top.mas_equalTo(topLab1.mas_bottom);
           make.height.mas_equalTo(40);
       }];
    
    
    UIView *logView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-165, 490*m6Scale-55, 660*m6Scale, 580*m6Scale)];
    logView.backgroundColor = [UIColor whiteColor];
    logView.layer.cornerRadius = 5.0;
    logView.layer.masksToBounds = YES;
    [self.view addSubview:logView];
//    [logView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(30);
//        make.top.equalTo(topView.mas_bottom).mas_equalTo(-55);
//        make.right.mas_equalTo(-30);
//        make.height.mas_equalTo(290*m6Scale);
//        make.width.mas_equalTo(330*m6Scale);
//    }];
    
    
    UILabel *logTitle = [[UILabel alloc]init];
    logTitle.text = @"登录";
    logTitle.font = [UIFont systemFontOfSize:20];
    logTitle.textAlignment = NSTextAlignmentCenter;
    [logView addSubview:logTitle];
    [logTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(logView);
        make.height.mas_equalTo(40);
    }];
    
    crmTF = [[UITextField alloc]init];
    [logView addSubview:crmTF];
    crmTF.keyboardType = UIKeyboardTypeNumberPad;
    crmTF.font = [UIFont systemFontOfSize:14];
    crmTF.placeholder = @"请输入CRM登录工号";
    crmTF.text = @"123456789";
    [crmTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logTitle.mas_bottom);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *crmLine = [[UILabel alloc]init];
    crmLine.backgroundColor = RGBCOLOR(229, 236, 246);
    [logView addSubview:crmLine];
    [crmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
        make.top.equalTo(crmTF.mas_bottom);
    }];
    
    phoneTF = [[UITextField alloc]init];
    [logView addSubview:phoneTF];
    phoneTF.delegate = self;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.font = [UIFont systemFontOfSize:14];
    phoneTF.placeholder = @"请输入手机号";
    phoneTF.text = @"15996408109";
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(crmLine.mas_bottom);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(60);
    }];
      
    UILabel *phoneLine = [[UILabel alloc]init];
    phoneLine.backgroundColor = RGBCOLOR(229, 236, 246);
    [logView addSubview:phoneLine];
    [phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
        make.top.equalTo(phoneTF.mas_bottom);
    }];
    
    codeTF = [[UITextField alloc]init];
    [logView addSubview:codeTF];
    codeTF.delegate = self;
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    codeTF.font = [UIFont systemFontOfSize:14];
    codeTF.placeholder = @"请输入6位验证码";
    codeTF.text = @"123456";
    [codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLine.mas_bottom);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-140);
        make.height.mas_equalTo(60);
    }];
         
    codeBtn = [[UIButton alloc]init];
    codeBtn.backgroundColor = RGBCOLOR(94, 153, 244);
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeBtn.layer.cornerRadius = 15;
    codeBtn.layer.masksToBounds = YES;
    [codeBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    [logView addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(30);
        make.right.equalTo(phoneLine.mas_right);
        make.centerY.equalTo(codeTF.mas_centerY);
    }];
    
         UILabel *codeLine = [[UILabel alloc]init];
         codeLine.backgroundColor = RGBCOLOR(229, 236, 246);
         [logView addSubview:codeLine];
         [codeLine mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.mas_equalTo(20);
             make.right.mas_equalTo(-20);
             make.height.mas_equalTo(1);
             make.top.equalTo(codeTF.mas_bottom);
         }];
    
    logBtn = [[UIButton alloc]init];
    [logBtn setTitle:@"登录" forState:UIControlStateNormal];
    logBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [logBtn setBackgroundImage:[UIImage bundleImageNamed:@"kfworkbtn_submit_bg"] forState:UIControlStateNormal];
    logBtn.backgroundColor = RGBCOLOR(94, 153, 244);
    logBtn.layer.cornerRadius = 17.5;
    logBtn.layer.masksToBounds = YES;
    [logBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logBtn];
    [logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logView.mas_left).offset(45);
        make.right.equalTo(logView.mas_right).offset(-45);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(logView.mas_bottom).mas_offset(-22);
    }];
    
    
//    logView.layer.shadowColor = RGBCOLOR(230, 249, 251).CGColor;//RGBCOLOR(149, 197, 252).CGColor;//
//      // 阴影偏移，默认(0, -3)
//      logView.layer.shadowOffset = CGSizeMake(7.0,7.0);
//      // 阴影透明度，默认0
//      logView.layer.shadowOpacity = 0.5;
//      // 阴影半径，默认3
//      logView.layer.shadowRadius = 10;
    CGRect logRect = logView.bounds;
    CGRect shadowRect = CGRectMake(logRect.origin.x-10, logRect.origin.y+10, logRect.size.width+20, logRect.size.height);
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:shadowRect];
    logView.layer.masksToBounds = NO;
    logView.layer.shadowColor = RGBCOLOR(230, 249, 251).CGColor;
    logView.layer.shadowOffset = CGSizeMake(0.0f, 10.0f);
    logView.layer.shadowOpacity = 0.5f;
    logView.layer.shadowPath = shadowPath.CGPath;
   
}

#pragma back
-(void)backBtn{
    [self dismissViewControllerAnimated:NO completion:nil];
    [[KFLiveChatManager installManager] closeLiveChatView];
}

-(void)submit{
//    KFLiveChatMainVC *viewC = [[KFLiveChatMainVC alloc] init];
//    viewC.modalPresentationStyle = 0;
//    [self presentViewController:viewC animated:NO completion:nil];
    
    if ([SPKFUtilities isValidString:crmTF.text] && [SPKFUtilities isValidString:phoneTF.text] && [SPKFUtilities isValidString:codeTF.text]) {

        NSDictionary *dic = @{@"staffNum":crmTF.text,@"mobile":phoneTF.text};
        [KFLiveChatRequest kfLiveChatLoginParams:dic Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
            if (isSuccess) {
                KFWorkPlatomVC *platom = [[KFWorkPlatomVC alloc]init];
                   platom.modalPresentationStyle = 0;
                   [self presentViewController:platom animated:NO completion:nil];
   
            }else{
                [self showNormalAlert:message];
            }
        }];
    }else{
        [self showNormalAlert:@"请输入正确信息"];
    }
}

-(void)showNormalAlert:(NSString *)des{
    LiveChatAlertVC *alert = [[LiveChatAlertVC alloc]init];
    alert.modalPresentationStyle = UIModalPresentationCustom;
    [alert showNormalAlertWithStr:des];
    [self presentViewController:alert animated:NO completion:nil];
}

-(void)sendCode{

    if (!_timer) {
        codeBtn.userInteractionEnabled = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cutDownTime) userInfo:nil repeats:YES];
    }
}

-(void)cutDownTime{
    
    if (countTime>0) {
        NSString *str = [NSString stringWithFormat:@"%lds",countTime--];
        [codeBtn setTitle:str forState:UIControlStateNormal];
    }else{
        countTime = 60;
        codeBtn.userInteractionEnabled = YES;
        [codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
        NSLog(@"......");
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == phoneTF) {
        if (range.location >= 11) {
            return NO;
        }
    }else if (textField == codeTF){
        if (range.location>=6) {
            return NO;
        }
    }
    
    return YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [crmTF resignFirstResponder];
    [phoneTF resignFirstResponder];
    [codeTF resignFirstResponder];
}

@end
