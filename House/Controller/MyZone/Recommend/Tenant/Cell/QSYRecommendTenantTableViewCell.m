//
//  QSYRecommendTenantTableViewCell.m
//  House
//
//  Created by ysmeng on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYRecommendTenantTableViewCell.h"

#import "NSString+Calculation.h"

#import "QSYRecommendTenantInfoDataModel.h"
#import "QSUserSimpleDataModel.h"
#import "QSYAskRentAndBuyDataModel.h"

#import "UIImageView+AFNetworking.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+App.h"

#import <objc/runtime.h>

///关联
static char IconKey;        //!<头像关联
static char UserNameKey;    //!<用户名关联
static char AddressKey;     //!<地址信息关联
static char TargetKey;      //!<购房目的或者租金支付方式关联
static char HouseNumberKey; //!<几室几厅信息关联
static char PriceKey;       //!<售价/租金关联
static char PriceUnitKey;   //!<售价/租金单位关联
static char AreaKey;        //!<面积关联
static char TradeTypeKey;   //!<物业类型
static char DecorationKey;  //!<装修类型
static char FaceKey;        //!<朝向
static char FloorKey;       //!<楼层
static char UserYearKey;    //!<房龄
static char FeaturesKey;    //!<标签
static char CommentKey;     //!<备注

@interface QSYRecommendTenantTableViewCell ()

///推荐房客的信息cell事件回调
@property (nonatomic,copy) void(^recommendTenantCellCallBack)(RECOMMEND_TENANT_CELL_ACTION_TYPE actionType,id params);

@end

@implementation QSYRecommendTenantTableViewCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///创建UI
        [self createRecommendTenantInfoUI];
        
    }
    
    return self;

}

