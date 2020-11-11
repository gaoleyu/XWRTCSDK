//
//  ChatWaitViewController.m
//  ecmc
//
//  Created by XianHong zhang on 2020/3/24.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "ChatWaitViewController.h"
#import "LiveChatAlertVC.h"


#import "LiveChatManager.h"
#import "LCHeartManager.h"
#import "LiveChatPlayMusic.h"
#import "PlayGIF.h"
#import "LiveChatRequest.h"
#import "KFLCHeartManager.h"
#import "SPKFUtilities.h"
@interface ChatWaitViewController ()<LCheartManagerDelegate>
{
    LiveChatAlertVC *passServiceAlert; //过号弹框
    LiveChatAlertVC *alert;
    //60s倒计时
    NSInteger timeCount;
}
@property (nonatomic, assign) int count;
@property (nonatomic, strong) PlayGIF *headerImgV;
@property (nonatomic, strong) UILabel *countLabel;
//是否展示确认进入弹框
@property (nonatomic, assign) BOOL isShowJoinAlert;

@property (nonatomic, assign) BOOL isSelectAction;//60s内是否已经选择挂断或进入

@end

@implementation ChatWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _count = 0;
    
    
    _headerImgV = [PlayGIF new];
    [self.view addSubview:_headerImgV];
    //缩放按钮
    UIButton *_scalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_scalBtn];
    [_scalBtn setImage:[UIImage bundleImageNamed:@"suofang"] forState:UIControlStateNormal];
    _scalBtn.frame = CGRectMake(10, 45, 40, 40);
    [_scalBtn addTarget:[LiveChatManager installManager] action:@selector(smallLiveChatView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [UILabel new];
    [self.view addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    //    titleLabel.textColor = [UIColor getColor:@"027db4"];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor getColor:@"444444"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"感谢您使用视频营业厅";
    
    _countLabel = [UILabel new];
    [self.view addSubview:_countLabel];
    _countLabel.numberOfLines = 0;
    _countLabel.textColor = [UIColor getColor:@"444444"];
    _countLabel.font = [UIFont systemFontOfSize:20];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self updateWaitCountLabel];
    
    UILabel *mobileLabel = [UILabel new];
    [self.view addSubview:mobileLabel];
    mobileLabel.numberOfLines = 0;
    mobileLabel.textColor = [UIColor whiteColor];
    mobileLabel.backgroundColor = [UIColor getColor:@"547CE4"];
    mobileLabel.font = [UIFont systemFontOfSize:15];
    mobileLabel.textAlignment = NSTextAlignmentCenter;
    mobileLabel.text = @"移动网络将产生一定的流量";
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage bundleImageNamed:@"cancelwaitbtb"] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    //    closeBtn.layer.cornerRadius = 40;
    //    closeBtn.layer.masksToBounds = YES;
    //    closeBtn.backgroundColor = [UIColor redColor];
    //75/69
    CGFloat imgw = kScreen_Width;
    CGFloat imgh = imgw*69/75;
    [_headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(imgh);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headerImgV.mas_bottom).offset(40);
        make.left.right.mas_equalTo(0);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
    }];
    //571/147
    CGFloat btnw = kScreen_Width - 100;
    CGFloat btnh = btnw*147/571;
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(btnw);
        make.height.mas_equalTo(btnh);
        make.top.mas_equalTo(_countLabel.mas_bottom).offset(40);
    }];
    float signheight = 28;
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            signheight = signheight + [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        }
    }
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(signheight);
    }];
    
    [self getNum];
    [LCHeartManager installManager].delegate =  self;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkAuthor];
}

#pragma mark   直接挂断
-(void)logOut{
    [LiveChatRequest liveChatLogOutResult:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
        
    }];
}

-(void)checkAuthor{
    
      LiveChatAlertVC *alertVC = [[LiveChatAlertVC alloc] init];
      alertVC.modalPresentationStyle = UIModalPresentationCustom;
      
      __weak ChatWaitViewController *weakSelf = self;
    [alertVC setSureBlock:^(id  _Nonnull obj) {
            
        [weakSelf closeLiveChat];
    }];
     [alertVC setCancelBlock:^{
         [weakSelf closeLiveChat];
     }];
    
      NSString *autherStatus = [KFLCHeartManager checkAuthor];
      if ([SPKFUtilities isValidString:autherStatus]) {
          [alertVC showNormalAlertWithStr:autherStatus];
          [self presentViewController:alertVC animated:NO completion:nil];
      }
      
}

