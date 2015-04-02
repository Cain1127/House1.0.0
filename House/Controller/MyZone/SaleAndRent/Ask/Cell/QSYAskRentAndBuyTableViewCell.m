//
//  QSYAskRentAndBuyTableViewCell.m
//  House
//
//  Created by ysmeng on 15/3/31.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskRentAndBuyTableViewCell.h"

#import "UIImageView+CacheImage.h"
#import "NSString+Calculation.h"

#import "QSYAskRentAndBuyDataModel.h"

#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+House.h"

#import <objc/runtime.h>

///关联
static char HouseTagKey;    //!<房子左上角标识图片key
static char AddressKey;     //!<地址key
static char TargetKey;      //!<购房目的或者租金支付方式
static char HouseNumberKey; //!<房子的数量信息关闻
static char PriceKey;       //!<金钱关联
static char PriceUnitKey;   //!<金钱单位
static char AreaKey;        //!<面积关联
static char TradeTypeKey;   //!<物业类型
static char DecorationKey;  //!<装修类型
static char FaceKey;        //!<朝向类型
static char FloorKey;       //!<楼层
static char UserYearKey;    //!<房龄
static char FeaturesKey;    //!<标签底view
static char CommentKey;     //!<备注信息
static char RecommendHouse; //!<推荐房源数量
static char SettingButton;  //!<设置按钮

@interface QSYAskRentAndBuyTableViewCell ()

///求租求购信息页上的回调
@property (nonatomic,copy) void(^askRentAndBuyCellCallBack)(ASK_RENTANDBUY_CELL_ACTION_TYPE actionType);

@end

@implementation QSYAskRentAndBuyTableViewCell

