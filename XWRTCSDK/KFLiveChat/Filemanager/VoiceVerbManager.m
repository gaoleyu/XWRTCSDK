//
//  VoiceVerbManager.m
//  ecmc
//
//  Created by zxh on 2020/8/12.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "VoiceVerbManager.h"

@implementation VoiceVerbManager

+ (instancetype)install{
    static VoiceVerbManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VoiceVerbManager alloc] init];
    });
    return manager;
}
- (void)startVerb{
    
}
- (void)stopVerb{
    
}

@end
