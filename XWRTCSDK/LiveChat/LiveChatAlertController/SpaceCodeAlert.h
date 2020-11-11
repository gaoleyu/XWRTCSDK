//
//  SpaceCodeAlert.h
//  ecmc
//
//  Created by zhangtao on 2020/4/13.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaTextField.h"
NS_ASSUME_NONNULL_BEGIN
/*
 *   SpaceCodeAlert *alert = [[SpaceCodeAlert alloc]initWithFrame:CGRectMake(49*m6Scale, 154*m6Scale, 556*m6Scale, 498*m6Scale)];
 */

typedef enum {
    service_code_overtime,   /*0.输入超时*/
    service_code_forget,     /* 1.忘记密码 */
    service_code_clear,      /*回调不需要处理，在此页面处理*/
    service_code_sure,       //  3.确定
    service_code_cancel,     /* 4.取消*/
}ServiceCodeType;

@interface SpaceCodeAlert : UIView

@property(nonatomic,copy)void (^spaceCodeCallBack)(NSInteger btnTag,id psd);

@property(nonatomic,strong) NSTimer *serviceTimer;
//提示号码
@property (nonatomic, strong) NSString *showMobile;

- (void)hiddenForgetBtn;

@end

NS_ASSUME_NONNULL_END
