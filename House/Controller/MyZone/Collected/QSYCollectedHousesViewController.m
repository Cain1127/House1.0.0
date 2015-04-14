//
//  QSYCollectedHousesViewController.m
//  House
//
//  Created by ysmeng on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYCollectedHousesViewController.h"
#import "QSSecondHouseDetailViewController.h"
#import "QSRentHouseDetailViewController.h"
#import "QSNewHouseDetailViewController.h"

#import "QSYCollectedRentHouseListView.h"
#import "QSYCollectedSecondHandHouseListView.h"
#import "QSYCollectedNewHouseListView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSHouseInfoDataModel.h"
#import "QSRentHouseInfoDataModel.h"
#import "QSNewHouseInfoDataModel.h"

@interface QSYCollectedHousesViewController ()

@end

@implementation QSYCollectedHousesViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"收藏房源"];
    
    ///编辑按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeEdit];
    
    UIButton *editButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///当前非编辑状态，进入删除状态
        if (button.selected) {
            
            button.selected = NO;
            
        } else {
            
            button.selected = YES;
            
        }
        
    }];
    [self setNavigationBarRightView:editButton];

}

- (void)createMainShowUI
{
    
    ///列表指针
    __block QSYCollectedRentHouseListView *rentHouseList;
    __block QSYCollectedSecondHandHouseListView *secondHandHouseList;
    __block QSYCollectedNewHouseListView *newHouseList;
    
    ///指示三角指针
    __block UIImageView *arrowIndicator;
    
    ///按钮指针
    __block UIButton *secondHandHouseButton;
    __block UIButton *rentHouseButton;
    __block UIButton *newHouseButton;
    
    ///尺寸
    CGFloat widthButton = SIZE_DEVICE_WIDTH / 3.0f;
    CGFloat listYPoint = 64.0f + 44.0f + SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.bgColorSelected = COLOR_CHARACTERS_LIGHTYELLOW;
    buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_16];

    ///二手房源
    buttonStyle.title = @"二手房源";
    secondHandHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 64.0f, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///当前已处于选择状态
        if (button.selected) {
            
            return;
            
        }
        
        ///切换按钮状态
        button.selected = YES;
        rentHouseButton.selected = NO;
        newHouseButton.selected = NO;
        
        ///切换列表
        secondHandHouseList = [[QSYCollectedSecondHandHouseListView alloc] initWithFrame:CGRectMake(-SIZE_DEVICE_WIDTH, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
            
            ///进入详情页
            [self gotoHouseDetailPage:tempModel andHouseType:fFilterMainTypeSecondHouse];
            
        }];
        [self.view addSubview:secondHandHouseList];
        
        ///获取当前正在显示的view
        UIView *tempView = rentHouseList ? rentHouseList : newHouseList;
        
        ///移动指示器
        [UIView animateWithDuration:0.3f animations:^{
            
            arrowIndicator.frame = CGRectMake(button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            
            tempView.frame = CGRectMake(SIZE_DEVICE_WIDTH, tempView.frame.origin.y, tempView.frame.size.width, tempView.frame.size.height);
            
            secondHandHouseList.frame = CGRectMake(0.0f, secondHandHouseList.frame.origin.y, secondHandHouseList.frame.size.width, secondHandHouseList.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            [tempView removeFromSuperview];
            rentHouseList = nil;
            newHouseList = nil;
            
        }];
        
    }];
    secondHandHouseButton.selected = YES;
    [self.view addSubview:secondHandHouseButton];
    
    ///出租房房源
    buttonStyle.title = @"出租房源";
    rentHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake(secondHandHouseButton.frame.origin.x + secondHandHouseButton.frame.size.width, 64.0f, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///当前已处于选择状态
        if (button.selected) {
            
            return;
            
        }
        
        ///切换按钮状态
        button.selected = YES;
        secondHandHouseButton.selected = NO;
        newHouseButton.selected = NO;
        
        ///坐标
        CGFloat xpoint = SIZE_DEVICE_WIDTH;
        CGFloat endXPoint = -SIZE_DEVICE_WIDTH;
        if (newHouseList) {
            
            xpoint = -xpoint;
            endXPoint = - endXPoint;
            
        }
        
        ///切换列表
        rentHouseList = [[QSYCollectedRentHouseListView alloc] initWithFrame:CGRectMake(xpoint, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
            
            ///进入详情页
            [self gotoHouseDetailPage:tempModel andHouseType:fFilterMainTypeRentalHouse];
            
        }];
        [self.view addSubview:rentHouseList];
        
        ///获取当前正在显示的view
        UIView *tempView = secondHandHouseList ? secondHandHouseList : newHouseList;
        
        ///移动指示器
        [UIView animateWithDuration:0.3f animations:^{
            
            arrowIndicator.frame = CGRectMake(button.frame.origin.x + button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            
            tempView.frame = CGRectMake(endXPoint, tempView.frame.origin.y, tempView.frame.size.width, tempView.frame.size.height);
            
            rentHouseList.frame = CGRectMake(0.0f, rentHouseList.frame.origin.y, rentHouseList.frame.size.width, rentHouseList.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            [tempView removeFromSuperview];
            secondHandHouseList = nil;
            newHouseList = nil;
            
        }];
        
    }];
    [self.view addSubview:rentHouseButton];
    
    ///新房
    buttonStyle.title = @"新房房源";
    newHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake(rentHouseButton.frame.origin.x + rentHouseButton.frame.size.width, 64.0f, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///当前已处于选择状态
        if (button.selected) {
            
            return;
            
        }
        
        ///切换按钮状态
        button.selected = YES;
        rentHouseButton.selected = NO;
        secondHandHouseButton.selected = NO;
        
        ///切换列表
        newHouseList = [[QSYCollectedNewHouseListView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
            
            ///进入详情页
            [self gotoHouseDetailPage:tempModel andHouseType:fFilterMainTypeNewHouse];
            
        }];
        [self.view addSubview:newHouseList];
        
        ///获取当前正在显示的view
        UIView *tempView = rentHouseList ? rentHouseList : secondHandHouseList;
        
        ///移动指示器
        [UIView animateWithDuration:0.3f animations:^{
            
            arrowIndicator.frame = CGRectMake(button.frame.origin.x + button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            
            tempView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, tempView.frame.origin.y, tempView.frame.size.width, tempView.frame.size.height);
            
            newHouseList.frame = CGRectMake(0.0f, newHouseList.frame.origin.y, newHouseList.frame.size.width, newHouseList.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            [tempView removeFromSuperview];
            rentHouseList = nil;
            secondHandHouseList = nil;
            
        }];
        
    }];
    [self.view addSubview:newHouseButton];
    
    secondHandHouseList = [[QSYCollectedSecondHandHouseListView alloc] initWithFrame:CGRectMake(0.0f, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
        
        ///进入详情页
        [self gotoHouseDetailPage:tempModel andHouseType:fFilterMainTypeSecondHouse];
        
    }];
    [self.view addSubview:secondHandHouseList];
    
    ///指示三角
    arrowIndicator = [[QSImageView alloc] initWithFrame:CGRectMake(secondHandHouseButton.frame.size.width / 2.0f - 7.5f, secondHandHouseButton.frame.origin.y + secondHandHouseButton.frame.size.height - 5.0f, 15.0f, 5.0f)];
    arrowIndicator.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [self.view addSubview:arrowIndicator];

}

#pragma mark - 进入详情页面
- (void)gotoHouseDetailPage:(id)dataModel andHouseType:(FILTER_MAIN_TYPE)houseType
{

    switch (houseType) {
            ///新房
        case fFilterMainTypeNewHouse:
        {
            
            ///获取房子模型
            QSNewHouseInfoDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSNewHouseDetailViewController *detailVC = [[QSNewHouseDetailViewController alloc] initWithTitle:houseInfoModel.title andLoupanID:houseInfoModel.loupan_id andLoupanBuildingID:houseInfoModel.loupan_building_id andDetailType:houseType];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
            
            ///获取房子模型
            QSHouseInfoDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSSecondHouseDetailViewController *detailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:houseInfoModel.village_name andDetailID:houseInfoModel.id_ andDetailType:houseType];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
            
            ///获取房子模型
            QSRentHouseInfoDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSRentHouseDetailViewController *detailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:houseInfoModel.village_name andDetailID:houseInfoModel.id_ andDetailType:houseType];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }

}

@end