#pragma mark - 搭建UI
- (void)createRecommendTenantInfoUI
{

    ///头像
    QSImageView *iconView = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f, 50.0f, 50.0f)];
    iconView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_80];
    [self.contentView addSubview:iconView];
    objc_setAssociatedObject(self, &IconKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    ///六角
    QSImageView *iconSixForm = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconView.frame.size.width, iconView.frame.size.height)];
    iconSixForm.image = [UIImage imageNamed:IMAGE_USERICON_HOLLOW_80];
    [iconView addSubview:iconSixForm];
    
    ///姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.origin.x + iconView.frame.size.width + 10.0f, iconView.frame.origin.y + 10.0f, 120.0f, 20.0f)];
    nameLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:nameLabel];
    objc_setAssociatedObject(self, &UserNameKey, nameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///聊天
    UIButton *talkButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 40.0f * 2.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 5.0f, 25.0f, 40.0f, 40.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        if (self.recommendTenantCellCallBack) {
            
            self.recommendTenantCellCallBack(rRecommendTenantCellActionTypeTalk,nil);
            
        }
        
    }];
    [talkButton setImage:[UIImage imageNamed:IMAGE_ZONE_CONTACT_TALK_NORMAL] forState:UIControlStateNormal];
    [talkButton setImage:[UIImage imageNamed:IMAGE_ZONE_CONTACT_TALK_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.contentView addSubview:talkButton];
    
    ///推荐房源
    UIButton *recommendButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 40.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 25.0f, 40.0f, 40.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        if (self.recommendTenantCellCallBack) {
            
            self.recommendTenantCellCallBack(rRecommendTenantCellActionTypeRecommend,nil);
            
        }
        
    }];
    [recommendButton setImage:[UIImage imageNamed:IMAGE_ZONE_TENANT_RECOMMEND_NORMAL] forState:UIControlStateNormal];
    [recommendButton setImage:[UIImage imageNamed:IMAGE_ZONE_TENANT_RECOMMEND_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.contentView addSubview:recommendButton];
    
    ///分隔线
    QSImageView *sepImageView = [[QSImageView alloc] initWithFrame:CGRectMake(iconView.center.x - 7.0f, iconView.frame.origin.y + iconView.frame.size.height + 5.0f, 14.0f, 4.0f)];
    sepImageView.image = [UIImage imageNamed:IMAGE_ZONE_RECOMMEND_TENANT_SEPIMAGE];
    [self.contentView addSubview:sepImageView];
    
    UILabel *headerSep = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, sepImageView.frame.origin.y + sepImageView.frame.size.height, iconView.frame.size.width / 2.0f - 7.0f, 0.25f)];
    headerSep.backgroundColor = COLOR_CHARACTERS_GRAY;
    [self.contentView addSubview:headerSep];
    
    UILabel *footerSep = [[UILabel alloc] initWithFrame:CGRectMake(sepImageView.frame.origin.x + sepImageView.frame.size.width, sepImageView.frame.origin.y + sepImageView.frame.size.height, SIZE_DEVICE_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT - sepImageView.frame.origin.x - sepImageView.frame.size.width, 0.25f)];
    footerSep.backgroundColor = COLOR_CHARACTERS_GRAY;
    [self.contentView addSubview:footerSep];
    
    ///地址信息
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, iconView.frame.origin.y + iconView.frame.size.height + 30.0f, 180.0f, 20.0f)];
    addressLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    addressLabel.textColor = COLOR_CHARACTERS_BLACK;
    [self.contentView addSubview:addressLabel];
    objc_setAssociatedObject(self, &AddressKey, addressLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///购买目的或者租金支付方式
    UILabel *targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, addressLabel.frame.origin.y + addressLabel.frame.size.height + 5.0f, 120.0f, 15.0f)];
    targetLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    targetLabel.textColor = COLOR_CHARACTERS_BLACK;
    [self.contentView addSubview:targetLabel];
    objc_setAssociatedObject(self, &TargetKey, targetLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///几室几厅
    UILabel *houseNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 160.0f, targetLabel.frame.origin.y - 5.0f, 120.0f, 20.0f)];
    houseNumLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    houseNumLabel.textColor = COLOR_CHARACTERS_BLACK;
    houseNumLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:houseNumLabel];
    objc_setAssociatedObject(self, &HouseNumberKey, houseNumLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///总价-租金
    UIView *priceRootView = [[UIView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, targetLabel.frame.origin.y + targetLabel.frame.size.height + 10.0f, (SIZE_DEFAULT_MAX_WIDTH - 8.0f) / 2.0f, 44.0f)];
    priceRootView.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    priceRootView.layer.cornerRadius = 6.0f;
    [self.contentView addSubview:priceRootView];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, priceRootView.frame.size.width - 60.0f, 44.0f)];
    priceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_25];
    priceLabel.textColor = COLOR_CHARACTERS_BLACK;
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.adjustsFontSizeToFitWidth = YES;
    [priceRootView addSubview:priceLabel];
    objc_setAssociatedObject(self, &PriceKey, priceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///单位
    UILabel *priceUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width, priceLabel.frame.origin.y + 20.0f, 60.0f, 15.0f)];
    priceUnitLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    priceUnitLabel.textColor = COLOR_CHARACTERS_BLACK;
    priceUnitLabel.textAlignment = NSTextAlignmentLeft;
    priceUnitLabel.text = @"万";
    [priceRootView addSubview:priceUnitLabel];
    objc_setAssociatedObject(self, &PriceUnitKey, priceUnitLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///面积
    UIView *areaRootView = [[UIView alloc] initWithFrame:CGRectMake(priceRootView.frame.origin.x + priceRootView.frame.size.width + 8.0f, priceRootView.frame.origin.y, priceRootView.frame.size.width, priceRootView.frame.size.height)];
    areaRootView.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    areaRootView.layer.cornerRadius = 6.0f;
    [self.contentView addSubview:areaRootView];
    
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, priceRootView.frame.size.width - 60.0f, 44.0f)];
    areaLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_25];
    areaLabel.textColor = COLOR_CHARACTERS_BLACK;
    areaLabel.textAlignment = NSTextAlignmentRight;
    [areaRootView addSubview:areaLabel];
    objc_setAssociatedObject(self, &AreaKey, areaLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *areaUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(areaLabel.frame.origin.x + areaLabel.frame.size.width, areaLabel.frame.origin.y + 20.0f, 60.0f, 15.0f)];
    areaUnitLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    areaUnitLabel.textColor = COLOR_CHARACTERS_BLACK;
    areaUnitLabel.textAlignment = NSTextAlignmentLeft;
    areaUnitLabel.text = [NSString stringWithFormat:@"/%@",APPLICATION_AREAUNIT];
    [areaRootView addSubview:areaUnitLabel];
    
    ///附加信息的标题宽度
    CGFloat widthTitle = 45.0f;
    CGFloat widthValue = (SIZE_DEFAULT_MAX_WIDTH - 2.0f * widthTitle - 8.0f - 10.0f) / 2.0f;
    
    ///物业类型
    UILabel *tradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, areaRootView.frame.origin.y + areaRootView.frame.size.height + 20.0f, widthTitle, 15.0f)];
    tradeLabel.text  =@"类  型";
    tradeLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    tradeLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [self.contentView addSubview:tradeLabel];
    
    ///内容项
    UILabel *tradeInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(tradeLabel.frame.origin.x + tradeLabel.frame.size.width + 5.0f, tradeLabel.frame.origin.y, widthValue, 15.0f)];
    tradeInfoLabel.textColor = COLOR_CHARACTERS_BLACK;
    tradeInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    tradeInfoLabel.textAlignment = NSTextAlignmentLeft;
    tradeInfoLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:tradeInfoLabel];
    objc_setAssociatedObject(self, &TradeTypeKey, tradeInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///装修
    UILabel *decorationLabel = [[UILabel alloc] initWithFrame:CGRectMake(tradeInfoLabel.frame.origin.x + tradeInfoLabel.frame.size.width + 8.0f, tradeInfoLabel.frame.origin.y, widthTitle, 15.0f)];
    decorationLabel.text  = @"装  修";
    decorationLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    decorationLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [self.contentView addSubview:decorationLabel];
    
    ///内容项
    UILabel *decorationInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(decorationLabel.frame.origin.x + decorationLabel.frame.size.width + 5.0f, decorationLabel.frame.origin.y, widthValue, 15.0f)];
    decorationInfoLabel.textColor = COLOR_CHARACTERS_BLACK;
    decorationInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    decorationInfoLabel.textAlignment = NSTextAlignmentLeft;
    decorationInfoLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:decorationInfoLabel];
    objc_setAssociatedObject(self, &DecorationKey, decorationInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///朝向
    UILabel *faceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, tradeLabel.frame.origin.y + tradeLabel.frame.size.height + 5.0f, widthTitle, 15.0f)];
    faceLabel.text  =@"朝  向";
    faceLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    faceLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [self.contentView addSubview:faceLabel];
    
    ///内容项
    UILabel *faceInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(faceLabel.frame.origin.x + faceLabel.frame.size.width + 5.0f, faceLabel.frame.origin.y, widthValue, 15.0f)];
    faceInfoLabel.textColor = COLOR_CHARACTERS_BLACK;
    faceInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    faceInfoLabel.textAlignment = NSTextAlignmentLeft;
    faceInfoLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:faceInfoLabel];
    objc_setAssociatedObject(self, &FaceKey, faceInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///楼层
    UILabel *floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(faceInfoLabel.frame.origin.x + faceInfoLabel.frame.size.width + 8.0f, faceLabel.frame.origin.y, widthTitle, 15.0f)];
    floorLabel.text  =@"楼  层";
    floorLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    floorLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [self.contentView addSubview:floorLabel];
    
    ///内容项
    UILabel *floorInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(floorLabel.frame.origin.x + floorLabel.frame.size.width + 5.0f, floorLabel.frame.origin.y, widthValue, 15.0f)];
    floorInfoLabel.textColor = COLOR_CHARACTERS_BLACK;
    floorInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    floorInfoLabel.textAlignment = NSTextAlignmentLeft;
    floorInfoLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:floorInfoLabel];
    objc_setAssociatedObject(self, &FloorKey, floorInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///房龄
    UILabel *usedYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, floorLabel.frame.origin.y + floorLabel.frame.size.height + 5.0f, widthTitle, 15.0f)];
    usedYearLabel.text  =@"房  龄";
    usedYearLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    usedYearLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [self.contentView addSubview:usedYearLabel];
    
    ///内容项
    UILabel *usedYearInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(usedYearLabel.frame.origin.x + usedYearLabel.frame.size.width + 5.0f, usedYearLabel.frame.origin.y, widthValue, 15.0f)];
    usedYearInfoLabel.textColor = COLOR_CHARACTERS_BLACK;
    usedYearInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    usedYearInfoLabel.textAlignment = NSTextAlignmentLeft;
    usedYearInfoLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:usedYearInfoLabel];
    objc_setAssociatedObject(self, &UserYearKey, usedYearInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///标签
    UIView *featuresRootView = [[UIView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, usedYearLabel.frame.origin.y + usedYearLabel.frame.size.height + 10.0f, SIZE_DEFAULT_MAX_WIDTH, 20.0f)];
    [self.contentView addSubview:featuresRootView];
    objc_setAssociatedObject(self, &FeaturesKey, featuresRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///备注
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, featuresRootView.frame.origin.y + featuresRootView.frame.size.height + 10.0f, SIZE_DEFAULT_MAX_WIDTH, 45.0f)];
    commentLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    commentLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    commentLabel.numberOfLines = 2;
    [self.contentView addSubview:commentLabel];
    objc_setAssociatedObject(self, &CommentKey, commentLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 420.0f - 0.25f, SIZE_DEFAULT_MAX_WIDTH, 0.25f)];
    bottomLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.contentView addSubview:bottomLineLabel];

}

