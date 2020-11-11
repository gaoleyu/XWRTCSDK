//
//  KFWorkPlatomVC.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/14.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "KFWorkPlatomVC.h"
#import "LiveChatAlertVC.h"
#import "KFLiveChatWaitVC.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"
#import "KFWorkStatusSelectVC.h"
#import "KFLiveChatManager.h"
#import "KFLiveChatRequest.h"
#import "KFStaffInfo.h"
#import "KFLCHeartManager.h"
#import "KFLiveChatParmas.h"
#import "KFLiveChatMainVC.h"
#import "LiveChatPlayMusic.h"
#import "SPKFUtilities.h"
#import "FileListVC.h"
#import "VoiceFilemanger.h"
@interface KFWorkPlatomVC ()<KFLCheartManagerDelegate>
{
    UIButton *backBtn;
}
//等待人数
@property (nonatomic, assign) int waitCount;
@property (nonatomic, assign) int roomCount;
@property (nonatomic,assign) BOOL isOnline;

@property (nonatomic,strong) UIButton  *workStatusBtn;
@property (nonatomic,strong) UILabel  *nameLabel;
@property (nonatomic,strong) UILabel  *jobNumLabel;
@property (nonatomic,strong) UIButton *receiveBtn;
@property (nonatomic,strong) UILabel  *waitNumLabel;
@property (nonatomic,strong) UILabel  *roomNumLab;
@property (nonatomic,strong) UIButton *serverHistoryBtn;
@property (nonatomic,strong) UIButton *logoutBtn;
//文件数
@property (nonatomic, strong) UIButton *fileCountBtn;
//@property (nonatomic,assign)BOOL isAgainLog; //登录失败再登录一次

@end

@implementation KFWorkPlatomVC

{
    BOOL isPlaying; //是否正在播放提示音
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor whiteColor];
    _waitCount = 0;
    _roomCount = 0;
    _isOnline = NO;
    isPlaying = NO;
    UIImageView *headerBackview = [[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"platworkheaderbg"]];
