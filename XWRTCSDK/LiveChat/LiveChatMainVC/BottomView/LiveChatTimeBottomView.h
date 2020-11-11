//
//  LiveChatTimeBottomView.h
//  ecmc
//
//  Created by XianHong zhang on 2020/4/22.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveChatTimeBottomView : UIView
//客服工号
@property (nonatomic, strong) NSString *kfid;

//更新通话时长
- (void)updateTimeLabelText;

@end

NS_ASSUME_NONNULL_END
