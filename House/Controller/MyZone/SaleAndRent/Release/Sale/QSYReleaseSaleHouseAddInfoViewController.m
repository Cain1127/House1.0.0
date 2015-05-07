//
//  QSYReleaseSaleHouseAddInfoViewController.m
//  House
//
//  Created by ysmeng on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseSaleHouseAddInfoViewController.h"
#import "QSYReleaseSaleHousePictureViewController.h"

#import "QSCustomSingleSelectedPopView.h"
#import "QSMultipleSelectedPopView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"

#import "QSCoreDataManager+House.h"

#import "QSReleaseSaleHouseDataModel.h"
#import "QSBaseConfigurationDataModel.h"

///事件的类型
typedef enum
{
    
    rReleaseSaleHouseAddinfoActionTypeHouseProperty = 20,   //!<房屋性质
    rReleaseSaleHouseAddinfoActionTypeBuildingYear,         //!<建筑年代
    rReleaseSaleHouseAddinfoActionTypeUsedYear,             //!<使用年限
    rReleaseSaleHouseAddinfoActionTypeFloor,                //!<楼层
    rReleaseSaleHouseAddinfoActionTypeHouseFace,            //!<朝向
    rReleaseSaleHouseAddinfoActionTypeDecoration,           //!<装修
    rReleaseSaleHouseAddinfoActionTypeInstallation,         //!<配套
    
}RELEASE_SALE_HOUSE_ADDINFO_ACTIONTYPE;

@interface QSYReleaseSaleHouseAddInfoViewController () <UITextFieldDelegate>

///出售物业的数据模型
@property (nonatomic,retain) QSReleaseSaleHouseDataModel *saleHouseReleaseModel;

@end

@implementation QSYReleaseSaleHouseAddInfoViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-03-26 09:03:39
 *
 *  @brief              创建发布出售物业时的附加信息填写窗口
 *
 *  @param saleModel    发布出售物业时的填写数据模型
 *
 *  @return             返回当前创建的附加信息窗口
 *
 *  @since              1.0.0
 */
- (instancetype)initWithSaleModel:(QSReleaseSaleHouseDataModel *)saleModel
{

    if (self = [super init]) {
        
        ///保存出售信息
        self.saleHouseReleaseModel = saleModel;
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"发布出售物业"];
    
}

- (void)createMainShowUI
{

    ///过滤条件的底view
    QSScrollView *pickedRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f - 25.0f)];
    [self createSettingInputUI:pickedRootView];
    [self.view addSubview:pickedRootView];
    
    ///分隔线
    UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, pickedRootView.frame.origin.y + pickedRootView.frame.size.height, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLineLabel];
    
    ///底部确定按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"下一步";
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///进入图片页
        QSYReleaseSaleHousePictureViewController *pictureAddVC = [[QSYReleaseSaleHousePictureViewController alloc] initWithSaleModel:self.saleHouseReleaseModel];
        [self.navigationController pushViewController:pictureAddVC animated:YES];
        
    }];
    [self.view addSubview:commitButton];

}

///搭建设置信息输入栏
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
    
    ///标记高度
    CGFloat currentHeight = (44.0f + 8.0f) * [tempInfoArray count] + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
    
    ///标签信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 5.0f, currentHeight, SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 5.0f, 30.0f)];
    tipsLabel.text = @"特色标签";
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
            __block QSBaseConfigurationDataModel *featuresModel = featuresList[k];
            
            UIButton *featuresButton = [UIButton createBlockButtonWithFrame:CGRectMake(gapOfFeatures + j * (widthOfFeatures + gapOfFeatures), currentHeight + i * (heightOfFeatures + 5.0f), widthOfFeatures, heightOfFeatures) andButtonStyle:nil andCallBack:^(UIButton *button) {
                
                if (button.selected) {
                    
                    button.selected = NO;
                    button.layer.borderColor = [COLOR_CHARACTERS_LIGHTGRAY CGColor];
                    
                    ///删除选择项
                    [self deleteFeatureWithModel:featuresModel];
                    
                } else {
                    
                    ///判断是否已添加三个，最多只能选择三个
                    if ([self.saleHouseReleaseModel.featuresList count] >= 3) {
                        
                        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"最多只能选择三个标签", 1.5f, ^(){})
                        return;
                        
                    }
                    
                    button.selected = YES;
                    button.layer.borderColor = [COLOR_CHARACTERS_BLACK CGColor];
                    
                    ///添加标签信息
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
            
            ///检测是否已选择过
            featuresButton.selected = [self checkFeaturesIsSave:featuresModel];
            
            ///添加按钮
            [view addSubview:featuresButton];
            k++;
            
        }
        
    }
    
    ///重置当前高度
    currentHeight = currentHeight + heightOfFeatures * sumRow + 5.0f * (sumRow - 1) + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
    
    ///判断是否可滚动
    if (currentHeight > view.frame.size.height) {
        
        view.contentSize = CGSizeMake(view.frame.size.width, currentHeight + 10.0f);
        
    }
    
}

