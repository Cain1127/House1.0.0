//
//  QSYReleaseRentHouseDateInfoViewController.m
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseRentHouseDateInfoViewController.h"
#import "QSYUserProtocolViewController.h"
#import "QSYExclusiveCompanyViewController.h"
#import "QSYReleaseRentTipsViewController.h"

#import "QSYPopCustomView.h"
#import "QSYWeekPickedView.h"
#import "QSYTimePickedView.h"
#import "QSCustomHUDView.h"

#import "UIButton+Factory.h"
#import "UITextField+CustomField.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSReleaseRentHouseDataModel.h"
#import "QSBaseConfigurationDataModel.h"
#import "QSYSendVerticalCodeReturnData.h"

#import "QSCoreDataManager+User.h"

#import <objc/runtime.h>

///关联
static char isExclusiveKey; //!<独家按钮关联
static char unExlusiveKey;  //!<非独家按钮关联

@interface QSYReleaseRentHouseDateInfoViewController () <UITextFieldDelegate>

///发布出租房时的暂存模型
@property (nonatomic,retain) QSReleaseRentHouseDataModel *rentHouseReleaseModel;

@property (nonatomic,assign) BOOL isAgreetProtocal;//!<是否同意服务协议

@end

@implementation QSYReleaseRentHouseDateInfoViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-03-26 09:03:39
 *
 *  @brief              创建发布出租物业时的日期等信息填写窗口
 *
 *  @param saleModel    发布出租物业时的填写数据模型
 *
 *  @return             返回当前创建的日期等信息窗口
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
    UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 44.0f - 25.0f, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLineLabel];
    
    ///底部确定按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"发布";
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断是否已同意协议
        if (!self.isAgreetProtocal) {
            
            return;
            
        }
        
        ///检测日期信息
        if ([self.rentHouseReleaseModel.weekInfos count] <= 0) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择预约周期", 1.0f, ^(){})
            return;
            
        }
        
        ///检测时间段信息
        if ([self.rentHouseReleaseModel.starTime length] <= 0 ||
            [self.rentHouseReleaseModel.endTime length] <= 0) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择预约时段", 1.0f, ^(){})
            return;
            
        }
        
        ///进行发布
        [self releaseSaleHouse];
        
    }];
    [self.view addSubview:commitButton];
    
}

