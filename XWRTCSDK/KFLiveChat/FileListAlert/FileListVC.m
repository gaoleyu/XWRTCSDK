//
//  FileListVC.m
//  ecmc
//
//  Created by zxh on 2020/8/11.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "FileListVC.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"
#import "KFLCHeartManager.h"
#import "FileListTableCell.h"
#import "VoiceFilemanger.h"
#import "KFLiveChatRequest.h"
#import "LiveChatAlertVC.h"
#import "SPKFUtilities.h"
@interface FileListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UIButton *upAllBtn;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *fileList;
@property (nonatomic, copy) NSMutableArray *fileA;
@end

@implementation FileListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    UIView *bgView = [[UIView alloc] init];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.3;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.cornerRadius = 10;
    centerView.layer.masksToBounds = YES;
    [self.view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(60);
        make.bottom.mas_equalTo(-60);
    }];
    [self creatSubViewsWithCenterView:centerView];
}
- (void)creatSubViewsWithCenterView:(UIView *)centerView{
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [centerView addSubview:_tableView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"待上传录音";
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.backgroundColor = [UIColor getColor:@"5A9BFF"];
    [centerView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    //标题
    UIView *titView = [[UIView alloc] init];
    [centerView addSubview:titView];
    titView.backgroundColor = [UIColor getColor:@"5A9BFF"];
    [titView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    //号码
    UILabel *phoneLabel = [[UILabel alloc] init];
    [titView addSubview:phoneLabel];
    phoneLabel.text = @"号码";
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.textColor = [UIColor whiteColor];
    //操作
    UILabel *czLabel = [[UILabel alloc] init];
    [titView addSubview:czLabel];
    czLabel.text = @"操作";
    czLabel.textAlignment = NSTextAlignmentCenter;
    czLabel.textColor = [UIColor whiteColor];
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    [titView addSubview:timeLabel];
    timeLabel.text = @"保存时间";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(titView.mas_centerX);
        make.width.mas_equalTo(70);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(timeLabel.mas_left);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [czLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(timeLabel.mas_right);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    //全部上传，取消按钮
    upAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    upAllBtn.layer.cornerRadius = 4;
//    upAllBtn.layer.masksToBounds = YES;
    [centerView addSubview:upAllBtn];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerView addSubview:cancelBtn];
    [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage bundleImageNamed:@"uploadlistClose"] forState:UIControlStateNormal];
     [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.centerX.equalTo(centerView.mas_centerX);
         make.right.mas_equalTo(-40);
        make.left.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    //uploadlistClose kfhistoryBtnbg
    [upAllBtn setTitle:@"全部上传" forState:UIControlStateNormal];
          [upAllBtn setBackgroundImage:[UIImage bundleImageNamed:@"kfhistoryBtnbg"] forState:UIControlStateNormal];
           [upAllBtn addTarget:self action:@selector(uploadAllBtnAction) forControlEvents:UIControlEventTouchUpInside];
          
          [upAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
              make.bottom.equalTo(cancelBtn.mas_top).offset(-20);
              make.centerX.equalTo(self.view.mas_centerX);
              make.right.mas_equalTo(-40);
              make.left.mas_equalTo(40);
              make.height.mas_equalTo(40);
          }];
          
         
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titView.mas_bottom);
        make.bottom.mas_equalTo(upAllBtn.mas_top).offset(-20);
    }];
    [self getLocalVoice];
}
#pragma mark 获取本地录音文件数
- (void)getLocalVoice{
    
    if ([SPKFUtilities isValidArray:[[VoiceFilemanger install] getFileList]]) {
        _fileList = [[NSMutableArray alloc] initWithArray:[[VoiceFilemanger install] getFileList]];
        
    }
    if ([SPKFUtilities isValidArray:_fileList] && _fileList.count > 0) {
        [upAllBtn setBackgroundImage:[UIImage bundleImageNamed:@"kfhistoryBtnbg"] forState:UIControlStateNormal];
        upAllBtn.backgroundColor = [UIColor clearColor];
        
    }else{
        [upAllBtn setBackgroundImage:[UIImage bundleImageNamed:@"uploadlistClose"] forState:UIControlStateNormal];
//        upAllBtn.backgroundColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1];
    }
    
    [self.tableView reloadData];
}
- (void)uploadAllBtnAction{
    if (![SPKFUtilities isValidArray:_fileList]) {
        return;
    }
    if ([SPKFUtilities isValidArray:_fileList]) {
        _fileA = [[NSMutableArray alloc] initWithArray:_fileList];
    }
    [self upLoadAllArr];
}
- (void)upLoadAllArr{
    if ([SPKFUtilities isValidArray:_fileA]) {
        NSString *path = [NSString stringWithFormat:@"%@/%@",[[VoiceFilemanger install] creatFileDic],_fileA.firstObject];
        [self uploadWithPath:path isMore:YES endBloc:^(BOOL isSuccess) {
            
            [_fileA removeObject:_fileA.firstObject];
            [self upLoadAllArr];
        }];
    }else{
        LiveChatAlertVC *alert = [[LiveChatAlertVC alloc] init];
             alert.modalPresentationStyle = UIModalPresentationCustom;
        
             [alert showNormalAlertWithStr:@"上传操作已完成，成功文件已从本地删除"];
             [self presentViewController:alert animated:NO completion:nil];
        [self getLocalVoice];
    }
}
- (void)cancelBtnAction{
    if (_refreshFileListBlock) {
        _refreshFileListBlock();
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark tableViewdelegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _fileList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FileListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[FileListTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell.czBtn addTarget:self action:@selector(upLoadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self getFileInfo:cell fileName:_fileList[indexPath.row]];
    cell.czBtn.tag = 2020 + indexPath.row;
    return cell;
}
- (void)getFileInfo:(FileListTableCell *)cell fileName:(NSString *)fileName{
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[VoiceFilemanger install] creatFileDic],fileName];
    cell.phoneLabel.text = @"";
    cell.timeLabel.text = @"";
    NSArray *namefArr = [fileName componentsSeparatedByString:@"_"];
    
    if ([SPKFUtilities isValidArray:namefArr]) {
        NSArray *nameArr = [namefArr.lastObject componentsSeparatedByString:@"."];
        if ([SPKFUtilities isValidArray:nameArr]) {
          cell.phoneLabel.text = [NSString stringWithFormat:@"%@",nameArr.firstObject];
        }
    }
    NSDictionary *info = [[VoiceFilemanger install] getFileInfo:path];
    if ([SPKFUtilities isValidDictionary:info]) {
        NSDate *creatTime = info[@"NSFileCreationDate"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *creatTimeStr = [dateFormatter stringFromDate:creatTime];
        if ([SPKFUtilities isValidString:creatTimeStr]) {
            cell.timeLabel.text = creatTimeStr;
        }
    }
    
    
}
- (void)upLoadAction:(UIButton *)btn{
    NSInteger index = btn.tag - 2020;
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[VoiceFilemanger install] creatFileDic],_fileList[index]];
    
    __weak FileListVC *weakSelf = self;
    [self uploadWithPath:path isMore:NO endBloc:^(BOOL isSuccess) {
        [weakSelf getLocalVoice];
    }];
}
- (void)uploadWithPath:(NSString *)path isMore:(BOOL)isMore endBloc:(void((^)( BOOL isSuccess)))block{
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
    __weak FileListVC *weakSelf = self;
     [KFLiveChatRequest upLoadVoiceFileWithPath:path Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
         [hud hideAnimated:YES];
         if (!isSuccess) {
            
             if (isMore) {
                 
             }else{
                 LiveChatAlertVC *alert = [[LiveChatAlertVC alloc] init];
                 alert.modalPresentationStyle = UIModalPresentationCustom;
//                 [alert alertSingleBtnWithDes:message sureBtn:@"去补传" cancelBtn:@"取消"];
                 [alert showNormalAlertWithStr:@"上传操作已完成，成功文件已从本地删除"];
                 [weakSelf presentViewController:alert animated:NO completion:nil];
//                 [alert setSureBlock:^(id  _Nonnull obj) {
//                     [weakSelf uploadWithPath:path isMore:NO endBloc:nil];
//                 }];
             }
         }else{
             if (isMore) {
                
                 
             }else{
                 LiveChatAlertVC *alert = [[LiveChatAlertVC alloc] init];
                alert.modalPresentationStyle = UIModalPresentationCustom;
           
                [alert showNormalAlertWithStr:@"上传操作已完成，成功文件已从本地删除"];
                [weakSelf presentViewController:alert animated:NO completion:nil];
             }
             
            
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                 [_fileList removeObject:[path lastPathComponent]];
                 [self.tableView reloadData];
             });
         }
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             block(isSuccess);
         });
     }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
