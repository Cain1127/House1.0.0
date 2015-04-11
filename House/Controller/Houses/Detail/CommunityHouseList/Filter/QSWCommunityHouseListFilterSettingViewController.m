//
//  QSWCommunityHouseListFilterSettingViewController.m
//  House
//
//  Created by 王树朋 on 15/4/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWCommunityHouseListFilterSettingViewController.h"

#import "QSCustomDistrictSelectedPopView.h"
#import "QSCustomSingleSelectedPopView.h"
#import "QSCustomCitySelectedView.h"

#import "UITextField+CustomField.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+App.h"

#import "QSBaseConfigurationDataModel.h"

#import "QSFilterDataModel.h"

///过滤器每一项输入框的事件类型
typedef enum
{
    
    fFilterSettingFieldActionTypeDistrict = 0,              //!<区域选择：天河区...
    fFilterSettingFieldActionTypeHouseType = 1,             //!<户型选择：一房一厅...
    fFilterSettingFieldActionTypePurposePurchase = 2,       //!<购房目的：新婚购房...
    fFilterSettingFieldActionTypeSalePrice = 3,             //!<售价
    fFilterSettingFieldActionTypeArea = 4,                  //!<面积
    
    fFilterSettingFieldActionTypeRenantType = 5,            //!<出租方式：整租...
    fFilterSettingFieldActionTypeRenantPrice = 6,           //!<租金
    fFilterSettingFieldActionTypeRenantPayType = 7,         //!<租金支付方式：押二付一...
    
    fFilterSettingFieldActionTypeHouseTradeType = 8,        //!<交易类型：普通住宅...
    fFilterSettingFieldActionTypeHouseUsedYear = 9,         //!<房龄
    fFilterSettingFieldActionTypeHouseFloor = 10,           //!<楼层
    fFilterSettingFieldActionTypeHouseOrientations = 11,    //!<朝向：朝南...
    fFilterSettingFieldActionTypeHouseDecoration = 12,      //!<装修：精装修...
    fFilterSettingFieldActionTypeHouseInstallation = 13,    //!<配套：暖气...
    
    fFilterSettingFieldActionTypeCity = 14                  //!<城市选择
    
}FILTER_SETTINGFIELD_ACTION_TYPE;

@interface QSWCommunityHouseListFilterSettingViewController () <UITextViewDelegate,UITextFieldDelegate>

///当前列表过滤器
@property (nonatomic,unsafe_unretained) QSFilterDataModel *filterModel;

///设置过滤信息后回调
@property (nonatomic,copy) void (^settingFilterInfoCallBack)(QSFilterDataModel *);

@property (nonatomic,strong) UITextView *commendField;//!<备注信息

///房源类型
@property (atomic,assign) FILTER_MAIN_TYPE houseType;

@end

@implementation QSWCommunityHouseListFilterSettingViewController

#pragma mark - 初始化
- (instancetype)initWithCurrentFilter:(QSFilterDataModel *)filterModel andCallBack:(void (^)(QSFilterDataModel *))callBack
{
    
    if (self = [super init]) {
        
        ///过滤器
        self.filterModel = filterModel;
        
        ///保存回调
        if (callBack) {
            
            self.settingFilterInfoCallBack = callBack;
            
        }
        
        ///房源类型
        self.houseType = [self.filterModel.filter_id intValue];
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"高级筛选"];
    
}

- (void)createMainShowUI
{
    
    ///过滤条件的底view
    QSScrollView *pickedRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f - 25.0f)];
    [self createSettingInputUI:pickedRootView];
    [self.view addSubview:pickedRootView];
    
    ///底部确定按钮
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///保存备注信息
        if ([self.commendField.text length] > 0) {
            
            self.filterModel.comment = self.commendField.text;
            
        }
        
        ///回调过滤
        if (self.settingFilterInfoCallBack) {
            
            self.settingFilterInfoCallBack(self.filterModel);
            
        }
        
        ///返回上一页
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [commitButton setTitle:@"确定" forState:UIControlStateNormal];
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
    NSArray *featuresList = [QSCoreDataManager getHouseFeatureListWithType:self.houseType];
    
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
    
    ///重置当前高度
    currentHeight = currentHeight + heightOfFeatures * sumRow + 5.0f * (sumRow - 1) + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
    
    ///备注信息
    self.commendField = [[UITextView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, currentHeight, SIZE_DEFAULT_MAX_WIDTH, 160.0f)];
    self.commendField.backgroundColor = [UIColor whiteColor];
    self.commendField.showsHorizontalScrollIndicator = NO;
    self.commendField.showsVerticalScrollIndicator = NO;
    self.commendField.delegate = self;
    self.commendField.layer.borderColor = [COLOR_CHARACTERS_LIGHTGRAY CGColor];
    self.commendField.layer.borderWidth = 0.5f;
    self.commendField.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    self.commendField.text = APPLICATION_NSSTRING_SETTING(self.filterModel.comment, @"");
    [view addSubview:self.commendField];
    currentHeight = currentHeight + self.commendField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
    
    ///判断是否可滚动
    if (currentHeight > view.frame.size.height) {
        
        view.contentSize = CGSizeMake(view.frame.size.width, currentHeight + 10.0f);
        
    }
    
}

