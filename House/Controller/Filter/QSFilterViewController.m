//
//  QSFilterViewController.m
//  House
//
//  Created by ysmeng on 15/1/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSFilterViewController.h"
#import "QSTabBarViewController.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"

#import "QSCustomSingleSelectedPopView.h"
#import "QSCustomDistrictSelectedPopView.h"
#import "QSCustomCitySelectedView.h"
#import "QSMultipleSelectedPopView.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+Filter.h"
#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+User.h"

#import "QSFilterDataModel.h"
#import "QSCDBaseConfigurationDataModel.h"
#import "QSBaseConfigurationDataModel.h"

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

@interface QSFilterViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,assign) FILTER_SETTINGVC_TYPE filterVCType;//!<过滤设置页面的类型
@property (nonatomic,retain) QSFilterDataModel *filterModel;    //!<过滤器数据模型
@property (nonatomic,assign) BOOL isAddAskRent;                 //!<是否同步添加求租求购

@end

@implementation QSFilterViewController

#pragma mark - 初始化
/**
 *  @author                 yangshengmeng, 15-01-23 13:01:52
 *
 *  @brief                  根据过滤器类型创建不同的过滤设置器
 *
 *  @param filterType       过滤类型：二手器、出租房等
 *
 *  @return                 返回过滤器对象
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithFilterType:(FILTER_SETTINGVC_TYPE)filterType
{

    if (self = [super init]) {
        
        ///保存过滤器类型
        self.filterVCType = filterType;
        
        ///初始化过滤器模型
        [self createFilterDataModel];
        
        ///初始化求租求购
        self.isAddAskRent = YES;
        
    }
    
    return self;

}

///初始化过滤器的数据模型
- (void)createFilterDataModel
{
    
    self.filterModel = [QSCoreDataManager getLocalFilterWithType:[self getFilterTypeWithFilterVCType]];
    
}

#pragma mark - 根据过滤器的类型，返回对应的过滤器类型
///根据过滤器的类型，返回对应的过滤器类型
- (FILTER_MAIN_TYPE)getFilterTypeWithFilterVCType
{

    switch (self.filterVCType) {
            ///出租房过滤设置
        case fFilterSettingVCTypeGuideRentHouse:
                        
        case fFilterSettingVCTypeHomeRentHouse:
                        
        case fFilterSettingVCTypeHouseListRentHouse:
            
            return fFilterMainTypeRentalHouse;
            
            break;
            
            ///二手房
        case fFilterSettingVCTypeGuideSecondHouse:
            
        case fFilterSettingVCTypeHomeSecondHouse:
            
        case fFilterSettingVCTypeHouseListSecondHouse:
            
            return fFilterMainTypeSecondHouse;
            
            break;
            
        default:
            break;
    }

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    switch (self.filterVCType) {
            ///指引页出租房导航栏UI
        case fFilterSettingVCTypeGuideRentHouse:
            
            ///指引页二手房导航栏UI
        case fFilterSettingVCTypeGuideSecondHouse:
            
            break;
            
            ///首页出租房导航栏UI
        case fFilterSettingVCTypeHomeRentHouse:
        {
        
            [super createNavigationBarUI];
            [self setNavigationBarTitle:@"出租房"];
        
        }
            
            break;
            
            ///首页二手房导航栏UI
        case fFilterSettingVCTypeHomeSecondHouse:
        {
        
            [super createNavigationBarUI];
            [self setNavigationBarTitle:@"二手房"];
        
        }
            
            break;
            
            ///房源列表二手房导航栏UI
        case fFilterSettingVCTypeHouseListRentHouse:
            
        case fFilterSettingVCTypeHouseListSecondHouse:
        {
            
            [super createNavigationBarUI];
            [self setNavigationBarTitle:@"高级过滤"];
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)createMainShowUI
{
    
    ///两种情况：已配置有过滤器时，存在导航栏，未配置时，是没有导航栏的
    switch (self.filterVCType) {
            ///指引页主UI创建
        case fFilterSettingVCTypeGuideRentHouse:
            
        case fFilterSettingVCTypeGuideSecondHouse:
            
            [self createFirstSettingFilterPage];
            
            break;
            
            ///其他过滤器设置页面的UI创建
        default:
            
            [self createUpdateFilterSettingPage];
            
            break;
            
    }

}

#pragma mark - 创建第一次设置过滤器的页面
- (void)createFirstSettingFilterPage
{

    ///头背景图片:700 x 305
    QSImageView *headerImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_WIDTH * 305.0f / 700.0f)];
    headerImageView.image = [UIImage imageNamed:IMAGE_FILTER_DEFAULT_HEADER];
    [self.view addSubview:headerImageView];
    
    ///头部提示信息
    QSLabel *titleTipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, headerImageView.frame.size.height / 2.0f - 30.0f, SIZE_DEFAULT_MAX_WIDTH, 30.0f)];
    titleTipsLabel.text = TITLE_FILTER_FIRSTSETTING_HEADER_TITLE;
    titleTipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_25];
    titleTipsLabel.textAlignment = NSTextAlignmentCenter;
    titleTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    [headerImageView addSubview:titleTipsLabel];
    
    QSLabel *subTitleTipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, headerImageView.frame.size.height / 2.0f, SIZE_DEFAULT_MAX_WIDTH, 20.0f)];
    subTitleTipsLabel.text = TITLE_FILTER_FIRSTSETTING_SUBHEADER_TITLE;
    subTitleTipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    subTitleTipsLabel.textAlignment = NSTextAlignmentCenter;
    subTitleTipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    [headerImageView addSubview:subTitleTipsLabel];
    
    ///过滤器设置底view
    QSScrollView *filterSettingRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, headerImageView.frame.size.height, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - headerImageView.frame.size.height)];
    [self createSettingInputUI:filterSettingRootView];
    [self.view addSubview:filterSettingRootView];
    
    ///看看运气如何按钮
    UIButton *commitFilterButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 54.0f, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:[QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow] andCallBack:^(UIButton *button) {
        
        ///设置当前状态
        self.filterModel.filter_status = @"2";
        
        ///保存过滤器
        [QSCoreDataManager updateFilterWithType:[self getFilterTypeWithFilterVCType] andFilterDataModel:self.filterModel andUpdateCallBack:^(BOOL isSuccess) {
            
            ///保存成功后进入房子列表
            if (isSuccess) {
                
                QSTabBarViewController *homePageVC = [[QSTabBarViewController alloc] initWithCurrentIndex:1];
                homePageVC.selectedIndex = 1;
                [self changeWindowRootViewController:homePageVC];
                
            }
            
        }];
        
    }];
    [commitFilterButton setTitle:TITLE_FILTER_FIRSTSETTING_COMMITBUTTON forState:UIControlStateNormal];
    [self.view addSubview:commitFilterButton];

}

///搭建过滤器设置信息输入栏
- (void)createSettingInputUI:(QSScrollView *)view
{

    /**
     *  房子类型 :
     *  区域 : 
     *  户型 :
     *  购房目的 :
     *  售价 :
     *  面积 :
     *  出租方式 :
     *  租金 :
     *  租金支付方式 :
     *  楼层 :
     *  朝向 :
     *  装修 :
     *  房龄 :
     *  标签 :
     *  备注 :
     *  配套 :
     */
    
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
    
    ///特色标签提示信息
    if (fFilterSettingVCTypeHouseListRentHouse <= self.filterVCType) {
        
        ///说明信息
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 5.0f, currentHeight, SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 5.0f, 30.0f)];
        tipsLabel.text = @"补充信息：(多选项)";
        tipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
        tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
        [view addSubview:tipsLabel];
        currentHeight = currentHeight + tipsLabel.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
        
        ///选择标签
        NSArray *featuresList = [QSCoreDataManager getHouseFeatureListWithType:[self getFilterTypeWithFilterVCType]];
        
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
        UITextView *commendField = [[UITextView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, currentHeight, SIZE_DEFAULT_MAX_WIDTH, 160.0f)];
        commendField.backgroundColor = [UIColor whiteColor];
        commendField.showsHorizontalScrollIndicator = NO;
        commendField.showsVerticalScrollIndicator = NO;
        commendField.delegate = self;
        commendField.layer.borderColor = [COLOR_CHARACTERS_LIGHTGRAY CGColor];
        commendField.layer.borderWidth = 0.5f;
        commendField.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
        [view addSubview:commendField];
        currentHeight = currentHeight + commendField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
        
        ///如果是高级过滤，则显示是否设置为求租求购：需要已登录
        if (fFilterSettingVCTypeHouseListRentHouse == self.filterVCType ||
            fFilterSettingVCTypeHouseListSecondHouse == self.filterVCType) {
            
            ///判断是否已登录
            if (lLoginCheckActionTypeLogined == [self checkLogin]) {
                
                ///提示信息
                UILabel *setAsAskFilterTips = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 5.0f, currentHeight, 200.0f, 30.0f)];
                setAsAskFilterTips.text = @"设为求租求购订阅信息";
                setAsAskFilterTips.textColor = COLOR_CHARACTERS_LIGHTGRAY;
                setAsAskFilterTips.font = [UIFont systemFontOfSize:FONT_BODY_16];
                [view addSubview:setAsAskFilterTips];
                currentHeight = currentHeight + setAsAskFilterTips.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
                
                ///设置开关
                UISwitch *tipsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 60.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT, setAsAskFilterTips.frame.origin.y + 3.0f, 60.0f, 30.0f)];
                tipsSwitch.onTintColor = COLOR_CHARACTERS_LIGHTYELLOW;
                tipsSwitch.on = YES;
                [tipsSwitch addTarget:self action:@selector(isAddAskRentAndPurchaseSwitchAction:) forControlEvents:UIControlEventValueChanged];
                [view addSubview:tipsSwitch];
                
                ///分隔线
                UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(setAsAskFilterTips.frame.origin.x, setAsAskFilterTips.frame.origin.y + setAsAskFilterTips.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP - 0.5f, SIZE_DEFAULT_MAX_WIDTH - 10.0f, 0.5f)];
                sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
                [view addSubview:sepLineLabel];
                
            } else {
            
                [commendField removeFromSuperview];
                currentHeight = currentHeight - commendField.frame.size.height - VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
            
            }
            
        }
        
    }
    
    ///判断是否可滚动
    if (currentHeight > view.frame.size.height) {
        
        view.contentSize = CGSizeMake(view.frame.size.width, currentHeight + 10.0f);
        
    }

}

