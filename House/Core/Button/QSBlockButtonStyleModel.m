//
//  QSBlockButtonStyleModel.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBlockButtonStyleModel.h"

@implementation QSBlockButtonStyleModel

#pragma mark - 清空风格
/**
 *  @author yangshengmeng, 15-01-17 18:01:06
 *
 *  @brief  清空按钮当前所有风格
 *
 *  @since  1.0.0
 */
- (void)clearButtonStyle
{
    
    self.title = nil;
    self.bgColor = nil;
    self.titleNormalColor = nil;
    self.titleHightedColor = nil;
    self.titleSelectedColor = nil;
    self.borderColor = nil;
    self.borderWith = 0.0f;
    self.cornerRadio = 0.0f;
    self.imagesNormal = nil;
    self.imagesHighted = nil;
    self.imagesSelected = nil;
    self.titleFont = nil;
    
}

@end
