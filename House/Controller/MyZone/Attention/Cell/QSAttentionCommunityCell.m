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
#import "QSNewHouseDetailDataModel.h"
#import "QSLoupanPhaseDataModel.h"
#import "QSLoupanInfoDataModel.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+App.h"

#import <objc/runtime.h>

///关联
static char AddressInfoKey;     //!<地址信息关联
static char BackgroudImageKey;  //!<背景图片关联
static char CommunityInfoKey;   //!<小区信息关联
static char FeaturesRootViewKey;//!<特色标签
static char TitleInfoKey;       //!<标题关联

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
    
    ///中间标题信息
    QSImageView *titleImageView = [[QSImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0f - 35.0f, bgImageView.frame.size.height - 39.5f, 70.0f, 79.0f)];
    titleImageView.image = [UIImage imageNamed:IMAGE_HOUSES_LIST_SIXFORM];
    [self createCommunityTitleInfoUI:titleImageView];
    titleImageView.hidden = YES;
    [self.contentView addSubview:titleImageView];
    
    ///特色标题底view
    UIView *featuresRootView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 50.0f * 3.0f - 12.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT, titleImageView.frame.origin.y + titleImageView.frame.size.height + 5.0f, 50.0f * 3.0f + 12.0f, 25.0f)];
    [self.contentView addSubview:featuresRootView];
    objc_setAssociatedObject(self, &FeaturesRootViewKey, featuresRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///小区信息
    UILabel *communityNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, featuresRootView.frame.origin.y, (self.frame.size.width - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 5.0f) / 2.0f, 25.0f)];
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

///搭建中间标题信息的UI
- (void)createCommunityTitleInfoUI:(UIView *)view
{
    
    ///主标题
    UILabel *titleLabel = [[QSLabel alloc] initWithFrame:CGRectMake(3.0f, 9.0f, view.frame.size.width - 6.0f, 40.0f)];
    titleLabel.text = @"3.12";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_CHARACTERS_BLACK;
    titleLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    [view addSubview:titleLabel];
    objc_setAssociatedObject(self, &TitleInfoKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///副标题
    UILabel *subTitleLabel = [[QSLabel alloc] initWithFrame:CGRectMake(3.0f, titleLabel.frame.origin.y + titleLabel.frame.size.height, titleLabel.frame.size.width, 20.0f)];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.textColor = COLOR_CHARACTERS_BLACK;
    subTitleLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    subTitleLabel.text = [NSString stringWithFormat:@"万/%@",APPLICATION_AREAUNIT];
    [view addSubview:subTitleLabel];
    
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
    if (addressLabel && [model.village.street length] > 0) {
        
        NSString *addressInfo = [NSString stringWithFormat:@"%@ | %@",[QSCoreDataManager getDistrictValWithDistrictKey:model.village.areaid],[QSCoreDataManager getStreetValWithStreetKey:model.village.street]];
        addressLabel.text = addressInfo;
        
    }
    
    ///更新小区
    UILabel *communityLabel = objc_getAssociatedObject(self, &CommunityInfoKey);
    if (communityLabel && model.village.title) {
        
        communityLabel.text = model.village.title;
        
    }
    
    ///更新图片
    UIImageView *bgImageView = objc_getAssociatedObject(self, &BackgroudImageKey);
    if (bgImageView && model.village.attach_thumb) {
        
        [bgImageView loadImageWithURL:[model.village.attach_thumb getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_HOUSES_LOADING_FAIL690x350]];
        
    }

}

/**
 *  @author         yangshengmeng, 15-04-13 09:04:11
 *
 *  @brief          刷新新房UI
 *
 *  @param model    收藏的数据模型
 *
 *  @since          1.0.0
 */
- (void)updateHistoryNewHouseInfoCellUIWithDataModel:(QSNewHouseDetailDataModel *)model
{

    ///更新地址信息
    UILabel *addressLabel = objc_getAssociatedObject(self, &AddressInfoKey);
    if (addressLabel && [model.loupan.street length] > 0) {
        
        NSString *addressInfo = [NSString stringWithFormat:@"%@ | %@",[QSCoreDataManager getDistrictValWithDistrictKey:model.loupan.areaid],[QSCoreDataManager getStreetValWithStreetKey:model.loupan.street]];
        addressLabel.text = addressInfo;
        
    }
    
    ///更新标题
    NSString *titleString = [NSString stringWithFormat:@"%d",[model.loupan_building.price_avg intValue] / 10000];
    UILabel *titleLabel = objc_getAssociatedObject(self, &TitleInfoKey);
    if (titleLabel && [titleString length] > 0) {
        
        titleLabel.superview.hidden = NO;
        titleLabel.text = titleString;
        
    }
    
    ///更新小区
    UILabel *communityLabel = objc_getAssociatedObject(self, &CommunityInfoKey);
    if (communityLabel && [model.loupan.title length] > 0) {
        
        communityLabel.text = model.loupan.title;
        
    }
    
    ///更新标签
    [self updateFeaturesWithArray:model.loupan.features];
    
    ///更新图片
    UIImageView *bgImageView = objc_getAssociatedObject(self, &BackgroudImageKey);
    if (bgImageView && [model.loupan_building.attach_file length] > 0) {
        
        [bgImageView loadImageWithURL:[model.loupan_building.attach_file getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_HOUSES_LOADING_FAIL690x350]];
        
    }

}

///更新特色标签
- (void)updateFeaturesWithArray:(NSString *)featureString
{
    
    ///特色标签的底view
    UIView *rootView = objc_getAssociatedObject(self, &FeaturesRootViewKey);
    if (featureString && rootView && ([featureString length] > 0)) {
        
        ///清空原标签
        for (UIView *obj in [rootView subviews]) {
            
            [obj removeFromSuperview];
            
        }
        
        ///将标签信息转为数组
        NSArray *featuresList = [featureString componentsSeparatedByString:@","];
        
        ///标签宽度
        CGFloat width = (rootView.frame.size.width - 12.0f) / 3.0f;
        
        ///循环创建特色标签
        for (int i = 0; i < [featuresList count] && i < 3;i++) {
            
            ///标签项
            UILabel *tempLabel = [[QSLabel alloc] initWithFrame:CGRectMake(3.0f + i * (width + 3.0f), 0.0f, width, rootView.frame.size.height)];
            
            ///根据特色标签，查询标签内容
            NSString *featureVal = [QSCoreDataManager getHouseFeatureWithKey:featuresList[i] andFilterType:fFilterMainTypeNewHouse];
            
            tempLabel.text = featureVal;
            tempLabel.font = [UIFont systemFontOfSize:FONT_BODY_12];
            tempLabel.textAlignment = NSTextAlignmentCenter;
            tempLabel.backgroundColor = COLOR_CHARACTERS_BLACK;
            tempLabel.textColor = [UIColor whiteColor];
            tempLabel.layer.cornerRadius = 4.0f;
            tempLabel.layer.masksToBounds = YES;
            tempLabel.adjustsFontSizeToFitWidth = YES;
            [rootView addSubview:tempLabel];
            
        }
        
    }
    
}

@end
