//
//  QSYReleaseRentHouseAddinfoViewController.m
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseRentHouseAddinfoViewController.h"
#import "QSYReleaseRentHouseImageViewController.h"

#import "QSCustomSingleSelectedPopView.h"
#import "QSMultipleSelectedPopView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"

#import "QSCoreDataManager+House.h"

#import "QSReleaseRentHouseDataModel.h"
#import "QSBaseConfigurationDataModel.h"

///事件的类型
typedef enum
{
    
    rReleaseRentHouseAddinfoActionTypeLimited = 10,     //!<限制
    rReleaseRentHouseAddinfoActionTypeFloor,            //!<楼层
    rReleaseRentHouseAddinfoActionTypeFace,             //!<朝向
    rReleaseRentHouseAddinfoActionTypeDecoration,       //!<装修
    rReleaseRentHouseAddinfoActionTypeInstallation,     //!<配套
    rReleaseRentHouseAddinfoActionTypeFee,              //!<物业管理费
    
}RELEASE_RENT_HOUSE_ADDINFO_ACTIONTYPE;

@interface QSYReleaseRentHouseAddinfoViewController () <UITextFieldDelegate>

///发布出租房时的暂存模型
@property (nonatomic,retain) QSReleaseRentHouseDataModel *rentHouseReleaseModel;

@property (nonatomic,unsafe_unretained) UITextField *feeField;//!<物业管理费输入框

@end

@implementation QSYReleaseRentHouseAddinfoViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-03-26 09:03:39
 *
 *  @brief              创建发布出租物业时的附加信息填写窗口
 *
 *  @param saleModel    发布出租物业时的填写数据模型
 *
 *  @return             返回当前创建的附加信息窗口
 *
 *  @since              1.0.0
 */
