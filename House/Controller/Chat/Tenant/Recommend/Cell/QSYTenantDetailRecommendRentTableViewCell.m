//
//  QSYTenantDetailRecommendRentTableViewCell.m
//  House
//
//  Created by ysmeng on 15/4/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYTenantDetailRecommendRentTableViewCell.h"

#import "NSString+Calculation.h"

#import "QSRentHouseInfoDataModel.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+App.h"

#import <objc/runtime.h>

static char HouseImageKey;  //!<房源图片关联
static char HouseTagKey;    //!<房源标签关联
static char TitleLabelKey;  //!<标题信息关联
static char HouseTypeKey;   //!<户型关联
static char HouseAreaKey;   //!<房源面积关联
static char HouseStreetKey; //!<街道信息关联
static char CommunityKey;   //!<小区关联
static char FeaturesKey;    //!<特色标签关联

@implementation QSYTenantDetailRecommendRentTableViewCell

#pragma mark - UI初始化
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        ///UI搭建
        [self createTenantDetailRecommendRentUI];
        
        ///分隔线
        UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - 0.5f, self.frame.size.width, 0.5f)];
        sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [self.contentView addSubview:sepLabel];
        
    }
    
    return self;

}

#pragma mark - 搭建UI
- (void)createTenantDetailRecommendRentUI
{

    ///图片框
    QSImageView *houseImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.width * 247.0f / 330.0f)];
    houseImageView.image = [UIImage imageNamed:IMAGE_HOUSES_LOADING_FAIL330x250];
    [self.contentView addSubview:houseImageView];
    objc_setAssociatedObject(self, &HouseImageKey, houseImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///左上角标签
    QSImageView *houseTagImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 18.0f)];
    houseTagImageView.hidden = YES;
    [self.contentView addSubview:houseTagImageView];
    objc_setAssociatedObject(self, &HouseTagKey, houseTagImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///中间六角形图标
    QSImageView *titleImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 70.0f, 79.0f)];
    titleImageView.image = [UIImage imageNamed:IMAGE_HOUSES_LIST_SIXFORM];
    titleImageView.center = CGPointMake(self.frame.size.width / 2.0f, houseImageView.frame.size.height);
    [self createTitleInfoUI:titleImageView];
    [self.contentView addSubview:titleImageView];
    
    ///户型
    UILabel *houseTypeLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, titleImageView.frame.origin.y + titleImageView.frame.size.height + 5.0f, self.frame.size.width / 2.0f, 25.0f)];
    houseTypeLabel.text = @"3房1厅";
    houseTypeLabel.font = [UIFont systemFontOfSize:FONT_BODY_18];
    houseTypeLabel.textAlignment = NSTextAlignmentLeft;
    houseTypeLabel.textColor = COLOR_CHARACTERS_BLACK;
    [self.contentView addSubview:houseTypeLabel];
    objc_setAssociatedObject(self, &HouseTypeKey, houseTypeLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///面积
    UILabel *areaLabel = [[QSLabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0f, houseTypeLabel.frame.origin.y, houseTypeLabel.frame.size.width, houseTypeLabel.frame.size.height)];
    areaLabel.text = @"128/㎡";
    areaLabel.font = [UIFont systemFontOfSize:FONT_BODY_18];
    areaLabel.textAlignment = NSTextAlignmentRight;
    areaLabel.textColor = COLOR_CHARACTERS_BLACK;
    [self.contentView addSubview:areaLabel];
    objc_setAssociatedObject(self, &HouseAreaKey, areaLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///街道和小区信息的底view，方便自适应
    UIView *streetRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, houseTypeLabel.frame.origin.y + houseTypeLabel.frame.size.height + 5.0f, self.frame.size.width, 15.0f)];
    [self createStreetAndCommunityUI:streetRootView];
    [self.contentView addSubview:streetRootView];
    
    ///特色标签的底view
    UIView *featuresRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, streetRootView.frame.origin.y + streetRootView.frame.size.height + 10.0f, self.frame.size.width, 20.0)];
    [self.contentView addSubview:featuresRootView];
    objc_setAssociatedObject(self, &FeaturesKey, featuresRootView, OBJC_ASSOCIATION_ASSIGN);

}

