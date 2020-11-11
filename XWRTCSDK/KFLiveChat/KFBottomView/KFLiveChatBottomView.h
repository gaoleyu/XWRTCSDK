//
//  KFLiveChatBottomView.h
//  ecmc
//
//  Created by XianHong zhang on 2020/4/3.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFLiveChatBottomView : UIView

@property (nonatomic, copy) void (^closeBtnBlock)();


@property (nonatomic, strong) UIButton *backBtn;

@end

NS_ASSUME_NONNULL_END
