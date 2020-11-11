//
//  LiveChatTimeBottomView.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/22.
//  Copyright © 2020 cp9. All rights reserved.
//
#import "LiveChatTimeBottomView.h"
#import "SPKFUtilities.h"

@interface LiveChatTimeBottomView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation LiveChatTimeBottomView
{
    
    //创建时期的时间戳
    NSTimeInterval creatTimeLength;
    //提示label
    UILabel *titleLabel;
}
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatSubviews];
    }
    return self;
}
- (void)creatSubviews{
    _kfid = @"";
    creatTimeLength = [[NSDate date] timeIntervalSince1970];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage bundleImageNamed:@"my_homeV_xialajiantou"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage bundleImageNamed:@"my_homeV_shanglajiantou"] forState:UIControlStateSelected];
    [closeBtn addTarget:self action:@selector(openCloseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:closeBtn];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor getColor:@"999999"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.text = @"工号客服为您服务，当前通话时长00:00";
    [self addSubview:titleLabel];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    //内容视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 0;
    //    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor getColor:@"394A7E"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(titleLabel.mas_bottom);
    }];
    _collectionView.hidden = YES;
    closeBtn.hidden = YES;
}
//隐藏展示按钮
- (void)openCloseBtnAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    
    float collctionVFrameY = 0;
    CGFloat frameY = 0;
    if (btn.selected) {
        frameY = kScreen_Height-30;
        if (@available(iOS 11.0, *)) {
            if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
                collctionVFrameY = btn.bottom + [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
                frameY = kScreen_Height-30-[[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
            }
        }
    }else{
        frameY = kScreen_Height-self.height;
        collctionVFrameY = btn.bottom;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, frameY, self.width, self.height);
    }];
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(collctionVFrameY);
            }];
        }
    }
    
}
#pragma mark collectionview delegate datasource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(215, 56);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 20, 24, 20);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor getColor:@"556698"];
    cell.layer.cornerRadius = 4;
    cell.layer.masksToBounds = YES;
    UILabel *txtLabel = [cell viewWithTag:2019042103];
    UIImageView *imgV = [cell viewWithTag:2019042104];
    UILabel *label = [cell viewWithTag:2019042105];
    if (!imgV) {
        imgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 48, 48)];
        //        imgV.image = [UIImage bundleImageNamed:@"taocan"];
        imgV.layer.cornerRadius = 4;
        imgV.layer.masksToBounds = YES;
        imgV.backgroundColor = [UIColor purpleColor];
        imgV.tag = 2019042104;
        [cell addSubview:imgV];
    }
    if (!txtLabel) {
        txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgV.right+4, 4, 215-60, 22)];
        txtLabel.font = [UIFont systemFontOfSize:15];
        txtLabel.textColor = [UIColor whiteColor];
        txtLabel.text = @"欢迎来到虚拟营业厅";
        txtLabel.tag = 2019042103;
        [cell addSubview:txtLabel];
    }
    
    if (!label){
        label = [[UILabel alloc] initWithFrame:CGRectMake(txtLabel.frame.origin.x, txtLabel.bottom, txtLabel.width, 17)];
        
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.text = @"欢迎来到虚拟营业厅";
        label.tag = @"2019042105";
        [cell addSubview:label];
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
    titleLabel.text = [NSString stringWithFormat:@"工号%@客服为您服务，当前通话时长%02ld:%02ld",_kfid,min,s];
    
}

@end