- (void)createSettingInputUI:(QSScrollView *)view
{
    
    ///日期时间的高芳
    CGFloat height = 20.0f + 40.0f + 5.0f + SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    
    ///指针
    __block UILabel *dateInfoLabel;
    
    ///日期
    QSBlockView *dateRootView = [[QSBlockView alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_WIDTH - 4.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, height) andSingleTapCallBack:^(BOOL flag) {
        
        ///弹出日期选择
        [self popWeekPickedView:dateInfoLabel];
        
    }];
    [view addSubview:dateRootView];
    
    ///说明信息
    UILabel *dateTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, dateRootView.frame.size.width - 30.0f, 20.0f)];
    dateTipsLabel.text = @"设置可预约周期";
    dateTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    dateTipsLabel.textColor = COLOR_CHARACTERS_GRAY;
    [dateRootView addSubview:dateTipsLabel];
    
    ///日期
    dateInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, dateTipsLabel.frame.origin.y + dateTipsLabel.frame.size.height + 5.0f, dateTipsLabel.frame.size.width, 40.0f)];
    [dateRootView addSubview:dateInfoLabel];
    
    ///加载默认信息
    if ([self.rentHouseReleaseModel.weekInfos count] > 0) {
        
        dateInfoLabel.text = APPLICATION_NSSTRING_SETTING_NIL(self.rentHouseReleaseModel.weekInfoString);
        
    }
    
    ///右箭头
    QSImageView *dateArrow = [[QSImageView alloc] initWithFrame:CGRectMake(dateRootView.frame.size.width - 13.0f, (dateRootView.frame.size.height - 23.0f) / 2.0f, 13.0f, 23.0f)];
    dateArrow.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [dateRootView addSubview:dateArrow];
    
    ///分隔线
    UILabel *dateLineLable = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, dateRootView.frame.size.height - 0.25f, dateRootView.frame.size.width, 0.25f)];
    dateLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [dateRootView addSubview:dateLineLable];
    
    ///指针
    __block UILabel *timeInfoLabel;
    
    ///时间段
    QSBlockView *timeRootView = [[QSBlockView alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, dateRootView.frame.origin.y + dateRootView.frame.size.height + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, dateRootView.frame.size.width, 85.0f) andSingleTapCallBack:^(BOOL flag) {
        
        ///选择可预约时间段
        [self popTimePickedView:timeInfoLabel];
        
    }];
    [view addSubview:timeRootView];
    
    ///说明信息
    UILabel *timeTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, timeRootView.frame.size.width - 30.0f, 20.0f)];
    timeTipsLabel.text = @"设置可预约时段";
    timeTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    timeTipsLabel.textColor = COLOR_CHARACTERS_GRAY;
    [timeRootView addSubview:timeTipsLabel];
    
    ///时间段
    timeInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, timeTipsLabel.frame.origin.y + timeTipsLabel.frame.size.height + 5.0f, timeTipsLabel.frame.size.width, 40.0f)];
    [timeRootView addSubview:timeInfoLabel];
    
    ///加载默认信息
    if ([self.rentHouseReleaseModel.starTime length] > 0 &&
        [self.rentHouseReleaseModel.endTime length] > 0) {
        
        timeInfoLabel.text = [NSString stringWithFormat:@"%@-%@",self.rentHouseReleaseModel.starTime,self.rentHouseReleaseModel.endTime];
        
    }
    
    ///右箭头
    QSImageView *timeArrow = [[QSImageView alloc] initWithFrame:CGRectMake(timeRootView.frame.size.width - 13.0f, (timeRootView.frame.size.height - 23.0f) / 2.0f, 13.0f, 23.0f)];
    timeArrow.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [timeRootView addSubview:timeArrow];
    
    ///分隔线
    UILabel *timeLineLable = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, timeRootView.frame.size.height - 0.25f, timeRootView.frame.size.width, 0.25f)];
    timeLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [timeRootView addSubview:timeLineLable];
    
    ///独家委托
    UILabel *authorizeTips = [[UILabel alloc] initWithFrame:CGRectMake(timeRootView.frame.origin.x, timeRootView.frame.origin.y + timeRootView.frame.size.height + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 70.0f, 20.0f)];
    authorizeTips.text = @"独家委托";
    authorizeTips.font = [UIFont systemFontOfSize:FONT_BODY_16];
    authorizeTips.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:authorizeTips];
    
    ///指针
    __block UIButton *authorizeBox;
    __block UIButton *unAuthorizeBox;
    ///选择独家公司指针
    __block UITextField *companyChoice;
    
    ///选择项
    authorizeBox = [UIButton createCustomStyleButtonWithFrame:CGRectMake(authorizeTips.frame.origin.x + authorizeTips.frame.size.width + 10.0f, authorizeTips.frame.origin.y, 62.0f, 20.0f) andButtonStyle:nil andCustomButtonStyle:cCustomButtonStyleRightTitle andTitleSize:40.0f andMiddleGap:2.0f andCallBack:^(UIButton *button) {
        
        if (!button.selected) {
            
            button.selected = YES;
            unAuthorizeBox.selected = NO;
            
        }
        
    }];
    [authorizeBox setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_NORMAL] forState:UIControlStateNormal];
    [authorizeBox setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_HIGHLIGHTED] forState:UIControlStateSelected];
    authorizeBox.selected = YES;
    [authorizeBox setTitle:@"独家" forState:UIControlStateNormal];
    [authorizeBox setTitleColor:COLOR_CHARACTERS_BLACK forState:UIControlStateNormal];
    [authorizeBox setTitleColor:COLOR_CHARACTERS_LIGHTYELLOW forState:UIControlStateHighlighted];
    [view addSubview:authorizeBox];
    
    ///非独家
    unAuthorizeBox = [UIButton createCustomStyleButtonWithFrame:CGRectMake(authorizeBox.frame.origin.x + authorizeBox.frame.size.width + 25.0f, authorizeTips.frame.origin.y, 82.0f, 20.0f) andButtonStyle:nil andCustomButtonStyle:cCustomButtonStyleRightTitle andTitleSize:60.0f andMiddleGap:2.0f andCallBack:^(UIButton *button) {
        
        if (!button.selected) {
            
            button.selected = YES;
            authorizeBox.selected = NO;
            
            ///清空独家公司选择项
            self.rentHouseReleaseModel.exclusiveCompany = nil;
            
            ///独家公司显示框内容为空
            companyChoice.text = nil;
            
        }
        
    }];
    [unAuthorizeBox setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_NORMAL] forState:UIControlStateNormal];
    [unAuthorizeBox setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_HIGHLIGHTED] forState:UIControlStateSelected];
    [unAuthorizeBox setTitle:@"不独家" forState:UIControlStateNormal];
    [unAuthorizeBox setTitleColor:COLOR_CHARACTERS_BLACK forState:UIControlStateNormal];
    [unAuthorizeBox setTitleColor:COLOR_CHARACTERS_LIGHTYELLOW forState:UIControlStateHighlighted];
    [view addSubview:unAuthorizeBox];
    
    ///分隔线
    UILabel *authorLineLable = [[UILabel alloc] initWithFrame:CGRectMake(authorizeTips.frame.origin.x, unAuthorizeBox.frame.origin.y + unAuthorizeBox.frame.size.height + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, timeRootView.frame.size.width, 0.25f)];
    authorLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:authorLineLable];
    
    ///选择独家公司
    companyChoice = [UITextField createCustomTextFieldWithFrame:CGRectMake(authorLineLable.frame.origin.x, unAuthorizeBox.frame.origin.y + unAuthorizeBox.frame.size.height + 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, timeRootView.frame.size.width, 44.0f) andPlaceHolder:nil andLeftTipsInfo:@"选择独家公司" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsLightGray];
    companyChoice.delegate = self;
    [view addSubview:companyChoice];
    objc_setAssociatedObject(companyChoice, &isExclusiveKey, authorizeBox, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(companyChoice, &unExlusiveKey, unAuthorizeBox, OBJC_ASSOCIATION_ASSIGN);
    
    ///加载默认独家公司信息
    if (self.rentHouseReleaseModel.exclusiveCompany) {
        
        companyChoice.text = [self.rentHouseReleaseModel.exclusiveCompany valueForKey:@"title"];
        
    }
    
    ///分隔线
    UILabel *companyLineLable = [[UILabel alloc] initWithFrame:CGRectMake(companyChoice.frame.origin.x, companyChoice.frame.origin.y + companyChoice.frame.size.height + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, companyChoice.frame.size.width, 0.25f)];
    companyLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:companyLineLable];
    
    ///承诺说明
    UIButton *protocalButton = [UIButton createBlockButtonWithFrame:CGRectMake(companyChoice.frame.origin.x, companyChoice.frame.origin.y + companyChoice.frame.size.height + 2.0f * 2.0f * VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, 20.0f, 20.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///改变状态
        if (button.selected) {
            
            button.selected = NO;
            
            ///修改协议同意状态
            self.isAgreetProtocal = NO;
            
        } else {
            
            button.selected = YES;
            
            ///修改协议同意状态
            self.isAgreetProtocal = YES;
            
        }
        
    }];
    [protocalButton setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_NORMAL] forState:UIControlStateNormal];
    [protocalButton setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_HIGHLIGHTED] forState:UIControlStateSelected];
    protocalButton.selected = YES;
    self.isAgreetProtocal = YES;
    [view addSubview:protocalButton];
    
    ///协议说明文字按钮
    UIButton *protocalTipsButton = [UIButton createBlockButtonWithFrame:CGRectMake(protocalButton.frame.origin.x + protocalButton.frame.size.width + 5.0f, protocalButton.frame.origin.y - 7.0f, companyLineLable.frame.size.width - protocalButton.frame.size.width + 5.0f, 50.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///进入协议页面
        QSYUserProtocolViewController *protocolVC = [[QSYUserProtocolViewController alloc] init];
        [self.navigationController pushViewController:protocolVC animated:YES];
        
    }];
    [protocalTipsButton setTitle:@"我承诺我发布的房源信息全部属实，并接受<<XXX的用户使用协议>>" forState:UIControlStateNormal];
    [protocalTipsButton setTitleColor:COLOR_CHARACTERS_LIGHTGRAY forState:UIControlStateNormal];
    [protocalTipsButton setTitleColor:COLOR_CHARACTERS_LIGHTYELLOW forState:UIControlStateHighlighted];
    protocalTipsButton.backgroundColor = [UIColor clearColor];
    protocalTipsButton.titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    protocalTipsButton.titleLabel.numberOfLines = 2;
    [view addSubview:protocalTipsButton];
    
    ///判断滚动
    if ((protocalTipsButton.frame.origin.y + protocalTipsButton.frame.size.height + 10.0f) > view.frame.size.height) {
        
        view.contentSize = CGSizeMake(view.frame.size.width, protocalTipsButton.frame.origin.y + protocalTipsButton.frame.size.height + 20.0f);
        
    }
    
}

