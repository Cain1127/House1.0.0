//
//  QSYReleaseHouseDateInfoViewController.m
//  House
//
//  Created by ysmeng on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseHouseDateInfoViewController.h"

#import "UIButton+Factory.h"
#import "UITextField+CustomField.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSReleaseSaleHouseDataModel.h"

@interface QSYReleaseHouseDateInfoViewController ()

///出售物业的数据模型
@property (nonatomic,retain) QSReleaseSaleHouseDataModel *saleHouseReleaseModel;

@end

@implementation QSYReleaseHouseDateInfoViewController

#pragma mark - 初始化
/**
*  @author             yangshengmeng, 15-03-26 14:03:32
*
*  @brief              创建发布出售物业，日期信息输入窗口
*
*  @param saleModel    出售物业暂存数据模型
*
*  @return             返回当前创建的发布物业数据模型
*
*  @since              1.0.0
*/
- (instancetype)initWithSaleHouseInfoModel:(QSReleaseSaleHouseDataModel *)saleModel
{

    if (self = [super init]) {
    
        ///保存数据
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
    UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 44.0f - 25.0f, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLineLabel];
    
    ///底部确定按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"发布";
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        
        
    }];
    [self.view addSubview:commitButton];

}

- (void)createSettingInputUI:(QSScrollView *)view
{
    
    ///日期时间的高芳
    CGFloat height = 20.0f + 40.0f + 5.0f + SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    
    ///日期
    QSBlockView *dateRootView = [[QSBlockView alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_WIDTH - 4.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, height) andSingleTapCallBack:^(BOOL flag) {
        
        
        
    }];
    [view addSubview:dateRootView];
    
    ///说明信息
    UILabel *dateTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, dateRootView.frame.size.width - 30.0f, 20.0f)];
    dateTipsLabel.text = @"设置可预约周期";
    dateTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    dateTipsLabel.textColor = COLOR_CHARACTERS_GRAY;
    [dateRootView addSubview:dateTipsLabel];
    
    ///日期
    UILabel *dateInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, dateTipsLabel.frame.origin.y + dateTipsLabel.frame.size.height + 5.0f, dateTipsLabel.frame.size.width, 40.0f)];
    [dateRootView addSubview:dateInfoLabel];
    
    ///右箭头
    QSImageView *dateArrow = [[QSImageView alloc] initWithFrame:CGRectMake(dateRootView.frame.size.width - 13.0f, (dateRootView.frame.size.height - 23.0f) / 2.0f, 13.0f, 23.0f)];
    dateArrow.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [dateRootView addSubview:dateArrow];
    
    ///分隔线
    UILabel *dateLineLable = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, dateRootView.frame.size.height - 0.25f, dateRootView.frame.size.width, 0.25f)];
    dateLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [dateRootView addSubview:dateLineLable];
    
    ///时间段
    QSBlockView *timeRootView = [[QSBlockView alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, dateRootView.frame.origin.y + dateRootView.frame.size.height + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, dateRootView.frame.size.width, 85.0f) andSingleTapCallBack:^(BOOL flag) {
        
        
        
    }];
    [view addSubview:timeRootView];
    
    ///说明信息
    UILabel *timeTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, timeRootView.frame.size.width - 30.0f, 20.0f)];
    timeTipsLabel.text = @"设置可预约周期";
    timeTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    timeTipsLabel.textColor = COLOR_CHARACTERS_GRAY;
    [timeRootView addSubview:timeTipsLabel];
    
    ///时间段
    UILabel *timeInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, timeTipsLabel.frame.origin.y + timeTipsLabel.frame.size.height + 5.0f, timeTipsLabel.frame.size.width, 40.0f)];
    [timeRootView addSubview:timeInfoLabel];
    
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
    
    ///选择项
    UIButton *authorizeBox = [UIButton createCustomStyleButtonWithFrame:CGRectMake(authorizeTips.frame.origin.x + authorizeTips.frame.size.width + 10.0f, authorizeTips.frame.origin.y, 62.0f, 20.0f) andButtonStyle:nil andCustomButtonStyle:cCustomButtonStyleRightTitle andTitleSize:40.0f andMiddleGap:2.0f andCallBack:^(UIButton *button) {
        
        
        
    }];
    [authorizeBox setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_NORMAL] forState:UIControlStateNormal];
    [authorizeBox setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_HIGHLIGHTED] forState:UIControlStateSelected];
    authorizeBox.selected = YES;
    [authorizeBox setTitle:@"独家" forState:UIControlStateNormal];
    [authorizeBox setTitleColor:COLOR_CHARACTERS_BLACK forState:UIControlStateNormal];
    [authorizeBox setTitleColor:COLOR_CHARACTERS_LIGHTYELLOW forState:UIControlStateHighlighted];
    [view addSubview:authorizeBox];
    
    UIButton *unAuthorizeBox = [UIButton createCustomStyleButtonWithFrame:CGRectMake(authorizeBox.frame.origin.x + authorizeBox.frame.size.width + 25.0f, authorizeTips.frame.origin.y, 82.0f, 20.0f) andButtonStyle:nil andCustomButtonStyle:cCustomButtonStyleRightTitle andTitleSize:60.0f andMiddleGap:2.0f andCallBack:^(UIButton *button) {
        
        
        
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
    UITextField *companyChoice = [UITextField createCustomTextFieldWithFrame:CGRectMake(authorLineLable.frame.origin.x, unAuthorizeBox.frame.origin.y + unAuthorizeBox.frame.size.height + 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, timeRootView.frame.size.width, 44.0f) andPlaceHolder:nil andLeftTipsInfo:@"选择独家公司" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsLightGray];
    [view addSubview:companyChoice];
    
    ///分隔线
    UILabel *companyLineLable = [[UILabel alloc] initWithFrame:CGRectMake(companyChoice.frame.origin.x, companyChoice.frame.origin.y + companyChoice.frame.size.height + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, companyChoice.frame.size.width, 0.25f)];
    companyLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:companyLineLable];
    
    ///承诺说明
    UIButton *protocalButton = [UIButton createBlockButtonWithFrame:CGRectMake(companyChoice.frame.origin.x, companyChoice.frame.origin.y + companyChoice.frame.size.height + 2.0f * 2.0f * VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, 20.0f, 20.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        
        
    }];
    [protocalButton setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_NORMAL] forState:UIControlStateNormal];
    [protocalButton setImage:[UIImage imageNamed:IMAGE_PUBLIC_SINGLE_SELECTED_HIGHLIGHTED] forState:UIControlStateSelected];
    protocalButton.selected = YES;
    [view addSubview:protocalButton];
    
    ///协议说明文字按钮
    UIButton *protocalTipsButton = [UIButton createBlockButtonWithFrame:CGRectMake(protocalButton.frame.origin.x + protocalButton.frame.size.width + 5.0f, protocalButton.frame.origin.y - 7.0f, companyLineLable.frame.size.width - protocalButton.frame.size.width + 5.0f, 50.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        
        
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


@end