#pragma mark - 检测标签是否已选择
- (BOOL)checkFeaturesIsPicked:(QSBaseConfigurationDataModel *)model
{
    
    for (QSBaseConfigurationDataModel *obj in self.filterModel.features_list) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            return YES;
            
        }
        
    }
    return NO;
    
}

#pragma mark - 保存/删除标签
- (void)addFeatureWithModel:(QSBaseConfigurationDataModel *)model
{
    
    for (QSBaseConfigurationDataModel *obj in self.filterModel.features_list) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            return;
            
        }
        
    }
    
    ///添加
    [self.filterModel.features_list addObject:model];
    
}

- (void)deleteFeatureWithModel:(QSBaseConfigurationDataModel *)model
{
    
    ///临时数组
    NSArray *tempArray = [[NSArray alloc] initWithArray:self.filterModel.features_list];
    [self.filterModel.features_list removeAllObjects];
    for (QSBaseConfigurationDataModel *obj in tempArray) {
        
        if (![obj.key isEqualToString:model.key]) {
            
            [self.filterModel.features_list addObject:obj];
            
        }
        
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
    NSString *filterInfo = [self.filterModel valueForKey:[tempDict valueForKey:@"filter_key"]];
    if ([filterInfo length] > 0) {
        
        tempTextField.text = filterInfo;
        
    }
    
    return tempTextField;
    
}

#pragma mark - 点击textField时的事件：不进入编辑模式，只跳转
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    ///分发事件
    int actionType = [[textField valueForKey:@"customFlag"] intValue];
    
    switch (actionType) {
            
            ///选择区域
        case fFilterSettingFieldActionTypeDistrict:
        {
            
            [QSCustomDistrictSelectedPopView showCustomDistrictSelectedPopviewWithSteetSelectedKey:([self.filterModel.street_key length] > 0 ? self.filterModel.street_key : nil) andDistrictPickeredCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                ///判断选择
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    ///显示当前位置信息
                    textField.text = tempModel.val;
                    
                    ///保存位置信息
                    QSBaseConfigurationDataModel *districtModel = [QSCoreDataManager getDistrictModelWithStreetKey:tempModel.key];
                    self.filterModel.district_key = districtModel.key;
                    self.filterModel.district_val = districtModel.val;
                    self.filterModel.street_key = tempModel.key;
                    self.filterModel.street_val = [QSCoreDataManager getStreetValWithStreetKey:tempModel.key];
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    ///显示当前位置信息
                    textField.text = nil;
                    
                    ///将过滤器中的位置信息清空
                    self.filterModel.district_key = nil;
                    self.filterModel.district_val = nil;
                    self.filterModel.street_key = nil;
                    self.filterModel.street_val = nil;
                    
                }
                
            }];
            
        }
            break;
            
            ///选择户型
        case fFilterSettingFieldActionTypeHouseType:
        {
            
            ///获取户型的数据
            NSArray *intentArray = [QSCoreDataManager getHouseType];
            
            ///显示户型的选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.filterModel.house_type_key length] > 0 ? self.filterModel.house_type_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.filterModel.house_type_key = tempModel.key;
                    self.filterModel.house_type_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    ///显示当前位置信息
                    textField.text = nil;
                    
                    ///清空原数据
                    self.filterModel.house_type_key = nil;
                    self.filterModel.house_type_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///购房目的
        case fFilterSettingFieldActionTypePurposePurchase:
        {
            
            ///获取购房目的数据
            NSArray *intentArray = [QSCoreDataManager getPurpostPerchaseType];
            
            ///显示购房目的选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.filterModel.buy_purpose_key length] > 0 ? self.filterModel.buy_purpose_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.filterModel.buy_purpose_key = tempModel.key;
                    self.filterModel.buy_purpose_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.filterModel.buy_purpose_key = nil;
                    self.filterModel.buy_purpose_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///出售价格
        case fFilterSettingFieldActionTypeSalePrice:
        {
            
            ///获取出售价格的数据
            NSArray *intentArray = [QSCoreDataManager getHouseSalePriceType];
            
            ///显示房子售价选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.filterModel.sale_price_key length] > 0 ? self.filterModel.sale_price_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.filterModel.sale_price_key = tempModel.key;
                    self.filterModel.sale_price_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.filterModel.sale_price_key = nil;
                    self.filterModel.sale_price_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///房子面积
        case fFilterSettingFieldActionTypeArea:
        {
            
            ///获取房子面积的数据
            NSArray *intentArray = [QSCoreDataManager getHouseAreaType];
            
            ///显示房子面积选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.filterModel.house_area_key length] > 0 ? self.filterModel.house_area_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.filterModel.house_area_key = tempModel.key;
                    self.filterModel.house_area_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.filterModel.house_area_key = nil;
                    self.filterModel.house_area_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///出租方式：整租...
        case fFilterSettingFieldActionTypeRenantType:
        {
            
            ///获取出租方式选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseRentType];
            
            ///显示出租方式选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.filterModel.rent_type_key length] > 0 ? self.filterModel.rent_type_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.filterModel.rent_type_key = tempModel.key;
                    self.filterModel.rent_type_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.filterModel.rent_type_key = nil;
                    self.filterModel.rent_type_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///租金
        case fFilterSettingFieldActionTypeRenantPrice:
        {
            
            ///获取租金选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseRentPriceType];
            
            ///显示租金选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.filterModel.rent_price_key length] > 0 ? self.filterModel.rent_price_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.filterModel.rent_price_key = tempModel.key;
                    self.filterModel.rent_price_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.filterModel.rent_price_key = nil;
                    self.filterModel.rent_price_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///租金支付方式：押二付一
        case fFilterSettingFieldActionTypeRenantPayType:
        {
            
            ///获取租金支付方式选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseRentPayType];
            
            ///显示租金支付方式选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.filterModel.rent_pay_type_key length] > 0 ? self.filterModel.rent_pay_type_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.filterModel.rent_pay_type_key = tempModel.key;
                    self.filterModel.rent_pay_type_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.filterModel.rent_pay_type_key = nil;
                    self.filterModel.rent_pay_type_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///房子的物业类型：普通住宅...
        case fFilterSettingFieldActionTypeHouseTradeType:
        {
            
            ///获取房子的物业类型选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseTradeType];
            
            ///显示房子的物业类型选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.filterModel.trade_type_key length] > 0 ? self.filterModel.trade_type_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.filterModel.trade_type_key = tempModel.key;
                    self.filterModel.trade_type_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.filterModel.trade_type_key = nil;
                    self.filterModel.trade_type_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///房龄
        case fFilterSettingFieldActionTypeHouseUsedYear:
        {
            
            ///获取房子房龄选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseUsedYearType];
            
            ///显示房龄选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.filterModel.used_year_key length] > 0 ? self.filterModel.used_year_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.filterModel.used_year_key = tempModel.key;
                    self.filterModel.used_year_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.filterModel.used_year_key = nil;
                    self.filterModel.used_year_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///楼层
        case fFilterSettingFieldActionTypeHouseFloor:
        {
            
            ///获取房子楼层选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseFloorType];
            
            ///显示房子楼层选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.filterModel.floor_key length] > 0 ? self.filterModel.floor_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.filterModel.floor_key = tempModel.key;
                    self.filterModel.floor_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.filterModel.floor_key = nil;
                    self.filterModel.floor_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///朝向：朝南...
        case fFilterSettingFieldActionTypeHouseOrientations:
        {
            
            ///获取房子朝向选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseFaceType];
            
            ///显示房子朝向选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.filterModel.house_face_key length] > 0 ? self.filterModel.house_face_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.filterModel.house_face_key = tempModel.key;
                    self.filterModel.house_face_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.filterModel.house_face_key = nil;
                    self.filterModel.house_face_val = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///装修：精装修...
        case fFilterSettingFieldActionTypeHouseDecoration:
        {
            
            ///获取房子装修类型选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseDecorationType];
            
            ///显示房子装修类型选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.filterModel.decoration_key length] > 0 ? self.filterModel.decoration_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                    self.filterModel.decoration_key = tempModel.key;
                    self.filterModel.decoration_val = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                    self.filterModel.decoration_key = nil;
                    self.filterModel.decoration_val = nil;
                    
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
    
    NSString *infoFileName = nil;
    
    switch (self.houseType) {
            
            ///高级筛选出租房
        case fFilterMainTypeRentalHouse:
            
            infoFileName = PLIST_FILE_NAME_FILTER_ADVANCE_RENANTHOUSE;
            
            break;
            
            ///高级筛选二手房
        case fFilterMainTypeSecondHouse:
            
            infoFileName = PLIST_FILE_NAME_FILTER_ADVANCE_SECONDHOUSE;
            
            break;
            
        default:
            break;
    }
    
    ///配置信息文件路径
    NSString *infoPath = [[NSBundle mainBundle] pathForResource:infoFileName ofType:PLIST_FILE_TYPE];
    
    return [NSDictionary dictionaryWithContentsOfFile:infoPath];
    
}

@end
