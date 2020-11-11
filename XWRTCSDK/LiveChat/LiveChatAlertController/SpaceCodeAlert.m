//
//  SpaceCodeAlert.m
//  ecmc
//
//  Created by zhangtao on 2020/4/13.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "SpaceCodeAlert.h"
#import "SPKFUtilities.h"
@implementation SpaceCodeAlert
{
    UILabel *titleLab;
    AreaTextField *codeTF;
    NSString *codeStr;
    
    UIButton *confirmBtn;  //确定
    UIButton *forgetBtn;//忘记密码
   
    int second;
}

#define titleTxt @"请在%dS内输入服务密码"
#define stitleTxt @"请在%dS内输入\n%@的服务密码"
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        [self createUI];
    }
    
    return self;
}

-(void)createUI{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 56*m6Scale, self.frame.size.width, self.frame.size.height-56*m6Scale-10*m6Scale)];
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    
    titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, self.frame.size.width, 29*m6Scale + 30)];
    [bgView addSubview:titleLab];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.numberOfLines = 0;
    titleLab.text = [NSString stringWithFormat:titleTxt,60];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = [UIColor getColor:@"333333"];
    
    CGFloat codeTFSpace = (self.frame.size.width-67*m6Scale*6)/7;
    codeTF = [[AreaTextField alloc]initWithFrame:CGRectMake(codeTFSpace, CGRectGetMaxY(titleLab.frame) + 46*m6Scale, (self.frame.size.width-codeTFSpace), 67*m6Scale)];
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    codeTF.areaWidth = 67*m6Scale;
    codeTF.originX = codeTFSpace;
    [bgView addSubview:codeTF];
    [codeTF boxInput:6 allowThird:YES textEntry:YES
            editDone:^(NSString * _Nonnull text) {
        if ([SPKFUtilities isValidString:text] && text.length == 6) {
            codeStr = text;
        }
    } deleteTxt:^{
        codeStr = @"";
    }];
    
    forgetBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2-50, CGRectGetMaxY(codeTF.frame)+29*m6Scale, 100, 26*m6Scale)];
    [forgetBtn setTag:service_code_forget];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor getColor:@"FF3753"] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:forgetBtn];
    
    UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(52*m6Scale, bgView.frame.size.height-53*m6Scale-77*m6Scale, 106, 77*m6Scale)];
    [clearBtn setTag:service_code_clear];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn setBackgroundColor:RGBCOLOR(140, 137, 127)];
    [clearBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.layer.cornerRadius = 5;
    clearBtn.layer.masksToBounds = YES;
    [bgView addSubview:clearBtn];
    
    confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width-106-52*m6Scale, bgView.frame.size.height-53*m6Scale-77*m6Scale, 106, 77*m6Scale)];
    [confirmBtn setTag:service_code_sure];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:RGBCOLOR(94, 148, 252)];
    [confirmBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.layer.masksToBounds = YES;
    [bgView addSubview:confirmBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-56*m6Scale-5,56*m6Scale+5,56*m6Scale, 56*m6Scale)];
//CGRectMake(self.frame.size.width/2-56*m6Scale/2,self.frame.size.height-56*m6Scale,56*m6Scale, 56*m6Scale)
    [cancelBtn setTag:service_code_cancel];
    [cancelBtn setBackgroundImage:[UIImage bundleImageNamed:@"alertclosedark"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    second = 60;
    if (!_serviceTimer) {
        _serviceTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(serviceInputCutdown) userInfo:nil repeats:YES];
    }
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerInvalidateNotificationMethod) name:@"kf_service_psd_cutdown_invalidate" object:nil];
}
-(void)hiddenForgetBtn{
    forgetBtn.hidden = YES;
}
- (void)setShowMobile:(NSString *)showMobile{
    _showMobile = showMobile;
    titleLab.text = [NSString stringWithFormat:stitleTxt,second,_showMobile];
}
-(void)serviceInputCutdown{
    if (second>0) {
//        dispatch_async(dispatch_get_main_queue(), ^{
            titleLab.text = [NSString stringWithFormat:titleTxt,--second];
        if (_showMobile) {
            titleLab.text = [NSString stringWithFormat:stitleTxt,--second,_showMobile];
        }else{
            titleLab.text = [NSString stringWithFormat:titleTxt,--second];
        }
        //        });
    }else{
        [self timerInvalidateNotificationMethod];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTag:service_code_overtime];
        [self click:btn];
    }
}

-(void)click:(UIButton *)btn{
    NSInteger tag = btn.tag;   //0.输入超时  1.忘记密码  2.清空   3.确定   4.取消
    
    if (tag == service_code_clear) {
        codeStr = nil;
        [codeTF clearInput];
    }else{
        
        if ([self spaceCodeCallBack]) {
            if (tag == service_code_sure && [SPKFUtilities isValidString:codeStr] && codeStr.length == 6) {
//                [_serviceTimer invalidate];
//                _serviceTimer = nil;
              //点击确定，通过通知走  invalidate
                NSString *code = codeStr;
                self.spaceCodeCallBack(tag, code);
                [codeTF clearInput];
                codeStr = nil;
            }else if(tag == service_code_forget || tag == service_code_cancel || tag == service_code_overtime){
//                [_serviceTimer invalidate];
//                _serviceTimer = nil;
                [self timerInvalidateNotificationMethod];
               self.spaceCodeCallBack(tag, @"");
            }
        }
    }
    
    
   
}

-(void)timerInvalidateNotificationMethod{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_serviceTimer invalidate];
    _serviceTimer = nil;
}

@end
