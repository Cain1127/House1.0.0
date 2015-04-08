//
//  QSYPropertyHouseInfoTableViewCell.m
//  House
//
//  Created by ysmeng on 15/4/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYPropertyHouseInfoTableViewCell.h"

#import "NSString+Calculation.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "NSDate+Formatter.h"

#import "QSRentHouseInfoDataModel.h"
#import "QSHouseInfoDataModel.h"

#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+House.h"

#import <objc/runtime.h>

///关联
static char HouseImageKey;  //!<物业的图片
static char HouseTagKey;    //!<房源标签关联
static char HouseTypeKey;   //!<户型信息关联
static char PriceKey;       //!<售价/租金关联
static char AddressInfoKey; //!<地址信息
static char FeaturesRootKey;//!<标签底view
static char ViewCountKey;   //!<流量量关联
static char OrderCountKey;  //!<订单关联
static char ReleaseDateKey; //!<发布日期
static char SettingKey;     //!<设置按钮关联

@interface QSYPropertyHouseInfoTableViewCell ()

@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;//!<房源类型

///物业列表的回调
@property (nonatomic,copy) void(^propertyListCellCallBack)(PROPERTY_INFOCELL_ACTION_TYPE actionType);

@end

@implementation QSYPropertyHouseInfoTableViewCell

