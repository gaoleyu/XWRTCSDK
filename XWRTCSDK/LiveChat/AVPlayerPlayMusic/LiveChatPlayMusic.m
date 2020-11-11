//
//  LiveChatPlayMusic.m
//  ecmc
//
//  Created by XianHong zhang on 2020/4/14.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "LiveChatPlayMusic.h"
#import <AVFoundation/AVFoundation.h>
@implementation LiveChatPlayMusic
{
    AVAudioPlayer *audioPlayer;
}
+ (instancetype)installManager{
    static LiveChatPlayMusic *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LiveChatPlayMusic alloc] init];
    });
    return manager;
}

- (id)init{
    if (self = [super init]) {
        
        
        
    }
    return self;
}
- (void)playLiveChatWatiMusic{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"spkf" ofType:@"mp3"];
    if (!path) {
        return;
    }
    NSURL *musicUrl = [NSURL fileURLWithPath:path];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:nil];
    audioPlayer.numberOfLoops = -1;
    [audioPlayer play];
    
}
- (void)stopLiveChatWatiMusic{
    [audioPlayer stop];
    
}

@end