//    headerBackview.backgroundColor = [UIColor getColor:@"5b90ff"];
    [self.view addSubview:headerBackview];
    //375/189
    CGFloat headerheight = kScreen_Width *189/375+20+statusHeight;
    [headerBackview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(headerheight);
    }];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIImage *imageBg = [UIImage bundleImageNamed:@"newnavbar_back"];
    [backBtn setImage:imageBg forState:UIControlStateNormal];
    [backBtn setAdjustsImageWhenHighlighted:NO];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusHeight);
        make.left.equalTo(self.view).offset(10);
        make.width.mas_equalTo( imageBg.size.width);
        make.height.mas_equalTo( imageBg.size.height);
    }];
    
    
    
    self.title = @"ChatRoom";
    self.workStatusBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.workStatusBtn setTitle:@"工作" forState:UIControlStateSelected];
    [self.workStatusBtn setTitle:@"休息" forState:UIControlStateNormal];
    self.workStatusBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.workStatusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.workStatusBtn setTitleColor:[UIColor getColor:@"FFE612"] forState:UIControlStateNormal];
    [self.workStatusBtn addTarget:self action:@selector(workStatusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.workStatusBtn];
    [self.workStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusHeight);
        make.right.equalTo(self.view).offset(-10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    statusLabel.text = @"我的状态:";
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.font = [UIFont systemFontOfSize:16];
    statusLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.workStatusBtn.mas_top);
        make.right.equalTo(self.workStatusBtn.mas_left).with.offset(-5);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(20);
    }];
    
    
    UIImageView *logImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    logImageView.backgroundColor = [UIColor clearColor];
    logImageView.image = [UIImage bundleImageNamed:@"kftouxiang"];
    [self.view addSubview:logImageView];
    [logImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.workStatusBtn.mas_top).with.offset(10);
        make.width.height.mas_equalTo(75);
    }];
    
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.text = [NSString stringWithFormat:@"姓名:%@",@"--"];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logImageView.mas_bottom).with.offset(11);
        make.right.equalTo(logImageView.mas_centerX).with.offset(-40);
    }];
    
    UIImageView *nameIcon = [[UIImageView alloc]init];
    nameIcon.image = [UIImage bundleImageNamed:@"xingming"];
    [self.view addSubview:nameIcon];
    [nameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameLabel.mas_left).mas_offset(-2.5);
        make.width.height.mas_equalTo(21);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    
    
    self.jobNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.jobNumLabel.text = [NSString stringWithFormat:@"工号:%@",@"10086"];
    self.jobNumLabel.font = [UIFont systemFontOfSize:16];
    self.jobNumLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.jobNumLabel];
    [self.jobNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logImageView.mas_bottom).with.offset(11);
        make.left.equalTo(logImageView.mas_centerX).with.offset(40);
    }];
    
    UIImageView *jobNumIcon = [[UIImageView alloc]init];
    jobNumIcon.image = [UIImage bundleImageNamed:@"gonghao"];
    [self.view addSubview:jobNumIcon];
    [jobNumIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.jobNumLabel.mas_left).mas_offset(-2.5);
        make.width.height.mas_equalTo(21);
        make.centerY.equalTo(self.jobNumLabel.mas_centerY);

    }];
    
    self.receiveBtn = [[UIButton alloc] initWithFrame:CGRectZero];
   self.receiveBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [self.receiveBtn addTarget:self action:@selector(receiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.receiveBtn];
    [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(headerBackview.mas_bottom).with.offset(10);
        make.width.height.mas_equalTo(170);
    }];

    
    self.waitNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前排队客户%d人",_waitCount]];
    [string addAttributes:@{NSForegroundColorAttributeName:[UIColor getColor:@"7EBBFF"],NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, string.length)];

    [string addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:25]} range:NSMakeRange(6, string.length - 7)];
    self.waitNumLabel.attributedText = string;
    [self.view addSubview:self.waitNumLabel];
    [self.waitNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.receiveBtn.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    
    self.roomNumLab = [[UILabel alloc] initWithFrame:CGRectZero];
    NSMutableAttributedString *roomString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余房间数%d间",_roomCount]];
    [roomString addAttributes:@{NSForegroundColorAttributeName:[UIColor getColor:@"7EBBFF"],NSFontAttributeName:[UIFont systemFontOfSize:17]} range:NSMakeRange(0, roomString.length)];

    [roomString addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:22]} range:NSMakeRange(5, roomString.length - 6)];
    self.roomNumLab.attributedText = roomString;
    [self.view addSubview:self.roomNumLab];
    [self.roomNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.waitNumLabel.mas_bottom).mas_offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    self.serverHistoryBtn = [[UIButton alloc] initWithFrame:CGRectZero];