///搭建小区和街道的信息UI
- (void)createStreetAndCommunityUI:(UIView *)view
{
    
    ///街道
    UILabel *streetLabel = [[UILabel alloc] init];
    streetLabel.text = @"北京路";
    streetLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    streetLabel.textAlignment = NSTextAlignmentLeft;
    streetLabel.textColor = COLOR_CHARACTERS_GRAY;
    streetLabel.translatesAutoresizingMaskIntoConstraints = NO;
    streetLabel.adjustsFontSizeToFitWidth = YES;
    [view addSubview:streetLabel];
    objc_setAssociatedObject(self, &HouseStreetKey, streetLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///小区
    UILabel *communityLabel = [[UILabel alloc] init];
    communityLabel.text = @"科城山庄峻森园";
    communityLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    communityLabel.textAlignment = NSTextAlignmentRight;
    communityLabel.textColor = COLOR_CHARACTERS_GRAY;
    communityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    communityLabel.adjustsFontSizeToFitWidth = YES;
    [view addSubview:communityLabel];
    objc_setAssociatedObject(self, &CommunityKey, communityLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///约束参数
    NSDictionary *___viewsVFL = NSDictionaryOfVariableBindings(streetLabel,communityLabel);
    
    ///约束
    NSString *___hVFL_all = @"H:|[streetLabel(>=60)]-5-[communityLabel(>=60)]|";
    NSString *___vVFL_street = @"V:|[streetLabel(15)]|";
    
    ///添加约束
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_all options:NSLayoutFormatAlignAllCenterY metrics:nil views:___viewsVFL]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_street options:NSLayoutFormatAlignAllCenterY metrics:nil views:___viewsVFL]];
    
}

///标题信息UI搭建
- (void)createTitleInfoUI:(UIView *)view
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f, 25.0f, view.frame.size.width - 4.0f, 20.0f)];
    titleLabel.text = @"340";
    titleLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_CHARACTERS_BLACK;
    [view addSubview:titleLabel];
    objc_setAssociatedObject(self, &TitleLabelKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *titleUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f, titleLabel.frame.origin.y + titleLabel.frame.size.height, titleLabel.frame.size.width, 14.0f)];
    titleUnitLabel.text = @"元/月";
    titleUnitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    titleUnitLabel.textAlignment = NSTextAlignmentCenter;
    titleUnitLabel.textColor = COLOR_CHARACTERS_BLACK;
    [view addSubview:titleUnitLabel];
    
}

#pragma mark - 刷新UI
/**
 *  @author             yangshengmeng, 15-05-01 12:05:38
 *
 *  @brief              刷新UI
 *
 *  @param tempModel    数据模型
 *
 *  @since              1.0.0
 */
- (void)updateTenantDetailRecommendRentUI:(QSRentHouseInfoDataModel *)tempModel
{

    ///更新小区
    [self updateHouseCommunityInfo:tempModel.village_name];
    
    ///更新详细街道信息
    [self updateHouseStreetInfo:[QSCoreDataManager getStreetValWithStreetKey:tempModel.street]];
    
    ///更新房子面积信息
    [self updateHouseAreaInfo:[NSString stringWithFormat:@"%d",[tempModel.house_area intValue]]];
    
    ///更新房子户型信息
    [self updateHouseTypeInfo:tempModel.house_shi and:tempModel.house_ting];
    
    ///更新中间标题
    [self updateTitleWithTitle:[NSString stringWithFormat:@"%d",[tempModel.rent_price intValue]]];
    
    ///更新背景图片
    [self updateHouseImage:tempModel.attach_file];
    
    ///更新左上角标签
    [self updateHouseTagImage:tempModel.rent_property];
    
    ///更新房子特色标签
    [self updateHouseFeatures:tempModel.features];

}