#pragma mark - 检测标签是否已在数据源中
- (BOOL)checkFeaturesIsSave:(QSBaseConfigurationDataModel *)model
{

    for (QSBaseConfigurationDataModel *obj in self.saleHouseReleaseModel.featuresList) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            return YES;
            
        }
        
    }
    return NO;

}

#pragma mark - 创建右剪头控件
///创建右剪头控件
- (UIView *)createRightArrowSubviewWithViewInfo:(NSDictionary *)tempDict
{
    
    NSString *orderString = [tempDict valueForKey:@"order"];
    int index = [orderString intValue];
    
    ///显示信息栏
    UITextField *tempTextField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 8.0f + index * (8.0f + 44.0f), SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f) andPlaceHolder:[tempDict valueForKey:@"placehold"] andLeftTipsInfo:[tempDict valueForKey:@"left_title"] andLeftTipsTextAlignment:NSTextAlignmentCenter andTextFieldStyle:[[tempDict valueForKey:@"type"] intValue]];
    tempTextField.font = [UIFont systemFontOfSize:FONT_BODY_16];
    tempTextField.delegate = self;
    [tempTextField setValue:[tempDict valueForKey:@"action_type"] forKey:@"customFlag"];
    NSString *filterInfo = [self.saleHouseReleaseModel valueForKey:[tempDict valueForKey:@"filter_key"]];
    if ([filterInfo length] > 0) {
        
        tempTextField.text = filterInfo;
        
    }
    
    return tempTextField;
    
}