#pragma mark - 弹出日期选择
///弹出日期选择
- (void)popWeekPickedView:(UILabel *)targetLabel
{
    
    ///弹出窗口
    __block QSYPopCustomView *popView;
    
    ///星期选择
    QSYWeekPickedView *weekPickedView = [[QSYWeekPickedView alloc] initWithFrame:CGRectMake(0.0f, 110.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 110.0f) andPickeData:self.rentHouseReleaseModel.weekInfos andPickedCallBack:^(WEEK_PICKED_CALLBACK_TYPE actionType, NSArray *pickedDatas) {
        
        ///选择星期
        if (wWeekPickedCallBackTypePicked == actionType) {
            
            ///清空原信息
            [self.rentHouseReleaseModel.weekInfos removeAllObjects];
            
            NSMutableString *tempString = [[NSMutableString alloc] init];
            for (int i = 0; i < [pickedDatas count]; i++) {
                
                QSBaseConfigurationDataModel *weekModel = pickedDatas[i];
                [tempString appendString:weekModel.val];
                
                ///添加分号
                if (i != ([pickedDatas count] - 1)) {
                    
                    [tempString appendString:@"、"];
                    
                }
                
                ///保存选择的星期信息
                [self.rentHouseReleaseModel.weekInfos addObject:weekModel];
                
            }
            
            targetLabel.text = tempString;
            self.rentHouseReleaseModel.weekInfoString = tempString;
            
        }
        
        ///回收
        [popView hiddenCustomPopview];
        
    }];
    
    ///展现
    popView = [QSYPopCustomView popCustomView:weekPickedView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {}];
    
}