///更新房子的特色标签
- (void)updateHouseFeatures:(NSString *)featureString
{
    
    UIView *view = objc_getAssociatedObject(self, &FeaturesKey);
    if (featureString && view && ([featureString length] > 0)) {
        
        ///清空原标签
        for (UIView *obj in [view subviews]) {
            
            [obj removeFromSuperview];
            
        }
        
        ///将标签信息转为数组
        NSArray *featuresList = [featureString componentsSeparatedByString:@","];
        
        ///标签宽度
        CGFloat width = (view.frame.size.width - 12.0f) / 3.0f;
        
        ///循环创建特色标签
        for (int i = 0; i < [featuresList count] && i < 3;i++) {
            
            ///标签项
            UILabel *tempLabel = [[QSLabel alloc] initWithFrame:CGRectMake(3.0f + i * (width + 3.0f), 0.0f, width, view.frame.size.height)];
            
            ///根据特色标签，查询标签内容
            NSString *featureVal = [QSCoreDataManager getHouseFeatureWithKey:featuresList[i] andFilterType:fFilterMainTypeRentalHouse];
            
            tempLabel.text = featureVal;
            tempLabel.font = [UIFont systemFontOfSize:FONT_BODY_12];
            tempLabel.textAlignment = NSTextAlignmentCenter;
            tempLabel.backgroundColor = COLOR_CHARACTERS_BLACK;
            tempLabel.textColor = [UIColor whiteColor];
            tempLabel.layer.cornerRadius = 4.0f;
            tempLabel.layer.masksToBounds = YES;
            tempLabel.adjustsFontSizeToFitWidth = YES;
            [view addSubview:tempLabel];
            
        }
        
    } else {
        
        ///清空原标签
        for (UIView *obj in [view subviews]) {
            
            [obj removeFromSuperview];
            
        }
        
    }
    
}

///更新房子左上角标签图片
- (void)updateHouseTagImage:(NSString *)tag
{
    
    UIImageView *imageView = objc_getAssociatedObject(self, &HouseTagKey);
    if (imageView && [tag length] > 0) {
        
        ///判断标签图片类型
        int isFreeRange = [tag intValue];
        
        ///整租
        if (hHouseRenantPropertyTypeEntire == isFreeRange) {
            
            imageView.hidden = NO;
            imageView.image = [UIImage imageNamed:IMAGE_HOUSES_LIST_ENTIRERENT];
            
        } else if (hHouseRenantPropertyTypeEntire == isFreeRange) {
            
            ///合租
            imageView.hidden = NO;
            imageView.image = [UIImage imageNamed:IMAGE_HOUSES_LIST_JOINTRENT];
            
        } else {
            
            imageView.hidden = YES;
            
        }
        
    } else {
        
        imageView.hidden = YES;
        
    }
    
}

///更新房子大图
- (void)updateHouseImage:(NSString *)urlString
{
    
    UIImageView *imageView = objc_getAssociatedObject(self, &HouseImageKey);
    if (imageView && urlString && ([urlString length] > 1)) {
        
        [imageView loadImageWithURL:[urlString getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_HOUSES_LOADING_FAIL330x250]];
        
    } else {
        
        imageView.image = [UIImage imageNamed:IMAGE_HOUSES_LOADING_FAIL330x250];
        
    }
    
}

///更新中间标题
- (void)updateTitleWithTitle:(NSString *)title
{
    
    UILabel *label = objc_getAssociatedObject(self, &TitleLabelKey);
    
    ///更新标题信息
    if (label && [title length] > 0) {
        
        label.text = title;
        
    } else {
        
        label.text = nil;
        
    }
    
}

///更新户型信息
- (void)updateHouseTypeInfo:(NSString *)houseCount and:(NSString *)hallCount
{
    
    UILabel *label = objc_getAssociatedObject(self, &HouseTypeKey);
    if (label && [houseCount intValue] > 0) {
        
        NSString *shiString = [NSString stringWithFormat:@"%@室",houseCount];
        if (hallCount) {
            
            [shiString stringByAppendingString:[NSString stringWithFormat:@"%@厅",hallCount]];
            
        }
        
        label.text = shiString;
        
    } else {
        
        label.text = nil;
        
    }
    
}

///更新房子面积
- (void)updateHouseAreaInfo:(NSString *)area
{
    
    UILabel *label = objc_getAssociatedObject(self, &HouseAreaKey);
    if (label && [area length] > 0) {
        
        label.text = [NSString stringWithFormat:@"%@/%@",area,APPLICATION_AREAUNIT];
        
    } else {
        
        label.text = nil;
        
    }
    
}

///更新街道信息
- (void)updateHouseStreetInfo:(NSString *)street
{
    
    UILabel *label = objc_getAssociatedObject(self, &HouseStreetKey);
    if (label && [street length] > 0) {
        
        label.text = street;
        
    } else {
        
        label.text = nil;
        
    }
    
}

///更新房子所在的小区信息
- (void)updateHouseCommunityInfo:(NSString *)info
{
    
    UILabel *label = objc_getAssociatedObject(self, &CommunityKey);
    if (label && [info length] > 0) {
        
        label.text = info;
        
    } else {
        
        label.text = nil;
        
    }
    
}

@end