#pragma mark - 点击textField时的事件：不进入编辑模式，只跳转
///点击textField时的事件：不进入编辑模式，只跳转
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    ///分发事件
    int actionType = [[textField valueForKey:@"customFlag"] intValue];
    
    switch (actionType) {
            
            ///房屋性质
        case rReleaseSaleHouseAddinfoActionTypeHouseProperty:
        {
            
            ///获取房屋性质选择项数组
            NSArray *intentArray = [QSCoreDataManager getHouseNatureTypes];
            
            ///显示房屋性质选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.saleHouseReleaseModel.natureKey length] > 0 ? self.saleHouseReleaseModel.natureKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.saleHouseReleaseModel.nature = tempModel.val;
                    self.saleHouseReleaseModel.natureKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.saleHouseReleaseModel.nature = nil;
                    self.saleHouseReleaseModel.natureKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///建筑年代
        case rReleaseSaleHouseAddinfoActionTypeBuildingYear:
        {
            
            ///获取房屋建筑年代选择项数组
            NSArray *intentArray = [QSCoreDataManager getHouseBuildingYearTypes];
            
            ///显示房屋建筑年代选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.saleHouseReleaseModel.buildingYearKey length] > 0 ? self.saleHouseReleaseModel.buildingYearKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.saleHouseReleaseModel.buildingYear = tempModel.val;
                    self.saleHouseReleaseModel.buildingYearKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.saleHouseReleaseModel.buildingYear = nil;
                    self.saleHouseReleaseModel.buildingYearKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///使用年限
        case rReleaseSaleHouseAddinfoActionTypeUsedYear:
        {
            
            ///获取房屋产权选择项数组
            NSArray *intentArray = [QSCoreDataManager getHousePropertyRightType];
            
            ///显示房屋产权选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.saleHouseReleaseModel.propertyRightYearKey length] > 0 ? self.saleHouseReleaseModel.propertyRightYearKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.saleHouseReleaseModel.propertyRightYear = tempModel.val;
                    self.saleHouseReleaseModel.propertyRightYearKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.saleHouseReleaseModel.propertyRightYear = nil;
                    self.saleHouseReleaseModel.propertyRightYearKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///楼层
        case rReleaseSaleHouseAddinfoActionTypeFloor:
        {
            
            ///获取楼层选择项数组
            NSArray *intentArray = [QSCoreDataManager getHouseFloorType];
            
            ///显示楼层选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.saleHouseReleaseModel.floorKey length] > 0 ? self.saleHouseReleaseModel.floorKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.saleHouseReleaseModel.floor = tempModel.val;
                    self.saleHouseReleaseModel.floorKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.saleHouseReleaseModel.floor = nil;
                    self.saleHouseReleaseModel.floorKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///朝向
        case rReleaseSaleHouseAddinfoActionTypeHouseFace:
        {
            
            ///获取朝向选择项数组
            NSArray *intentArray = [QSCoreDataManager getHouseFaceType];
            
            ///显示朝向选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.saleHouseReleaseModel.faceKey length] > 0 ? self.saleHouseReleaseModel.faceKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.saleHouseReleaseModel.face = tempModel.val;
                    self.saleHouseReleaseModel.faceKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.saleHouseReleaseModel.face = nil;
                    self.saleHouseReleaseModel.faceKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///装修
        case rReleaseSaleHouseAddinfoActionTypeDecoration:
        {
            
            ///获取装修选择项数组
            NSArray *intentArray = [QSCoreDataManager getHouseDecorationType];
            
            ///显示装修选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.saleHouseReleaseModel.decorationKey length] > 0 ? self.saleHouseReleaseModel.decorationKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.saleHouseReleaseModel.decoration = tempModel.val;
                    self.saleHouseReleaseModel.decorationKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.saleHouseReleaseModel.decoration = nil;
                    self.saleHouseReleaseModel.decorationKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///配套
        case rReleaseSaleHouseAddinfoActionTypeInstallation:
        {
            
            ///获取配套选择项数组
            NSArray *intentArray = [QSCoreDataManager getHouseInstallationTypes:fFilterMainTypeSecondHouse];
            
            ///显示配套选择项窗口
            [QSMultipleSelectedPopView showMultipleSelectedViewWithDataSource:intentArray andSelectedSource:([self.saleHouseReleaseModel.installationList count] > 0 ? self.saleHouseReleaseModel.installationList : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeMultipleSelected == actionType) {
                    
                    ///拼装显示信息
                    NSMutableString *showString = [[NSMutableString alloc] init];
                    for (int i = 0;i < [params count];i++) {
                        
                        QSBaseConfigurationDataModel *tempModel = params[i];
                        
                        ///非第一个元素时，添加逗号
                        if (i != 0) {
                            
                            [showString appendString:@","];
                            
                        }
                        
                        [showString appendString:tempModel.val];
                        
                    }
                    
                    textField.text = showString;
                    self.saleHouseReleaseModel.installationString = showString;
                    [self.saleHouseReleaseModel.installationList removeAllObjects];
                    [self.saleHouseReleaseModel.installationList addObjectsFromArray:params];
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.saleHouseReleaseModel.installationString = nil;
                    [self.saleHouseReleaseModel.installationList removeAllObjects];;
                    
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

#pragma mark - 配套信息的添加和删除
///配置信息的添加和删除
- (void)addInstallationWithModel:(QSBaseConfigurationDataModel *)model
{

    ///遍历原保存，如果没有，则添加
    for (QSBaseConfigurationDataModel *obj in self.saleHouseReleaseModel.installationList) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            return;
            
        }
        
    }
    
    ///添加
    [self.saleHouseReleaseModel.installationList addObject:model];

}

- (void)deleteInstallationWithModel:(QSBaseConfigurationDataModel *)model
{

    ///遍历，如果存在，则删除
    for (QSBaseConfigurationDataModel *obj in self.saleHouseReleaseModel.installationList) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            [self.saleHouseReleaseModel.installationList removeObject:obj];

        }
        
    }

}

#pragma mark - 添加/删除标签
///添加/删除标签
- (void)addFeatureWithModel:(QSBaseConfigurationDataModel *)model
{

    ///遍历原保存，如果没有，则添加
    for (QSBaseConfigurationDataModel *obj in self.saleHouseReleaseModel.featuresList) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            return;
            
        }
        
    }
    
    ///添加
    [self.saleHouseReleaseModel.featuresList addObject:model];

}

- (void)deleteFeatureWithModel:(QSBaseConfigurationDataModel *)model
{

    ///遍历，如果存在，则删除
    NSArray *tempArray = [[NSArray alloc] initWithArray:self.saleHouseReleaseModel.featuresList];
    [self.saleHouseReleaseModel.featuresList removeAllObjects];
    for (QSBaseConfigurationDataModel *obj in tempArray) {
        
        if (![obj.key isEqualToString:model.key]) {
            
            [self.saleHouseReleaseModel.featuresList addObject:obj];
            
        }
        
    }

}

#pragma mark - 返回当前页的设置信息配置文件字典
///返回当前页的设置信息配置文件字典
- (NSDictionary *)getFilterSettingInfoWithType
{
    
    NSString *infoFileName = PLIST_FILE_NAME_RELEASE_SALEHOUSE_ADD;
    ///配置信息文件路径
    NSString *infoPath = [[NSBundle mainBundle] pathForResource:infoFileName ofType:PLIST_FILE_TYPE];
    return [NSDictionary dictionaryWithContentsOfFile:infoPath];
    
}

@end
