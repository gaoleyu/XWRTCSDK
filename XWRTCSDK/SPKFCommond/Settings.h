//
//  Settings.h
//  OpenVideoCall
//
//  Created by CavanSu on 2019/6/4.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>
#if TARGET_IPHONE_SIMULATOR//模拟器

#elif TARGET_OS_IPHONE//真机
#import "Encryption.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

//#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
@interface Settings : NSObject
@property (nonatomic, strong) Encryption *encryption;
@property (nonatomic, assign) AgoraVideoFrameRate frameRate;
@property (nonatomic, assign) CGSize dimension;
@property (nonatomic, copy) NSString *roomName;
@end
#endif
