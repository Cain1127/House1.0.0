//
//  QSYAskSecondHandHouseViewController.m
//  House
//
//  Created by ysmeng on 15/4/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskSecondHandHouseViewController.h"

#import "QSCustomDistrictSelectedPopView.h"
#import "QSCustomSingleSelectedPopView.h"
#import "QSCustomHUDView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"

#import "QSFilterDataModel.h"
#import "QSBaseConfigurationDataModel.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+App.h"

///备注信息的宏
#define RELEASE_ASK_COMMENT_PLACEHOLD @"备注信息，输入文字备注信息，60个汉字字符以内"

///求购信息事件
typedef enum
{

    rReleaseAskBuyPickedActionTypeDistrict = 10,//!<区域
    rReleaseAskBuyPickedActionTypeHouseType,    //!<户型
    rReleaseAskBuyPickedActionTypeBuyTarget,    //!<购房目的
    rReleaseAskBuyPickedActionTypeSalePrice,    //!<售价
    rReleaseAskBuyPickedActionTypeArea,         //!<面积
    rReleaseAskBuyPickedActionTypeTradeType,    //!<物业类型
    rReleaseAskBuyPickedActionTypeFloor,        //!<楼层
    rReleaseAskBuyPickedActionTypeFace,         //!<朝向
    rReleaseAskBuyPickedActionTypeDecoration,   //!<装修
    rReleaseAskBuyPickedActionTypeUsedYear,     //!<房龄

}RELEASE_ASK_BUY_PICKED_ACTION_TYPE;

@interface QSYAskSecondHandHouseViewController () <UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,retain) QSFilterDataModel *releaseModel;               //!<发布时使用的数据模型
@property (nonatomic,assign) BUYHOUSE_RELEASE_STATUS_TYPE releaseStatus;    //!<当前求租信息的发布状态
@property (nonatomic,copy) void(^releasedCallBack)(BOOL isRelease);         //!<发布后的回调
@property (nonatomic,strong) UITextView *commentField;                      //!<备注信息框

@end

@implementation QSYAskSecondHandHouseViewController