#pragma mark - 初始化
/**
 *  @author                 yangshengmeng, 15-04-07 23:04:41
 *
 *  @brief                  根据房源类型，创建物业信息UI
 *
 *  @param style            风格
 *  @param reuseIdentifier  复用标签
 *  @param houseType        房源类型
 *
 *  @return                 返回当前创建的物业cell
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andHouseType:(FILTER_MAIN_TYPE)houseType
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///保存房源类型
        self.houseType = houseType;
        
        ///搭建UI
        [self createPropertyListCellUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createPropertyListCellUI
{

    ///图片
    QSImageView *houseImageView = [[QSImageView alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f, 75.0f, 85.0f)];
    houseImageView.image = [UIImage imageNamed:IMAGE_ZONE_MYPROPERTYLIST_HOUSE_DEFAULT];
    [self.contentView addSubview:houseImageView];
    objc_setAssociatedObject(self, &HouseImageKey, houseImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///房源标签图片
    QSImageView *houseTagView = [[QSImageView alloc] initWithFrame:CGRectMake((houseImageView.frame.size.width - 30.0f) / 2.0f, 0.0f, 30.0f, 18.0f)];
    houseTagView.hidden = YES;
    [houseImageView addSubview:houseTagView];
    objc_setAssociatedObject(self, &HouseTagKey, houseTagView, OBJC_ASSOCIATION_ASSIGN);
    
    ///六角
    QSImageView *sixformImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, houseImageView.frame.size.height, houseImageView.frame.size.width)];
    sixformImageView.image = [UIImage imageNamed:IMAGE_USERICON_HOLLOW_150x170];
    [houseImageView addSubview:sixformImageView];
    
    ///室厅卫面积
    UILabel *areaInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(houseImageView.frame.origin.x + houseImageView.frame.size.width + 10.0f, houseImageView.frame.origin.y, 100.0f, 20.0f)];
    areaInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_18];
    areaInfoLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:areaInfoLabel];
    objc_setAssociatedObject(self, &HouseTypeKey, areaInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///租金/售价
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 90.0f, areaInfoLabel.frame.origin.y, 90.0f, 40.0f)];
    priceLabel.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    priceLabel.layer.cornerRadius = 6.0f;
    priceLabel.layer.masksToBounds = YES;
    priceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:priceLabel];
    objc_setAssociatedObject(self, &PriceKey, priceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///地址信息
    UILabel *addressInfo = [[UILabel alloc] initWithFrame:CGRectMake(areaInfoLabel.frame.origin.x, areaInfoLabel.frame.origin.y + areaInfoLabel.frame.size.height + 20.0f, 180.0f, 15.0f)];
    addressInfo.textColor = COLOR_CHARACTERS_LIGHTLIGHTGRAY;
    addressInfo.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [self.contentView addSubview:addressInfo];
    objc_setAssociatedObject(self, &AddressInfoKey, addressInfo, OBJC_ASSOCIATION_ASSIGN);
    
    ///标签信息
    UIView *featuresRootView = [[UIView alloc] initWithFrame:CGRectMake(addressInfo.frame.origin.x, addressInfo.frame.origin.y + addressInfo.frame.size.height + 10.0f, 180.0f, 20.0f)];
    [self.contentView addSubview:featuresRootView];
    objc_setAssociatedObject(self, &FeaturesRootKey, featuresRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///预约信息
    UILabel *orderInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(houseImageView.frame.origin.x, houseImageView.frame.origin.y + houseImageView.frame.size.height + 20.0f, 200.0f, 20.0f)];
    orderInfoLabel.textColor = COLOR_CHARACTERS_LIGHTLIGHTGRAY;
    orderInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self.contentView addSubview:orderInfoLabel];
    objc_setAssociatedObject(self, &ReleaseDateKey, orderInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///查看次数
    UILabel *viewCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0f, 0.0f, 40.0f, orderInfoLabel.frame.size.height)];
    viewCountLabel.adjustsFontSizeToFitWidth = YES;
    viewCountLabel.textAlignment = NSTextAlignmentCenter;
    viewCountLabel.textColor = COLOR_CHARACTERS_YELLOW;
    viewCountLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [orderInfoLabel addSubview:viewCountLabel];
    objc_setAssociatedObject(self, &ViewCountKey, viewCountLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///预约单
    UILabel *orderCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(105.0f, 0.0f, 40.0f, orderInfoLabel.frame.size.height)];
    orderCountLabel.adjustsFontSizeToFitWidth = YES;
    orderCountLabel.textAlignment = NSTextAlignmentCenter;
    orderCountLabel.textColor = COLOR_CHARACTERS_YELLOW;
    orderCountLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [orderInfoLabel addSubview:orderCountLabel];
    objc_setAssociatedObject(self, &OrderCountKey, orderCountLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///展开按钮
    UIButton *settinButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 44.0f, 165.0f - 44.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        if (button.selected) {
            
            ///收缩事件
            
        } else {
        
            ///刷开事件
        
        }
        
    }];
    [settinButton setImage:[UIImage imageNamed:IMAGE_ZONE_ASK_SETTING_NORMAL] forState:UIControlStateNormal];
    [settinButton setImage:[UIImage imageNamed:IMAGE_ZONE_ASK_SETTING_HIGHLIGHTED] forState:UIControlStateHighlighted];
    settinButton.selected = NO;
    [self.contentView addSubview:settinButton];
    objc_setAssociatedObject(self, &SettingKey, settinButton, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *topLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 165.0f - 0.25f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.25f)];
    topLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.contentView addSubview:topLineLabel];

}

#pragma mark - 刷新UI
/**
 *  @author             yangshengmeng, 15-04-07 23:04:49
 *
 *  @brief              刷新UI
 *
 *  @param tempModel    房源的数据模型
 *
 *  @since              1.0.0
 */
- (void)updateMyPropertyHouseInfo:(id)tempModel andHouseType:(FILTER_MAIN_TYPE)houseType andCallBack:(void(^)(PROPERTY_INFOCELL_ACTION_TYPE actionType))callBack
{
    
    ///保存回调
    if (callBack) {
        
        self.propertyListCellCallBack = callBack;
        
    }
    
    ///更换房源类型
    self.houseType = houseType;

    ///过滤类型
    if (fFilterMainTypeRentalHouse == self.houseType) {
        
        [self updateMyPropertyRentHouseInfo:tempModel];
        
    }
    
    if (fFilterMainTypeSecondHouse == self.houseType) {
        
        [self updateMyPropertySecondHandHouseInfo:tempModel];
        
    }

}

