//
//  ChatSelectVC.m
//  ecmc
//
//  Created by XianHong zhang on 2020/3/24.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "ChatSelectVC.h"
#import "Masonry.h"
#import "ChatWaitViewController.h"
#import "LiveChatManager.h"
#import "KFLiveChatManager.h"
#import "LiveChatParmas.h"
#import "LiveChatRequest.h"
#import "UIImageView+WebCache.h"
#import "LiveChatAlertVC.h"
#import "KFLCHeartManager.h"
#import "SPKFUtilities.h"
@interface ChatSelectVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSString *serviceNum;
}
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ChatSelectVC
- (void)setDataArray:(NSArray *)dataArray{
    if ([SPKFUtilities isValidArray:dataArray]) {
        _dataArray = dataArray;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.4;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    //背景图
    UIView *contentbgView = [UIView new];
    [self.view addSubview:contentbgView];
    //698/1068
    UIImageView *bgImgV = [UIImageView new];
    bgImgV.image = [UIImage bundleImageNamed:@"selectworkbg"];
    [contentbgView addSubview:bgImgV];
    float topspce = 64;
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            topspce = topspce + [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        }
    }
    CGFloat bgViewH = (kScreen_Width-40)*1068/698;
    [contentbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(topspce);
        make.height.mas_equalTo(bgViewH);
    }];
    [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    //标题
    UIImageView *titleImgV = [UIImageView new];
    [contentbgView addSubview:titleImgV];
    titleImgV.image = [UIImage bundleImageNamed:@"selectworktitle"];
    //534/75
    [titleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(35);
        make.height.mas_equalTo((kScreen_Width-80)*75/534);
    }];
    //内容视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [contentbgView addSubview:_collectionView];
    //组册组得头视图,可设置，可不设置

    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(titleImgV.mas_bottom);
    }];
    //取消继续按钮 106 38
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelBtn setBackgroundImage:[UIImage bundleImageNamed:@"selectVCClose"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage bundleImageNamed:@"selectVCClose"] forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setImage:[UIImage bundleImageNamed:@"btn_call_dialog_business_call"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [sureBtn setTitle:@"呼叫营业员" forState:UIControlStateNormal];
    [self.view addSubview:sureBtn];
    //192 53
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgImgV.mas_top).offset(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentbgView.mas_bottom).offset(0);
        make.width.mas_equalTo(192);
        make.height.mas_equalTo(53);
        make.centerX.mas_equalTo(_collectionView.mas_centerX);