#pragma mark - 是否设置求租求购开关事件
- (void)isAddAskRentAndPurchaseSwitchAction:(UISwitch *)switchView
{

    ///判断开关状态
    if (switchView.on) {
        
        self.isAddAskRent = YES;
        
    } else {
    
        self.isAddAskRent = NO;
    
    }

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

#pragma mark - 创建重新设置过滤器的页面
///创建重新设置过滤器的页面
- (void)createUpdateFilterSettingPage
{
    
    ///其他选择项的底view起始y坐标
    CGFloat ypoint = 64.0f;

    ///过滤条件的底view
    QSScrollView *pickedRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, ypoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - ypoint - 44.0f - 25.0f)];
    [self createSettingInputUI:pickedRootView];
    [self.view addSubview:pickedRootView];
    
    ///底部确定按钮
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///设置当前状态
        self.filterModel.filter_status = @"2";
        
        ///保存过滤器
        [QSCoreDataManager updateFilterWithType:[self getFilterTypeWithFilterVCType] andFilterDataModel:self.filterModel andUpdateCallBack:^(BOOL isSuccess) {
            
            ///判断是否发送求租求购
            if (fFilterSettingVCTypeHouseListRentHouse == self.filterVCType ||
                fFilterSettingVCTypeHouseListSecondHouse == self.filterVCType) {
                
                if (self.isAddAskRent) {
                    
                    [self addAskRentAndPurphase];
                    
                }
                
            }
            
            ///回调
            if (self.resetFilterCallBack) {
                
                self.resetFilterCallBack(isSuccess);
                
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }];
        
    }];
    [commitButton setTitle:@"确定" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commitButton setTitleColor:COLOR_CHARACTERS_YELLOW forState:UIControlStateHighlighted];
    commitButton.layer.cornerRadius = 6.0f;
    commitButton.backgroundColor = COLOR_CHARACTERS_YELLOW;
    [self.view addSubview:commitButton];

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

