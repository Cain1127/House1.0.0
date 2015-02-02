//
//  QSHouseListTitleCollectionViewCell.m
//  House
//
//  Created by ysmeng on 15/1/31.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHouseListTitleCollectionViewCell.h"

#import <objc/runtime.h>

///关联
static char TitleLabelKey;//!<标题关联key

@implementation QSHouseListTitleCollectionViewCell

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-01-31 14:01:37
 *
 *  @brief          重写初始化，搭建自定义UI
 *
 *  @param frame    大小和位置
 *
 *  @return         返回当前创建的cell
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        ///搭建UI
        [self createHouseListTitleCellUI];
        
        ///分隔线
        UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - 0.5f, self.frame.size.width, 0.5f)];
        sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [self.contentView addSubview:sepLabel];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createHouseListTitleCellUI
{

    ///大标题
    UILabel *titleLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, self.frame.size.width, 40.0f)];
    titleLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    titleLabel.textColor = COLOR_CHARACTERS_GRAY;
    titleLabel.text = @"23456";
    [self.contentView addSubview:titleLabel];
    objc_setAssociatedObject(self, &TitleLabelKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///小标题
    UILabel *subTitleLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, titleLabel.frame.origin.y + titleLabel.frame.size.height - 5.0f, self.frame.size.width, 15.0f)];
    subTitleLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    subTitleLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    subTitleLabel.text = @"套二手房信息";
    [self.contentView addSubview:subTitleLabel];

}

#pragma mark - 更新标题
/**
 *  @author         yangshengmeng, 15-01-31 14:01:29
 *
 *  @brief          根据给定的标题信息，更新标题
 *
 *  @param title    标题信息
 *
 *  @since          1.0.0
 */
- (void)updateTitleInfoWithTitle:(NSString *)title
{

    ///更新标题
    UILabel *titleLabel = objc_getAssociatedObject(self, &TitleLabelKey);
    if (titleLabel && title) {
        
        titleLabel.text = title;
        
    }

}

@end