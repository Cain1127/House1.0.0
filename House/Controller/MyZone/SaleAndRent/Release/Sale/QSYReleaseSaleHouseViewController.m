//
//  QSYReleaseSaleHouseViewController.m
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseSaleHouseViewController.h"
#import "QSYReleasePickCommunityViewController.h"
#import "QSYReleaseSaleHouseAddInfoViewController.h"

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
@property (nonatomic,strong) QSScrollView *pickedRootView;

@property (nonatomic,unsafe_unretained) UITextField *districtField;
@property (nonatomic,unsafe_unretained) UITextField *streetField;
@property (nonatomic,unsafe_unretained) UITextField *detailAddressField;
@property (nonatomic,unsafe_unretained) UITextField *SalePriceField;

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
            
            ///进入第二页
            QSYReleaseSaleHouseAddInfoViewController *addInfoVC = [[QSYReleaseSaleHouseAddInfoViewController alloc] initWithSaleModel:self.saleHouseReleaseModel];
            [self.navigationController pushViewController:addInfoVC animated:YES];
            
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
    
    ///注册键盘弹出监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarHideAction:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - 键盘弹出和回收
- (void)keyboarShowAction:(NSNotification *)sender
{

    //上移：需要知道键盘高度和移动时间
    CGRect keyBoardRect = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval anTime;
    [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
    CGRect frame = CGRectMake(self.pickedRootView.frame.origin.x,
                              64.0f - keyBoardRect.size.height,
                              self.pickedRootView.frame.size.width,
                              self.pickedRootView.frame.size.height);
    [UIView animateWithDuration:anTime animations:^{
        
        self.pickedRootView.frame = frame;
        
    }];

}

- (void)keyboarHideAction:(NSNotification *)sender
{

    NSTimeInterval anTime;
    [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
    CGRect frame = CGRectMake(self.pickedRootView.frame.origin.x,
                              64.0f,
                              self.pickedRootView.frame.size.width,
                              self.pickedRootView.frame.size.height);
    [UIView animateWithDuration:anTime animations:^{
        
        self.pickedRootView.frame = frame;
        
    }];

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
    
    ///保存地区和街道
    if (rReleaseSaleHouseHomeActionTypeDistrice == [[tempDict valueForKey:@"action_type"] intValue]) {
        
        self.districtField = tempTextField;
        
    }
    
    if (rReleaseSaleHouseHomeActionTypeStreet == [[tempDict valueForKey:@"action_type"] intValue]) {
        
        self.streetField = tempTextField;
        
    }
    
    if (rReleaseSaleHouseHomeActionTypeDetailAddress == [[tempDict valueForKey:@"action_type"] intValue]) {
        
        self.detailAddressField = tempTextField;
        
    }
    
    if (rReleaseSaleHouseHomeActionTypeSalePrice == [[tempDict valueForKey:@"action_type"] intValue]) {
        
        self.SalePriceField = tempTextField;
        
    }
    
    return tempTextField;
    
}

#pragma mark - 校验数据
///校验数据
- (BOOL)checkInputData
{

    ///物业类型
    if ([self.saleHouseReleaseModel.trandType length] <= 0 ||
        [self.saleHouseReleaseModel.trandTypeKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择物业类型", 1.0f, ^(){})
        return NO;
        
    }
    
    ///区域信息
    if ([self.saleHouseReleaseModel.district length] <= 0 ||
        [self.saleHouseReleaseModel.districtKey length] <= 0 ||
        [self.saleHouseReleaseModel.street length] <= 0 ||
        [self.saleHouseReleaseModel.streetKey length] <= 0) {
        
        ///提示
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择区域信息", 1.0f, ^(){})
        
        return NO;
        
    }
    
    ///小区名
    if ([self.saleHouseReleaseModel.community length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请填写小区名称", 1.0, ^(){})
        
        return NO;
        
    }
    
    ///详细地址
    if ([self.detailAddressField.text length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请填写详细地址", 1.0, ^(){})
        [self.detailAddressField becomeFirstResponder];
        return NO;
        
    } else {
    
        [self.detailAddressField resignFirstResponder];
        self.saleHouseReleaseModel.address = self.detailAddressField.text;
    
    }
    
    ///户型
    if ([self.saleHouseReleaseModel.houseType length] <= 0 ||
        [self.saleHouseReleaseModel.houseTypeKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择户型", 1.0, ^(){})
        
        return NO;
        
    }
    
    ///面积
    if ([self.saleHouseReleaseModel.area length] <= 0 ||
        [self.saleHouseReleaseModel.areaKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择面积", 1.0, ^(){})
        return NO;
        
    }
    
    ///售价
    if ([self.SalePriceField.text length] <= 0 ||
        [self.saleHouseReleaseModel.salePriceKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择售价", 1.0, ^(){})
        [self.SalePriceField becomeFirstResponder];
        return NO;
        
    } else {
    
        [self.SalePriceField resignFirstResponder];
        self.saleHouseReleaseModel.salePrice = self.SalePriceField.text;
        self.saleHouseReleaseModel.salePriceKey = self.SalePriceField.text;
    
    }
    
    ///是否议价
    if ([self.saleHouseReleaseModel.negotiatedPrice length] <= 0 ||
        [self.saleHouseReleaseModel.negotiatedPriceKey length] <= 0) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择是否议价", 1.0, ^(){})
        return NO;
        
    }
    
    return YES;

}

#pragma mark - 点击textField时的事件：不进入编辑模式，只跳转
///点击textField时的事件：不进入编辑模式，只跳转
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    ///分发事件
    int actionType = [[textField valueForKey:@"customFlag"] intValue];
    
    switch (actionType) {
            
            ///物业类型
        case rReleaseSaleHouseHomeActionTypeTradeType:
        {
            
            ///回收详细地址弹出的键盘
            [self.detailAddressField resignFirstResponder];
            [self.SalePriceField resignFirstResponder];
            
            ///获取房子的物业类型选择项数据
            NSArray *intentArray = [QSCoreDataManager getHouseTradeType];
            
            ///显示房子的物业类型选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.saleHouseReleaseModel.trandTypeKey length] > 0 ? self.saleHouseReleaseModel.trandTypeKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.saleHouseReleaseModel.trandType = tempModel.val;
                    self.saleHouseReleaseModel.trandTypeKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.saleHouseReleaseModel.trandType = nil;
                    self.saleHouseReleaseModel.trandTypeKey = nil;
                    
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
            [self.detailAddressField resignFirstResponder];
            [self.SalePriceField resignFirstResponder];
            
            [QSCustomDistrictSelectedPopView showCustomDistrictSelectedPopviewWithSteetSelectedKey:([self.saleHouseReleaseModel.streetKey length] > 0 ? self.saleHouseReleaseModel.streetKey : nil) andDistrictPickeredCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                ///判断选择
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    ///查找区模型
                    QSBaseConfigurationDataModel *districtModel = [QSCoreDataManager getDistrictModelWithStreetKey:tempModel.key];
                    
                    ///显示当前位置信息
                    self.districtField.text = districtModel.val;
                    self.streetField.text = tempModel.val;
                    self.saleHouseReleaseModel.district = districtModel.val;
                    self.saleHouseReleaseModel.districtKey = districtModel.key;
                    self.saleHouseReleaseModel.street = [QSCoreDataManager getStreetValWithStreetKey:tempModel.key];
                    self.saleHouseReleaseModel.streetKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    ///显示当前位置信息
                    self.districtField.text = nil;
                    self.streetField.text = nil;
                    self.saleHouseReleaseModel.district = nil;
                    self.saleHouseReleaseModel.districtKey = nil;
                    self.saleHouseReleaseModel.street = nil;
                    self.saleHouseReleaseModel.streetKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///小区名
        case rReleaseSaleHouseHomeActionTypeCommunityName:
        {
            
            ///回收详细地址弹出的键盘
            [self.detailAddressField resignFirstResponder];
            [self.SalePriceField resignFirstResponder];
            
            QSYReleasePickCommunityViewController *pickCommunityVC = [[QSYReleasePickCommunityViewController alloc] initWithPickedCallBack:^(BOOL flag, id pickModel) {
                
                ///已选择小区
                if (flag) {
                    
                    ///保存选择的小区信息
                    QSCommunityDataModel *pickCommunity = pickModel;
                    
                    ///显示信息
                    textField.text = pickCommunity.title;
                    
                    ///保存小区
                    self.saleHouseReleaseModel.community = pickCommunity.title;
                    self.saleHouseReleaseModel.communityKey = pickCommunity.id_;
                    
                }
                
            }];
            [self.navigationController pushViewController:pickCommunityVC animated:YES];
            return NO;
            
        }
            break;
            
            ///详细地址
        case rReleaseSaleHouseHomeActionTypeDetailAddress:
        {
            
            textField.returnKeyType = UIReturnKeyDone;
            return YES;
            
        }
            break;
            
            ///户型
        case rReleaseSaleHouseHomeActionTypeHouseType:
        {
            
            ///回收详细地址弹出的键盘
            [self.detailAddressField resignFirstResponder];
            [self.SalePriceField resignFirstResponder];
            
            ///获取户型的数据
            NSArray *intentArray = [QSCoreDataManager getHouseType];
            
            ///显示户型的选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.saleHouseReleaseModel.houseTypeKey length] > 0 ? self.saleHouseReleaseModel.houseTypeKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.saleHouseReleaseModel.houseType = tempModel.val;
                    self.saleHouseReleaseModel.houseTypeKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    ///取消户型信息
                    textField.text = nil;
                    self.saleHouseReleaseModel.houseType = nil;
                    self.saleHouseReleaseModel.houseTypeKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///面积
        case rReleaseSaleHouseHomeActionTypeArea:
        {
            
            ///回收详细地址弹出的键盘
            [self.detailAddressField resignFirstResponder];
            [self.SalePriceField resignFirstResponder];
            
            ///获取房子面积的数据
            NSArray *intentArray = [QSCoreDataManager getHouseAreaType];
            
            ///显示房子面积选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.saleHouseReleaseModel.areaKey length] > 0 ? self.saleHouseReleaseModel.areaKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.saleHouseReleaseModel.area = tempModel.val;
                    self.saleHouseReleaseModel.areaKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.saleHouseReleaseModel.area = nil;
                    self.saleHouseReleaseModel.areaKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///售价
        case rReleaseSaleHouseHomeActionTypeSalePrice:
        {
            
            ///回收详细地址弹出的键盘
            textField.returnKeyType = UIReturnKeyDone;
            return YES;
            
        }
            break;
            
            ///是否议价
        case rReleaseSaleHouseHomeActionTypeIsprice:
        {
            
            ///回收详细地址弹出的键盘
            [self.detailAddressField resignFirstResponder];
            [self.SalePriceField resignFirstResponder];
            
            ///获取是否议价选择项数组
            NSArray *intentArray = [QSCoreDataManager getHouseIsNegotiatedPriceType];
            
            ///显示是否议价选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.saleHouseReleaseModel.negotiatedPriceKey length] > 0 ? self.saleHouseReleaseModel.negotiatedPriceKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.saleHouseReleaseModel.negotiatedPrice = tempModel.val;
                    self.saleHouseReleaseModel.negotiatedPriceKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.saleHouseReleaseModel.negotiatedPrice = nil;
                    self.saleHouseReleaseModel.negotiatedPriceKey = nil;
                    
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

#pragma mark - 详细地址编辑完成后保存地址信息
- (void)textFieldDidEndEditing:(UITextField *)textField
{

    ///详细地址输入框
    int actionType = [[textField valueForKey:@"customFlag"] intValue];
    if (rReleaseSaleHouseHomeActionTypeDetailAddress == actionType) {
        
        NSString *inputString = textField.text;
        if ([inputString length] > 0) {
            
            self.saleHouseReleaseModel.address = inputString;
            
        } else {
        
            self.saleHouseReleaseModel.address = nil;
        
        }
        
    }
    
    if (rReleaseSaleHouseHomeActionTypeSalePrice == actionType) {
        
        NSString *inputString = textField.text;
        if ([inputString length] > 0) {
            
            self.saleHouseReleaseModel.salePrice = [NSString stringWithFormat:@"%.2f",[inputString floatValue] * 10000];
            self.saleHouseReleaseModel.salePriceKey = [NSString stringWithFormat:@"%.2f",[inputString floatValue] * 10000];
            
        } else {
            
            self.saleHouseReleaseModel.address = nil;
            self.saleHouseReleaseModel.salePriceKey = nil;
            
        }
        
    }
    
}

#pragma mark - 重写返回事件
///重写返回事件，返回时，提示清空发布信息
- (void)gotoTurnBackAction
{

    
    TIPS_ALERT_MESSAGE_CONFIRMBUTTON(nil,@"返回将会清空发布出售物业所填写的信息",@"取消",@"确认",^(int buttonIndex) {
        
        ///判断按钮事件:0取消
        if (0 < buttonIndex) {
            
            [super gotoTurnBackAction];
            
        }
        
    })

}

@end