//        make.left.mas_equalTo(50);
    }];
}
#pragma mark CollectionDeleaget
//创建完cell得内容后，仍要设置代理方法，返回头视图，和尾视图
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreen_Width, 30);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreen_Width-80)/3, 80);
}
- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if (kind == UICollectionElementKindSectionHeader) {

        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headView" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgImgV = [headerView viewWithTag:2020042101];
        if (!bgImgV) {
            bgImgV = [UIImageView new];
            bgImgV.image = [UIImage bundleImageNamed:@"selectworktitlebg"];
            bgImgV.tag = 2020042101;
            [headerView addSubview:bgImgV];
            bgImgV.contentMode = UIViewContentModeScaleAspectFit;
            //449/65
            bgImgV.frame = CGRectMake(0, 0, headerView.height*449/65, headerView.height);
        }
        UILabel *titleLabel = [headerView viewWithTag:2020042102];
        if (!titleLabel) {
            titleLabel = [UILabel new];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.text = @"  ";
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.tag = 2020042102;
            [headerView addSubview:titleLabel];
            titleLabel.frame = CGRectMake(10, 0, headerView.width, headerView.height);
        }
        
        NSDictionary *rowDic = _dataArray[indexPath.section];
        if ([SPKFUtilities isValidDictionary:rowDic]) {
            NSString *serviceName = rowDic[@"serviceName"];
            if ([SPKFUtilities isValidString:serviceName]) {
                titleLabel.text = serviceName;
            }
        }
        return headerView;

    }

   return nil;
    

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([SPKFUtilities isValidArray:_dataArray]) {
        return _dataArray.count;
    }
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSDictionary *rowDic = _dataArray[section];
    if ([SPKFUtilities isValidDictionary:rowDic]) {
        NSArray *rowArr = rowDic[@"children"];
        if ([SPKFUtilities isValidArray:rowArr]) {
            return rowArr.count;
        }
    }
    
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];

   
    
    
    UIImageView *bgImgV = [cell viewWithTag:2019042103];
    UIImageView *imgV = [cell viewWithTag:2019042104];
    UILabel *label = [cell viewWithTag:2019042105];
    
    
    if (!bgImgV) {
        bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 70, 70)];
        bgImgV.image = [UIImage bundleImageNamed:@"selectworkbordbg"];
        bgImgV.tag = 2019042103;
        [cell addSubview:bgImgV];
    }
    if (!imgV) {
        imgV = [[UIImageView alloc] initWithFrame:CGRectMake((bgImgV.width-31)/2, bgImgV.frame.origin.y+10, 31, 31)];
        imgV.image = [UIImage bundleImageNamed:@"taocan"];
        imgV.tag = 2019042104;
        [cell addSubview:imgV];
    }
    if (!label){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgV.bottom, bgImgV.width, 22)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.tag = @"2019042105";
        label.text = @"业务";
        [cell addSubview:label];
    }
    NSDictionary *rowDic = _dataArray[indexPath.section];
       if ([SPKFUtilities isValidDictionary:rowDic]) {
           NSArray *rowArr = rowDic[@"children"];
           if ([SPKFUtilities isValidArray:rowArr]) {
               NSDictionary *dataDic = rowArr[indexPath.row];
               if ([SPKFUtilities isValidDictionary:dataDic]) {
                   
                   NSString *imgUrl = dataDic[@"picUrl"];
                   NSString *txt = dataDic[@"serviceName"];
                   if ([SPKFUtilities isValidString:txt]) {
                       label.text = txt;
                   }
                   if ([SPKFUtilities isValidString:imgUrl]) {
                       [imgV sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
                   }
               }
           }
       }
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *bgImgV = [cell viewWithTag:2019042103];
    bgImgV.image = [UIImage bundleImageNamed:@"itembg"];
    
    
    NSDictionary *rowDic = _dataArray[indexPath.section];
    if ([SPKFUtilities isValidDictionary:rowDic]) {
        NSArray *rowArr = rowDic[@"children"];
        if ([SPKFUtilities isValidArray:rowArr]) {
            NSDictionary *dataDic = rowArr[indexPath.row];
            if ([SPKFUtilities isValidDictionary:dataDic]) {
                serviceNum = dataDic[@"serviceNum"];
            }
        }
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *bgImgV = [cell viewWithTag:2019042103];
    bgImgV.image = [UIImage bundleImageNamed:@"selectworkbordbg"];
}

#pragma mark 取消按钮点击方法
- (void)cancelBtnAction:(UIButton *)btn{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
#pragma mark 工作按钮点击方法
- (void)sureBtnClick:(UIButton *)btn{

    
    LiveChatAlertVC *alertVC = [[LiveChatAlertVC alloc] init];
    alertVC.modalPresentationStyle = UIModalPresentationCustom;
    
    if (serviceNum) {
        [self getNum];
        
    }else{
        [alertVC showNormalAlertWithStr:@"请选择要办理的业务"];
        [self presentViewController:alertVC animated:NO completion:nil];
    }
    
   
    
}

#pragma mark 取号
- (void)getNum{
    
    LiveChatAlertVC *alertVC = [[LiveChatAlertVC alloc] init];
    alertVC.modalPresentationStyle = UIModalPresentationCustom;
    
    __weak ChatSelectVC *weakSelf = self;
    [alertVC setSureBlock:^(id  _Nonnull obj) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [alertVC setCancelBlock:^{
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
         
    NSString *autherStatus = [KFLCHeartManager checkAuthor];
    if ([SPKFUtilities isValidString:autherStatus]) {
        [alertVC showNormalAlertWithStr:autherStatus];
        [self presentViewController:alertVC animated:NO completion:nil];
       
        return;
    }
       
    
    
    //取号
    [LiveChatRequest liveChatUpSelectYW:serviceNum Result:^(id  _Nonnull response, BOOL isSuccess, NSString * _Nonnull message) {
        if (isSuccess) {
            if ([SPKFUtilities isValidDictionary:response]) {
                NSDictionary *resultDic = response[@"result"];
                if ([SPKFUtilities isValidDictionary:resultDic]) {
                    [LiveChatManager installManager].ywResultDic = resultDic;
                    [self dismissViewControllerAnimated:NO completion:nil];

                    [LiveChatManager installManager].ywID = serviceNum;
                    [[LiveChatManager installManager] showLiveChatWaitView];
                    
                }else{
                    [alertVC showNormalAlertWithStr:message];
                }
            }else{
                [alertVC showNormalAlertWithStr:message];
            }
        }else{
            [alertVC showNormalAlertWithStr:message];
            [self presentViewController:alertVC animated:NO completion:nil];
        }
    }];
}


@end