///更新出租房信息
- (void)updateMyPropertyRentHouseInfo:(QSRentHouseInfoDataModel *)tempModel
{
    
    ///求租求购标识图片
    if (hHouseRenantPropertyTypeEntire == [tempModel.rent_property intValue]) {
        
        [self updateHouseTagImage:IMAGE_ZONE_ASK_TAG_RENT_ENTIRE];
        
    }
    
    if (hHouseRenantPropertyTypeJoint == [tempModel.rent_property intValue]) {
        
        [self updateHouseTagImage:IMAGE_ZONE_ASK_TAG_RENT_PARTNER];
        
    }
    
    ///更新室厅面积信息
    [self updateHouseTitleInfo:tempModel.house_shi andTing:tempModel.house_ting andArea:tempModel.house_area];
    
    ///更新租金
    [self updatePriceInfo:[NSString stringWithFormat:@"%.0f",[tempModel.rent_price floatValue]] andUnit:@"/月"];
    
    ///更新地址信息
    [self updateHouseAddressInfo:[NSString stringWithFormat:@"%@|%@",[QSCoreDataManager getStreetValWithStreetKey:tempModel.street],tempModel.village_name]];
    
    ///更新发布日期
    [self updateHouseReleaseInfo:tempModel.update_time];
    
    ///更新查看次数
    [self updateHouseViewCountInfo:tempModel.view_count];
    
    ///更新订单数
    [self updateHouseOrderNumber:tempModel.reservation_num];
    
    ///更新标签信息
    [self updateHouseFeaturesInfo:tempModel.features];

    ///更新房源图片
    [self updateHouseImage:tempModel.attach_thumb];

}

///更新二手房信息
- (void)updateMyPropertySecondHandHouseInfo:(QSHouseInfoDataModel *)tempModel
{
    
    ///房源标识
    [self updateHouseTagImage:IMAGE_ZONE_ASK_TAG_BUY];
    
    ///更新室厅面积信息
    [self updateHouseTitleInfo:tempModel.house_shi andTing:tempModel.house_ting andArea:tempModel.house_area];
    
    ///更新售价
    [self updatePriceInfo:[NSString stringWithFormat:@"%.0f",[tempModel.house_price floatValue] / 10000.0f] andUnit:@"万"];
    
    ///更新地址信息
    [self updateHouseAddressInfo:[NSString stringWithFormat:@"%@|%@",[QSCoreDataManager getStreetValWithStreetKey:tempModel.street],tempModel.village_name]];
    
    ///更新发布日期
    [self updateHouseReleaseInfo:tempModel.update_time];
    
    ///更新查看次数
    [self updateHouseViewCountInfo:tempModel.view_count];
    
    ///更新订单数
    [self updateHouseOrderNumber:tempModel.reservation_num];
    
    ///更新标签信息
    [self updateHouseFeaturesInfo:tempModel.features];

    ///更新房源图片
    [self updateHouseImage:tempModel.attach_thumb];

}

///查看预约单数
- (void)updateHouseOrderNumber:(NSString *)orderNum
{

    UILabel *label = objc_getAssociatedObject(self, &OrderCountKey);
    if (label) {
        
        if ([orderNum length] > 0) {
            
            if ([orderNum intValue] > 999) {
                
                label.text = @"999+";
                
            } else {
                
                label.text = orderNum;
                
            }
            
        } else {
            
            label.text = nil;
            
        }
        
    }

}

///更新查看地次数
- (void)updateHouseViewCountInfo:(NSString *)viewCount
{

    UILabel *label = objc_getAssociatedObject(self, &ViewCountKey);
    if (label) {
        
        if ([viewCount length] > 0) {
            
            if ([viewCount intValue] > 999) {
                
                label.text = @"999+";
                
            } else {
            
                label.text = viewCount;
            
            }
            
        } else {
        
            label.text = nil;
        
        }
        
    }

}

///更新发布日期
- (void)updateHouseReleaseInfo:(NSString *)dateInfo
{

    UILabel *label = objc_getAssociatedObject(self, &ReleaseDateKey);
    if (label) {
        
        if ([dateInfo length] > 0) {
            
            label.text = [NSString stringWithFormat:@"浏览量(   ) 预约单(   ) %@发布",[[NSDate formatNSTimeToNSDateString:dateInfo] substringToIndex:10]];
            
        } else {
        
            label.text = nil;
        
        }
        
    }

}

