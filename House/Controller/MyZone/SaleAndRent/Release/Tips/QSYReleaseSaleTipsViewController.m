//
//  QSYReleaseSaleTipsViewController.m
//  House
//
//  Created by ysmeng on 15/4/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseSaleTipsViewController.h"
#import "QSYOwnerPropertyViewController.h"
#import "QSRentHouseDetailViewController.h"

#import "QSBlockButtonStyleModel+Normal.h"

@interface QSYReleaseSaleTipsViewController ()

@property (nonatomic,copy) NSString *title;     //!<标题
@property (nonatomic,copy) NSString *detailID;  //!<发布房源的详情ID

@end

@implementation QSYReleaseSaleTipsViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-04-02 22:04:41
 *
 *  @brief          根据发布房源的标题和id初始化一个发布提示页面
 *
 *  @param title    标题
 *  @param detailID 详情id
 *
 *  @return         返回当前创建的发布提示页
 *
 *  @since          1.0.0
 */
- (instancetype)initWithTitle:(NSString *)title andDetailID:(NSString *)detailID
{
    
    if (self = [super init]) {
        
        self.title = title;
        self.detailID = detailID;
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    ///由于本页面不需要导航栏UI，故需要重载此方法，并且不执行任何代码

}

- (void)createMainShowUI
{
    
    ///提示图片
    QSImageView *tipsImageView = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 2.0f - 30.0f, SIZE_DEVICE_HEIGHT / 2.0f - 34.0f, 60.0f, 68.0f)];
    tipsImageView.image = [UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ACCEPT_BT_NORMAL];
    [self.view addSubview:tipsImageView];
    
    ///提示信息
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 160.0f) / 2.0f, tipsImageView.frame.origin.y + tipsImageView.frame.size.height + 5.0f, 160.0f, 20.0f)];
    messageLabel.text = @"发布房源成功！";
    messageLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:messageLabel];
    
    ///按钮宽度
    CGFloat widthButton = SIZE_DEVICE_WIDTH - 4.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 8.0f;
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    
    ///查看物业详情
    buttonStyle.title = @"查看物业详情";
    UIButton *detailButton = [UIButton createBlockButtonWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, messageLabel.frame.origin.y + messageLabel.frame.size.height + 25.0f, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///进入详情页
        QSRentHouseDetailViewController *detailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:self.title andDetailID:self.detailID andDetailType:fFilterMainTypeRentalHouse];
        [detailVC setTurnBackDistanceStep:7];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }];
    [self.view addSubview:detailButton];
    
    ///管理我的物业
    buttonStyle.title = @"管理我的物业";
    UIButton *houseListButton = [UIButton createBlockButtonWithFrame:CGRectMake(detailButton.frame.origin.x + detailButton.frame.size.width + 8.0f, detailButton.frame.origin.y, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断原来是否存在管理物业页面
        for (int i = 0; i < [self.navigationController.viewControllers count]; i++) {
            
            UIViewController *tempVC = self.navigationController.viewControllers[i];
            if ([tempVC isKindOfClass:[QSYOwnerPropertyViewController class]]) {
                
                [((QSYOwnerPropertyViewController *)tempVC) updateMyPropertyData];
                [self.navigationController popToViewController:tempVC animated:YES];
                return;
                
            }
            
        }
        
        ///进入物业管理页
        QSYOwnerPropertyViewController *propertyVC = [[QSYOwnerPropertyViewController alloc] initWithHouseType:fFilterMainTypeRentalHouse];
        [propertyVC setTurnBackDistanceStep:7];
        [self.navigationController pushViewController:propertyVC animated:YES];
        
    }];
    [self.view addSubview:houseListButton];
    
}

@end
