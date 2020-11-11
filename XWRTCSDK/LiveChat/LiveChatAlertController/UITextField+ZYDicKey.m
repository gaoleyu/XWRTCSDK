//
//  UITextField+ZYDicKey.m
//  ecmc
//
//  Created by XianHong zhang on 2020/3/25.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "UITextField+ZYDicKey.h"
#import <objc/runtime.h>
static NSString *keyNameKey = @"keyNameKey";

@implementation UITextField (ZYDicKey)

- (void)setKeyName:(NSString *)keyName{
    objc_setAssociatedObject(self, &keyNameKey, keyName, OBJC_ASSOCIATION_COPY);
}
- (NSString *)keyName{
    return objc_getAssociatedObject(self, &keyNameKey);
}

@end
