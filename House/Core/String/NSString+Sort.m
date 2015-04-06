//
//  NSString+Sort.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "NSString+Sort.h"

@implementation NSString (Sort)

+ (NSString *)getChineseWordInitialEnglishWord:(NSString *)chineseWord
{

    NSMutableString *source = [chineseWord mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return [source substringToIndex:1];

}

+ (NSString *)getChineseWordSpell:(NSString *)chineseWord
{

    NSMutableString *source = [chineseWord mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;

}

+ (NSString *)getChineseStringWithoutSeparated:(NSString*)sourceString
{

    ///获取拼音字符串
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    
    ///取消特定字符串
    NSRange urgentRange = [source rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @" "]];
    if (urgentRange.location != NSNotFound)
    {
        
        return [self getChineseStringWithoutSeparated:[source stringByReplacingCharactersInRange:urgentRange withString:@""]];
        
    }
    
    return source;

}

+ (NSString *)getChineseStringPinyinSeparatedBySpace:(NSString *)sourceString
{

    ///获取拼音字符串
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;

}

+ (NSString *)getChineseStringPinyinSpellWithSepatatedString:(NSString *)sourceString separatedString:(NSString *)separatedString
{

    ///获取拼音字符串
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    
    ///分隔字符
    NSString *sepString = [separatedString length] > 0 ? separatedString : @"";
    [source replaceOccurrencesOfString:@" " withString:sepString options:NSCaseInsensitiveSearch range:NSMakeRange(0, 1)];
    
    return source;

}

+ (NSString *)getChineseStringPinyinInitial:(NSString *)chineseString
{

    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i < [chineseString length]; i++) {
        
        NSString *pinyin = [self getChineseWordInitialEnglishWord:[chineseString substringWithRange:NSMakeRange(i, 1)]];
        if (pinyin && [pinyin length] > 0) {
            
            [resultString appendString:pinyin];
            
        }
        
    }
    
    return [NSString stringWithString:resultString];

}

/**
 *  @author                 yangshengmeng, 15-04-03 14:04:32
 *
 *  @brief                  传入一串字符串，并且按中文首字母排序
 *
 *  @param originalArray    字符串数组，如果其中有非字符串对象，则只返回字符之前的元素排序结果集
 *
 *  @return                 返回排序后的结果集
 *
 *  @since                  1.0.0
 */
+ (NSArray *)sortChineseByInitial:(NSArray *)originalArray
{

    for (NSString *obj in originalArray) {
        
        if (![obj isKindOfClass:[NSString class]]) {
            
            return nil;
            
        }
        
        
        
    }
    return nil;

}

/**
 *  @author                 yangshengmeng, 15-04-03 14:04:52
 *
 *  @brief                  按中文首字母排序给定数组中的指定元素
 *
 *  @param originalArray    原数组
 *  @param propertyKey      需要排序的字段名
 *
 *  @return                 返回排序后的结果集
 *
 *  @since                  1.0.0
 */
+ (NSArray *)sortChineseByInitial:(NSArray *)originalArray andPropertyKey:(NSString *)propertyKey
{

    return nil;

}

/**
 *  @author                 yangshengmeng, 15-04-03 14:04:42
 *
 *  @brief                  按中文全拼排序给定的字符串数组
 *
 *  @param originalArray    字符串数组
 *
 *  @return                 返回排序后的结果
 *
 *  @since                  1.0.0
 */
+ (NSArray *)sortChineseBySpelling:(NSArray *)originalArray
{

    return nil;

}

/**
 *  @author                 yangshengmeng, 15-04-03 14:04:14
 *
 *  @brief                  按中文全拼排序给定字段数组集
 *
 *  @param originalArray    原对明数组
 *  @param propertyKey      需要排序的元素名
 *
 *  @return                 返回排序后的结果集
 *
 *  @since                  1.0.0
 */
+ (NSArray *)sortChineseBySpelling:(NSArray *)originalArray andPropertyKey:(NSString *)propertyKey
{

    return nil;

}

@end

@implementation QSYStringSortModel



@end