#pragma mark - 始化时
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///白色背景
        self.backgroundColor = [UIColor whiteColor];
        
        ///搭建UI
        [self createAskRendAndBuyCellUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createAskRendAndBuyCellUI
{
    
    ///所有信息的底view
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, SIZE_DEFAULT_MAX_WIDTH, 332.0f + 44.0f)];
    [self.contentView addSubview:rootView];

    ///标识
    QSImageView *houseTagImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 18.0f)];
    houseTagImageView.hidden = YES;
    [rootView addSubview:houseTagImageView];
    objc_setAssociatedObject(self, &HouseTagKey, houseTagImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///地址信息
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, houseTagImageView.frame.origin.y + houseTagImageView.frame.size.height + 10.0f, 180.0f, 20.0f)];
    addressLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    addressLabel.textColor = COLOR_CHARACTERS_BLACK;
    [rootView addSubview:addressLabel];
    objc_setAssociatedObject(self, &AddressKey, addressLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///购买目的或者租金支付方式
    UILabel *targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, addressLabel.frame.origin.y + addressLabel.frame.size.height + 5.0f, 120.0f, 15.0f)];
    targetLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    targetLabel.textColor = COLOR_CHARACTERS_BLACK;
    [rootView addSubview:targetLabel];
    objc_setAssociatedObject(self, &TargetKey, targetLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///几室几厅
    UILabel *houseNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(rootView.frame.size.width - 160.0f, targetLabel.frame.origin.y - 5.0f, 120.0f, 20.0f)];
    houseNumLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    houseNumLabel.textColor = COLOR_CHARACTERS_BLACK;
    houseNumLabel.textAlignment = NSTextAlignmentRight;
    [rootView addSubview:houseNumLabel];
    objc_setAssociatedObject(self, &HouseNumberKey, houseNumLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///总价-租金
    UIView *priceRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, targetLabel.frame.origin.y - 5.0f, (rootView.frame.size.width - 8.0f) / 2.0f, 44.0f)];
    priceRootView.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    priceRootView.layer.cornerRadius = 6.0f;
    [rootView addSubview:priceRootView];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, priceRootView.frame.size.width - 60.0f, 44.0f)];
    priceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_25];
    priceLabel.textColor = COLOR_CHARACTERS_BLACK;
    priceLabel.textAlignment = NSTextAlignmentRight;
    [priceRootView addSubview:priceLabel];
    objc_setAssociatedObject(self, &PriceKey, priceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///单位
    UILabel *priceUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width, priceLabel.frame.origin.y + 25.0f, 60.0f, 15.0f)];
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
    [rootView addSubview:areaRootView];
    
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, priceRootView.frame.size.width - 60.0f, 44.0f)];
    areaLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_25];
    areaLabel.textColor = COLOR_CHARACTERS_BLACK;
    areaLabel.textAlignment = NSTextAlignmentRight;
    [areaRootView addSubview:areaLabel];
    objc_setAssociatedObject(self, &AreaKey, areaLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *areaUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(areaLabel.frame.origin.x + areaLabel.frame.size.width, areaLabel.frame.origin.y + 25.0f, 60.0f, 15.0f)];
    areaUnitLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    areaUnitLabel.textColor = COLOR_CHARACTERS_BLACK;
    areaUnitLabel.textAlignment = NSTextAlignmentLeft;
    areaUnitLabel.text = @"万";
    [areaRootView addSubview:areaUnitLabel];
    
    ///附加信息的标题宽度
    CGFloat widthTitle = 45.0f;
    CGFloat widthValue = (rootView.frame.size.width - 2.0f * widthTitle - 8.0f - 10.0f) / 2.0f;
    
    ///物业类型
    UILabel *tradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, areaRootView.frame.origin.y + areaRootView.frame.size.height + 20.0f, widthTitle, 15.0f)];
    tradeLabel.text  =@"类    型";
    tradeLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    tradeLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [rootView addSubview:tradeLabel];
    
    ///内容项
    UILabel *tradeInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(tradeLabel.frame.origin.x + tradeLabel.frame.size.width + 5.0f, tradeLabel.frame.origin.y, widthValue, 15.0f)];
    tradeInfoLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    tradeInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    tradeInfoLabel.textAlignment = NSTextAlignmentLeft;
    tradeInfoLabel.adjustsFontSizeToFitWidth = YES;
    [rootView addSubview:tradeInfoLabel];
    objc_setAssociatedObject(self, &TradeTypeKey, tradeInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///装修
    UILabel *decorationLabel = [[UILabel alloc] initWithFrame:CGRectMake(tradeInfoLabel.frame.origin.x + tradeInfoLabel.frame.size.width + 8.0f, tradeInfoLabel.frame.origin.y, widthTitle, 15.0f)];
    decorationLabel.text  =@"装    修";
    decorationLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    decorationLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [rootView addSubview:decorationLabel];
    
    ///内容项
    UILabel *decorationInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(decorationLabel.frame.origin.x + decorationLabel.frame.size.width + 5.0f, decorationLabel.frame.origin.y, widthValue, 15.0f)];
    decorationInfoLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    decorationInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    decorationInfoLabel.textAlignment = NSTextAlignmentLeft;
    decorationInfoLabel.adjustsFontSizeToFitWidth = YES;
    [rootView addSubview:decorationInfoLabel];
    objc_setAssociatedObject(self, &DecorationKey, decorationInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///朝向
    UILabel *faceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, tradeLabel.frame.origin.y + tradeLabel.frame.size.height + 5.0f, widthTitle, 15.0f)];
    faceLabel.text  =@"朝    向";
    faceLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    faceLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [rootView addSubview:faceLabel];
    
    ///内容项
    UILabel *faceInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(faceLabel.frame.origin.x + faceLabel.frame.size.width + 5.0f, faceLabel.frame.origin.y, widthValue, 15.0f)];
    faceInfoLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    faceInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    faceInfoLabel.textAlignment = NSTextAlignmentLeft;
    faceInfoLabel.adjustsFontSizeToFitWidth = YES;
    [rootView addSubview:faceInfoLabel];
    objc_setAssociatedObject(self, &FaceKey, faceInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///楼层
    UILabel *floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(faceInfoLabel.frame.origin.x + faceInfoLabel.frame.size.width + 8.0f, faceLabel.frame.origin.y, widthTitle, 15.0f)];
    floorLabel.text  =@"楼    层";
    floorLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    floorLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [rootView addSubview:floorLabel];
    
    ///内容项
    UILabel *floorInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(floorLabel.frame.origin.x + floorLabel.frame.size.width + 5.0f, floorLabel.frame.origin.y, widthValue, 15.0f)];
    floorInfoLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    floorInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    floorInfoLabel.textAlignment = NSTextAlignmentLeft;
    floorInfoLabel.adjustsFontSizeToFitWidth = YES;
    [rootView addSubview:floorInfoLabel];
    objc_setAssociatedObject(self, &FloorKey, floorInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///房龄
    UILabel *usedYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, floorLabel.frame.origin.y + floorLabel.frame.size.height + 5.0f, widthTitle, 15.0f)];
    usedYearLabel.text  =@"房    龄";
    usedYearLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    usedYearLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [rootView addSubview:usedYearLabel];
    
    ///内容项
    UILabel *usedYearInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(usedYearLabel.frame.origin.x + usedYearLabel.frame.size.width + 5.0f, usedYearLabel.frame.origin.y, widthValue, 15.0f)];
    usedYearInfoLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    usedYearInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    usedYearInfoLabel.textAlignment = NSTextAlignmentLeft;
    usedYearInfoLabel.adjustsFontSizeToFitWidth = YES;
    [rootView addSubview:usedYearInfoLabel];
    objc_setAssociatedObject(self, &UserYearKey, usedYearInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///标签
    UIView *featuresRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, usedYearLabel.frame.origin.y + usedYearLabel.frame.size.height + 10.0f, rootView.frame.size.width, 20.0f)];
    [rootView addSubview:featuresRootView];
    objc_setAssociatedObject(self, &FeaturesKey, featuresRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///备注
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, featuresRootView.frame.origin.y + featuresRootView.frame.size.height + 10.0f, rootView.frame.size.width, 45.0f)];
    commentLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    commentLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    commentLabel.numberOfLines = 2;
    [rootView addSubview:commentLabel];
    objc_setAssociatedObject(self, &CommentKey, commentLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///推荐房源
    UIButton *recommendHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, commentLabel.frame.origin.y + commentLabel.frame.size.height + 10.0f, rootView.frame.size.width, 20.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.askRentAndBuyCellCallBack) {
            
            self.askRentAndBuyCellCallBack(aAskRentAndBuyCellActionTypeRecommend);
            
        }
        
    }];
    [recommendHouseButton setTitle:@"推荐房源(        条)" forState:UIControlStateNormal];
    recommendHouseButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [recommendHouseButton setTitleColor:COLOR_CHARACTERS_LIGHTGRAY forState:UIControlStateNormal];
    [rootView addSubview:recommendHouseButton];
    
    ///推荐房源数量
    UILabel *recommendHouseNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(85.0f, 0.0f, 30.0f, 20.0f)];
    recommendHouseNumLabel.textColor = COLOR_CHARACTERS_YELLOW;
    recommendHouseNumLabel.font = [UIFont systemFontOfSize:15.0f];
    [recommendHouseButton addSubview:recommendHouseNumLabel];
    objc_setAssociatedObject(self, &RecommendHouse, recommendHouseNumLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///展开按钮
    UIButton *settinButton = [UIButton createBlockButtonWithFrame:CGRectMake(rootView.frame.size.width - 44.0f, recommendHouseButton.frame.origin.y - 24.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///回调展开
        if (button.selected) {
            
            if (self.askRentAndBuyCellCallBack) {
                
                self.askRentAndBuyCellCallBack(aAskRentAndBuyCellActionTypeSetting);
                
            }
            
        } else {
        
            if (self.askRentAndBuyCellCallBack) {
                
                self.askRentAndBuyCellCallBack(aAskRentAndBuyCellActionTypeSettingClose);
                
            }
        
        }
        
    }];
    [settinButton setImage:[UIImage imageNamed:IMAGE_ZONE_ASK_SETTING_NORMAL] forState:UIControlStateNormal];
    [settinButton setImage:[UIImage imageNamed:IMAGE_ZONE_ASK_SETTING_HIGHLIGHTED] forState:UIControlStateHighlighted];
    settinButton.selected = NO;
    [rootView addSubview:settinButton];
    objc_setAssociatedObject(self, &SettingButton, settinButton, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *topLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, recommendHouseButton.frame.origin.y + recommendHouseButton.frame.size.height + 20.0f - 0.25f, rootView.frame.size.width, 0.25f)];
    topLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [rootView addSubview:topLineLabel];
    
    ///编辑按钮
    CGFloat ypointEditButton = recommendHouseButton.frame.origin.y + recommendHouseButton.frame.size.height + 21.0f;
    UIButton *editButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, ypointEditButton, (rootView.frame.size.width - 8.0f) / 2.0f, (rootView.frame.size.height - ypointEditButton - 1.0f)) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        if (self.askRentAndBuyCellCallBack) {
            
            self.askRentAndBuyCellCallBack(aAskRentAndBuyCellActionTypeEdit);
            
        }
        
    }];
    [rootView addSubview:editButton];
    
    ///删除按钮
    UIButton *deleteButton = [UIButton createBlockButtonWithFrame:CGRectMake(editButton.frame.origin.x + editButton.frame.size.width + 8.0f, editButton.frame.origin.y, editButton.frame.size.width, editButton.frame.size.height) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        if (self.askRentAndBuyCellCallBack) {
            
            self.askRentAndBuyCellCallBack(aAskRentAndBuyCellActionTypeDelete);
            
        }
        
    }];
    [rootView addSubview:deleteButton];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, rootView.frame.size.height - 0.25f, rootView.frame.size.width, 0.25f)];
    bottomLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [rootView addSubview:bottomLineLabel];

}

