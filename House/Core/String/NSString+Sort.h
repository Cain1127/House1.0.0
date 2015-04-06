//
//  NSString+Sort.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Sort)

+ (NSString *)getChineseWordInitialEnglishWord:(NSString *)chineseWord;

+ (NSString *)getChineseWordSpell:(NSString *)chineseWord;

+ (NSString *)getChineseStringWithoutSeparated:(NSString*)sourceString;

+ (NSString *)getChineseStringPinyinSeparatedBySpace:(NSString *)sourceString;

+ (NSString *)getChineseStringPinyinSpellWithSepatatedString:(NSString *)sourceString separatedString:(NSString *)separatedString;

+ (NSString *)getChineseStringPinyinInitial:(NSString *)chineseString;

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
+ (NSArray *)sortChineseByInitial:(NSArray *)originalArray;

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
+ (NSArray *)sortChineseByInitial:(NSArray *)originalArray andPropertyKey:(NSString *)propertyKey;

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
+ (NSArray *)sortChineseBySpelling:(NSArray *)originalArray;

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
+ (NSArray *)sortChineseBySpelling:(NSArray *)originalArray andPropertyKey:(NSString *)propertyKey;

@end

@interface QSYStringSortModel : NSObject

@property (nonatomic,copy) NSString *chineseString; //!<原汉字
@property (nonatomic,copy) NSString *pinyin;        //!<拼音

@end