//
//  QSAttentionCommunityCell.m
//  House
//
//  Created by ysmeng on 15/3/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAttentionCommunityCell.h"

#import "NSString+Calculation.h"

#import "QSCommunityHouseDetailDataModel.h"
#import "QSWCommunityDataModel.h"

#import "QSCoreDataManager+House.h"

#import <objc/runtime.h>

///关联
static char AddressInfoKey;     //!<地址信息关联
static char BackgroudImageKey;  //!<背景图片关联
static char CommunityInfoKey;   //!<小区信息关联

@implementation QSAttentionCommunityCell

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-02-27 09:02:14
 *
 *  @brief          初始化
 *
 *  @param frame    大小和位置
 *
 *  @return         返回小区/新房的cell
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        ///UI搭建
        [self createCommunityCellUI];
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
///UI搭建
- (void)createCommunityCellUI
{
    
    ///背景图片
    QSImageView *bgImageView = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, SIZE_DEFAULT_MAX_WIDTH, 350.0f / 690.0f * SIZE_DEFAULT_MAX_WIDTH)];
    bgImageView.image = [UIImage imageNamed:IMAGE_HOUSES_LOADING_FAIL690x350];
    [self.contentView addSubview:bgImageView];
    objc_setAssociatedObject(self, &BackgroudImageKey, bgImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///地址信息
    UILabel *addressLabel = [[QSLabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 8.0f, 0.0f, 120.0f, 30.0f)];
    addressLabel.backgroundColor = [UIColor whiteColor];
    addressLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.textColor = COLOR_CHARACTERS_BLACK;
    addressLabel.text = @"越秀区|北京路";
    [self.contentView addSubview:addressLabel];
    objc_setAssociatedObject(self, &AddressInfoKey, addressLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///小区信息
    UILabel *communityNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, addressLabel.frame.origin.y + addressLabel.frame.size.height + 20.0f, (self.frame.size.width - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 5.0f) / 2.0f, 25.0f)];
    communityNameLabel.text = @"碧桂园清泉城";
    communityNameLabel.textColor = COLOR_CHARACTERS_BLACK;
    communityNameLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [self.contentView addSubview:communityNameLabel];
    objc_setAssociatedObject(self, &CommunityInfoKey, communityNameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *sepLine = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.frame.size.height - 0.5f, SIZE_DEFAULT_MAX_WIDTH, 0.25f)];
    sepLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.contentView addSubview:sepLine];
    
}

#pragma mark - 刷新UI
/**
 *  @author         yangshengmeng, 15-03-24 22:03:51
 *
 *  @brief          更新收藏小区的cell
 *
 *  @param model    小区详情数据模型
 *
 *  @since          1.0.0
 */
- (void)updateIntentionCommunityInfoCellUIWithDataModel:(QSCommunityHouseDetailDataModel *)model
{

    ///更新地址信息
    UILabel *addressLabel = objc_getAssociatedObject(self, &AddressInfoKey);
    if (addressLabel && model.village.address) {
        
        addressLabel.text = model.village.address;
        
    }
    
    ///更新小区
    UILabel *communityLabel = objc_getAssociatedObject(self, &CommunityInfoKey);
    if (communityLabel && model.village.title) {
        
        communityLabel.text = model.village.title;
        
    }
    
    ///更新面积
    
    
    ///更新图片
    UIImageView *bgImageView = objc_getAssociatedObject(self, &BackgroudImageKey);
    if (bgImageView && model.village.attach_thumb) {
        
        [bgImageView loadImageWithURL:[model.village.attach_thumb getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_HOUSES_LOADING_FAIL690x350]];
        
    }

}

@end