#pragma mark - 刷新UI
/**
 *  @author         yangshengmeng, 15-03-31 18:03:40
 *
 *  @brief          根据数据模型刷新UI
 *
 *  @param model    求租求购的数据模型
 *  @param callBack cell上的事件回调
 *
 *  @since          1.0.0
 */
- (void)updateAskRentAndBuyInfoCellUI:(QSYAskRentAndBuyDataModel *)model andSettingButtonStatus:(BOOL)isHidenSettingButton andCallBack:(void(^)(ASK_RENTANDBUY_CELL_ACTION_TYPE actionType))callBack
{

    ///保存回调
    if (callBack) {
        
        self.askRentAndBuyCellCallBack = callBack;
        
    }
    
    ///地址信息
    [self updateHouseAddress:model.areaid andStreetKey:model.street];
    
    ///室厅信息更新
    [self updateHouseNumberInfo:model.house_shi andTingNum:model.house_ting];
    
    ///更新面积:model.areaid
    [self updateHouseArea:[QSCoreDataManager getHouseAreaTypeWithKey:model.areaid]];
    
    ///物业类型
    [self updateTradeType:[QSCoreDataManager getHouseTradeTypeWithKey:model.property_type]];
    
    ///装修
    [self updateDecoration:[QSCoreDataManager getHouseDecorationTypeWithKey:model.decoration_type]];
    
    ///朝向
    [self updateHouseFace:[QSCoreDataManager getHouseFaceTypeWithKey:model.house_face]];
    
    ///楼层
    [self updateHouseFloor:[QSCoreDataManager getHouseFloorTypeWithKey:model.floor_which]];
    
    ///房龄
    [self updateHouseUseYear:@"10-15年"];
    
    ///备注信息
    [self updateCommentInfo:model.content];
    
    ///推荐房源数量
    [self updateRecommendNumber:model.commend_num];
    
    ///更新求租UI信息
    if (1 == [model.type intValue]) {
        
        ///求租求购标识图片
        if (hHouseRenantPropertyTypeEntire == [model.rent_property intValue]) {
            
            [self updateHouseTagImage:IMAGE_ZONE_ASK_TAG_RENT_ENTIRE];
            
        }
        
        if (hHouseRenantPropertyTypeJoint == [model.rent_property intValue]) {
            
            [self updateHouseTagImage:IMAGE_ZONE_ASK_TAG_RENT_PARTNER];
            
        }
        
        ///更新租金支付方式
        [self updateRentPayType:[QSCoreDataManager getHouseRentTypeWithKey:model.payment]];
        
        ///更新价钱信息
        [self updatePriceInfo:model.price AndUnit:@"元以下"];
        
        ///更新标签
        [self updateFeatures:model.features andHouseType:fFilterMainTypeRentalHouse];
        
    }
    
    ///更新求购信息
    if (2 == [model.type intValue]) {
        
        ///求租求购标识
        [self updateHouseTagImage:IMAGE_ZONE_ASK_TAG_BUY];
        
        ///更新物业类型
        [self updateRentPayType:[QSCoreDataManager getPerpostPerchaseTypeWithKey:model.intent]];
        
        ///更新价钱信息
        [self updatePriceInfo:model.price AndUnit:@"万"];
        
        ///更新标签
        [self updateFeatures:model.features andHouseType:fFilterMainTypeSecondHouse];
    
    }
    
}

