//
//  NSString+Extension.m
//  EcmcFramework
//
//  Created by qihaijun on 8/18/15.
//  Copyright © 2015 XWTec. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+Extension.h"
#import "SPKFUtilities.h"

static const char encodingTable[] =
"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static Byte digits[8] = { 1, 2, 3, 4, 5, 6, 7, 8 };

@implementation NSString (Extension)

#pragma mark - MD5

- (NSString *)md5Value { return [self md5Uppercase]; }

- (NSString *)md5Uppercase
{
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5 (cStr, (CC_LONG)strlen (cStr), result);

	NSMutableString *resultString = [NSMutableString string];
	for (int i = 0; i != sizeof (result) / sizeof (unsigned char); ++i) {
		[resultString appendFormat:@"%02X", result[i]]; // 大写
		//        [resultString appendFormat:@"%02x", result[i]]; // 小写
	}
	return resultString;
}

- (NSString *)md5Lowercase { return [self md5Value].lowercaseString; }

#pragma mark - Base64

+ (NSString *)base64StringFromText:(NSString *)text
{
    NSString *base64 = @"";
    if ([SPKFUtilities isValidString:text]) {

        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        base64 = [self base64EncodedStringFrom:data];
    }
    return base64;
}

+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}


- (NSData *)base64DecodedData
{
	if (self == nil) return nil;
	if ([self length] == 0) return [NSData data];

	static char *decodingTable = NULL;
	if (decodingTable == NULL) {
		decodingTable = malloc (256);
		if (decodingTable == NULL) return nil;
		memset (decodingTable, CHAR_MAX, 256);
		NSUInteger i;
		for (i = 0; i < 64; i++) decodingTable[(short)encodingTable[i]] = i;
	}

	const char *characters = [self cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL) return nil; //  Not an ASCII string!
	char *bytes = malloc ((([self length] + 3) / 4) * 3);
	if (bytes == NULL) return nil;

	NSUInteger length = 0;
	NSUInteger i = 0;
	while (YES) {
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++) {
			if (characters[i] == '\0') break;
			if (isspace (characters[i]) || characters[i] == '=') continue;
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX) { //  Illegal character!
				free (bytes);
				return nil;
			}
		}

		if (bufferLength == 0) break;
		if (bufferLength == 1) { //  At least two characters are needed to produce one byte!
			free (bytes);
			return nil;
		}

		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2) bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3) bytes[length++] = (buffer[2] << 6) | buffer[3];
	}

	bytes = realloc (bytes, length);
	return [NSData dataWithBytesNoCopy:bytes length:length];
}

#pragma mark - DES

- (NSString *)DESDecryptWithKey:(const NSString *)key
{
	NSData *data = [self base64DecodedData];

	NSUInteger bufferSize = ([data length] + kCCKeySizeDES) & ~(kCCKeySizeDES - 1);
	uint8_t *buffer = malloc(bufferSize * sizeof(uint8_t));
	memset ((void *)buffer, 0, sizeof (buffer));
	size_t bufferNumBytes;
	CCCryptorStatus cryptStatus =
	CCCrypt (kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, [key UTF8String], kCCKeySizeDES,
	         digits, [data bytes], [data length], buffer, bufferSize, &bufferNumBytes);

	NSString *result = nil;
	if (cryptStatus == kCCSuccess) {
		NSData *plainData = [NSData dataWithBytes:buffer length:(NSUInteger)bufferNumBytes];
		result = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
	}

    free(buffer); //优化  by zhouhao
	return result;
}

- (NSString *)DESEncryptWithKey:(const NSString *)key
{
	NSString *result = nil;
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

	NSUInteger bufferSize = ([data length] + kCCKeySizeDES) & ~(kCCKeySizeDES - 1);
//	char buffer[bufferSize];
    uint8_t *buffer = malloc(bufferSize * sizeof(uint8_t));
	memset ((void *)buffer, 0, sizeof (buffer));
	size_t bufferNumBytes;
	CCCryptorStatus cryptStatus =
	CCCrypt (kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, [key UTF8String], kCCKeySizeDES,
	         digits, [data bytes], [data length], buffer, bufferSize, &bufferNumBytes);
	if (cryptStatus == kCCSuccess) {
		NSData *plainData = [NSData dataWithBytes:buffer length:(NSUInteger)bufferNumBytes];
		result = [plainData base64EncodedString];
	}
    free(buffer);
	return result;
}

- (NSString *)DESEscapedEncryptWithKey:(const NSString *)key
{
	NSString *encrypt = [self DESEncryptWithKey:key];
	// 加号会传到服务器会变成空格，url encode 一下，强制转换＋为%2B，服务端不用变，会自动 url decode
	encrypt = [encrypt stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	encrypt = [encrypt stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	return encrypt;
}

- (NSString *)convertDateFormatter:(NSString *)sourceFormatter
                   targetFormatter:(NSString *)targetFormatter
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:sourceFormatter];
	NSDate *date = [dateFormatter dateFromString:self];
	[dateFormatter setDateFormat:targetFormatter];
	return [dateFormatter stringFromDate:date];
}

/** 返回文字的size*/
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW {
    
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (NSString *)getAtPresentTime
{
    // 1.创建时间
    NSDate *now = [NSDate date];
    // 2.创建时间格式化
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 3.指定格式
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    // 4.格式化时间
    NSString *str = [formatter stringFromDate:now];
    
    return str;
}

- (CGSize)sizeWithFont:(UIFont *)font {
    
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

@end