//    [self.serverHistoryBtn setTitle:@"服务记录" forState:UIControlStateNormal];
    [self.serverHistoryBtn setBackgroundImage:[UIImage bundleImageNamed:@"kfhistoryBtnbg"] forState:UIControlStateNormal];
    [self.serverHistoryBtn setTitle:@"切换工作状态" forState:UIControlStateSelected];
          [self.serverHistoryBtn setTitle:@"切换工作状态" forState:UIControlStateNormal];
       [self.serverHistoryBtn addTarget:self action:@selector(workStatusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.serverHistoryBtn addTarget:self action:@selector(serverHistoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.roomNumLab.hidden = YES;
    [self.view addSubview:self.serverHistoryBtn];
    [self.serverHistoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.roomNumLab.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(570*m6Scale);
        make.height.mas_equalTo(108*m6Scale);
    }];
    [self.serverHistoryBtn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
    }];
    [self.serverHistoryBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-19);
        make.height.width.mas_equalTo(20);
    }];
    
    UIImageView *historyBtnArrow = [[UIImageView alloc]initWithFrame:CGRectZero];
    historyBtnArrow.image = [UIImage bundleImageNamed:@"jinru"];
    [self.serverHistoryBtn addSubview:historyBtnArrow];
    [historyBtnArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.serverHistoryBtn);
        make.right.mas_equalTo(-19);
        make.width.height.mas_equalTo(20);
    }];
    
    self.logoutBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [self.logoutBtn setBackgroundImage:[UIImage bundleImageNamed:@"kfhistoryBtnbg"] forState:UIControlStateNormal];
     [self.logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logoutBtn];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serverHistoryBtn.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(570*m6Scale);
        make.height.mas_equalTo(108*m6Scale);
    }];
    
    [self.logoutBtn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
    }];
    [self.logoutBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-19);
        make.height.width.mas_equalTo(20);
    }];
    
    UIImageView *logoutBtnArrow = [[UIImageView alloc]initWithFrame:CGRectZero];
    logoutBtnArrow.image = [UIImage bundleImageNamed:@"jinru"];
    [self.logoutBtn addSubview:logoutBtnArrow];
    [logoutBtnArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoutBtn);
        make.right.mas_equalTo(-19);
        make.width.height.mas_equalTo(20);
    }];
    
   
    [self receiveBtnStatus:NO];
    [self checkLogin];
       
}
- (void)creatWaitUp{
    if ([KFLiveChatParmas installParmas].isOpenRecordForI) {
        //待上传提示
        UILabel *upTitLabel = [[UILabel alloc] init];
        upTitLabel.text = @"待上传文件:";
        upTitLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:upTitLabel];
        [upTitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backBtn.mas_right);
            make.top.mas_equalTo(backBtn.mas_top);
        }];
        //文件数
        _fileCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fileCountBtn setTitle:@"0" forState:UIControlStateNormal];
        _fileCountBtn.layer.cornerRadius = 4;
        _fileCountBtn.layer.masksToBounds = YES;
        [_fileCountBtn addTarget:self action:@selector(upListVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_fileCountBtn];
        [_fileCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(upTitLabel.mas_right);
            make.width.mas_equalTo(40);
            make.centerY.mas_equalTo(upTitLabel.mas_centerY);
            make.height.mas_equalTo(25);
        }];
        [self getLocalVoiceIsShowAler:NO];
    }
}
#pragma mark 上传列表
- (void)upListVC{
    FileListVC *VC = [[FileListVC alloc] init];
    VC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:VC animated:NO completion:nil];
    __weak KFWorkPlatomVC *weakSelf = self;
    [VC setRefreshFileListBlock:^{
        [weakSelf getLocalVoiceIsShowAler:NO];
    }];
}
#pragma mark --根据切换的状态更新本地UI
-(void)receiveBtnStatus:(BOOL)isSelect{
    
    self.workStatusBtn.selected = isSelect;
    self.serverHistoryBtn.selected = isSelect;
    self.receiveBtn.selected = isSelect;
    self.waitNumLabel.hidden = !isSelect;
//    self.roomNumLab.hidden = !isSelect;
    self.receiveBtn.userInteractionEnabled = isSelect;
    self.isOnline = isSelect;
    NSString *title = @"";
    NSString *img = @"";
    UIColor *titColor = nil;
    
    if (isSelect) {
        [self startKFHeart];
        title = @"接待";
        img = @"gongzuobg";
        titColor = [UIColor getColor:@"487BFD"];
        if (_waitCount == 0) {
            img = @"platwoekxiuxibg";
            titColor = [UIColor getColor:@"B4ADB6"];
        }
    }else{
        [self stopKFHeart];
        title = @"接待";
        img = @"platwoekxiuxibg";
        titColor = [UIColor getColor:@"B4ADB6"];
    }
    
    [self.receiveBtn setTitle:title forState:UIControlStateNormal];
    [self.receiveBtn setTitleColor:titColor forState:UIControlStateNormal];
    [self.receiveBtn setBackgroundImage:[UIImage bundleImageNamed:img] forState:UIControlStateNormal];
    self.receiveBtn.adjustsImageWhenHighlighted = NO;
}