///更新标签信息
- (void)updateHouseFeaturesInfo:(NSString *)featuresString
{

    UIView *rootView = objc_getAssociatedObject(self, &FeaturesRootKey);
    if (rootView) {
        
        ///清空原标签
        for (UIView *obj in [rootView subviews]) {
            
            [obj removeFromSuperview];
            
        }
        
        if ([featuresString length] <= 0) {
            
            return;
            
        }
        
        ///将标签信息转为数组
        NSArray *featuresList = [featuresString componentsSeparatedByString:@","];
        
        ///标签宽度
        CGFloat width = (rootView.frame.size.width - 16.0f) / 3.0f;
        
        ///循环创建特色标签
        for (int i = 0; i < [featuresList count] && i < 3;i++) {
            
            ///标签项
            UILabel *tempLabel = [[QSLabel alloc] initWithFrame:CGRectMake(3.0f + i * (width + 3.0f), 0.0f, width, rootView.frame.size.height)];
            
            ///根据特色标签，查询标签内容
            NSString *featureVal = [QSCoreDataManager getHouseFeatureWithKey:featuresList[i] andFilterType:self.houseType];
            
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

///更新地址信息
- (void)updateHouseAddressInfo:(NSString *)address
{

    UILabel *label = objc_getAssociatedObject(self, &AddressInfoKey);
    if (label) {
        
        if ([address length] > 0) {
            
            label.text = address;
            
        } else {
        
            label.text = nil;
        
        }
        
    }

}

///更新租金或售价
- (void)updatePriceInfo:(NSString *)price andUnit:(NSString *)unitInfo
{

    UILabel *label = objc_getAssociatedObject(self, &PriceKey);
    if (label) {
        
        if ([price length] > 0) {
            
            label.text = [NSString stringWithFormat:@"%@%@",price,unitInfo];
            
        } else {
        
            label.text = nil;
        
        }
        
    }

}

///更新房源图片
- (void)updateHouseImage:(NSString *)imageURL
{

    UIImageView *houseImageView = objc_getAssociatedObject(self, &HouseImageKey);
    if (houseImageView) {
        
        if ([imageURL length] > 0) {
            
            [houseImageView loadImageWithURL:[imageURL getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_ZONE_MYPROPERTYLIST_HOUSE_DEFAULT]];
            
        } else {
        
            houseImageView.image = [UIImage imageNamed:IMAGE_ZONE_MYPROPERTYLIST_HOUSE_DEFAULT];
        
        }
        
    }

}

///更新房子标识图片
- (void)updateHouseTagImage:(NSString *)imageName
{
    
    UIImageView *tagImageView = objc_getAssociatedObject(self, &HouseTagKey);
    if (tagImageView && imageName) {
        
        tagImageView.image = [UIImage imageNamed:imageName];
        tagImageView.hidden = NO;
        
    }
    
}

///更新室厅卫信息
- (void)updateHouseTitleInfo:(NSString *)roomNum andTing:(NSString *)tingNum andArea:(NSString *)areaInfo
{

    UILabel *label = objc_getAssociatedObject(self, &HouseTypeKey);
    if (label) {
        
        NSMutableString *tempString = [NSMutableString string];
        
        if ([roomNum length] > 0) {
            
            [tempString appendFormat:@"%@室",roomNum];
            
        }
        
        if ([tingNum length] > 0) {
            
            [tempString appendFormat:@"%@厅",tingNum];
            
        }
        
        if (tempString.length > 0) {
            
            [tempString appendString:@"|"];
            
        }
        
        if ([areaInfo length] > 0) {
            
            [tempString appendFormat:@"%.0f",[areaInfo floatValue]];
            
        }
        
        if (tempString.length > 0) {
            
            label.text = tempString;
            
        } else {
        
            label.text = @"";
        
        }
        
    }

}

/**
 *  @author         yangshengmeng, 15-04-07 23:04:19
 *
 *  @brief          设置编辑功能是否显示
 *
 *  @param isShow   YES-显示
 *
 *  @since          1.0.0
 */
- (void)updateEditFunctionShowStatus:(BOOL)isShow
{

    

}

@end
