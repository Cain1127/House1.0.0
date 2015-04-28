//
//  QSYReleaseRentHouseViewController.m
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseRentHouseViewController.h"
#import "QSYReleasePickCommunityViewController.h"
#import "QSYReleaseRentHouseAddinfoViewController.h"

#import "QSCustomDistrictSelectedPopView.h"
#import "QSCustomSingleSelectedPopView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"

#import "QSBaseConfigurationDataModel.h"
#import "QSReleaseRentHouseDataModel.h"
#import "QSCommunityDataModel.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+App.h"

///事件的类型
typedef enum
{
    
    rReleaseRentHouseHomeActionTypeDistrice = 10,       //!<区
    rReleaseRentHouseHomeActionTypeStreet,              //!<街道
    rReleaseRentHouseHomeActionTypeCommunity,           //!<小区名
    rReleaseRentHouseHomeActionTypeAddress,             //!<地址
    rReleaseRentHouseHomeActionTypeHouseType,           //!<户型
    rReleaseRentHouseHomeActionTypeArea,                //!<面积
    rReleaseRentHouseHomeActionTypeRentPrice,           //!<租金
    rReleaseRentHouseHomeActionTypeRentPayType,         //!<支付方式
    rReleaseRentHouseHomeActionTypeWhetherBargaining,   //!<是否议价
    rReleaseRentHouseHomeActionTypeHouseStatus,         //!<房屋状态
    rReleaseRentHouseHomeActionTypePayTime,             //!<支付时间
    rReleaseRentHouseHomeActionTypeRentProperty,        //!<出租方式
    
}RELEASE_RENT_HOUSE_HOME_ACTIONTYPE;

@interface QSYReleaseRentHouseViewController () <UITextFieldDelegate>

///出租房发布信息数据模型
@property (nonatomic,retain) QSReleaseRentHouseDataModel *rentHouseReleaseModel;

@property (nonatomic,strong) QSScrollView *pickedRootView;
@property (nonatomic,unsafe_unretained) UITextField *districtField;
@property (nonatomic,unsafe_unretained) UITextField *streetField;
@property (nonatomic,unsafe_unretained) UITextField *detailAddressField;
@property (nonatomic,unsafe_unretained) UITextField *rentPriceField;
@property (nonatomic,unsafe_unretained) UITextField *areaField;

@end

@implementation QSYReleaseRentHouseViewController

#pragma mark - 初始化
///初始化
- (instancetype)init
{
    
    ///初始化发布数据模型
    QSReleaseRentHouseDataModel *tempModel = [[QSReleaseRentHouseDataModel alloc] init];
    tempModel.propertyStatus = rReleasePropertyStatusNew;
    return [self initWithRentHouseModel:tempModel];
    
}

/**
 *  @author         yangshengmeng, 15-04-16 17:04:27
 *
 *  @brief          根据原有的物业信息，重新修改物业
 *
 *  @param model    物业数据类型
 *
 *  @return         返回当前创建的发布物业窗口
 *
 *  @since          1.0.0
 */
- (instancetype)initWithRentHouseModel:(QSReleaseRentHouseDataModel *)model
{

    if (self = [super init]) {
        
        ///初始化发布数据模型
        self.rentHouseReleaseModel = model;
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"发布出租物业"];
    
}

- (void)createMainShowUI
{
    
    ///过滤条件的底view
    self.pickedRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f - 25.0f)];
    [self createSettingInputUI:self.pickedRootView];
    [self.view addSubview:self.pickedRootView];
    
    ///分隔线
    UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.pickedRootView.frame.origin.y + self.pickedRootView.frame.size.height, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLineLabel];
    
    ///底部确定按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"下一步";
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///校验数据
        if ([self checkInputData]) {
            
            QSYReleaseRentHouseAddinfoViewController *addinfoVC = [[QSYReleaseRentHouseAddinfoViewController alloc] initWithRentHouseModel:self.rentHouseReleaseModel];
            [self.navigationController pushViewController:addinfoVC animated:YES];
            
        }
        
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
    
    ///判断是否可滚动：超出高度则设置滚动
    if ((([tempInfoArray count] * (44.0f + 8.0f)) + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP) > view.frame.size.height) {
        
        view.contentSize = CGSizeMake(view.frame.size.width, (([tempInfoArray count] * (44.0f + 8.0f)) + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP) + 20.0f);
        
    }
    
}