#pragma mark 取号
- (void)getNum{
    
    LiveChatAlertVC *alertVC = [[LiveChatAlertVC alloc] init];
    alertVC.modalPresentationStyle = UIModalPresentationCustom;
    
    __weak ChatWaitViewController *weakSelf = self;
      [alertVC setSureBlock:^(id  _Nonnull obj) {
          
          [weakSelf closeLiveChat];
      }];
    
    NSString *autherStatus = [KFLCHeartManager checkAuthor];
    if ([SPKFUtilities isValidString:autherStatus]) {
      
        return;
    }
    
    if ([SPKFUtilities isValidDictionary:[LiveChatManager installManager].ywResultDic]) {
        NSDictionary *resultDic = [LiveChatManager installManager].ywResultDic;
        [self updateView:resultDic];
        [LiveChatManager installManager].ywResultDic = nil; //用后置空
        [[LCHeartManager installManager] startTimer];
    }else{
        //取号
        [LiveChatRequest liveChatUpSelectYW:_ywID Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
            if (isSuccess) {
                if ([SPKFUtilities isValidDictionary:response]) {
                    NSDictionary *resultDic = response[@"result"];
                    [self updateView:resultDic];
                }
                [[LCHeartManager installManager] startTimer];
            }else{
                [alertVC showNormalAlertWithStr:message];
                [self presentViewController:alertVC animated:NO completion:nil];
            }
        }];
    }
}
#pragma mark 更新页面数据
- (void)updateView:(NSDictionary *)dataDic{
    /*{
     acceptNum = "1255043822505689088",
     waitPosition = 2,
     queueNum = "DEFAULT",
     }*/
    if ([SPKFUtilities isValidDictionary:dataDic]) {
        NSString *waitCount = dataDic[@"waitPosition"];
        //        NSString *acceptNum = dataDic[@"acceptNum"];
        if ([SPKFUtilities isValidString:waitCount] || [waitCount isKindOfClass:[NSNumber class]]) {
            _count = waitCount.intValue;
            [self updateWaitCountLabel];
        }
        //acceptNum 受理编码
        if ([SPKFUtilities isValidString:dataDic[@"acceptNum"]]) {
            [LiveChatParmas installParmas].acceptNum = dataDic[@"acceptNum"];
        }
    }
}
#pragma mark 更新等待人数
- (void)updateWaitCountLabel{
    _countLabel.text = [NSString stringWithFormat:@"当前排队%d人，请耐心等待...",_count];
    NSString *countStr = [NSString stringWithFormat:@"%d",_count];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:_countLabel.text];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor getColor:@"5A98FF"]} range:NSMakeRange(4, countStr.length)];
    [_countLabel setAttributedText:attStr];
}