- (instancetype)initWithRentHouseModel:(QSReleaseRentHouseDataModel *)model
{

    if (self = [super init]) {
        
        ///保存数据模型
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
        
        ///进入图片视频标题等设置页面
        QSYReleaseRentHouseImageViewController *addinfoVC = [[QSYReleaseRentHouseImageViewController alloc] initWithRentHouseModel:self.rentHouseReleaseModel];
        [self.navigationController pushViewController:addinfoVC animated:YES];
        
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
    if (rReleaseRentHouseAddinfoActionTypeFee == [[tempDict valueForKey:@"action_type"] intValue]) {
        
        self.feeField = tempTextField;
        
    }
    
    return tempTextField;
    
}

#pragma mark - 点击textField时的事件：不进入编辑模式，只跳转
///点击textField时的事件：不进入编辑模式，只跳转
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if ([self.feeField isFirstResponder]) {
        
        return NO;
        
    }
    
    ///分发事件
    int actionType = [[textField valueForKey:@"customFlag"] intValue];
    
    switch (actionType) {
            
            ///限制
        case rReleaseRentHouseAddinfoActionTypeLimited:
        {
            
            ///获取限制的数据
            NSArray *intentArray = [QSCoreDataManager getRentHouseLimitedTypes];
            
            ///显示限制选择窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.rentHouseReleaseModel.limitedKey length] > 0 ? self.rentHouseReleaseModel.limitedKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.rentHouseReleaseModel.limited = tempModel.val;
                    self.rentHouseReleaseModel.limitedKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.rentHouseReleaseModel.limitedKey = nil;
                    self.rentHouseReleaseModel.limitedKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///楼层
        case rReleaseRentHouseAddinfoActionTypeFloor:
        {
            
            ///获取楼层选择项数组
            NSArray *intentArray = [QSCoreDataManager getHouseFloorType];
            
            ///显示楼层选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.rentHouseReleaseModel.floorKey length] > 0 ? self.rentHouseReleaseModel.floorKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.rentHouseReleaseModel.floor = tempModel.val;
                    self.rentHouseReleaseModel.floorKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.rentHouseReleaseModel.floor = nil;
                    self.rentHouseReleaseModel.floorKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///朝向
        case rReleaseRentHouseAddinfoActionTypeFace:
        {
            
            ///获取朝向选择项数组
            NSArray *intentArray = [QSCoreDataManager getHouseFaceType];
            
            ///显示朝向选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.rentHouseReleaseModel.faceKey length] > 0 ? self.rentHouseReleaseModel.faceKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.rentHouseReleaseModel.face = tempModel.val;
                    self.rentHouseReleaseModel.faceKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.rentHouseReleaseModel.face = nil;
                    self.rentHouseReleaseModel.faceKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///装修
        case rReleaseRentHouseAddinfoActionTypeDecoration:
        {
            
            ///获取装修选择项数组
            NSArray *intentArray = [QSCoreDataManager getHouseDecorationType];
            
            ///显示装修选择项窗口
            [QSCustomSingleSelectedPopView showSingleSelectedViewWithDataSource:intentArray andCurrentSelectedKey:([self.rentHouseReleaseModel.decorationKey length] > 0 ? self.rentHouseReleaseModel.decorationKey : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeSingleSelected == actionType) {
                    
                    ///转模型
                    QSBaseConfigurationDataModel *tempModel = params;
                    
                    textField.text = tempModel.val;
                    self.rentHouseReleaseModel.decoration = tempModel.val;
                    self.rentHouseReleaseModel.decorationKey = tempModel.key;
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    textField.text = nil;
                    self.rentHouseReleaseModel.decoration = nil;
                    self.rentHouseReleaseModel.decorationKey = nil;
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///配套
        case rReleaseRentHouseAddinfoActionTypeInstallation:
        {
            
            ///获取配套选择项数组
            NSArray *intentArray = [QSCoreDataManager getHouseInstallationTypes:fFilterMainTypeRentalHouse];
            
            ///显示配套选择项窗口
            [QSMultipleSelectedPopView showMultipleSelectedViewWithDataSource:intentArray andSelectedSource:([self.rentHouseReleaseModel.installationList count] > 0 ? self.rentHouseReleaseModel.installationList : nil) andSelectedCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
                if (cCustomPopviewActionTypeMultipleSelected == actionType) {
                    
                    if ([params count] > 0) {
                        
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
                        self.rentHouseReleaseModel.installationString = showString;
                        [self.rentHouseReleaseModel.installationList removeAllObjects];
                        [self.rentHouseReleaseModel.installationList addObjectsFromArray:params];
                        
                    } else {
                    
                        textField.text = nil;
                        self.rentHouseReleaseModel.installationString = nil;
                        [self.rentHouseReleaseModel.installationList removeAllObjects];
                    
                    }
                    
                } else if (cCustomPopviewActionTypeUnLimited == actionType) {
                    
                    ///拼装显示信息
                    NSMutableString *showString = [[NSMutableString alloc] init];
                    for (int i = 0;i < [intentArray count];i++) {
                        
                        QSBaseConfigurationDataModel *tempModel = intentArray[i];
                        
                        ///非第一个元素时，添加逗号
                        if (i != 0) {
                            
                            [showString appendString:@","];
                            
                        }
                        
                        [showString appendString:tempModel.val];
                        
                    }
                    
                    textField.text = showString;
                    self.rentHouseReleaseModel.installationString = showString;
                    [self.rentHouseReleaseModel.installationList removeAllObjects];
                    [self.rentHouseReleaseModel.installationList addObjectsFromArray:intentArray];
                    
                }
                
            }];
            
            return NO;
            
        }
            break;
            
            ///物业管理费
        case rReleaseRentHouseAddinfoActionTypeFee:
        {
        
            textField.returnKeyType = UIReturnKeyDone;
            return YES;
        
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
    
    NSString *infoFileName = PLIST_FILE_NAME_RELEASE_RENTHOUSE_ADD;
    ///配置信息文件路径
    NSString *infoPath = [[NSBundle mainBundle] pathForResource:infoFileName ofType:PLIST_FILE_TYPE];
    return [NSDictionary dictionaryWithContentsOfFile:infoPath];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

    int actionType = [[textField valueForKey:@"customFlag"] intValue];
    if (rReleaseRentHouseAddinfoActionTypeFee == actionType &&
        [textField.text length] > 0) {
        
        self.rentHouseReleaseModel.fee = textField.text;
        self.rentHouseReleaseModel.feeKey = textField.text;
        
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;

}

@end
