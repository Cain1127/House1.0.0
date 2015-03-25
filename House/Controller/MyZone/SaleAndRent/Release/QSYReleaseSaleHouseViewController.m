//
//  QSYReleaseSaleHouseViewController.m
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseSaleHouseViewController.h"
#import "QSYReleasePickCommunityViewController.h"

#import "QSCustomSingleSelectedPopView.h"
#import "QSCustomDistrictSelectedPopView.h"

#import "UITextField+CustomField.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+App.h"

#import "QSReleaseSaleHouseDataModel.h"
#import "QSBaseConfigurationDataModel.h"
#import "QSCommunityDataModel.h"

///事件的类型
typedef enum
{

    rReleaseSaleHouseHomeActionTypeTradeType = 20,  //!<物业类型
    rReleaseSaleHouseHomeActionTypeDistrice,        //!<区
    rReleaseSaleHouseHomeActionTypeStreet,          //!<街道
    rReleaseSaleHouseHomeActionTypeCommunityName,   //!<小区名字
    rReleaseSaleHouseHomeActionTypeDetailAddress,   //!<详情地址
    rReleaseSaleHouseHomeActionTypeHouseType,       //!<户型
    rReleaseSaleHouseHomeActionTypeArea,            //!<面积
    rReleaseSaleHouseHomeActionTypeSalePrice,       //!<售价
    rReleaseSaleHouseHomeActionTypeIsprice,         //!<是否议价
    
}RELEASE_SALE_HOUSE_HOME_ACTIONTYPE;

@interface QSYReleaseSaleHouseViewController () <UITextFieldDelegate>

///出售物业的数据模型
@property (nonatomic,retain) QSReleaseSaleHouseDataModel *saleHouseReleaseModel;

@property (nonatomic,unsafe_unretained) UITextField *districtField;
@property (nonatomic,unsafe_unretained) UITextField *streetField;

@end

@implementation QSYReleaseSaleHouseViewController

#pragma mark - 初始化
///初始化
- (instancetype)init
{

    if (self = [super init]) {
        
        ///初始化发布数据模型
        self.saleHouseReleaseModel = [[QSReleaseSaleHouseDataModel alloc] init];
        
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
    
    ///判断是否可滚动
    if (([tempInfoArray count] * 44.0f) > view.frame.size.height) {
        
        view.contentSize = CGSizeMake(view.frame.size.width, ([tempInfoArray count] * 44.0f) + 10.0f);
        
    }
    
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
    
    ///保存地区和街道
    if (rReleaseSaleHouseHomeActionTypeDistrice == [[tempDict valueForKey:@"action_type"] intValue]) {
        
        self.districtField = tempTextField;
        
    }
    
    if (rReleaseSaleHouseHomeActionTypeStreet == [[tempDict valueForKey:@"action_type"] intValue]) {
        
        self.streetField = tempTextField;
        
    }
    
    return tempTextField;
    
}

#pragma mark - 点击textField时的事件：不进入编辑模式，只跳转
///点击textField时的事件：不进入编辑模式，只跳转
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    ///分发事件
    int actionType = [[textField valueForKey:@"customFlag"] intValue];
    
    ///详细地址输入框指针
    static UITextField *tempField = nil;
    
    switch (actionType) {
            
            ///物业类型
        case rReleaseSaleHouseHomeActionTypeTradeType:
        {
            
            ///回收详细地址弹出的键盘
            [tempField resignFirstResponder];
            
            ///获取房子的物业类型选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseTradeType];
            
            ///显示房子的物业类型选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:nil andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///地区
        case rReleaseSaleHouseHomeActionTypeDistrice:
            
            ///街道
        case rReleaseSaleHouseHomeActionTypeStreet:
        {
            
            ///回收详细地址弹出的键盘
            [tempField resignFirstResponder];
            
            [QSCustomDistrictSelectedPopView showCustomDistrictSelectedPopviewWithSteetSelectedKey:nil andDistrictPickeredCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                ///判断选择
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    ///查找区模型
                    QSBaseConfigurationDataModel *districtModel = [QSCoreDataManager getDistrictModelWithStreetKey:tempModel.key];
                    
                    ///显示当前位置信息
                    self.streetField.text = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    ///显示当前位置信息
                    textField.text = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///小区名
        case rReleaseSaleHouseHomeActionTypeCommunityName:
        {
            
            ///回收详细地址弹出的键盘
            [tempField resignFirstResponder];
            QSYReleasePickCommunityViewController *pickCommunityVC = [[QSYReleasePickCommunityViewController alloc] initWithPickedCallBack:^(BOOL flag, id pickModel) {
                
                ///已选择小区
                if (flag) {
                    
                    ///保存选择的小区信息
                    QSCommunityDataModel *pickCommunity = pickModel;
                    
                    ///显示信息
                    textField.text = pickCommunity.title;
                    
                }
                
            }];
            [self.navigationController pushViewController:pickCommunityVC animated:YES];
            return NO;
            
        }
            break;
            
            ///详细地址
        case rReleaseSaleHouseHomeActionTypeDetailAddress:
        {
            
            tempField = textField;
            return YES;
            
        }
            break;
            
            ///户型
        case rReleaseSaleHouseHomeActionTypeHouseType:
        {
            
            ///回收详细地址弹出的键盘
            [tempField resignFirstResponder];
            
            ///获取户型的数据
            NSArray *intentArray = [QSCoreDataManager getHouseType];
            
            ///显示户型的选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:nil andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    ///显示当前位置信息
                    textField.text = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///面积
        case rReleaseSaleHouseHomeActionTypeArea:
        {
            
            ///回收详细地址弹出的键盘
            [tempField resignFirstResponder];
            
            ///获取房子面积的数据
            NSArray *intentArray = [QSCoreDataManager getHouseAreaType];
            
            ///显示房子面积选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:nil andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///售价
        case rReleaseSaleHouseHomeActionTypeSalePrice:
        {
            
            ///回收详细地址弹出的键盘
            [tempField resignFirstResponder];
            
            ///获取出售价格的数据
            NSArray *intentArray = [QSCoreDataManager getHouseSalePriceType];
            
            ///显示房子售价选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:nil andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///是否议价
        case rReleaseSaleHouseHomeActionTypeIsprice:
        {
            
            ///回收详细地址弹出的键盘
            [tempField resignFirstResponder];
            
            ///获取出售价格的数据
            NSArray *intentArray = [QSCoreDataManager getHouseIsNegotiatedPriceType];
            
            ///显示房子售价选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:nil andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    
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

#pragma mark - 返回当前页的设置信息配置文件字典
///返回当前页的设置信息配置文件字典
- (NSDictionary *)getFilterSettingInfoWithType
{
    
    NSString *infoFileName = PLIST_FILE_NAME_RELEASE_SALEHOUSE;
    ///配置信息文件路径
    NSString *infoPath = [[NSBundle mainBundle] pathForResource:infoFileName ofType:PLIST_FILE_TYPE];
    return [NSDictionary dictionaryWithContentsOfFile:infoPath];
    
}

#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;

}

@end
