//
//  QSYSearchHousesViewController.m
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSearchHousesViewController.h"
#import "QSWHousesMapDistributionViewController.h"

#import "QSCustomPickerView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSCoreDataManager+House.h"

@interface QSYSearchHousesViewController () <UITextFieldDelegate>

@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;    //!<房源类型
@property (nonatomic,copy) NSString *searchKey;             //!<搜索关键字

///导航栏选择器
@property (nonatomic,strong) QSCustomPickerView *houseTypePicker;

@end

@implementation QSYSearchHousesViewController

#pragma mark - 初始化
- (instancetype)initWithHouseType:(FILTER_MAIN_TYPE)houseType andSearchKey:(NSString *)searchKey;
{

    if (self = [super init]) {
        
        ///保存参数
        self.houseType = houseType;
        self.searchKey = searchKey;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    ///指针
    __block UITextField *seachTextField;
    
    ///中间选择列表类型按钮
    QSBaseConfigurationDataModel *tempModel = [QSCoreDataManager getHouseListMainTypeModelWithID:[NSString stringWithFormat:@"%d",self.houseType]];
    self.houseTypePicker = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(5.0f, 22.0f, 80.0f, 40.0f) andPickerType:cCustomPickerTypeNavigationBarHouseMainType andPickerViewStyle:cCustomPickerStyleLeftArrow andCurrentSelectedModel:tempModel andIndicaterCenterXPoint:0.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *selectedKey, NSString *selectedVal) {
        
        ///弹出时，回收键盘
        if (pPickerCallBackActionTypeShow == callBackType) {
            
            [seachTextField resignFirstResponder];
            
        }
        
        ///选择不同的列表类型，事件处理
        if (pPickerCallBackActionTypePicked == callBackType) {
            
            ///保存类型
            self.houseType = [selectedKey intValue];
            
        }
        
    }];
    [self.view addSubview:self.houseTypePicker];
    
    ///创建导航栏搜索输入框
    seachTextField = [[UITextField alloc]initWithFrame:CGRectMake(self.houseTypePicker.frame.origin.x +  self.houseTypePicker.frame.size.width + 8.0f, 27.0f, SIZE_DEVICE_WIDTH - self.houseTypePicker.frame.size.width - 44.0f - 15.0f, 30.0f)];
    seachTextField.backgroundColor = [UIColor whiteColor];
    seachTextField.placeholder = [NSString stringWithFormat:@"请输入小区名称或地址"];
    seachTextField.font = [UIFont systemFontOfSize:14.0f];
    seachTextField.borderStyle = UITextBorderStyleRoundedRect;
    seachTextField.returnKeyType = UIReturnKeySearch;
    seachTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    seachTextField.delegate = self;
    [self.view addSubview:seachTextField];
    
    ///地图列表
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeLeft andButtonType:nNavigationBarButtonTypeMapList];
    
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 44.0f, 20.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        QSWHousesMapDistributionViewController *mapHouseListVC = [[QSWHousesMapDistributionViewController alloc] init];
        [self.navigationController pushViewController:mapHouseListVC animated:YES];
        
    }];
    [self.view addSubview:cancelButton];
    
    ///分隔线
    UILabel *sepLine = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 64.0f - 0.25f, SIZE_DEVICE_WIDTH, 0.25f)];
    sepLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLine];

}

@end
