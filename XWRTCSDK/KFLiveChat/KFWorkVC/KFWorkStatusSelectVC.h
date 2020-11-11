//
//  KFWorkStatusSelectVC.h
//  ecmc
//
//  Created by XianHong zhang on 2020/4/22.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KFWorkStatusSelectVC : BaseViewController

@property (nonatomic, copy) void (^sleepBlock)();
@property (nonatomic, copy) void (^workBlock)();

@end

NS_ASSUME_NONNULL_END
