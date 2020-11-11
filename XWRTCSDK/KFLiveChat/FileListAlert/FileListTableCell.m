//
//  FileListTableCell.m
//  ecmc
//
//  Created by zxh on 2020/8/11.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "FileListTableCell.h"
#import "SPKFUtilities.h"
@implementation FileListTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    //号码
    UILabel *phoneLabel = [[UILabel alloc] init];
    [self.contentView addSubview:phoneLabel];
    phoneLabel.text = @"18351839916";
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.textColor = [UIColor getColor:@"666666"];
    //操作
    _czBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_czBtn];
    _czBtn.backgroundColor = [UIColor getColor:@"5A9BFF"];
    _czBtn.layer.cornerRadius = 4;
    _czBtn.layer.masksToBounds = YES;
    [_czBtn setTitle:@"立即上传" forState:UIControlStateNormal];
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    timeLabel.text = @"2020-21-13\n10:02:01";
    timeLabel.numberOfLines = 2;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor getColor:@"666666"];
    
    _phoneLabel = phoneLabel;
    _timeLabel = timeLabel;
    _phoneLabel.font = [UIFont systemFontOfSize:15];;
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    _czBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_czBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0).offset(-10);
        make.width.mas_equalTo(70);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(75);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(timeLabel.mas_left);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
}



@end