#pragma mark - 刷新UI
/**
 *  @author             yangshengmeng, 15-04-15 16:04:21
 *
 *  @brief              根据推荐房客的信息，刷新房客UI
 *
 *  @param tempModel    数据模型
 *  @param callBack     房客cell中相关事件回调
 *
 *  @since              1.0.0
 */
- (void)updateRecommendTenantInfoCellUI:(QSYRecommendTenantInfoDataModel *)tempModel andCallBack:(void(^)(RECOMMEND_TENANT_CELL_ACTION_TYPE actionType,id params))callBack
{
    
    ///保存回调
    if (callBack) {
        
        self.recommendTenantCellCallBack = callBack;
        
    }
    
    ///更新用户名
    [self updateUserName:tempModel.buyer_msg.username];
    
    ///地址信息
    [self updateHouseAddress:tempModel.need_msg.areaid andStreetKey:tempModel.need_msg.street];
    
    ///室厅信息更新
    [self updateHouseNumberInfo:tempModel.need_msg.house_shi andTingNum:tempModel.need_msg.house_ting];
    
    ///更新面积:model.areaid
    [self updateHouseArea:[QSCoreDataManager getHouseAreaTypeWithKey:tempModel.need_msg.areaid]];
    
    ///物业类型
    [self updateTradeType:[QSCoreDataManager getHouseTradeTypeWithKey:tempModel.need_msg.property_type]];
    
    ///装修
    [self updateDecoration:[QSCoreDataManager getHouseDecorationTypeWithKey:tempModel.need_msg.decoration_type]];
    
    ///朝向
    [self updateHouseFace:[QSCoreDataManager getHouseFaceTypeWithKey:tempModel.need_msg.house_face]];
    
    ///楼层
    [self updateHouseFloor:[QSCoreDataManager getHouseFloorTypeWithKey:tempModel.need_msg.floor_which]];
    
    ///房龄
    [self updateHouseUseYear:[QSCoreDataManager getHouseUsedYearTypeWithKey:tempModel.need_msg.used_year]];
    
    ///备注信息
    [self updateCommentInfo:tempModel.need_msg.content];
    
    ///更新头像
    [self updateUserIcon:tempModel.buyer_msg.avatar];
    
    ///更新求租UI信息
    if (1 == [tempModel.need_msg.type intValue]) {
        
        ///更新租金支付方式
        [self updateRentPayType:[QSCoreDataManager getHouseRentTypeWithKey:tempModel.need_msg.payment]];
        
        ///更新价钱信息
        [self updatePriceInfo:tempModel.need_msg.price AndUnit:@"元以下"];
        
        ///更新标签
        [self updateFeatures:tempModel.need_msg.features andHouseType:fFilterMainTypeRentalHouse];
        
    }
    
    ///更新求购信息
    if (2 == [tempModel.need_msg.type intValue]) {
        
        ///更新物业类型
        [self updateRentPayType:[QSCoreDataManager getPerpostPerchaseTypeWithKey:tempModel.need_msg.intent]];
        
        ///更新价钱信息
        [self updatePriceInfo:[NSString stringWithFormat:@"%.0f",([tempModel.need_msg.price floatValue]) / 10000] AndUnit:@"万"];
        
        ///更新标签
        [self updateFeatures:tempModel.need_msg.features andHouseType:fFilterMainTypeSecondHouse];
        
    }

}

