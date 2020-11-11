//
//  SPKFUtilities.m
//  ecmc
//
//  Created by zxh on 2020/7/7.
//  Copyright © 2020 cp9. All rights reserved.
//

#import "SPKFUtilities.h"

@implementation SPKFUtilities

+ (BOOL)isValidDictionary:(id)object
{
    return object && [object isKindOfClass:[NSDictionary class]] && ((NSDictionary *)object).count;
}

+ (BOOL)isValidArray:(id)object
{
    return object && [object isKindOfClass:[NSArray class]] && ((NSArray *)object).count;
}

+ (BOOL)isValidString:(id)object
{
    return object && [object isKindOfClass:[NSString class]] && ((NSString *)object).length;
}

+ (BOOL)isValidData:(id)object
{
    return object && [object isKindOfClass:[NSData class]] && ((NSData *)object).length;
}

+ (NSString *)jsonStringWithString:(NSString *)string
{
    return [NSString
    stringWithFormat:@"\"%@\"",
                     [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""
                                                                                                                      withString:@"\\\""]];
}


@end