#pragma mark 监听心跳数据
- (void)timerActionDelete {
    if (_isShowJoinAlert) {
        if (alert) {
            timeCount --;
            if (timeCount > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    alert.contentLabel.text = [NSString stringWithFormat:@"工号%@客服为您服务 \n请在%lds内确认",[LiveChatParmas installParmas].staffNum,timeCount];
                });//@"工号%@客服为您服务，是否进入？\n请在%lds内确认"
                
            }else{
//                [self closeBtnAction:nil];
                [[LCHeartManager installManager] stopTimer];
                [self logOut];
                [self closeLiveChat];
            }
            
        }
    }
}
- (void)requeSuccessWithDataDic:(NSDictionary *)dic{
    if ([SPKFUtilities isValidDictionary:dic]) {
        NSDictionary *resultDic = dic[@"result"];
        
        if ([SPKFUtilities isValidDictionary:resultDic]) {
            
            
            NSDictionary *userdic = resultDic[@"forUser"];
            if ([SPKFUtilities isValidDictionary:userdic]) {
                NSString *waitPosition = userdic[@"waitPosition"];
                if ([SPKFUtilities isValidString:waitPosition] || [waitPosition isKindOfClass:[NSNumber class]]) {
                    _count = waitPosition.intValue;
                    [self updateWaitCountLabel];
                }
                //acceptNum 受理编码
                if ([SPKFUtilities isValidString:userdic[@"acceptNum"]]) {
                    [LiveChatParmas installParmas].acceptNum = userdic[@"acceptNum"];
                }
                if ([SPKFUtilities isValidString:userdic[@"roomNum"]]) {
                    [LiveChatParmas installParmas].roomNum = userdic[@"roomNum"];
                }
                if ([SPKFUtilities isValidString:userdic[@"staffNum"]]) {
                    [LiveChatParmas installParmas].staffNum = userdic[@"staffNum"];
                }
            }
            //处理心跳状态
            [KFLCHeartManager liveHeartDataType:resultDic controller:self];
            
            
        }
    }
}
#pragma mark 展示弹框
- (void)showDDJTAlert{
    if (!_isShowJoinAlert) {
        alert = [[LiveChatAlertVC alloc] init];
        
        alert.modalPresentationStyle = UIModalPresentationCustom;
        _isShowJoinAlert = YES;
        [[LiveChatManager installManager] bigLiveChatView];
        timeCount = 60;
        [alert showDDJTAlertWithStr:[NSString stringWithFormat:@"工号%@客服为您服务，是否进入？\n请在60s内确认",[LiveChatParmas installParmas].staffNum]];
        //        [[LCHeartManager installManager] stopTimer];
        __weak ChatWaitViewController *weakSelf = self;
        [alert setCancelBlock:^{
            weakSelf.isSelectAction = YES;
//            [weakSelf closeBtnAction:nil];
//            [[LiveChatPlayMusic installManager] stopLiveChatWatiMusic];
            [weakSelf logOut];  //直接挂断需要调用logout接口
            [weakSelf closeLiveChat];
        }];
        [alert setSureBlock:^(id obj) {
            weakSelf.isSelectAction = YES;
//            [[LiveChatPlayMusic installManager] stopLiveChatWatiMusic];
            [[LiveChatManager installManager] showLiveChatView];
            [weakSelf joinRoom];
        }];
        [self presentViewController:alert animated:NO completion:nil];
    }
    
    
}

#pragma mark 挂断按钮点击方法
- (void)closeBtnAction:(UIButton *)btn{
    LiveChatAlertVC *alertVC = [[LiveChatAlertVC alloc] init];
    
    alertVC.modalPresentationStyle = UIModalPresentationCustom;
    [alertVC alertSingleBtnWithDes:@"您确认要取消等待吗？" sureBtn:@"确认" cancelBtn:@"取消"];
    [self presentViewController:alertVC animated:NO completion:nil];
    __weak ChatWaitViewController *weakSelf = self;
    [alertVC setSureBlock:^(id  _Nonnull obj) {
        [weakSelf logOut];  //直接挂断需要调用logout接口
        [weakSelf closeLiveChat];
    }];
  
    
}
- (void)closeLiveChat{
    if (alert) {
        [alert dismissViewControllerAnimated:NO completion:nil];
        alert = nil;
        
        if (!_isSelectAction) {
            passServiceAlert = [[LiveChatAlertVC alloc]init];
            passServiceAlert.modalPresentationStyle = UIModalPresentationCustom;
            [passServiceAlert showNormalAlertWithStr:@"您已过号。"];
            timeCount = 600;  //倒计时过号赋大大值，防止到时退出
            __weak ChatWaitViewController *weakSelf = self;
            [passServiceAlert setCancelBlock:^{
                [weakSelf closeLiveChatRealClose];
            }];
            [passServiceAlert setSureBlock:^(id  _Nonnull obj) {
                [weakSelf closeLiveChatRealClose];
            }];
            [self presentViewController:passServiceAlert animated:NO completion:nil];
        }else{
            [self closeLiveChatRealClose];
        }
    }else if (passServiceAlert){
        return;
    }
    else{
        [self closeLiveChatRealClose];
    }
}

// closeLiveChat方法的延伸，为了XX的弹框
-(void)closeLiveChatRealClose{
    self.isShowJoinAlert = NO;
    [LiveChatRequest liveChatGiveUpNumResult:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
        [[LiveChatManager installManager] closeLiveChatView];
        
    }];
}

#pragma mark 加入聊天室
- (void)joinRoom{
    
    [LiveChatRequest liveChatJoinRoomResult:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)pushToLiveChat{
    [[LCHeartManager installManager] stopTimer];
    //显示视频通话页面
    [[LiveChatManager installManager] showLiveChatView];
    
}


@end