#pragma mark - 根据不同的类型返回对应的配置文件
- (NSDictionary *)getFilterSettingInfoWithType
{

    NSString *infoFileName = nil;
    
    switch (self.filterVCType) {
            
            ///指引页：二手房
        case fFilterSettingVCTypeGuideSecondHouse:
        {
         
            infoFileName = PLIST_FILE_NAME_FILTER_FINDHOUSE_SECONDHOUSE;
                
        }
            break;
            
            ///指引页出租房
        case fFilterSettingVCTypeGuideRentHouse:
        {
            
            infoFileName = PLIST_FILE_NAME_FILTER_FINDHOUSE_RENANTHOUSE;
            
        }
            break;
            
            ///首页二手房
        case fFilterSettingVCTypeHomeSecondHouse:
            
            infoFileName = PLIST_FILE_NAME_FILTER_FINDHOUSE_SECONDHOUSE_RESET;
            
            break;
            
            ///首页出租房
        case fFilterSettingVCTypeHomeRentHouse:
            
            infoFileName = PLIST_FILE_NAME_FILTER_FINDHOUSE_RENANTHOUSE_RESET;
            
            break;
            
            ///高级筛选出租房
        case fFilterSettingVCTypeHouseListRentHouse:
            
            infoFileName = PLIST_FILE_NAME_FILTER_ADVANCE_RENANTHOUSE;
            
            break;
            
            ///高级筛选二手房
        case fFilterSettingVCTypeHouseListSecondHouse:
            
            infoFileName = PLIST_FILE_NAME_FILTER_ADVANCE_SECONDHOUSE;
            
            break;
            
        default:
            break;
    }
    
    ///配置信息文件路径
    NSString *infoPath = [[NSBundle mainBundle] pathForResource:infoFileName ofType:PLIST_FILE_TYPE];
    
    return [NSDictionary dictionaryWithContentsOfFile:infoPath];

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
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
                    ///显示当前位置信息
                    textField.text = tempModel.val;
                    
                    ///保存位置信息
                    QSCDBaseConfigurationDataModel *districtModel = [QSCoreDataManager getDistrictModelWithStreetKey:tempModel.key];
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
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
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
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
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
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
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
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
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
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
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
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
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
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
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
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
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
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
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
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
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
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
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
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
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
            
            ///配套：暖气....
        case fFilterSettingFieldActionTypeHouseInstallation:
        {
            
            ///获取配套选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseRentPayType];
            
            ///显示配套选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.filterModel.street_key length] > 0 ? self.filterModel.street_key : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                ///转模型
                QSCDBaseConfigurationDataModel *tempModel = params;
                
                textField.text = tempModel.val;
                
            }];
            
            return NO;
            
        }
            break;
            
            ///城市选择
        case fFilterSettingFieldActionTypeCity:
        {
        
            [QSCustomCitySelectedView showCustomCitySelectedPopviewWithCitySelectedKey:nil andCityPickeredCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                ///判断选择
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSCDBaseConfigurationDataModel *tempModel = params;
                    
                    ///显示当前位置信息
                    textField.text = tempModel.val;
                    
                    ///更新用户默认城市：必须更新，影响地区选择，如若无城市，将会导致地区选择无数据
                    [QSCoreDataManager updateCurrentUserCity:params];
                    
                    ///保存位置信息
                    QSCDBaseConfigurationDataModel *provinceModel = [QSCoreDataManager getProvinceModelWithCityKey:tempModel.key];
                    self.filterModel.city_key = tempModel.key;
                    self.filterModel.city_val = tempModel.val;
                    self.filterModel.province_key = provinceModel.key;
                    self.filterModel.province_val = provinceModel.val;
                    
                }
                
            }];
        
        }
            break;
            
        default:
            break;
    }
    
    return NO;

}

