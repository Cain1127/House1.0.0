//
//  QSYMyHistoryViewController.m
//  House
//
//  Created by ysmeng on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMyHistoryViewController.h"
#import "QSNewHouseDetailViewController.h"
#import "QSSecondHouseDetailViewController.h"
#import "QSRentHouseDetailViewController.h"

#import "QSYHistoryRentHouseList.h"
#import "QSYHistorySecondHandHouseListView.h"
#import "QSYHistoryNewHouseListView.h"
#import "QSCommunityDetailViewController.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSWRentHouseInfoDataModel.h"
#import "QSRentHouseDetailDataModel.h"
#import "QSNewHouseDetailDataModel.h"
#import "QSLoupanInfoDataModel.h"
#import "QSLoupanPhaseDataModel.h"
#import "QSSecondHouseDetailDataModel.h"
#import "QSWSecondHouseInfoDataModel.h"

#import "MJRefresh.h"

@interface QSYMyHistoryViewController ()

@property (nonatomic,strong) UIView *noRecordsRootView;                     //!<无记录底view
@property (nonatomic,unsafe_unretained) UICollectionView *currentListView;  //!<当前房源列表
@property (assign) BOOL isNeedRefresh;                                      //!<是否需要刷新

@end

@implementation QSYMyHistoryViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"浏览记录"];
    
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
    
    ///创建无记录UI
    [self createNoRecordsUI];

    ///列表指针
    __block QSYHistoryRentHouseList *rentHouseList;
    __block QSYHistorySecondHandHouseListView *secondHandHouseList;
    __block QSYHistoryNewHouseListView *newHouseList;
    
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
        secondHandHouseList = [[QSYHistorySecondHandHouseListView alloc] initWithFrame:CGRectMake(-SIZE_DEVICE_WIDTH, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
            
            ///无记录UI
            if (hHouseListActionTypeNoRecord == actionType) {
                
                self.noRecordsRootView.hidden = NO;
                return;
                
            }
            
            ///有记录时隐藏无记录UI
            if (hHouseListActionTypeHaveRecord == actionType) {
                
                self.noRecordsRootView.hidden = YES;
                return;
                
            }
            
            if (hHouseListActionTypeGotoDetail == actionType) {
                
                ///进入详情页
                [self gotoHouseDetailPage:tempModel andHouseType:fFilterMainTypeSecondHouse];
                return;
                
            }
            
        }];
        [self.view addSubview:secondHandHouseList];
        self.currentListView = secondHandHouseList;
        
        ///获取当前正在显示的view
        UIView *tempView = rentHouseList ? rentHouseList : newHouseList;
        
        ///移动指示器
        [UIView animateWithDuration:0.3f animations:^{
            
            arrowIndicator.frame = CGRectMake(button.frame.origin.x + button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            
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
        CGFloat xpoint = -SIZE_DEVICE_WIDTH;
        CGFloat endXPoint = SIZE_DEVICE_WIDTH;
        if (secondHandHouseList) {
            
            xpoint = -xpoint;
            endXPoint = - endXPoint;
            
        }
        
        ///切换列表
        rentHouseList = [[QSYHistoryRentHouseList alloc] initWithFrame:CGRectMake(xpoint, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
            
            ///无记录UI
            if (hHouseListActionTypeNoRecord == actionType) {
                
                self.noRecordsRootView.hidden = NO;
                return;
                
            }
            
            ///有记录时隐藏无记录UI
            if (hHouseListActionTypeHaveRecord == actionType) {
                
                self.noRecordsRootView.hidden = YES;
                return;
                
            }
            
            if (hHouseListActionTypeGotoDetail == actionType) {
                
                ///进入详情页
                [self gotoHouseDetailPage:tempModel andHouseType:fFilterMainTypeRentalHouse];
                return;
                
            }
            
        }];
        [self.view addSubview:rentHouseList];
        self.currentListView = rentHouseList;
        
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
        secondHandHouseButton.selected = NO;
        rentHouseButton.selected = NO;
        
        ///切换列表
        newHouseList = [[QSYHistoryNewHouseListView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
            
            ///无记录UI
            if (hHouseListActionTypeNoRecord == actionType) {
                
                self.noRecordsRootView.hidden = NO;
                return;
                
            }
            
            ///有记录时隐藏无记录UI
            if (hHouseListActionTypeHaveRecord == actionType) {
                
                self.noRecordsRootView.hidden = YES;
                return;
                
            }
            
            if (hHouseListActionTypeGotoDetail == actionType) {
                
                ///进入详情页
                [self gotoHouseDetailPage:tempModel andHouseType:fFilterMainTypeRentalHouse];
                
            }
            
        }];
        [self.view addSubview:newHouseList];
        self.currentListView = newHouseList;
        
        ///获取当前正在显示的view
        UIView *tempView = secondHandHouseList ? secondHandHouseList : rentHouseList;
        
        ///移动指示器
        [UIView animateWithDuration:0.3f animations:^{
            
            arrowIndicator.frame = CGRectMake(button.frame.origin.x + button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            
            tempView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, tempView.frame.origin.y, tempView.frame.size.width, tempView.frame.size.height);
            
            newHouseList.frame = CGRectMake(0.0f, newHouseList.frame.origin.y, newHouseList.frame.size.width, newHouseList.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            [tempView removeFromSuperview];
            secondHandHouseList = nil;
            rentHouseList = nil;
            
        }];
        
    }];
    [self.view addSubview:newHouseButton];
    
    ///初始化时，加载二手房列表
    secondHandHouseList = [[QSYHistorySecondHandHouseListView alloc] initWithFrame:CGRectMake(0.0f, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
        
        ///无记录UI
        if (hHouseListActionTypeNoRecord == actionType) {
            
            self.noRecordsRootView.hidden = NO;
            return;
            
        }
        
        ///有记录时隐藏无记录UI
        if (hHouseListActionTypeHaveRecord == actionType) {
            
            self.noRecordsRootView.hidden = YES;
            return;
            
        }
        
        if (hHouseListActionTypeGotoDetail == actionType) {
            
            ///进入详情页
            [self gotoHouseDetailPage:tempModel andHouseType:fFilterMainTypeSecondHouse];
            return;
            
        }
        
    }];
    [self.view addSubview:secondHandHouseList];
    
    ///指示三角
    arrowIndicator = [[QSImageView alloc] initWithFrame:CGRectMake(secondHandHouseButton.frame.size.width / 2.0f - 7.5f, secondHandHouseButton.frame.origin.y + secondHandHouseButton.frame.size.height - 5.0f, 15.0f, 5.0f)];
    arrowIndicator.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [self.view addSubview:arrowIndicator];

}

///创建无记录UI
- (void)createNoRecordsUI
{

    self.noRecordsRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    self.noRecordsRootView.hidden = YES;
    [self.view addSubview:self.noRecordsRootView];
    
    ///无记录说明信息
    UIImageView *tipsImage = [[UIImageView alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 75.0f) / 2.0f, (SIZE_DEVICE_HEIGHT - 64.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f - 85.0f, 75.0f, 85.0f)];
    tipsImage.image = [UIImage imageNamed:IMAGE_PUBLIC_NOHISTORY];
    tipsImage.tag = 3110;
    [self.noRecordsRootView addSubview:tipsImage];
    
    ///提示信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, tipsImage.frame.origin.y + tipsImage.frame.size.height + 15.0f, SIZE_DEFAULT_MAX_WIDTH, 20.0f)];
    tipsLabel.text = @"暂无浏览房源";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    tipsLabel.tag = 3111;
    [self.noRecordsRootView addSubview:tipsLabel];
    
}

#pragma mark - 进入详情页面
- (void)gotoHouseDetailPage:(id)dataModel andHouseType:(FILTER_MAIN_TYPE)houseType
{
    
    switch (houseType) {
            ///新房
        case fFilterMainTypeNewHouse:
        {
            
            ///获取房子模型
            QSNewHouseDetailDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSNewHouseDetailViewController *detailVC = [[QSNewHouseDetailViewController alloc] initWithTitle:houseInfoModel.loupan.title andLoupanID:houseInfoModel.loupan.id_ andLoupanBuildingID:houseInfoModel.loupan_building.id_ andDetailType:houseType];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
            
            ///获取房子模型
            QSSecondHouseDetailDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSSecondHouseDetailViewController *detailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:houseInfoModel.house.village_name andDetailID:houseInfoModel.house.id_ andDetailType:houseType];
            
            ///删除物业时回调
            detailVC.deletePropertyCallBack = ^(BOOL isDelete){
            
                self.isNeedRefresh = YES;
            
            };
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
            
            ///获取房子模型
            QSRentHouseDetailDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSRentHouseDetailViewController *detailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:houseInfoModel.house.village_name andDetailID:houseInfoModel.house.id_ andDetailType:houseType];
            
            detailVC.deletePropertyCallBack = ^(BOOL isDelete){
            
                self.isNeedRefresh = YES;
            
            };
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 视图将要显示时判断是否刷新
- (void)viewWillAppear:(BOOL)animated
{
 
    [super viewWillAppear:animated];
    
    if (self.isNeedRefresh) {
        
        self.isNeedRefresh = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.currentListView.header beginRefreshing];
            
        });
        
    }
    
}

@end