///更新设置按钮的隐藏状态
- (void)updateSettingButton:(BOOL)flag
{

    UIButton *settingButton = objc_getAssociatedObject(self, &SettingButton);
    if (settingButton) {
        
        if (flag) {
            
            [settingButton setImage:[UIImage imageNamed:IMAGE_ZONE_ASK_SETTING_CLOSE_NORMAL] forState:UIControlStateNormal];
            [settingButton setImage:[UIImage imageNamed:IMAGE_ZONE_ASK_SETTING_CLOSE_HIGHLIGHTED] forState:UIControlStateHighlighted];
            settingButton.selected = YES;
            
        } else {
            
            [settingButton setImage:[UIImage imageNamed:IMAGE_ZONE_ASK_SETTING_NORMAL] forState:UIControlStateNormal];
            [settingButton setImage:[UIImage imageNamed:IMAGE_ZONE_ASK_SETTING_HIGHLIGHTED] forState:UIControlStateHighlighted];
            settingButton.selected = NO;
            
        }
        
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

///更新推荐房源数量
- (void)updateRecommendNumber:(NSString *)num
{

    UILabel *recommendLabel = objc_getAssociatedObject(self, &RecommendHouse);
    if (recommendLabel && num) {
        
        recommendLabel.text = num;
        
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

///更新房龄
- (void)updateHouseUseYear:(NSString *)useYear
{

    UILabel *useYearLabel = objc_getAssociatedObject(self, &UserYearKey);
    if (useYearLabel && useYear) {
        
        useYearLabel.text = useYear;
        
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

///更新地址信息
- (void)updateHouseAddress:(NSString *)districtKey andStreetKey:(NSString *)streetKey
{

    UILabel *addressLabel = objc_getAssociatedObject(self, &AddressKey);
    if (addressLabel && districtKey && streetKey) {
        
        NSString *districtString = [QSCoreDataManager getDistrictValWithDistrictKey:districtKey];
        NSString *streetString = [QSCoreDataManager getStreetValWithStreetKey:streetKey];
        addressLabel.text = [NSString stringWithFormat:@"%@|%@",districtString,streetString];
        
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
    if (rootView && featureString) {
        
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

///更新面积
- (void)updateHouseArea:(NSString *)area
{

    UILabel *labelArea = objc_getAssociatedObject(self, &AreaKey);
    if (labelArea && area) {
        
        labelArea.text = [NSString stringWithFormat:@"%.0f",[area floatValue]];
        
    }

}

@end
