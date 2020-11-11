//
//  NSData+Extension.h
//  EcmcFramework
//
//  Created by qihaijun on 8/18/15.
//  Copyright © 2015 XWTec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(Extension)

//! Base64 encoded string
- (NSString *)base64EncodedString;

- (id)JSONValue;

@end