#pragma mark - 添加求租求购
///添加求租求购
- (void)addAskRentAndPurphase
{

    ///根据不同的类型，添加不同的求租求购
    if (fFilterMainTypeRentalHouse == [self getFilterTypeWithFilterVCType]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self addNewAskRentAndRentRecords];
            
        });
        
    }
    
    if (fFilterMainTypeSecondHouse == [self getFilterTypeWithFilterVCType]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self addNewAskRentAndBuyRecords];
            
        });
        
    }

}

- (void)addNewAskRentAndBuyRecords
{
    
    NSDictionary *params = @{
                             @"type" : @"2",
                             @"cityid" : APPLICATION_NSSTRING_SETTING(self.filterModel.city_key, @""),
                             @"areaid" : APPLICATION_NSSTRING_SETTING(self.filterModel.district_key, @""),
                             @"street" : APPLICATION_NSSTRING_SETTING(self.filterModel.street_key, @""),
                             @"intent" : APPLICATION_NSSTRING_SETTING(self.filterModel.buy_purpose_key, @""),
                             @"price" : APPLICATION_NSSTRING_SETTING(self.filterModel.sale_price_key, @""),
                             @"house_shi" : APPLICATION_NSSTRING_SETTING(self.filterModel.house_type_key, @""),
                             @"house_area" : APPLICATION_NSSTRING_SETTING(self.filterModel.house_area_key, @""),
                             @"property_type" : APPLICATION_NSSTRING_SETTING(self.filterModel.trade_type_key, @""),
                             @"floor_which" : APPLICATION_NSSTRING_SETTING(self.filterModel.floor_key, @""),
                             @"house_face" : APPLICATION_NSSTRING_SETTING(self.filterModel.house_face_key, @""),
                             @"decoration_type" : APPLICATION_NSSTRING_SETTING(self.filterModel.decoration_key, @""),
                             @"features" : [self.filterModel getFeaturesPostParams],
                             @"used_year" : APPLICATION_NSSTRING_SETTING(self.filterModel.used_year_key, @""),
                             @"content" : APPLICATION_NSSTRING_SETTING(self.filterModel.comment, @"")};
    
    ///发布
    [QSRequestManager requestDataWithType:rRequestTypeMyZoneAddAskRentPurpase andParams:@{@"rentPurchaseInfo" : params} andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///发布成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            APPLICATION_LOG_INFO(@"高级过滤->设置为求购", @"成功");
            
        } else {
            
            APPLICATION_LOG_INFO(@"高级过滤->设置为求购", @"失败");
            
        }
        
    }];
    
}

