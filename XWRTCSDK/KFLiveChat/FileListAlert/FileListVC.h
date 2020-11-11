//
//  FileListVC.h
//  ecmc
//
//  Created by zxh on 2020/8/11.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileListVC : BaseViewController

@property (nonatomic, copy) void (^refreshFileListBlock)();

@end

NS_ASSUME_NONNULL_END
