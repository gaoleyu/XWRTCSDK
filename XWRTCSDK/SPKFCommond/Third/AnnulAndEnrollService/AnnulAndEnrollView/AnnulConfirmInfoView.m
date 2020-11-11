//
//  AnnulConfirmInfoView.m
//  ecmc
//
//  Created by zhangtao on 2020/2/10.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "AnnulConfirmInfoView.h"
#import "SPKFUtilities.h"
@implementation AnnulConfirmInfoView
{
    UIView *contentView;
    UIButton *agreeBtn;
    UIButton *confirmBtn;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
//        self.frame = CGRectZero;
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    contentView = [[UIView alloc]init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(self);
        make.edges.equalTo(self);
        make.width.equalTo(self);
    }];
    
    UILabel *line = [[UILabel alloc]init];//WithFrame:CGRectMake(25, 0, SCREEN_WIDTH-50, .5)];
    line.backgroundColor = [UIColor getColor:@"DBDBDB"];
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.equalTo(self);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(.5);
    }];
    
    UIImageView *tImgV = [[UIImageView alloc]init];//WithFrame:CGRectMake(26, 25, 19.5, 19.5)];
    tImgV.image = [UIImage bundleImageNamed:@"AnnulInfo_confirm_icon"];
    [contentView addSubview:tImgV];
    [tImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.top.mas_equalTo(24.5);
        make.width.height.mas_equalTo(19.5);
    }];
    
    UILabel *titleLab = [[UILabel alloc]init];
    [contentView addSubview:titleLab];
    titleLab.textColor = [UIColor getColor:@"333333"];
    titleLab.font = [UIFont boldSystemFontOfSize:16];
    titleLab.text = @"注销前，请确认以下信息：";
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tImgV.mas_right).mas_offset(9.5);
        make.centerY.equalTo(tImgV.mas_centerY);
    }];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.textColor = [UIColor getColor:@"666666"];
    infoLab.font = [UIFont systemFontOfSize:14];
    infoLab.numberOfLines = 0;
    infoLab.attributedText = [self info];
    [contentView addSubview:infoLab];
    [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(28);
        make.right.mas_equalTo(-28);
        make.top.equalTo(tImgV.mas_bottom).mas_offset(25);
    }];
    
   
    
    UILabel *agreeInfoLab = [[UILabel alloc]init];
    [contentView addSubview:agreeInfoLab];
    agreeInfoLab.text = @"申请注销即表示您已阅读及同意以上信息";
    agreeInfoLab.textColor = [UIColor getColor:@"3B84CA"];
    agreeInfoLab.font = [UIFont systemFontOfSize:12];
    [agreeInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoLab.mas_bottom).mas_offset(78);
        make.centerX.equalTo(self);

    }];
    
    
    agreeBtn = [[UIButton alloc]init];
       [contentView addSubview:agreeBtn];
       [agreeBtn setImage:[UIImage bundleImageNamed:@"Annul_agree"] forState:UIControlStateSelected];
       [agreeBtn setImage:[UIImage bundleImageNamed:@"Annul_disagree"] forState:UIControlStateNormal];
       agreeBtn.selected = NO;
       [agreeBtn addTarget:self action:@selector(agreeOrNot:) forControlEvents:UIControlEventTouchUpInside];
       [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.height.mas_equalTo(24);
           make.right.equalTo(agreeInfoLab.mas_left).mas_offset(0);
           make.centerY.equalTo(agreeInfoLab.mas_centerY);
       }];
    [agreeBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    confirmBtn = [[UIButton alloc]init];
    [contentView addSubview:confirmBtn];
    [confirmBtn setTitle:@"确定申请" forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage bundleImageNamed:@"annulService_submit_normal"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage bundleImageNamed:@"annulService_submit_normal"] forState:UIControlStateHighlighted];

       [confirmBtn setBackgroundImage:[UIImage bundleImageNamed:@"annulService_submit_select"] forState:UIControlStateSelected];
       confirmBtn.selected = agreeBtn.selected;
    confirmBtn.enabled = confirmBtn.selected;
//       _confirmBtn.userInteractionEnabled = agreeBtn.selected;
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.5);
        make.right.mas_equalTo(-20.5);
        make.top.equalTo(agreeBtn.mas_bottom).mas_offset(14);
        make.height.mas_equalTo(54.5);
        make.bottom.mas_equalTo(-1);
    }];
}

-(void)agreeOrNot:(UIButton *)sender{
    agreeBtn.selected = !agreeBtn.selected;
    confirmBtn.selected = agreeBtn.selected;
    confirmBtn.enabled = agreeBtn.selected;
    
}

-(void)confirm{
    if (self.annulInfoBack) {
        self.annulInfoBack();
    }
}

-(NSMutableAttributedString *)info{
   NSString *string1 = @"1.注销后江苏移动客户端将不再为当前号码提供登录、查询、业务办理等相关服务；\n\n2.如您注销后想恢复使用查询、业务办理等相关服务，请您重新激活或者选择江苏移动的其他线上、线下渠道进行办理；\n\n";;
       NSString *string2 = @"3.如您想彻底注销当前号码，请您携带有效身份证件去当地实体营业厅进行办理。";
       NSString *string = [string1 stringByAppendingString:string2];
       NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
       NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
       paragraphStyle.lineSpacing = 3; // 调整行间距
       NSRange range = NSMakeRange(0, [string length]);
       [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
       [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor getColor:@"666666"],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, [string1 length])];
       [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor getColor:@"333333"],NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} range:NSMakeRange(string1.length, string2.length)];
       
       return attributedString;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