#pragma mark --自动登录//主要查看是否有sessionId
-(void)checkLogin{
    if (
        ![SPKFUtilities isValidString:[KFLiveChatParmas installParmas].sessionId]) {
        
         __weak KFWorkPlatomVC *weakSelf = self;
        
        NSString *phoneNo =@"";
        NSDictionary *dic = @{@"staffNum":phoneNo,@"mobile":phoneNo};
        [KFLiveChatRequest kfLiveChatLoginParams:dic Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
            //请求成功后，数据在请求方法里处理了
            if (isSuccess) {
                NSDictionary *resultDic = response[@"result"];
                if ([SPKFUtilities isValidDictionary:resultDic]) {
                    NSString *isOpenRecordForI = resultDic[@"isOpenRecordForI"];
                                                   if ([SPKFUtilities isValidString:isOpenRecordForI]) {
                                                       if ([isOpenRecordForI isEqualToString:@"0"]) {
                                                           [KFLiveChatParmas installParmas].isOpenRecordForI = NO;
                                                       }else if ([isOpenRecordForI isEqualToString:@"1"]) {
                                                           [KFLiveChatParmas installParmas].isOpenRecordForI = YES;
                                                           [self creatWaitUp];
                                                       }

                                                   }
                }
                if ([SPKFUtilities isValidString:[KFLiveChatParmas installParmas].staffName]) {
                    self.nameLabel.text = [NSString stringWithFormat:@"姓名:%@",[KFLiveChatParmas installParmas].staffName];
                }
                if ([SPKFUtilities isValidString:[KFLiveChatParmas installParmas].staffNum]) {
                    self.jobNumLabel.text = [NSString stringWithFormat:@"工号:%@",[KFLiveChatParmas installParmas].staffNum];
                }
                [self getLocalVoiceIsShowAler:YES];
                //更新客服状态
//                 [self updateStatus:@"ONLINE"];
                //开启心跳
//                [weakSelf startKFHeart];
            }
            else{
                LiveChatAlertVC *alert = [[LiveChatAlertVC alloc]init];
                alert.modalPresentationStyle = UIModalPresentationCustom;
                [alert showNormalAlertWithStr:message?:@"客服登录失败"];
                [weakSelf presentViewController:alert animated:NO completion:nil];
                [alert setSureBlock:^(id  _Nonnull obj) {
                //                 [self dismissViewControllerAnimated:NO completion:nil];
                    [[KFLiveChatManager installManager] closeLiveChatView];
                }];
                [alert setCancelBlock:^{
                //                 [self dismissViewControllerAnimated:NO completion:nil];
                    [[KFLiveChatManager installManager] closeLiveChatView];
                }];
            }
        }];
    }else{
        [self showNormalAlert:@""];
    }
}
#pragma mark 获取本地录音文件数
- (void)getLocalVoiceIsShowAler:(BOOL)isShowAlert{
    NSArray *fileList = [[VoiceFilemanger install] getFileList];
    if ([SPKFUtilities isValidArray:fileList]) {
        [_fileCountBtn setTitle:[NSString stringWithFormat:@"%ld",fileList.count] forState:UIControlStateNormal];
        _fileCountBtn.backgroundColor = [UIColor redColor];
        if (isShowAlert) {
            //提示未上传总数
            LiveChatAlertVC *alert = [[LiveChatAlertVC alloc] init];
            alert.modalPresentationStyle = UIModalPresentationCustom;
            [alert alertSingleBtnWithDes:[NSString stringWithFormat:@"您当前共有%ld个文件未上传",fileList.count] sureBtn:@"立即上传" cancelBtn:@"取消"];
            [self presentViewController:alert animated:NO completion:nil];
            __weak KFWorkPlatomVC *weakSelf = self;
            [alert setSureBlock:^(id  _Nonnull obj) {
                [weakSelf upListVC];
                
            }];
        }
    }else{
        [_fileCountBtn setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        _fileCountBtn.backgroundColor = [UIColor clearColor];
    }
}
#pragma mark-- 启动心跳
-(void)startKFHeart{
    
    
    if ([SPKFUtilities isValidString:[KFLiveChatParmas installParmas].sessionId]) {
        [KFLCHeartManager installManager].delegate = self;
        [[KFLCHeartManager installManager] startTimer];
    }
}
#pragma mark-- 停止心跳
-(void)stopKFHeart{
    [[KFLCHeartManager installManager] stopTimer];
    [KFLCHeartManager installManager].delegate = nil;
    [[LiveChatPlayMusic installManager] stopLiveChatWatiMusic];
    isPlaying = NO;
}

#pragma mark--更新客服状态
//OFFLINE:已下线；
//ONLINE:上线；
//DUTY:等待接待；
//FREE:休息；
//BUSY:接待中
-(void)updateStatus:(NSString *)status{
    if ([SPKFUtilities isValidString:status]) {
        __weak KFWorkPlatomVC *weakSelf = self;
        [KFLiveChatRequest kfLiveChatUpdateStatus:status Params:@"" Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
            
            if (isSuccess && [SPKFUtilities isValidString:status]) {
                if([status isEqualToString:@"ONLINE"]){
                    [weakSelf receiveBtnStatus:YES];
                }else{
                     [weakSelf receiveBtnStatus:NO];
                }
//               if([status isEqualToString:@"FREE"]){
//
//                    [weakSelf receiveBtnStatus:NO];
//
//                };
            }else{
                [weakSelf showNormalAlert:message];
            }
            
        }];
    }
}