/**
 *  @author             yangshengmeng, 15-04-01 14:04:42
 *
 *  @brief              创建一个发布求购的信息填写页面
 *
 *  @param filterModel  当前的求购信息数据模型
 *  @param isNewRelease 是否是新发布
 *  @param callBack     发布后的回调
 *
 *  @return             返回当前创建的求购发布页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithModel:(QSFilterDataModel *)filterModel andReleaseStatus:(BUYHOUSE_RELEASE_STATUS_TYPE)isNewRelease andCallBack:(void(^)(BOOL isRelease))callBack
{
    
    if (self = [super init]) {
        
        ///保存参数
        if (callBack) {
            
            self.releasedCallBack = callBack;
            
        }
        
        ///判断是否是新发布，或者重新发布
        if (bBuyhouseReleaseStatusTypeRerelease == isNewRelease) {
            
            self.releaseModel = filterModel;
            
        } else {
            
            self.releaseModel = [[QSFilterDataModel alloc] init];
            
        }
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"求购"];
    
}

- (void)createMainShowUI
{

    ///过滤条件的底view
    QSScrollView *pickedRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f - 25.0f)];
    [self createSettingInputUI:pickedRootView];
    [self.view addSubview:pickedRootView];
    
    ///底部确定按钮
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///校验数据
        if ([self checkAskSecondHandHouseInfo]) {
            
            [self releaseAskBuyHouse];
            
        }
        
    }];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commitButton setTitleColor:COLOR_CHARACTERS_YELLOW forState:UIControlStateHighlighted];
    commitButton.layer.cornerRadius = 6.0f;
    commitButton.backgroundColor = COLOR_CHARACTERS_YELLOW;
    [self.view addSubview:commitButton];

}

///搭建过滤器设置信息输入栏
- (void)createSettingInputUI:(QSScrollView *)view
{
    
    ///根据类型获取不同的加载plist配置文件信息
    NSDictionary *infoDict = [self getFilterSettingInfoWithType];
    
    ///数据无效，则不创建
    if (nil == infoDict || (0 >= [infoDict count])) {
        
        return;
        
    }
    
    ///遍历创建UI
    NSArray *tempInfoArray = [infoDict allValues];
    for (int i = 0; i < [tempInfoArray count]; i++) {
        
        NSDictionary *tempDict = tempInfoArray[i];
        UIView *tempTextField = [self createRightArrowSubviewWithViewInfo:tempDict];
        [view addSubview:tempTextField];
        
        ///分隔线
        UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempTextField.frame.origin.x + 5.0f, tempTextField.frame.origin.y + tempTextField.frame.size.height + 3.5f, tempTextField.frame.size.width, 0.5f)];
        sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [view addSubview:sepLineLabel];
        
    }
    
    ///UI的最大高度记录
    CGFloat currentHeight = (44.0f + 8.0f) * [tempInfoArray count] + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
    
    ///说明信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 5.0f, currentHeight, SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 5.0f, 30.0f)];
    tipsLabel.text = @"补充信息：(多选项)";
    tipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [view addSubview:tipsLabel];
    currentHeight = currentHeight + tipsLabel.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
    
    ///选择标签
    NSArray *featuresList = [QSCoreDataManager getHouseFeatureListWithType:fFilterMainTypeSecondHouse];
    
    ///每个标签的宽度
    CGFloat widthOfFeatures = 80.0f;
    CGFloat heightOfFeatures = 30.0f;
    CGFloat cornerOfFeatures = 3.0f;
    
    ///每行放置的个数
    int numOfFeaturesRow = SIZE_DEVICE_WIDTH > 320.0f ? 4 : 3;
    CGFloat gapOfFeatures = (SIZE_DEVICE_WIDTH - numOfFeaturesRow * widthOfFeatures) / (numOfFeaturesRow + 1);
    
    ///重置滚动页高度
    int sumRow = (int)([featuresList count] / numOfFeaturesRow + (([featuresList count] % numOfFeaturesRow) > 0 ? 1 : 0));
    
    ///创建每一个标签按钮
    int k = 0;
    for (int i = 0; i < sumRow; i++) {
        
        for (int j = 0; j < numOfFeaturesRow && k < [featuresList count]; j++) {
            
            ///标签模型
            QSBaseConfigurationDataModel *featuresModel = featuresList[k];
            
            UIButton *featuresButton = [UIButton createBlockButtonWithFrame:CGRectMake(gapOfFeatures + j * (widthOfFeatures + gapOfFeatures), currentHeight + i * (heightOfFeatures + 5.0f), widthOfFeatures, heightOfFeatures) andButtonStyle:nil andCallBack:^(UIButton *button) {
                
                ///回收备注信息的键盘
                [self.commentField resignFirstResponder];
                
                if (button.selected) {
                    
                    button.selected = NO;
                    button.layer.borderColor = [COLOR_CHARACTERS_LIGHTGRAY CGColor];
                    
                    ///删除选择的标签
                    [self deleteFeatureWithModel:featuresModel];
                    
                } else {
                    
                    button.selected = YES;
                    button.layer.borderColor = [COLOR_CHARACTERS_BLACK CGColor];
                    
                    ///保存选择的标签
                    [self addFeatureWithModel:featuresModel];
                    
                }
                
            }];
            featuresButton.layer.borderColor = [COLOR_CHARACTERS_LIGHTGRAY CGColor];
            featuresButton.layer.borderWidth = 0.5f;
            [featuresButton setTitle:featuresModel.val forState:UIControlStateNormal];
            [featuresButton setTitleColor:COLOR_CHARACTERS_LIGHTGRAY forState:UIControlStateNormal];
            [featuresButton setTitleColor:COLOR_CHARACTERS_BLACK forState:UIControlStateSelected];
            featuresButton.layer.cornerRadius = cornerOfFeatures;
            featuresButton.titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
            featuresButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            
            ///检测是否已存在标签信息
            featuresButton.selected = [self checkFeaturesIsPicked:featuresModel];
            
            [view addSubview:featuresButton];
            k++;
            
        }
        
    }
    
    ///重置高度
    currentHeight = currentHeight + heightOfFeatures * sumRow + 5.0f * (sumRow - 1) + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
    
    ///备注信息
    self.commentField = [[UITextView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 5.0f, currentHeight, SIZE_DEFAULT_MAX_WIDTH - 10.0f, 160.0f)];
    self.commentField.backgroundColor = [UIColor whiteColor];
    self.commentField.showsHorizontalScrollIndicator = NO;
    self.commentField.showsVerticalScrollIndicator = NO;
    self.commentField.delegate = self;
    self.commentField.layer.borderColor = [COLOR_CHARACTERS_LIGHTGRAY CGColor];
    self.commentField.layer.borderWidth = 0.5f;
    self.commentField.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    self.commentField.text = RELEASE_ASK_COMMENT_PLACEHOLD;
    self.commentField.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    self.commentField.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [view addSubview:self.commentField];
    
    ///判断原来是否有对应信息
    if ([self.releaseModel.comment length] > 0) {
        
        self.commentField.text = self.releaseModel.comment;
        self.commentField.textColor = COLOR_CHARACTERS_BLACK;
        
    }
    
    currentHeight = currentHeight + self.commentField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
    
    ///判断是否可滚动
    if (currentHeight > view.frame.size.height) {
        
        view.contentSize = CGSizeMake(view.frame.size.width, currentHeight + 10.0f);
        
    }
    
}

#pragma mark - 创建右剪头控制
- (UIView *)createRightArrowSubviewWithViewInfo:(NSDictionary *)tempDict
{
    
    NSString *orderString = [tempDict valueForKey:@"order"];
    int index = [orderString intValue];
    
    ///显示信息栏
    UITextField *tempTextField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 8.0f + index * (8.0f + 44.0f), SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f) andPlaceHolder:nil andLeftTipsInfo:[tempDict valueForKey:@"left_title"] andLeftTipsTextAlignment:NSTextAlignmentCenter andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsLightGray];
    tempTextField.font = [UIFont systemFontOfSize:FONT_BODY_16];
    tempTextField.delegate = self;
    [tempTextField setValue:[tempDict valueForKey:@"action_type"] forKey:@"customFlag"];
    tempTextField.placeholder = [tempDict valueForKey:@"placehold"];
    NSString *filterInfo = [self.releaseModel valueForKey:[tempDict valueForKey:@"filter_key"]];
    if ([filterInfo length] > 0) {
        
        tempTextField.text = filterInfo;
        
    }
    
    return tempTextField;
    
}

#pragma mark - 弹出选择框
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    ///分发事件
    int actionType = [[textField valueForKey:@"customFlag"] intValue];
    switch (actionType) {
            ///选择区域
        case rReleaseAskBuyPickedActionTypeDistrict:
        {
            
            [QSCustomDistrictSelectedPopView showCustomDistrictSelectedPopviewWithSteetSelectedKey:([self.releaseModel.street_key length] > 0 ? self.releaseModel.street_key : nil) andDistrictPickeredCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                ///判断选择
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    ///显示当前位置信息
                    textField.text = tempModel.val;
                    
                    ///保存位置信息
                    QSBaseConfigurationDataModel *districtModel = [QSCoreDataManager getDistrictModelWithStreetKey:tempModel.key];
                    self.releaseModel.district_key = districtModel.key;
                    self.releaseModel.district_val = districtModel.val;
                    self.releaseModel.street_key = tempModel.key;
                    self.releaseModel.street_val = [QSCoreDataManager getStreetValWithStreetKey:tempModel.key];
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    ///显示当前位置信息
                    textField.text = nil;
                    
                    ///将过滤器中的位置信息清空
                    self.releaseModel.district_key = nil;
                    self.releaseModel.district_val = nil;
                    self.releaseModel.street_key = nil;
                    self.releaseModel.street_val = nil;
                    
                }
                
            }];
            
        }
            break;
            
            ///选择户型
        case rReleaseAskBuyPickedActionTypeHouseType:
        {
            
            ///获取户型的数据
            NSArray *intentArray = [QSCoreDataManager getHouseType];
            
            ///显示户型的选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.releaseModel.house_type_key length] > 0 ? self.releaseModel.house_type_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.releaseModel.house_type_key = tempModel.key;
                    self.releaseModel.house_type_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    ///显示当前位置信息
                    textField.text = nil;
                    
                    ///清空原数据
                    self.releaseModel.house_type_key = nil;
                    self.releaseModel.house_type_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///购房目的
        case rReleaseAskBuyPickedActionTypeBuyTarget:
        {
            
            ///获取购房目的数据
            NSArray *intentArray = [QSCoreDataManager getPurpostPerchaseType];
            
            ///显示购房目的选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.releaseModel.buy_purpose_key length] > 0 ? self.releaseModel.buy_purpose_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.releaseModel.buy_purpose_key = tempModel.key;
                    self.releaseModel.buy_purpose_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.releaseModel.buy_purpose_key = nil;
                    self.releaseModel.buy_purpose_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///出售价格
        case rReleaseAskBuyPickedActionTypeSalePrice:
        {
            
            ///获取出售价格的数据
            NSArray *intentArray = [QSCoreDataManager getHouseSalePriceType];
            
            ///显示房子售价选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.releaseModel.sale_price_key length] > 0 ? self.releaseModel.sale_price_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.releaseModel.sale_price_key = tempModel.key;
                    self.releaseModel.sale_price_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.releaseModel.sale_price_key = nil;
                    self.releaseModel.sale_price_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///房子面积
        case rReleaseAskBuyPickedActionTypeArea:
        {
            
            ///获取房子面积的数据
            NSArray *intentArray = [QSCoreDataManager getHouseAreaType];
            
            ///显示房子面积选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.releaseModel.house_area_key length] > 0 ? self.releaseModel.house_area_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.releaseModel.house_area_key = tempModel.key;
                    self.releaseModel.house_area_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.releaseModel.house_area_key = nil;
                    self.releaseModel.house_area_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///房子的物业类型：普通住宅...
        case rReleaseAskBuyPickedActionTypeTradeType:
        {
            
            ///获取房子的物业类型选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseTradeType];
            
            ///显示房子的物业类型选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.releaseModel.trade_type_key length] > 0 ? self.releaseModel.trade_type_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.releaseModel.trade_type_key = tempModel.key;
                    self.releaseModel.trade_type_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.releaseModel.trade_type_key = nil;
                    self.releaseModel.trade_type_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///楼层
        case rReleaseAskBuyPickedActionTypeFloor:
        {
            
            ///获取房子楼层选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseFloorType];
            
            ///显示房子楼层选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.releaseModel.floor_key length] > 0 ? self.releaseModel.floor_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.releaseModel.floor_key = tempModel.key;
                    self.releaseModel.floor_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.releaseModel.floor_key = nil;
                    self.releaseModel.floor_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///朝向：朝南...
        case rReleaseAskBuyPickedActionTypeFace:
        {
            
            ///获取房子朝向选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseFaceType];
            
            ///显示房子朝向选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.releaseModel.house_face_key length] > 0 ? self.releaseModel.house_face_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.releaseModel.house_face_key = tempModel.key;
                    self.releaseModel.house_face_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.releaseModel.house_face_key = nil;
                    self.releaseModel.house_face_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///装修：精装修...
        case rReleaseAskBuyPickedActionTypeDecoration:
        {
            
            ///获取房子装修类型选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseDecorationType];
            
            ///显示房子装修类型选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.releaseModel.decoration_key length] > 0 ? self.releaseModel.decoration_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.releaseModel.decoration_key = tempModel.key;
                    self.releaseModel.decoration_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.releaseModel.decoration_key = nil;
                    self.releaseModel.decoration_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///房龄
        case rReleaseAskBuyPickedActionTypeUsedYear:
        {
            
            ///获取房子房龄选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseUsedYearType];
            
            ///显示房龄选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.releaseModel.used_year_key length] > 0 ? self.releaseModel.used_year_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.releaseModel.used_year_key = tempModel.key;
                    self.releaseModel.used_year_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.releaseModel.used_year_key = nil;
                    self.releaseModel.used_year_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
        default:
            break;
    }
    return NO;

}

#pragma mark - 根据不同的类型返回对应的配置文件
- (NSDictionary *)getFilterSettingInfoWithType
{
    
    ///配置信息文件路径
    NSString *infoPath = [[NSBundle mainBundle] pathForResource:PLIST_FILE_NAME_FILTER_ASK_SECONDHOUSE ofType:PLIST_FILE_TYPE];
    return [NSDictionary dictionaryWithContentsOfFile:infoPath];
    
}

#pragma mark - 数据校验
- (BOOL)checkAskSecondHandHouseInfo
{
    
    ///地区
    if ([self.releaseModel.district_key length] <= 0 ||
        [self.releaseModel.street_key length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择目标区域", 1.0f, ^(){})
        return NO;
        
    } else {
    
        QSBaseConfigurationDataModel *cityModel = [QSCoreDataManager getCityModelWithDitrictKey:self.releaseModel.district_key];
        self.releaseModel.city_key = cityModel.key;
        self.releaseModel.city_val = cityModel.val;
    
    }
    
    ///户型
    if ([self.releaseModel.house_type_key length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择户型", 1.0f, ^(){})
        return NO;
        
    }
    
    ///购房目的
    if ([self.releaseModel.buy_purpose_key length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择购房目的", 1.0f, ^(){})
        return NO;
        
    }
    
    ///售价
    if ([self.releaseModel.sale_price_key length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择售价信息", 1.0f, ^(){})
        return NO;
        
    }

    return YES;

}

#pragma mark - 保存/删除标签
- (void)addFeatureWithModel:(QSBaseConfigurationDataModel *)model
{
    
    for (QSBaseConfigurationDataModel *obj in self.releaseModel.features_list) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            return;
            
        }
        
    }
    
    ///添加
    [self.releaseModel.features_list addObject:model];
    
}

- (void)deleteFeatureWithModel:(QSBaseConfigurationDataModel *)model
{
    
    ///临时数组
    NSArray *tempArray = [[NSArray alloc] initWithArray:self.releaseModel.features_list];
    [self.releaseModel.features_list removeAllObjects];
    for (QSBaseConfigurationDataModel *obj in tempArray) {
        
        if (![obj.key isEqualToString:model.key]) {
            
            [self.releaseModel.features_list addObject:obj];
            
        }
        
    }
    
}

#pragma mark - 备注信息开始输入及完成输入时修改文字
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:RELEASE_ASK_COMMENT_PLACEHOLD]) {
        
        textView.text = nil;
        textView.textColor = COLOR_CHARACTERS_BLACK;
        
    }
    return YES;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if ([textView.text length] <= 0) {
        
        textView.text = RELEASE_ASK_COMMENT_PLACEHOLD;
        textView.textColor = COLOR_CHARACTERS_LIGHTGRAY;
        
    } else {
        
        self.releaseModel.comment = textView.text;
        
    }
    
}

#pragma mark - 检测标签是否已选择
- (BOOL)checkFeaturesIsPicked:(QSBaseConfigurationDataModel *)model
{
    
    for (QSBaseConfigurationDataModel *obj in self.releaseModel.features_list) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            return YES;
            
        }
        
    }
    return NO;
    
}

- (void)releaseAskBuyHouse
{
    
    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在发布"];

    
    NSDictionary *params = @{@"type" : @"2",
                        @"cityid" : APPLICATION_NSSTRING_SETTING(self.releaseModel.city_key, @""),
                    @"areaid" : APPLICATION_NSSTRING_SETTING(self.releaseModel.district_key, @""),
                        @"street" : APPLICATION_NSSTRING_SETTING(self.releaseModel.street_key, @""),
                @"intent" : APPLICATION_NSSTRING_SETTING(self.releaseModel.buy_purpose_key, @""),
                    @"price" : APPLICATION_NSSTRING_SETTING(self.releaseModel.sale_price_key, @""),
                @"house_shi" : APPLICATION_NSSTRING_SETTING(self.releaseModel.house_type_key, @""),
                @"house_area" : APPLICATION_NSSTRING_SETTING(self.releaseModel.house_area_key, @""),
            @"property_type" : APPLICATION_NSSTRING_SETTING(self.releaseModel.trade_type_key, @""),
                    @"floor_which" : APPLICATION_NSSTRING_SETTING(self.releaseModel.floor_key, @""),
                @"house_face" : APPLICATION_NSSTRING_SETTING(self.releaseModel.house_face_key, @""),
        @"decoration_type" : APPLICATION_NSSTRING_SETTING(self.releaseModel.decoration_key, @""),
                @"features" : [self.releaseModel getFeaturesPostParams],
            @"used_year" : APPLICATION_NSSTRING_SETTING(self.releaseModel.used_year_key, @""),
                    @"content" : APPLICATION_NSSTRING_SETTING(self.releaseModel.comment, @"")};
    
    ///发布
    [QSRequestManager requestDataWithType:rRequestTypeMyZoneAddAskRentPurpase andParams:@{@"rentPurchaseInfo" : params} andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///发布成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [hud hiddenCustomHUDWithFooterTips:@"发布成功" andDelayTime:1.0f andCallBack:^(BOOL flag) {
                
                if (flag) {
                    
                    ///返回上一页
                    if (self.releasedCallBack) {
                        
                        self.releasedCallBack(YES);
                        
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
            }];
            
        } else {
            
            [hud hiddenCustomHUDWithFooterTips:@"发布失败" andDelayTime:1.0];
            
        }
        
    }];
    
}

@end