#pragma mark - 创建右剪头控件
///创建右剪头控件
- (UIView *)createRightArrowSubviewWithViewInfo:(NSDictionary *)tempDict
{
    
    NSString *orderString = [tempDict valueForKey:@"order"];
    int index = [orderString intValue];
    
    ///显示信息栏
    UITextField *tempTextField = [UITextField
                                  createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 8.0f + index * (8.0f + 44.0f), SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f)
                                  andPlaceHolder:[tempDict valueForKey:@"placehold"]
                                  andLeftTipsInfo:[tempDict valueForKey:@"left_title"]
                                  andRightTipsInfo:[tempDict valueForKey:@"right_title"]
                                  andLeftTipsTextAlignment:NSTextAlignmentCenter
                                  andTextFieldStyle:[[tempDict valueForKey:@"type"] intValue]];
    tempTextField.font = [UIFont systemFontOfSize:FONT_BODY_16];
    tempTextField.delegate = self;
    [tempTextField setValue:[tempDict valueForKey:@"action_type"] forKey:@"customFlag"];
    NSString *filterInfo = [self.rentHouseReleaseModel valueForKey:[tempDict valueForKey:@"filter_key"]];
    if ([filterInfo length] > 0) {
        
        tempTextField.text = filterInfo;
        
    }
    
    ///保存地区和街道
    if (rReleaseRentHouseHomeActionTypeDistrice == [[tempDict valueForKey:@"action_type"] intValue]) {
        
        self.districtField = tempTextField;
        
    }
    
    if (rReleaseRentHouseHomeActionTypeStreet == [[tempDict valueForKey:@"action_type"] intValue]) {
        
        self.streetField = tempTextField;
        
    }
    
    if (rReleaseRentHouseHomeActionTypeAddress == [[tempDict valueForKey:@"action_type"] intValue]) {
        
        self.detailAddressField = tempTextField;
        
    }
    
    ///保存租金
    if (rReleaseRentHouseHomeActionTypeRentPrice == [[tempDict valueForKey:@"action_type"] intValue]) {
        
        self.rentPriceField = tempTextField;
        
    }
    
    if (rReleaseRentHouseHomeActionTypeArea == [[tempDict valueForKey:@"action_type"] intValue]) {
        
        self.areaField = tempTextField;
        
    }
    
    return tempTextField;
    
}

