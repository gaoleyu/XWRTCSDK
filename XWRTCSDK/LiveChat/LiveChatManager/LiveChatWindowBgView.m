//
//  LiveChatWindowBgView.m
//  ecmc
//
//  Created by zxh on 2020/9/27.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "LiveChatWindowBgView.h"

@implementation LiveChatWindowBgView

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:[UIApplication sharedApplication].keyWindow];
    if (_pointBlock) {
        _pointBlock(p);
    }
}

@end
