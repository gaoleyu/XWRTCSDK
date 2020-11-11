//
//  LiveChatWindowBgView.h
//  ecmc
//
//  Created by zxh on 2020/9/27.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveChatWindowBgView : UIView


@property (nonatomic, copy) void (^pointBlock)(CGPoint p);

@end

NS_ASSUME_NONNULL_END