///更新金钱信息
- (void)updatePriceInfo:(NSString *)priceString AndUnit:(NSString *)unitString
{
    
    UILabel *priceLabel = objc_getAssociatedObject(self, &PriceKey);
    if (priceLabel && priceString) {
        
        priceLabel.text = priceString;
        
    }
    
    UILabel *unitLabel = objc_getAssociatedObject(self, &PriceUnitKey);
    if (unitLabel && unitString) {
        
        unitLabel.text = unitString;
        
    }
    
}

///更新标签
- (void)updateFeatures:(NSString *)featureString andHouseType:(FILTER_MAIN_TYPE)houseType
{
    
    UIView *rootView = objc_getAssociatedObject(self, &FeaturesKey);
    if (rootView && [featureString length] > 0) {
        
        ///清空原标签
        for (UIView *obj in [rootView subviews]) {
            
            [obj removeFromSuperview];
            
        }
        
        ///将标签信息转为数组
        NSArray *featuresList = [featureString componentsSeparatedByString:@","];
        
        ///标签宽度
        CGFloat width = (rootView.frame.size.width - 12.0f) / 5.0f;
        
        ///循环创建特色标签
        for (int i = 0; i < [featuresList count] && i < 3;i++) {
            
            ///标签项
            UILabel *tempLabel = [[QSLabel alloc] initWithFrame:CGRectMake(3.0f + i * (width + 3.0f), 0.0f, width, rootView.frame.size.height)];
            
            ///根据特色标签，查询标签内容
            NSString *featureVal = [QSCoreDataManager getHouseFeatureWithKey:featuresList[i] andFilterType:houseType];
            
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

///更新购房目的或者租金支付方式
- (void)updateRentPayType:(NSString *)info
{
    
    UILabel *payTypeLabel = objc_getAssociatedObject(self, &TargetKey);
    if (payTypeLabel && info) {
        
        payTypeLabel.text = info;
        
    }
    
}

///备注
- (void)updateCommentInfo:(NSString *)comment
{
    
    UILabel *commentLabel = objc_getAssociatedObject(self, &CommentKey);
    if (commentLabel && comment) {
        
        commentLabel.text = comment;
        
    }
    
}

///更新房龄
- (void)updateHouseUseYear:(NSString *)useYear
{
    
    UILabel *useYearLabel = objc_getAssociatedObject(self, &UserYearKey);
    if (useYearLabel && useYear) {
        
        useYearLabel.text = useYear;
        
    }
    
}

///楼层
- (void)updateHouseFloor:(NSString *)floor
{
    
    UILabel *floorLabel = objc_getAssociatedObject(self, &FloorKey);
    if (floorLabel && floor) {
        
        floorLabel.text = floor;
        
    }
    
}

///朝向
- (void)updateHouseFace:(NSString *)face
{
    
    UILabel *faceLabel = objc_getAssociatedObject(self, &FaceKey);
    if (faceLabel && face) {
        
        faceLabel.text = face;
        
    }
    
}

///装修类型
- (void)updateDecoration:(NSString *)decoration
{
    
    UILabel *decorationLabel = objc_getAssociatedObject(self, &DecorationKey);
    if (decorationLabel && decoration) {
        
        decorationLabel.text = decoration;
        
    }
    
}

///物业类型
- (void)updateTradeType:(NSString *)tradeType
{
    
    UILabel *tradeLabel = objc_getAssociatedObject(self, &TradeTypeKey);
    if (tradeLabel && tradeType) {
        
        tradeLabel.text = tradeType;
        
    }
    
}

///更新面积
- (void)updateHouseArea:(NSString *)area
{
    
    UILabel *labelArea = objc_getAssociatedObject(self, &AreaKey);
    if (labelArea && area) {
        
        labelArea.text = [NSString stringWithFormat:@"%.0f",[area floatValue]];
        
    }
    
}

///更新头像
- (void)updateUserIcon:(NSString *)iconURL
{

    UIImageView *imageView = objc_getAssociatedObject(self, &IconKey);
    if (imageView && [iconURL length] > 0) {
        
        [imageView setImageWithURL:[iconURL getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_DEFAULT_80]];
        
    }

}

///更新几室几厅
- (void)updateHouseNumberInfo:(NSString *)houseNum andTingNum:(NSString *)tingNum
{
    
    UILabel *numberLabel = objc_getAssociatedObject(self, &HouseNumberKey);
    if (numberLabel && houseNum) {
        
        NSString *showString = [NSString stringWithFormat:@"%@室",houseNum];
        if ([tingNum length] > 0) {
            
            showString = [showString stringByAppendingString:[NSString stringWithFormat:@"%@厅",tingNum]];
            
        }
        numberLabel.text = showString;
        
    }
    
}

///更新地址信息
- (void)updateHouseAddress:(NSString *)districtKey andStreetKey:(NSString *)streetKey
{
    
    UILabel *addressLabel = objc_getAssociatedObject(self, &AddressKey);
    if (addressLabel && districtKey && streetKey) {
        
        NSString *districtString = [QSCoreDataManager getDistrictValWithDistrictKey:districtKey];
        NSString *streetString = [QSCoreDataManager getStreetValWithStreetKey:streetKey];
        addressLabel.text = [NSString stringWithFormat:@"%@ | %@",districtString,streetString];
        
    }
    
}

///更新用户名
- (void)updateUserName:(NSString *)name
{

    UILabel *userName = objc_getAssociatedObject(self, &UserNameKey);
    if (userName && [name length] > 0) {
        
        userName.text = name;
        
    }

}

@end