#pragma mark - 校验数据
- (BOOL)checkInputData
{

    if ([self.rentHouseReleaseModel.districtKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择区域", 1.0f, ^(){})
        return NO;
        
    }
    
    if ([self.rentHouseReleaseModel.streetKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择区域", 1.0f, ^(){})
        return NO;
        
    }
    
    if ([self.rentHouseReleaseModel.community length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择小区", 1.0f, ^(){})
        return NO;
        
    }
    
    if ([self.detailAddressField.text length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请填写详细地址", 1.0f, ^(){})
        [self.detailAddressField becomeFirstResponder];
        return NO;
        
    } else {
    
        self.rentHouseReleaseModel.address = self.detailAddressField.text;
    
    }
    
    ///回收地址输入框的键盘
    [self.detailAddressField resignFirstResponder];
    
    if ([self.rentHouseReleaseModel.houseTypeKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择户型", 1.0f, ^(){})
        return NO;
        
    }
    
    if ([self.areaField.text length] <= 0 ||
        [self.rentHouseReleaseModel.areaKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请填写面积", 1.0f, ^(){})
        [self.areaField becomeFirstResponder];
        return NO;
        
    } else {
    
        [self.areaField resignFirstResponder];
        self.rentHouseReleaseModel.areaKey = self.rentPriceField.text;
        self.rentHouseReleaseModel.area = self.rentPriceField.text;
    
    }
    
    if ([self.rentPriceField.text length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请填写租金", 1.0f, ^(){})
        [self.rentPriceField becomeFirstResponder];
        return NO;
        
    } else {
    
        [self.rentPriceField resignFirstResponder];
        self.rentHouseReleaseModel.rentPriceKey = self.rentPriceField.text;
        self.rentHouseReleaseModel.rentPrice = self.rentPriceField.text;
    
    }
    
    ///回收租金键盘
    [self.rentPriceField resignFirstResponder];
    
    if ([self.rentHouseReleaseModel.rentPaytypeKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择支付方式", 1.0f, ^(){})
        return NO;
        
    }
    
    if ([self.rentHouseReleaseModel.whetherBargainingKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择是否议", 1.0f, ^(){})
        return NO;
        
    }
    
    if ([self.rentHouseReleaseModel.houseStatusKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择房屋状态", 1.0f, ^(){})
        return NO;
        
    }
    
    if ([self.rentHouseReleaseModel.leadTimeKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择交付时间", 1.0f, ^(){})
        return NO;
        
    }
    
    if ([self.rentHouseReleaseModel.rentTypeKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择出租方式", 1.0f, ^(){})
        return NO;
        
    }
    
    return YES;

}

#pragma mark - 点击textField时的事件：不进入编辑模式，只跳转
///点击textField时的事件：不进入编辑模式，只跳转
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if ([self.detailAddressField isFirstResponder]) {
        
        return NO;
        
    }
    
    if ([self.rentPriceField isFirstResponder]) {
        
        return NO;
        
    }
    
    if ([self.areaField isFirstResponder]) {
        
        return NO;
        
    }
    
    ///分发事件
    int actionType = [[textField valueForKey:@"customFlag"] intValue];
    
    switch (actionType) {
            
            ///地区和街道选择
        case rReleaseRentHouseHomeActionTypeDistrice:
            
        case rReleaseRentHouseHomeActionTypeStreet:
        {
        
            ///回收详细地址弹出的键盘
            [self.detailAddressField resignFirstResponder];
            [self.rentPriceField resignFirstResponder];
            
            [QSCustomDistrictSelectedPopView showCustomDistrictSelectedPopviewWithSteetSelectedKey:([self.rentHouseReleaseModel.streetKey length] > 0 ? self.rentHouseReleaseModel.streetKey : nil) andDistrictPickeredCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                ///判断选择
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    ///查找区模型
                    QSBaseConfigurationDataModel *districtModel = [QSCoreDataManager getDistrictModelWithStreetKey:tempModel.key];
                    
                    ///显示当前位置信息
                    self.districtField.text = districtModel.val;
                    self.streetField.text = tempModel.val;
                    self.rentHouseReleaseModel.district = districtModel.val;
                    self.rentHouseReleaseModel.districtKey = districtModel.key;
                    self.rentHouseReleaseModel.street = [QSCoreDataManager getStreetValWithStreetKey:tempModel.key];
                    self.rentHouseReleaseModel.streetKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    ///显示当前位置信息
                    self.districtField.text = nil;
                    self.streetField.text = nil;
                    self.rentHouseReleaseModel.district = nil;
                    self.rentHouseReleaseModel.districtKey = nil;
                    self.rentHouseReleaseModel.street = nil;
                    self.rentHouseReleaseModel.streetKey = nil;
                    
                }
                
            }];
            
            return NO;
        
        }
            break;
            
            ///小区名
        case rReleaseRentHouseHomeActionTypeCommunity:
        {
            
            ///回收详细地址弹出的键盘
            [self.detailAddressField resignFirstResponder];
            [self.rentPriceField resignFirstResponder];
            
            QSYReleasePickCommunityViewController *pickCommunityVC = [[QSYReleasePickCommunityViewController alloc] initWithPickedCallBack:^(BOOL flag, id pickModel) {
                
                ///已选择小区
                if (flag) {
                    
                    ///保存选择的小区信息
                    QSCommunityDataModel *pickCommunity = pickModel;
                    
                    ///显示信息
                    textField.text = pickCommunity.title;
                    
                    ///保存小区
                    self.rentHouseReleaseModel.community = pickCommunity.title;
                    self.rentHouseReleaseModel.communityKey = pickCommunity.id_;
                    
                }
                
            }];
            [self.navigationController pushViewController:pickCommunityVC animated:YES];
            return NO;
            
        }
            break;
            
            ///详细地址
        case rReleaseRentHouseHomeActionTypeAddress:
        {
            
            textField.returnKeyType = UIReturnKeyDone;
            return YES;
            
        }
            
            ///户型
        case rReleaseRentHouseHomeActionTypeHouseType:
        {
            
            ///回收详细地址弹出的键盘
            [self.detailAddressField resignFirstResponder];
            [self.rentPriceField resignFirstResponder];
            
            ///获取户型的数据
            NSArray *intentArray = [QSCoreDataManager getHouseType];
            
            ///显示户型的选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.rentHouseReleaseModel.houseTypeKey length] > 0 ? self.rentHouseReleaseModel.houseTypeKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.rentHouseReleaseModel.houseType = tempModel.val;
                    self.rentHouseReleaseModel.houseTypeKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    ///取消户型信息
                    textField.text = nil;
                    self.rentHouseReleaseModel.houseType = nil;
                    self.rentHouseReleaseModel.houseTypeKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///面积
        case rReleaseRentHouseHomeActionTypeArea:
            
            ///租金
        case rReleaseRentHouseHomeActionTypeRentPrice:
        {
            
            ///回收详细地址弹出的键盘
            textField.returnKeyType = UIReturnKeyDone;
            return YES;
            
        }
            break;
            
            ///租金支付方式
        case rReleaseRentHouseHomeActionTypeRentPayType:
        {
            
            ///回收详细地址弹出的键盘
            [self.detailAddressField resignFirstResponder];
            [self.rentPriceField resignFirstResponder];
            
            ///获取租金支付方式的数据
            NSArray *intentArray = [QSCoreDataManager getHouseRentPayType];
            
            ///显示房子租金支付方式选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.rentHouseReleaseModel.rentPaytypeKey length] > 0 ? self.rentHouseReleaseModel.rentPaytypeKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.rentHouseReleaseModel.rentPaytype = tempModel.val;
                    self.rentHouseReleaseModel.rentPaytypeKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.rentHouseReleaseModel.rentPaytype = nil;
                    self.rentHouseReleaseModel.rentPaytypeKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///是否议价
        case rReleaseRentHouseHomeActionTypeWhetherBargaining:
        {
            
            ///回收详细地址弹出的键盘
            [self.detailAddressField resignFirstResponder];
            [self.rentPriceField resignFirstResponder];
            
            ///获取是否议价选择项数组
            NSArray *intentArray = [QSCoreDataManager getHouseIsNegotiatedPriceType];
            
            ///显示是否议价选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.rentHouseReleaseModel.whetherBargainingKey length] > 0 ? self.rentHouseReleaseModel.whetherBargainingKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.rentHouseReleaseModel.whetherBargaining = tempModel.val;
                    self.rentHouseReleaseModel.whetherBargainingKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.rentHouseReleaseModel.whetherBargaining = nil;
                    self.rentHouseReleaseModel.whetherBargainingKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///房屋状态
        case rReleaseRentHouseHomeActionTypeHouseStatus:
        {
            
            ///回收详细地址弹出的键盘
            [self.detailAddressField resignFirstResponder];
            [self.rentPriceField resignFirstResponder];
            
            ///获取房屋状态选择项数组
            NSArray *intentArray = [QSCoreDataManager getRentHouseStatusTypes];
            
            ///显示房屋状态选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.rentHouseReleaseModel.houseStatusKey length] > 0 ? self.rentHouseReleaseModel.houseStatusKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.rentHouseReleaseModel.houseStatus = tempModel.val;
                    self.rentHouseReleaseModel.houseStatusKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.rentHouseReleaseModel.houseStatus = nil;
                    self.rentHouseReleaseModel.houseStatusKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///交付时间
        case rReleaseRentHouseHomeActionTypePayTime:
        {
            
            ///回收详细地址弹出的键盘
            [self.detailAddressField resignFirstResponder];
            [self.rentPriceField resignFirstResponder];
            
            ///获取交付时间可选择项
            NSArray *intentArray = [QSCoreDataManager getRentHouseLeadTimeTyps];
            
            ///显示交付时间选择项选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.rentHouseReleaseModel.leadTimeKey length] > 0 ? self.rentHouseReleaseModel.leadTimeKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.rentHouseReleaseModel.leadTime = tempModel.val;
                    self.rentHouseReleaseModel.leadTimeKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.rentHouseReleaseModel.leadTime = nil;
                    self.rentHouseReleaseModel.leadTimeKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///出租方式
        case rReleaseRentHouseHomeActionTypeRentProperty:
        {
            
            ///回收详细地址弹出的键盘
            [self.detailAddressField resignFirstResponder];
            [self.rentPriceField resignFirstResponder];
            
            ///获取出租方式选择项数组
            NSArray *intentArray = [QSCoreDataManager getHouseRentType];
            
            ///显示出租方式选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.rentHouseReleaseModel.rentTypeKey length] > 0 ? self.rentHouseReleaseModel.rentTypeKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.rentHouseReleaseModel.rentType = tempModel.val;
                    self.rentHouseReleaseModel.rentTypeKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.rentHouseReleaseModel.rentType = nil;
                    self.rentHouseReleaseModel.rentTypeKey = nil;
                    
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
    
    NSString *infoFileName = PLIST_FILE_NAME_RELEASE_RENTHOUSE;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self.districtField resignFirstResponder];
    [self.streetField resignFirstResponder];
    [self.detailAddressField resignFirstResponder];
    [self.rentPriceField resignFirstResponder];
    [self.areaField resignFirstResponder];

}

#pragma mark - 详细地址编辑完成后保存地址信息
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    ///详细地址输入框
    int actionType = [[textField valueForKey:@"customFlag"] intValue];
    if (rReleaseRentHouseHomeActionTypeAddress == actionType) {
        
        NSString *inputString = textField.text;
        if ([inputString length] > 0) {
            
            self.rentHouseReleaseModel.address = inputString;
            
        } else {
            
            self.rentHouseReleaseModel.address = nil;
            
        }
        
    }
    
    if (rReleaseRentHouseHomeActionTypeRentPrice == actionType) {
        
        NSString *inputString = textField.text;
        if ([inputString length] > 0) {
            
            self.rentHouseReleaseModel.rentPrice = inputString;
            self.rentHouseReleaseModel.rentPriceKey = inputString;
            
        } else {
            
            self.rentHouseReleaseModel.rentPrice = nil;
            self.rentHouseReleaseModel.rentPriceKey = nil;
            
        }
        
    }
    
    if (rReleaseRentHouseHomeActionTypeArea == actionType) {
        
        NSString *inputString = textField.text;
        if ([inputString length] > 0) {
            
            self.rentHouseReleaseModel.area = inputString;
            self.rentHouseReleaseModel.areaKey = inputString;
            
        } else {
            
            self.rentHouseReleaseModel.area = nil;
            self.rentHouseReleaseModel.areaKey = nil;
            
        }
        
    }
    
}

#pragma mark - 重写返回事件
///重写返回事件，返回时，提示清空发布信息
- (void)gotoTurnBackAction
{
    
    TIPS_ALERT_MESSAGE_CONFIRMBUTTON(nil,@"返回将会清空发布出租物业所填写的信息",@"取消",@"确认",^(int buttonIndex) {
        
        ///判断按钮事件:0取消
        if (0 < buttonIndex) {
            
            [super gotoTurnBackAction];
            
        }
        
    })
    
}

@end