#pragma mark--普通提醒弹框
-(void)showNormalAlert:(NSString *)des{
    LiveChatAlertVC *alert = [[LiveChatAlertVC alloc]init];
    alert.modalPresentationStyle = UIModalPresentationCustom;
    [alert showNormalAlertWithStr:des];
    [self presentViewController:alert animated:NO completion:nil];
}

#pragma mark ----KFLCheartManagerDelegate
//计时器每次走的回调，为了全局使用一个计时器
- (void)timerActionDelete{

}
//客服心跳返回的数据
-(void)kfHeartRequestCallBack:(NSDictionary *)repDic{
        
    if ([SPKFUtilities isValidDictionary:repDic] && [SPKFUtilities isValidDictionary:repDic[@"forStaff"]]) {
        if (repDic[@"forStaff"][@"freeRoom"]) {
            _roomCount = [repDic[@"forStaff"][@"freeRoom"] intValue];
            NSMutableAttributedString *roomString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余房间数%d间",_roomCount]];
            [roomString addAttributes:@{NSForegroundColorAttributeName:[UIColor getColor:@"7EBBFF"],NSFontAttributeName:[UIFont systemFontOfSize:17]} range:NSMakeRange(0, roomString.length)];

            [roomString addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:22]} range:NSMakeRange(5, roomString.length - 6)];
            self.roomNumLab.attributedText = roomString;
        }
        if (repDic[@"forStaff"][@"waitCount"]) {
            _waitCount = [repDic[@"forStaff"][@"waitCount"] intValue];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前排队客户%d人",_waitCount]];
            [string addAttributes:@{NSForegroundColorAttributeName:[UIColor getColor:@"7EBBFF"],NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, string.length)];

            [string addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:25]} range:NSMakeRange(6, string.length - 7)];
            self.waitNumLabel.attributedText = string;
        }
        
        
        //等待人数或房间数为0 不可点击且置灰
        if (self.isOnline) {
            if (_waitCount==0 /*|| _roomCount==0*/) {
                [self.receiveBtn setTitleColor:[UIColor getColor:@"B4ADB6"] forState:UIControlStateNormal];
                [self.receiveBtn setBackgroundImage:[UIImage bundleImageNamed:@"platwoekxiuxibg"] forState:UIControlStateNormal];
                       self.receiveBtn.userInteractionEnabled = NO;
                
                if (isPlaying) {
                    [[LiveChatPlayMusic installManager] stopLiveChatWatiMusic];
                    isPlaying = NO;
                }
                
            }else{
                [self.receiveBtn setTitleColor:[UIColor getColor:@"487BFD"] forState:UIControlStateNormal];
                [self.receiveBtn setBackgroundImage:[UIImage bundleImageNamed:@"gongzuobg"] forState:UIControlStateNormal];
                self.receiveBtn.userInteractionEnabled = YES;
                
                if (!isPlaying) {
                    [[LiveChatPlayMusic installManager] playLiveChatWatiMusic];
                    isPlaying = YES;
                }
            }
        }
       
        
