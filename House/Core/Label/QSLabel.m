//
//  QSLabel.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSLabel.h"

@implementation QSLabel

/**
 *  @author                 yangshengmeng, 15-01-17 15:01:22
 *
 *  @brief                  重写文本信息显示的位置
 *
 *  @param bounds           当前Label的大小
 *  @param numberOfLines    当前行
 *
 *  @return                 返回文本信息显示的区域
 *
 *  @since                  1.0.0
 */
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{

    return CGRectMake(2.0f, 2.0f, bounds.size.width-4.0f, bounds.size.height-4.0f);

}

@end
