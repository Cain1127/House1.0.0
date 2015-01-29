//
//  QSGuideSummaryViewController.m
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSGuideSummaryViewController.h"
#import "QSGuideLookingforRoomViewController.h"
#import "QSGuideSaleHouseViewController.h"
#import "QSBlockButtonStyleModel+Normal.h"

@interface QSGuideSummaryViewController ()

@end

@implementation QSGuideSummaryViewController

#pragma mark - UI搭建
- (void)createCustomGuideHeaderSubviewsUI:(UIView *)view
{
    
    ///头信息按上下两半切分：上面是房源，下面是房客
    UIView *housesView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height/2.0f)];
    housesView.backgroundColor = [UIColor clearColor];
    [self createHousesSubviews:housesView];
    [view addSubview:housesView];
    
    UIView *tenantView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, view.frame.size.height/2.0f, view.frame.size.width, view.frame.size.height/2.0f)];
    tenantView.backgroundColor = [UIColor clearColor];
    [self createTenantSubviews:tenantView];
    [view addSubview:tenantView];
    
}

///添加房源信息展示view
- (void)createHousesSubviews:(UIView *)view
{
    
    ///房源:173 x 200
    UIImageView *houseHavedTipsImageView = [[UIImageView alloc] init];
    houseHavedTipsImageView.translatesAutoresizingMaskIntoConstraints = NO;
    houseHavedTipsImageView.image = [UIImage imageNamed:IMAGE_GUIDE_HOUSESTIP];
    [view addSubview:houseHavedTipsImageView];
    
    ///房源数量人头图片
    UIImageView *houseHavedImageView = [[UIImageView alloc] init];
    houseHavedImageView.translatesAutoresizingMaskIntoConstraints = NO;
    houseHavedImageView.image = [UIImage imageNamed:IMAGE_GUIDE_HOUSES_PERSION];
    [view addSubview:houseHavedImageView];
    
    ///数量显示Label
    QSLabel *countLabel = [[QSLabel alloc] init];
    countLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_35];
    countLabel.text = @"234,8923";
    countLabel.textColor = [UIColor blackColor];
    countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:countLabel];
    
    ///约束view字典
    NSDictionary *___VFLViewsDict = NSDictionaryOfVariableBindings(houseHavedImageView,houseHavedTipsImageView,countLabel);
    
    ///添加约束
    NSString *___hVFL_tipAndHaved = @"H:|-(>=15)-[houseHavedImageView(165)]-[houseHavedTipsImageView(87)]-(>=15)-|";
    NSString *___hVFL_countLabel = @"H:[countLabel(>=165)]";
    NSString *___vVFL_havedTip = @"V:[houseHavedTipsImageView(100)]";
    NSString *___vVFL_havedImageAndCountLabel = @"V:[houseHavedImageView(28)]-[countLabel(houseHavedImageView)]-15-|";
    
    ///添加结束
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_tipAndHaved options:NSLayoutFormatAlignAllLastBaseline metrics:nil views:___VFLViewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_havedTip options:NSLayoutFormatAlignAllCenterY metrics:nil views:___VFLViewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_havedImageAndCountLabel options:NSLayoutFormatAlignAllLeft metrics:nil views:___VFLViewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_countLabel options:0 metrics:nil views:___VFLViewsDict]];
    
}

