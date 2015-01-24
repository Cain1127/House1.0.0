//
//  QSFilterViewController.m
//  House
//
//  Created by ysmeng on 15/1/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSFilterViewController.h"
#import "QSCoreDataManager+App.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+RightArrow.h"

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
    fFilterSettingFieldActionTypeHouseInstallation = 13     //!<配套：暖气...

}FILTER_SETTINGFIELD_ACTION_TYPE;

@interface QSFilterViewController ()<UITextFieldDelegate>

@property (nonatomic,assign) BOOL isSettingFilter;              //!<本地过滤器是否已配置标识:YES-已配置
@property (nonatomic,assign) APPLICATION_FILTER_TYPE filterType;//!<过滤器类型

@end

@implementation QSFilterViewController

#pragma mark - 初始化
- (instancetype)initWithFilterType:(APPLICATION_FILTER_TYPE)filterType
{

    if (self = [super init]) {
        
        ///获取过滤器是否已配置标识
        self.isSettingFilter = [QSCoreDataManager getLocalFilterSettingFlag];
        
        ///保存过滤器类型
        self.filterType = filterType;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    ///如果未配置过滤器，则不创建导航栏
    if (self.isSettingFilter) {
        
        [super createNavigationBarUI];
        
    }
    
}

- (void)createMainShowUI
{

    ///两种情况：已配置有过滤器时，存在导航栏，未配置时，是没有导航栏的
    if (self.isSettingFilter) {
        
        [self createUpdateFilterSettingPage];
        
    } else {
    
        [self createFirstSettingFilterPage];
    
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
    UIView *filterSettingRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, headerImageView.frame.size.height, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - headerImageView.frame.size.height)];
    [self createSettingInputUI:filterSettingRootView];
    [self.view addSubview:filterSettingRootView];
    
    ///看看运气如何按钮
    UIButton *commitFilterButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 54.0f, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:[QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow] andCallBack:^(UIButton *button) {
        
        
        
    }];
    [commitFilterButton setTitle:TITLE_FILTER_FIRSTSETTING_COMMITBUTTON forState:UIControlStateNormal];
    [self.view addSubview:commitFilterButton];

}

///搭建过滤器设置信息输入栏
- (void)createSettingInputUI:(UIView *)view
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
    NSDictionary *infoDict = [self getFilterSettingInfoWithType:self.filterType];
    
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
        UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempTextField.frame.origin.x, tempTextField.frame.origin.y + tempTextField.frame.size.height + 3.5f, tempTextField.frame.size.width, 0.5f)];
        sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [view addSubview:sepLineLabel];
        
    }

}

#pragma mark - 创建重新设置过滤器的页面
- (void)createUpdateFilterSettingPage
{

    

}

#pragma mark - 创建右剪头控制
- (UIView *)createRightArrowSubviewWithViewInfo:(NSDictionary *)tempDict
{

    NSString *orderString = [tempDict valueForKey:@"order"];
    int index = [orderString intValue];
    
    ///显示信息栏
    UITextField *tempTextField = [UITextField createRightArrowTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 8.0f + index * (8.0f + 44.0f), SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f)];
    tempTextField.font = [UIFont systemFontOfSize:FONT_BODY_16];
    tempTextField.delegate = self;
    [tempTextField setValue:[tempDict valueForKey:@"action_type"] forKey:@"customFlag"];
    
    ///右侧显示信息
    UILabel *leftLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 90.0f, 44.0f) andTopGap:2.0f andBottomGap:2.0f andLeftGap:2.0f andRightGap:20.0f];
    leftLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    leftLabel.text = [tempDict valueForKey:@"left_title"];
    leftLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    leftLabel.textAlignment = NSTextAlignmentCenter;
    
    tempTextField.leftViewMode = UITextFieldViewModeAlways;
    tempTextField.leftView = leftLabel;
    
    return tempTextField;

}

#pragma mark - 根据不同的类型返回对应的配置文件
- (NSDictionary *)getFilterSettingInfoWithType:(APPLICATION_FILTER_TYPE)filterType
{

    NSString *infoFileName = nil;
    
    switch (filterType) {
            
            ///二手房
        case applicationFileterTypeSecondHandHouse:
            
            infoFileName = PLIST_FILE_NAME_FILTER_FINDHOUSE_SECONDHOUSE;
            
            break;
            
            ///二手房
        case applicationFileterTypeRenantHouse:
            
            infoFileName = PLIST_FILE_NAME_FILTER_FINDHOUSE_RENANTHOUSE;
            
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
            
            NSLog(@"================区域选择==================");
            
            break;
            
            ///选择户型
        case fFilterSettingFieldActionTypeHouseType:
            
            NSLog(@"================户型选择==================");
            
            break;
            
            ///购房目的
        case fFilterSettingFieldActionTypePurposePurchase:
            
            NSLog(@"================购房目的选择==================");
            
            break;
            
            ///出售价格
        case fFilterSettingFieldActionTypeSalePrice:
            
            NSLog(@"================价格==================");
            
            break;
            
            ///房子面积
        case fFilterSettingFieldActionTypeArea:
            
            NSLog(@"================住房面积==================");
            
            break;
            
            ///出租方式：整租...
        case fFilterSettingFieldActionTypeRenantType:
            
            NSLog(@"================出租方式选择==================");
            
            break;
            
            ///租金
        case fFilterSettingFieldActionTypeRenantPrice:
            
            NSLog(@"================租金选择==================");
            
            break;
            
            ///租金支付方式：押二付一
        case fFilterSettingFieldActionTypeRenantPayType:
            
            NSLog(@"================租金支付方式选择==================");
            
            break;
            
            ///房子的物业类型：普通住宅...
        case fFilterSettingFieldActionTypeHouseTradeType:
            
            NSLog(@"================房子物业类型选择==================");
            
            break;
            
            ///房子的使用年限
        case fFilterSettingFieldActionTypeHouseUsedYear:
            
            NSLog(@"================使用选择==================");
            
            break;
            
            ///楼层
        case fFilterSettingFieldActionTypeHouseFloor:
            
            NSLog(@"================楼层选择==================");
            
            break;
            
            ///朝向：朝南...
        case fFilterSettingFieldActionTypeHouseOrientations:
            
            NSLog(@"================朝向选择==================");
            
            break;
            
            ///装修：精装修...
        case fFilterSettingFieldActionTypeHouseDecoration:
            
            NSLog(@"================装修选择==================");
            
            break;
            
            ///配套：暖气....
        case fFilterSettingFieldActionTypeHouseInstallation:
            
            NSLog(@"================配套选择==================");
            
            break;
            
        default:
            break;
    }
    
    return NO;

}

@end