- (void)addNewAskRentAndRentRecords
{
    
    NSDictionary *params = @{
                             @"type" : @"1",
                             @"rent_property" : APPLICATION_NSSTRING_SETTING(self.filterModel.rent_type_key, @""),
                             @"cityid" : APPLICATION_NSSTRING_SETTING(self.filterModel.city_key, @""),
                             @"areaid" : APPLICATION_NSSTRING_SETTING(self.filterModel.district_key, @""),
                             @"street" : APPLICATION_NSSTRING_SETTING(self.filterModel.street_key, @""),
                             @"price" : APPLICATION_NSSTRING_SETTING(self.filterModel.rent_price_key, @""),
                             @"house_shi" : APPLICATION_NSSTRING_SETTING(self.filterModel.house_type_key, @""),
                             @"property_type" : APPLICATION_NSSTRING_SETTING(self.filterModel.trade_type_key, @""),
                             @"floor_which" : APPLICATION_NSSTRING_SETTING(self.filterModel.floor_key, @""),
                             @"house_face" : APPLICATION_NSSTRING_SETTING(self.filterModel.house_face_key, @""),
                             @"decoration_type" : APPLICATION_NSSTRING_SETTING(self.filterModel.decoration_key, @""),
                             @"installation" : @"",
                             @"payment" : APPLICATION_NSSTRING_SETTING(self.filterModel.rent_pay_type_key,@""),
                             @"features" : [self.filterModel getFeaturesPostParams],
                             @"content" : APPLICATION_NSSTRING_SETTING(self.filterModel.comment, @"")};
    
    ///发布
    [QSRequestManager requestDataWithType:rRequestTypeMyZoneAddAskRentPurpase andParams:@{@"rentPurchaseInfo" : params} andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///发布成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            APPLICATION_LOG_INFO(@"高级过滤->设置为求租", @"成功");
            
        } else {
            
            APPLICATION_LOG_INFO(@"高级过滤->设置为求租", @"失败");
            
        }
        
    }];

}

@end