///添加房客信息展示view
- (void)createTenantSubviews:(UIView *)view
{
    
    ///房客:173 x 200
    UIImageView *tenantHavedTipsImageView = [[UIImageView alloc] init];
    tenantHavedTipsImageView.translatesAutoresizingMaskIntoConstraints = NO;
    tenantHavedTipsImageView.image = [UIImage imageNamed:IMAGE_GUIDE_TENANTTIP];
    [view addSubview:tenantHavedTipsImageView];
    
    ///房客数量人头图片
    UIImageView *tenantHavedImageView = [[UIImageView alloc] init];
    tenantHavedImageView.translatesAutoresizingMaskIntoConstraints = NO;
    tenantHavedImageView.image = [UIImage imageNamed:IMAGE_GUIDE_TENANT_PERSION];
    [view addSubview:tenantHavedImageView];
    
    ///数量显示Label
    QSLabel *countLabel = [[QSLabel alloc] init];
    countLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_35];
    countLabel.text = @"234,8923";
    countLabel.textColor = [UIColor blackColor];
    countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:countLabel];
    
    ///约束view字典
    NSDictionary *___VFLViewsDict = NSDictionaryOfVariableBindings(tenantHavedTipsImageView,tenantHavedImageView,countLabel);
    
    ///添加约束
    NSString *___hVFL_tipAndHaved = @"H:|-15-[tenantHavedTipsImageView(87)]-[tenantHavedImageView(165)]-(>=15)-|";
    NSString *___hVFL_countLabel = @"H:[countLabel(>=165)]";
    NSString *___vVFL_havedTip = @"V:[tenantHavedTipsImageView(100)]";
    NSString *___vVFL_havedImageAndCountLabel = @"V:|-75-[tenantHavedImageView(28)]-[countLabel(tenantHavedImageView)]";
    
    ///添加结束
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_tipAndHaved options:NSLayoutFormatAlignAllLastBaseline metrics:nil views:___VFLViewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_havedTip options:NSLayoutFormatAlignAllCenterY metrics:nil views:___VFLViewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_havedImageAndCountLabel options:NSLayoutFormatAlignAllRight metrics:nil views:___VFLViewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_countLabel options:0 metrics:nil views:___VFLViewsDict]];
    
}

/**
 *  @author     yangshengmeng, 15-01-20 14:01:51
 *
 *  @brief      在给定的视图上添加底部相关控件
 *
 *  @param view 底部控制
 *
 *  @since      1.0.0
 */
- (void)createCustomGuideFooterUI:(UIView *)view
{
    
    ///我要找房
    QSBlockButtonStyleModel *yellowButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    yellowButtonStyle.title = TITLE_GUIDE_SUMMARY_FINDHOUSE_BUTTON;
    UIButton *findHouseButton = [UIButton createBlockButtonWithButtonStyle:yellowButtonStyle andCallBack:^(UIButton *button) {
        
        QSGuideLookingforRoomViewController *findHouseVC = [[QSGuideLookingforRoomViewController alloc] init];
        [self.navigationController pushViewController:findHouseVC animated:YES];
        
    }];
    findHouseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:findHouseButton];
    
    ///我要放盘
    QSBlockButtonStyleModel *whiteButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    whiteButtonStyle.title = TITLE_GUIDE_SUMMARY_SALEHOUSE_BUTTON;
    UIButton *saleHouseButton = [UIButton createBlockButtonWithButtonStyle:whiteButtonStyle andCallBack:^(UIButton *button) {
        
        QSGuideSaleHouseViewController *saleHouseVC = [QSGuideSaleHouseViewController alloc];
        [self.navigationController pushViewController:saleHouseVC animated:YES];
        
    }];
    saleHouseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:saleHouseButton];
    
    ///计算间隙
    CGFloat gap = (SIZE_DEVICE_HEIGHT > 480.0f) ? ((SIZE_DEVICE_WIDTH > 320.0f) ? ((SIZE_DEVICE_WIDTH > 350.0f) ? 40.0f : 30.0f) : 30.0f) : 20.0f;
    CGFloat width = (SIZE_DEVICE_WIDTH > 320.0f) ? ((SIZE_DEVICE_WIDTH > 350.0f) ? 300.0f : 240.0f) : 200.0f;
    NSDictionary *___VFLSizeDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2f",gap],@"gap",[NSString stringWithFormat:@"%.2f",width],@"width",nil];
    
    ///添加约束
    NSString *___hVFL_findButton = @"H:[findHouseButton(width)]";
    NSString *___hVFL_saleButton = @"H:[saleHouseButton(width)]";
    NSString *___vVFL_all = @"V:|-gap-[findHouseButton]-10-[saleHouseButton(==findHouseButton)]-gap-|";
    
    ///约束参数字典
    NSDictionary *___VFLViewsDict = NSDictionaryOfVariableBindings(findHouseButton,saleHouseButton);
    
    ///添加约束
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_findButton options:NSLayoutFormatAlignAllCenterY metrics:___VFLSizeDict views:___VFLViewsDict]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:findHouseButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_saleButton options:NSLayoutFormatAlignAllCenterY metrics:___VFLSizeDict views:___VFLViewsDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_all options:NSLayoutFormatAlignAllCenterX metrics:___VFLSizeDict views:___VFLViewsDict]];
    
}

@end
