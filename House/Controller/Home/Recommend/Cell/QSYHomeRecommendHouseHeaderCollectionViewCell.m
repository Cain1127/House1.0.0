//
//  QSYHomeRecommendHouseHeaderCollectionViewCell.m
//  House
//
//  Created by ysmeng on 15/4/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYHomeRecommendHouseHeaderCollectionViewCell.h"

#import "NSString+Calculation.h"

#import "QSHouseInfoDataModel.h"

#import "QSCoreDataManager+App.h"

#import "UIImageView+AFNetworking.h"
#import <objc/runtime.h>

///头图片
#define HEADER_DEFAULT_IMAGE [UIImage imageNamed:IMAGE_HOME_RECOMMEND_HOUSE_HEADER_DEFAULT]

///关联
static char ImageKey;   //!<图片关联
static char PriceKey;   //!<售价关联
static char AreaKey;    //!<面积关联
static char TitleKey;   //!<标题信息
static char AddressKey; //!<地址信息关联

@implementation QSYHomeRecommendHouseHeaderCollectionViewCell

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        ///创建UI
        [self createHomeRecommendHouseHeaderUI];
        
        ///分隔线
        UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, frame.size.height - 0.5f, SIZE_DEFAULT_MAX_WIDTH, 0.5f)];
        sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [self.contentView addSubview:sepLabel];
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createHomeRecommendHouseHeaderUI
{

    CGFloat heightImage = SIZE_DEFAULT_MAX_WIDTH * 3.0f / 4.0f;
    CGFloat heightInfo = 120.0f;
    
    ///图片
    QSImageView *headerImageView = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, SIZE_DEFAULT_MAX_WIDTH, heightImage)];
    headerImageView.image = HEADER_DEFAULT_IMAGE;
    [self.contentView addSubview:headerImageView];
    objc_setAssociatedObject(self, &ImageKey, headerImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///其他信息底view
    UIView *infoRootView = [[UIView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, headerImageView.frame.origin.y + headerImageView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH, heightInfo)];
    [self createMainHouseInfo:infoRootView];
    infoRootView.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    [self.contentView addSubview:infoRootView];

}

- (void)createMainHouseInfo:(UIView *)rootView
{

    ///售价
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    priceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    priceLabel.adjustsFontSizeToFitWidth = YES;
    [rootView addSubview:priceLabel];
    objc_setAssociatedObject(self, &PriceKey, priceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///售价单位
    UILabel *priceUnitLabel = [[UILabel alloc] init];
    priceUnitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    priceUnitLabel.text = @"万";
    priceUnitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [rootView addSubview:priceUnitLabel];
    
    ///面积
    UILabel *areaLabel = [[UILabel alloc] init];
    areaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    areaLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    areaLabel.textAlignment = NSTextAlignmentRight;
    areaLabel.adjustsFontSizeToFitWidth = YES;
    [rootView addSubview:areaLabel];
    objc_setAssociatedObject(self, &AreaKey, areaLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///面积单位
    UILabel *areaUnitLabel = [[UILabel alloc] init];
    areaUnitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    areaUnitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    areaUnitLabel.text = @"/㎡";
    areaUnitLabel.textAlignment = NSTextAlignmentRight;
    [rootView addSubview:areaUnitLabel];
    
    ///标题信息
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [rootView addSubview:titleLabel];
    objc_setAssociatedObject(self, &TitleKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///地址附加信息
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    addressLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [rootView addSubview:addressLabel];
    objc_setAssociatedObject(self, &AddressKey, addressLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///控件
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(priceLabel,priceUnitLabel,areaLabel,areaUnitLabel,titleLabel,addressLabel);
    
    ///约束
    NSString *___hVFL_price = @"H:|-20-[priceLabel(>=40,<=120)]-0-[priceUnitLabel(20)]-(>=10)-[areaLabel(>=40,<=80)]-0-[areaUnitLabel(30)]-20-|";
    NSString *___hVFL_title = @"H:|-20-[titleLabel]-20-|";
    NSString *___hVFL_address = @"H:|-20-[addressLabel]-20-|";
    NSString *___vVFL_most = @"V:|-20-[priceLabel(30)]-10-[titleLabel(15)]-10-[addressLabel(15)]-20-|";
    
    ///添加约束
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_price options:NSLayoutFormatAlignAllBottom metrics:nil views:viewDict]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_title options:0 metrics:nil views:viewDict]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_address options:0 metrics:nil views:viewDict]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_most options:0 metrics:nil views:viewDict]];

}

#pragma mark - 刷新UI
- (void)updateRecommendHouseUIWithModel:(QSHouseInfoDataModel *)tempModel
{
    
    ///更新售价
    [self updateSalePrice:tempModel.house_price];
    
    ///更新面积
    [self updateAreaInfo:tempModel.house_area];
    
    ///更新标题
    [self updateTitleInfo:tempModel.title];
    
    ///更新地址信息
    NSString *houseType = [NSString stringWithFormat:@"%@室",tempModel.house_shi];
    if ([tempModel.house_ting intValue] > 0) {
        
        houseType = [houseType stringByAppendingString:[NSString stringWithFormat:@"%@厅",tempModel.house_ting]];
        
    }
    [self updateAddressInfo:tempModel.street andCommunity:tempModel.village_name andHouseType:houseType];

    ///更新图片
    [self updateHeaderImage:tempModel.attach_file];

}

///更新标题信息
- (void)updateTitleInfo:(NSString *)title
{

    UILabel *titleLabel = objc_getAssociatedObject(self, &TitleKey);
    if ([title length] > 0) {
        
        titleLabel.text = title;
        
    } else {
    
        titleLabel.text = nil;
    
    };

}

///更新地址信息
- (void)updateAddressInfo:(NSString *)streetKey andCommunity:(NSString *)community andHouseType:(NSString *)houseType
{

    UILabel *addressLabel = objc_getAssociatedObject(self, &AddressKey);
    NSMutableString *info = [NSMutableString string];
    
    if ([streetKey length] > 0) {
        
        [info appendString:[QSCoreDataManager getStreetValWithStreetKey:streetKey]];
        
    }
    
    if ([community length] > 0) {
        
        [info appendString:@" | "];
        [info appendString:community];
        
    }
    
    if ([houseType length] > 0) {
        
        [info appendString:@" | "];
        [info appendString:houseType];
        
    }
    
    if ([info length] > 0) {
        
        addressLabel.text = info;
        
    } else {
    
        addressLabel.text = nil;
    
    }

}

///更新面积
- (void)updateAreaInfo:(NSString *)area
{

    UILabel *areaLabel = objc_getAssociatedObject(self, &AreaKey);
    if ([area length] > 0) {
        
        areaLabel.text = area;
        
    } else {
    
        areaLabel.text = @"0";
    
    }

}

///更新售价
- (void)updateSalePrice:(NSString *)salePrice
{

    UILabel *priceLabel = objc_getAssociatedObject(self, &PriceKey);
    if ([salePrice length] > 0) {
        
        priceLabel.text = [NSString stringWithFormat:@"%.0f",[salePrice floatValue] / 10000];
        
    } else {
    
        priceLabel.text = @"0";
    
    }

}

///更新头图片
- (void)updateHeaderImage:(NSString *)headerURL
{

    UIImageView *headerImage = objc_getAssociatedObject(self, &ImageKey);
    if ([headerURL length] > 0) {
        
        [headerImage setImageWithURL:[headerURL getImageURL] placeholderImage:HEADER_DEFAULT_IMAGE];
        
    } else {
    
        headerImage.image = HEADER_DEFAULT_IMAGE;
    
    }

}

@end