#pragma mark - 时间段选择
- (void)popTimePickedView:(UILabel *)timeLabel
{
    
    ///弹出窗口
    __block QSYPopCustomView *popView;
    
    ///时间段选择
    QSYTimePickedView *weekPickedView = [[QSYTimePickedView alloc] initWithFrame:CGRectMake(0.0f, 110.0f, SIZE_DEVICE_WIDTH, 226.0f) andStarTime:([self.rentHouseReleaseModel.starTime length] > 0 ? self.rentHouseReleaseModel.starTime : @"08:00") andEndTime:([self.rentHouseReleaseModel.endTime length] > 0 ? self.rentHouseReleaseModel.endTime : @"18:00") andPickedCallBack:^(TIME_PICKED_ACTION_TYPE actionType, NSString *startTime, NSString *endTime) {
        
        ///选择星期
        if (tTimePickedActionTypePicked == actionType) {
            
            self.rentHouseReleaseModel.starTime = APPLICATION_NSSTRING_SETTING_NIL(startTime);
            self.rentHouseReleaseModel.endTime = APPLICATION_NSSTRING_SETTING_NIL(endTime);
            timeLabel.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
            
        }
        
        ///回收
        [popView hiddenCustomPopview];
        
    }];
    
    ///展现
    popView = [QSYPopCustomView popCustomView:weekPickedView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {}];
    
}

#pragma mark - 独家公司选择
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    ///弹出独家公司选择页
    QSYExclusiveCompanyViewController *pickedCompanyVC = [[QSYExclusiveCompanyViewController alloc] initWithPickedCallBack:^(BOOL isPicked, id params) {
        
        if (isPicked) {
            
            ///保存独家公司
            self.rentHouseReleaseModel.exclusiveCompany = params;
            
            ///修改独家选择状态
            UIButton *authorButton = objc_getAssociatedObject(textField, &isExclusiveKey);
            if (authorButton) {
                
                authorButton.selected = YES;
                
            }
            
            UIButton *unAuthorButton = objc_getAssociatedObject(textField, &unExlusiveKey);
            if (unAuthorButton) {
                
                unAuthorButton.selected = NO;
                
            }
            
            ///修改显示文字
            textField.text = [params valueForKey:@"title"];
            
        }
        
    }];
    [self.navigationController pushViewController:pickedCompanyVC animated:YES];
    return NO;
    
}

#pragma mark - 发布房源
- (void)releaseSaleHouse
{
    
    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在发布房源"];
    
    ///生成参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self.rentHouseReleaseModel createReleaseRentHouseParams]];
    
    ///发布房源
    REQUEST_TYPE requestType = rRequestTypeMyZoneReleaseRentHouse;
    if (rReleasePropertyStatusUpdate == self.rentHouseReleaseModel.propertyStatus) {
        
        requestType = rRequestTypeMyZoneUpdateRentHouseProperty;
        [params setObject:self.rentHouseReleaseModel.propertyID forKey:@"id_"];
        
    }
    
    [QSRequestManager requestDataWithType:requestType andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///发布成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [hud hiddenCustomHUDWithFooterTips:@"发布成功" andDelayTime:1.0f andCallBack:^(BOOL flag) {
                
                ///刷新用户信息:由于发布物业后，房客升级为业主
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    if (rReleasePropertyStatusNew == self.rentHouseReleaseModel.propertyStatus) {
                        
                        [[NSUserDefaults standardUserDefaults] setValue:@"99" forKey:@"is_release_property"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [QSCoreDataManager reloadUserInfoFromServer];
                        
                    }
                    
                });
                
                ///获取返回ID
                QSYSendVerticalCodeReturnData *tempModel = resultData;
                
                ///提示发布成功
                QSYReleaseRentTipsViewController *tipsVC = [[QSYReleaseRentTipsViewController alloc] initWithTitle:self.rentHouseReleaseModel.title andDetailID:([self.rentHouseReleaseModel.propertyID intValue] > 0 ? self.rentHouseReleaseModel.propertyID : tempModel.msg)];
                [self.navigationController pushViewController:tipsVC animated:YES];
                
            }];
            
        } else {
            
            NSString *tipsString = @"发布失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.0f];
            
        }
        
    }];
    
}

@end
