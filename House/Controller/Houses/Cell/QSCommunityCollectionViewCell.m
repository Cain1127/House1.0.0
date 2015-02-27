//
//  QSCommunityCollectionViewCell.m
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCommunityCollectionViewCell.h"

#import "NSString+Calculation.h"

#import <objc/runtime.h>

///关联
static char AddressInfoKey;     //!<地址信息关联
static char BackgroudImageKey;  //!<背景图片关联
static char TitleInfoKey;       //!<标题信息关联
static char CommunityInfoKey;   //!<小区信息关联
static char FeaturesRootViewKey;//!<特色标签的底view关联

@implementation QSCommunityCollectionViewCell

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
    QSImageView *titleImageView = [[QSImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0f - 35.0f, bgImageView.frame.size.height - 79.0f, 70.0f, 79.0f)];
    titleImageView.image = [UIImage imageNamed:IMAGE_HOUSES_LIST_SIXFORM];
    [self createCommunityTitleInfoUI:titleImageView];
    [self.contentView addSubview:titleImageView];
    
    ///特色标题底view
    UIView *featuresRootView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 50.0f * 3.0f - 12.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT, titleImageView.frame.origin.y + titleImageView.frame.size.height + 5.0f, 50.0f * 3.0f + 12.0f, 25.0f)];
    [self.contentView addSubview:featuresRootView];
    objc_setAssociatedObject(self, &FeaturesRootViewKey, featuresRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///小区信息
    UILabel *communityNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, featuresRootView.frame.origin.y, SIZE_DEFAULT_MAX_WIDTH - featuresRootView.frame.size.width - 5.0f, 25.0f)];
    communityNameLabel.text = @"碧桂园清泉城";
    communityNameLabel.textColor = COLOR_CHARACTERS_BLACK;
    communityNameLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [self.contentView addSubview:communityNameLabel];
    objc_setAssociatedObject(self, &CommunityInfoKey, communityNameLabel, OBJC_ASSOCIATION_ASSIGN);

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
 *  @author             yangshengmeng, 15-02-12 18:02:39
 *
 *  @brief              小区或新房每项信息的刷新
 *
 *  @param dataModel    数据模型
 *
 *  @since              1.0.0
 */
- (void)updateCommunityInfoCellUIWithDataModel:(id)dataModel
{

    ///更新地址信息
    [self updateAddressInfo:nil];
    
    ///更新标题信息
    [self updateTitleInfo:nil];
    
    ///更新小区信息
    [self updateCommunityInfo:nil];
    
    ///更新特色标签
    [self updateFeaturesWithArray:nil];
    
    ///更新背景图片
    [self updateBackgroudImage:nil];

}

///更新特色标签
- (void)updateFeaturesWithArray:(NSArray *)featuresList
{

    ///特色标签的底view
//    UIView *rootView = objc_getAssociatedObject(self, &FeaturesRootViewKey);

}

///更新小区信息
- (void)updateCommunityInfo:(NSString *)info
{

    UILabel *communityLabel = objc_getAssociatedObject(self, &CommunityInfoKey);
    if (communityLabel && info) {
        
        communityLabel.text = info;
        
    }

}

///更新中间标题信息
- (void)updateTitleInfo:(NSString *)title
{

    UILabel *titleLabel = objc_getAssociatedObject(self, &TitleInfoKey);
    if (titleLabel && title) {
        
        titleLabel.text = title;
        
    }

}

///更新地址信息
- (void)updateAddressInfo:(NSString *)address
{

    UILabel *label = objc_getAssociatedObject(self, &AddressInfoKey);
    if (label && address) {
        
        label.text = address;
        
    }

}

///更新小区/新房的大图
- (void)updateBackgroudImage:(NSString *)imgUrl
{

    UIImageView *bgImageView = objc_getAssociatedObject(self, &BackgroudImageKey);
    if (bgImageView && imgUrl) {
        
        [bgImageView loadImageWithURL:[imgUrl getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_HOUSES_LOADING_FAIL690x350]];
        
    }

}

@end
