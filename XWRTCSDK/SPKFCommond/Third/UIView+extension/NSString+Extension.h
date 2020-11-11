//
//  NSString+Extension.h
//  EcmcFramework
//
//  Created by qihaijun on 8/18/15.
//  Copyright © 2015 XWTec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Extension)

//! MD5
- (NSString *)md5Value;
//! Uppercase MD5
- (NSString *)md5Uppercase;
//! Lowercase MD5
- (NSString *)md5Lowercase;

//! Base64 encoded string
- (NSData *)base64DecodedData;

//! DES decrypt
- (NSString *)DESDecryptWithKey:(const NSString *)key;
//! DES encrypt
- (NSString *)DESEncryptWithKey:(const NSString *)key;
//! DES encrypt with escape
- (NSString *)DESEscapedEncryptWithKey:(const NSString *)key;

- (NSString *)convertDateFormatter:(NSString *)sourceFormatter
                   targetFormatter:(NSString *)targetFormatter;

//base64
+ (NSString *)base64StringFromText:(NSString *)text;

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;
+ (NSString *)getAtPresentTime;

@end