//        if ([SPKFUtilities isValidString:repDic[@"forStaff"][@"notifyType"]] && [repDic[@"forStaff"][@"notifyType"] isEqualToString:@"ONLINE"]) {
//
//            [self receiveBtnStatus:YES];
//        }else{
//
//             [self receiveBtnStatus:NO];
//        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isOnline) {
        [self startKFHeart];
    }
    if ([KFLiveChatParmas installParmas].isOpenRecordForI) {
        [self getLocalVoiceIsShowAler:NO];
    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopKFHeart];
}

#pragma mark 工作状态变更事件
-(void)workStatusBtnClick:(UIButton *)sender{
 
    
    KFWorkStatusSelectVC *alertVC = [[KFWorkStatusSelectVC alloc] init];
    alertVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:alertVC animated:NO completion:nil];
    __weak KFWorkPlatomVC *weakSelf = self;
    [alertVC setWorkBlock:^{
        [weakSelf showChangeStatusAlertCode:@"ONLINE" des:@"确定切换为“工作”？"];
    }];
    [alertVC setSleepBlock:^{
        [weakSelf showChangeStatusAlertCode:@"FREE" des:@"确定切换为“休息”？"];

    }];
}

-(void)showChangeStatusAlertCode:(NSString *)code des:(NSString *)des{
    __weak KFWorkPlatomVC *WeakSelf = self;
    LiveChatAlertVC *vc = [[LiveChatAlertVC alloc]init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [vc alertSingleBtnWithDes:des sureBtn:@"确认" cancelBtn:@"取消"];
    [vc setSureBlock:^(id  _Nonnull obj) {
        [WeakSelf updateStatus:code];
    }];
    [self presentViewController:vc animated:NO completion:nil];
}


#pragma mark 接待事件   叫号
-(void)receiveBtnClick:(UIButton *)sender{
    NSLog(@"语音接待");
    
   
    NSString *autherStatus = [KFLCHeartManager checkAuthor];
    if ([SPKFUtilities isValidString:autherStatus]) {
        
        [self showNormalAlert:autherStatus];
        return;
    }
    
    
    if (sender.selected && _waitCount > 0) {
        __weak KFWorkPlatomVC *weakSelf = self;
        //客服叫号
        [KFLiveChatRequest kfLiveChatPOPResult:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
            if (isSuccess) {
                //告诉用户客户已接入
//                      __weak KFWorkPlatomVC *weakSelf = self;
                      //跳到接入等待页面
//                      KFLiveChatWaitVC *VC = [[KFLiveChatWaitVC alloc] init];
//                      VC.modalPresentationStyle = 0;
//                      [self presentViewController:VC animated:NO completion:nil];
                if ([SPKFUtilities isValidDictionary:response] &&
                    [SPKFUtilities isValidDictionary:response[@"result"]] &&
                    [SPKFUtilities isValidDictionary:response[@"result"][@"acceptInfo"]]
                    ) {
                    [self openSPChatViewControllerWithInfo:response[@"result"]];
                }else{
                    [weakSelf showNormalAlert:@"缺少房间信息"];
                }
                //acceptNum acceptInfo
                if ([SPKFUtilities isValidDictionary:response]) {
                    NSDictionary *resultdic = response[@"result"];
                    if ([SPKFUtilities isValidDictionary:resultdic]) {
                        NSDictionary *kfDic = resultdic[@"acceptInfo"];
                        if ([SPKFUtilities isValidDictionary:kfDic]) {
                            NSString *acceptNum = kfDic[@"acceptNum"];
                            if ([SPKFUtilities isValidString:acceptNum]) {
                                [KFLiveChatParmas installParmas].acceptNum = acceptNum;
                            }
                        }
                    }
                }
                
            }else{
                [self showNormalAlert:(message ? message : @"叫号失败")];
            }
        }];
    }else{
        NSString *des = @"";
        if (!sender.selected) {
           des = @"当前处于休息状态";
        }
        if (_waitCount <= 0) {
           des = @"当前无用户等待";
        }
        [self showNormalAlert:des];
    }
}

