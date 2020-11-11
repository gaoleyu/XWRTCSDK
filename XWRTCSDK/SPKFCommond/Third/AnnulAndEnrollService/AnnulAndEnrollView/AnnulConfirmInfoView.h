//
//  AnnulConfirmInfoView.h
//  ecmc
//
//  Created by zhangtao on 2020/2/10.
//  Copyright © 2020 cp9. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnnulConfirmInfoView : UIScrollView

@property(nonatomic,copy)void(^annulInfoBack)(void);
@end

NS_ASSUME_NONNULL_END
