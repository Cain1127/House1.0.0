//
//  QSYReleaseSaleHousePictureViewController.m
//  House
//
//  Created by ysmeng on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseSaleHousePictureViewController.h"
#import "QSYReleaseHouseContactInfoViewController.h"

#import "UITextField+CustomField.h"
#import "QSBlockButtonStyleModel+Normal.h"

#import "QSReleaseSaleHouseDataModel.h"

@interface QSYReleaseSaleHousePictureViewController () <UITextFieldDelegate,UITextViewDelegate>

///出售物业的数据模型
@property (nonatomic,retain) QSReleaseSaleHouseDataModel *saleHouseReleaseModel;

@end

@implementation QSYReleaseSaleHousePictureViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-03-26 09:03:39
 *
 *  @brief              创建发布出售物业时的图片/补充/视频信息信息填写窗口
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
        
        ///进入联系信息填写窗口
        QSYReleaseHouseContactInfoViewController *pictureAddVC = [[QSYReleaseHouseContactInfoViewController alloc] initWithSaleHouseModel:self.saleHouseReleaseModel];
        [self.navigationController pushViewController:pictureAddVC animated:YES];
        
    }];
    [self.view addSubview:commitButton];

}

///搭建设置信息输入栏
- (void)createSettingInputUI:(QSScrollView *)view
{
    
    ///提示信息
    UIView *tipsRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 44.0f)];
    tipsRootView.backgroundColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:tipsRootView];
    
    ///提示文字
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 7.0f, tipsRootView.frame.size.width - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 30.0f)];
    tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    tipsLabel.text = @"补充信息，选择项";
    tipsLabel.textColor = [UIColor whiteColor];
    [tipsRootView addSubview:tipsLabel];
    
    ///标题
    UITextField *titleField = [UITextField createCustomTextFieldWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, tipsRootView.frame.origin.y + tipsRootView.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, tipsRootView.frame.size.width - 4.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f) andPlaceHolder:@"简要描述20字以内" andLeftTipsInfo:@"标       题" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsLightGray];
    titleField.delegate = self;
    [view addSubview:titleField];
    
    ///分隔线
    UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleField.frame.origin.x, titleField.frame.origin.y + titleField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP / 2.0f, titleField.frame.size.width, 0.25f)];
    sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:sepLineLabel];
    
    ///详细描述
    UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(titleField.frame.origin.x, titleField.frame.origin.y + titleField.frame.size.height + 2.0f * VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, titleField.frame.size.width, 120.0f)];
    descriptionView.delegate = self;
    descriptionView.showsHorizontalScrollIndicator = NO;
    descriptionView.showsVerticalScrollIndicator = NO;
    descriptionView.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    descriptionView.layer.borderWidth = 0.5f;
    descriptionView.layer.borderColor = [COLOR_CHARACTERS_BLACKH CGColor];
    descriptionView.font = [UIFont systemFontOfSize:FONT_BODY_16];
    descriptionView.text = @"房屋详细描述";
    descriptionView.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    [view addSubview:descriptionView];
    
    ///添加图片
    UILabel *addImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(descriptionView.frame.origin.x, descriptionView.frame.origin.y + descriptionView.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, descriptionView.frame.size.width, 30.0f)];
    addImageLabel.text = @"添加图片";
    addImageLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    addImageLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:addImageLabel];
    
    ///添加图片按钮
    UIButton *addImageButtonOne = [UIButton createBlockButtonWithFrame:CGRectMake(addImageLabel.frame.origin.x, addImageLabel.frame.origin.y + addImageLabel.frame.size.height +  VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, 60.0f, 60.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        
        
    }];
    addImageButtonOne.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    addImageButtonOne.layer.borderColor = [COLOR_CHARACTERS_BLACKH CGColor];
    addImageButtonOne.layer.borderWidth = 0.5f;
    [addImageButtonOne setTitle:@"+" forState:UIControlStateNormal];
    [addImageButtonOne setTitleColor:COLOR_CHARACTERS_BLACKH forState:UIControlStateNormal];
    [addImageButtonOne setTitleColor:COLOR_CHARACTERS_YELLOW forState:UIControlStateHighlighted];
    [view addSubview:addImageButtonOne];
    
    ///添加视频
    UILabel *addVedioLabel = [[UILabel alloc] initWithFrame:CGRectMake(addImageLabel.frame.origin.x, addImageButtonOne.frame.origin.y + addImageButtonOne.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, addImageLabel.frame.size.width, 30.0f)];
    addVedioLabel.text = @"添加视频";
    addVedioLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    addVedioLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:addVedioLabel];
    
    ///添加视频按钮
    UIButton *addVedioButton = [UIButton createBlockButtonWithFrame:CGRectMake(addVedioLabel.frame.origin.x, addVedioLabel.frame.origin.y + addVedioLabel.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, 60.0f, 60.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        
        
    }];
    addVedioButton.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    addVedioButton.layer.borderColor = [COLOR_CHARACTERS_BLACKH CGColor];
    addVedioButton.layer.borderWidth = 0.5f;
    [addVedioButton setTitle:@"+" forState:UIControlStateNormal];
    [addVedioButton setTitleColor:COLOR_CHARACTERS_BLACKH forState:UIControlStateNormal];
    [addVedioButton setTitleColor:COLOR_CHARACTERS_YELLOW forState:UIControlStateHighlighted];
    [view addSubview:addVedioButton];
    
    ///判断滚动
    if (addVedioButton.frame.origin.y + addVedioButton.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP > view.frame.size.height) {
        
        view.contentSize = CGSizeMake(view.frame.size.width, addVedioButton.frame.origin.y + addVedioButton.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP + 15.0f);
        
    }
    
}

#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    if ([textView.text isEqualToString:@"房屋详细描述"]) {
        
        textView.text = nil;
        textView.textColor = COLOR_CHARACTERS_BLACK;
        
    }
    return YES;

}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{

    if ([textView.text length] <= 0) {
        
        textView.text = @"房屋详细描述";
        textView.textColor = COLOR_CHARACTERS_BLACK;
        
    }
    return YES;

}

@end