#pragma mark 打开视频客服页面
- (void)openSPChatViewControllerWithInfo:(NSDictionary *)repDic{
                   
    
    KFLiveChatMainVC *mainVC = [[KFLiveChatMainVC alloc] init];
    mainVC.resultDic = repDic;
    mainVC.modalPresentationStyle = 0;
    [self presentViewController:mainVC animated:NO completion:nil];
    __weak KFWorkPlatomVC *weakSelf = self;
    [mainVC setUploadFileBlock:^(NSString *path) {
        if ([SPKFUtilities isValidString:path]) {
            [weakSelf uploadLastFile:path];
            
        }
    }];
}
- (void)uploadLastFile:(NSString *)path{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
     //自定义imageView 750/196
     UIImageView *cusImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200*196/750.f)];
     NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"upvoicefile" ofType:@"gif"];
     NSData *data = [NSData dataWithContentsOfFile:imgPath];
     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
         UIImage *image = [UIImage sd_imageWithGIFData:data];
         cusImageV.image = image;
     }];
     hud.customView = cusImageV;
     //设置hud模式
     hud.mode = MBProgressHUDModeCustomView;
     //设置在hud影藏时将其从SuperView上移除,自定义情况下默认为NO
     hud.removeFromSuperViewOnHide = YES;
     hud.backgroundColor = [UIColor clearColor];
     [KFLiveChatRequest upLoadVoiceFileWithPath:path Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
         [hud hideAnimated:YES];
         
         if (!isSuccess) {
             LiveChatAlertVC *alert = [[LiveChatAlertVC alloc] init];
             alert.modalPresentationStyle = UIModalPresentationCustom;
             [alert alertSingleBtnWithDes:@"录音上传失败，请稍后补传。" sureBtn:@"去补传" cancelBtn:@"取消"];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self presentViewController:alert animated:NO completion:nil];
             });
             __weak KFWorkPlatomVC *weakSelf = self;
             [alert setSureBlock:^(id  _Nonnull obj) {
                 [weakSelf upListVC];
             }];
         }else{
             [KFLCHeartManager showToast:@"上传操作已完成，成功文件已从本地删除" duration:3];
             [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
         }
         [self getLocalVoiceIsShowAler:NO];
     }];
}
#pragma mark  服务历史事件
-(void)serverHistoryBtnClick{
    NSLog(@"服务历史");
    [self showNormalAlert:@"当前没有服务记录"];
//      [KFLiveChatParmas installParmas].status = @"ONLINE";
//    [KFLiveChatRequest kfLiveChatPushSerivceCodeResult:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
//
//    }];
}

#pragma mark 退出登陆事件
-(void)logoutBtnClick{
    NSLog(@"退出登陆");

    __weak KFWorkPlatomVC *weakSelf = self;
 
    
     
       LiveChatAlertVC *vc = [[LiveChatAlertVC alloc]init];
       vc.modalPresentationStyle = UIModalPresentationCustom;
       [vc alertSingleBtnWithDes:@"是否确认退出？" sureBtn:@"确定" cancelBtn:@"取消"];
       [vc setSureBlock:^(id  _Nonnull obj) {
              [KFLiveChatRequest kfLiveChatLogOutResult:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
           //        if (isSuccess) {
//                       [weakSelf updateStatus:@"OFFLINE"];
                       [[KFLiveChatParmas installParmas] clearAllParams];
                       [[KFLiveChatManager installManager] closeLiveChatView];

               }];
       }];
       [self presentViewController:vc animated:NO completion:nil];
    
    
}

#pragma mark 返回
-(void)backBtnClick{
//    [[KFLiveChatManager installManager] closeLiveChatView];
    [self logoutBtnClick];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    CGRect btnBounds = self.receiveBtn.frame;
    //扩大点击区域，想缩小就将-10设为正值
    btnBounds = CGRectInset(btnBounds, -10, -10);
    
    return CGRectContainsPoint(btnBounds, point);
}




-(void)dealloc{
    
}

@end
