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
#import "QSYHousesNormalListViewController.h"

#import "QSYCollectedRentHouseListView.h"
#import "QSYCollectedSecondHandHouseListView.h"
#import "QSYCollectedNewHouseListView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSCoreDataManager.h"

#import "QSHouseInfoDataModel.h"
#import "QSRentHouseInfoDataModel.h"
#import "QSNewHouseInfoDataModel.h"

#import "MJRefresh.h"

@interface QSYCollectedHousesViewController ()

@property (assign) BOOL isHouseCollectedChange;                             //!<房源收藏是否已变动
@property (assign) FILTER_MAIN_TYPE currentHouseType;                       //!<记录当前房源类型
@property (nonatomic,unsafe_unretained) UICollectionView *currentListView;  //!<当前列表指针
@property (nonatomic,strong) UIButton *editButton;                          //!<导航栏编辑按钮
@property (nonatomic,strong) UIView *noRecordsView;                         //!<无记录提示页面
@property (nonatomic,strong) UILabel *noRecordsTipsLabel;                   //!<无记录提示页面
@property (nonatomic,strong) UIButton *noRecordsButton;                     //!<无记录提示页面

@end

@implementation QSYCollectedHousesViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"收藏房源"];
    
    ///编辑按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeEdit];
    
    self.editButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断当前是否有数据
        if (!self.noRecordsView.hidden) {
            
            return;
            
        }
        
        ///当前非编辑状态，进入删除状态
        if (button.selected) {
            
            button.selected = NO;
            if ([self.currentListView respondsToSelector:@selector(setIsEditingWithNumber:)]) {
                
                [self.currentListView performSelector:@selector(setIsEditingWithNumber:) withObject:@(0)];
                
            }
            
        } else {
            
            button.selected = YES;
            if ([self.currentListView respondsToSelector:@selector(setIsEditingWithNumber:)]) {
                
                [self.currentListView performSelector:@selector(setIsEditingWithNumber:) withObject:@(1)];
                
            }
            
        }
        
    }];
    self.editButton.hidden = YES;
    [self setNavigationBarRightView:self.editButton];

}

- (void)createMainShowUI
{
    
    [self createNoRecordUI];
    self.isHouseCollectedChange = NO;
    
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
    self.currentHouseType = fFilterMainTypeSecondHouse;
    
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
        self.currentHouseType = fFilterMainTypeSecondHouse;
        self.currentListView = nil;
        
        ///切换列表
        secondHandHouseList = [[QSYCollectedSecondHandHouseListView alloc] initWithFrame:CGRectMake(-SIZE_DEVICE_WIDTH, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
            
            switch (actionType) {
                    ///进入详情页
                case hHouseListActionTypeGotoDetail:
                {
                    
                    ///进入详情页
                    [self gotoHouseDetailPage:tempModel andHouseType:fFilterMainTypeSecondHouse];
                    
                }
                    break;
                    
                    ///无收收藏
                case hHouseListActionTypeNoRecord:
                {
                    
                    self.noRecordsTipsLabel.text = @"暂无二手房源收藏历史";
                    [self.noRecordsButton setTitle:@"看看二手房源" forState:UIControlStateNormal];
                    self.noRecordsView.hidden = NO;
                    self.editButton.hidden = YES;
                    [self.view bringSubviewToFront:self.noRecordsView];
                    
                };
                    break;
                    
                    ///收收藏
                case hHouseListActionTypeHaveRecord:
                {
                    
                    self.noRecordsView.hidden = YES;
                    self.editButton.hidden = NO;
                    [self.view sendSubviewToBack:self.noRecordsView];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        self.currentListView = secondHandHouseList;
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
        self.currentHouseType = fFilterMainTypeRentalHouse;
        self.currentListView = nil;
        
        ///坐标
        CGFloat xpoint = SIZE_DEVICE_WIDTH;
        CGFloat endXPoint = -SIZE_DEVICE_WIDTH;
        if (newHouseList) {
            
            xpoint = -xpoint;
            endXPoint = - endXPoint;
            
        }
        
        ///切换列表
        rentHouseList = [[QSYCollectedRentHouseListView alloc] initWithFrame:CGRectMake(xpoint, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
            
            switch (actionType) {
                    ///进入详情页
                case hHouseListActionTypeGotoDetail:
                {
                    
                    ///进入详情页
                    [self gotoHouseDetailPage:tempModel andHouseType:fFilterMainTypeRentalHouse];
                    
                }
                    break;
                    
                    ///无收收藏
                case hHouseListActionTypeNoRecord:
                {
                    
                    self.noRecordsTipsLabel.text = @"暂无出租房源收藏历史";
                    [self.noRecordsButton setTitle:@"看看出租房源" forState:UIControlStateNormal];
                    self.noRecordsView.hidden = NO;
                    self.editButton.hidden = YES;
                    [self.view bringSubviewToFront:self.noRecordsView];
                    
                };
                    break;
                    
                    ///收收藏
                case hHouseListActionTypeHaveRecord:
                {
                    
                    self.noRecordsView.hidden = YES;
                    self.editButton.hidden = NO;
                    [self.view sendSubviewToBack:self.noRecordsView];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        self.currentListView = rentHouseList;
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
        self.currentHouseType = fFilterMainTypeNewHouse;
        self.currentListView = nil;
        
        ///切换列表
        newHouseList = [[QSYCollectedNewHouseListView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
            
            switch (actionType) {
                    ///进入详情页
                case hHouseListActionTypeGotoDetail:
                {
                    
                    ///进入详情页
                    [self gotoHouseDetailPage:tempModel andHouseType:fFilterMainTypeNewHouse];
                    
                }
                    break;
                    
                    ///无收收藏
                case hHouseListActionTypeNoRecord:
                {
                    
                    self.noRecordsTipsLabel.text = @"暂无新房房源收藏历史";
                    [self.noRecordsButton setTitle:@"看看新房房源" forState:UIControlStateNormal];
                    self.noRecordsView.hidden = NO;
                    self.editButton.hidden = YES;
                    [self.view bringSubviewToFront:self.noRecordsView];
                    
                };
                    break;
                    
                    ///收收藏
                case hHouseListActionTypeHaveRecord:
                {
                    
                    self.noRecordsView.hidden = YES;
                    self.editButton.hidden = NO;
                    [self.view sendSubviewToBack:self.noRecordsView];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        self.currentListView = newHouseList;
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
    
    ///一开始加载二手房
    secondHandHouseList = [[QSYCollectedSecondHandHouseListView alloc] initWithFrame:CGRectMake(0.0f, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint) andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
        
        switch (actionType) {
                ///进入详情页
            case hHouseListActionTypeGotoDetail:
            {
            
                ///进入详情页
                [self gotoHouseDetailPage:tempModel andHouseType:fFilterMainTypeSecondHouse];
                
            }
                break;
                
                ///无收收藏
            case hHouseListActionTypeNoRecord:
            {
            
                self.noRecordsTipsLabel.text = @"暂无二手房源收藏历史";
                [self.noRecordsButton setTitle:@"看看二手房源" forState:UIControlStateNormal];
                self.noRecordsView.hidden = NO;
                self.editButton.hidden = YES;
                [self.view bringSubviewToFront:self.noRecordsView];
            
            };
                break;
                
                ///收收藏
            case hHouseListActionTypeHaveRecord:
            {
            
                self.noRecordsView.hidden = YES;
                self.editButton.hidden = NO;
                [self.view sendSubviewToBack:self.noRecordsView];
            
            }
                break;
                
            default:
                break;
        }
        
    }];
    self.currentListView = secondHandHouseList;
    [self.view addSubview:secondHandHouseList];
    
    ///指示三角
    arrowIndicator = [[QSImageView alloc] initWithFrame:CGRectMake(secondHandHouseButton.frame.size.width / 2.0f - 7.5f, secondHandHouseButton.frame.origin.y + secondHandHouseButton.frame.size.height - 5.0f, 15.0f, 5.0f)];
    arrowIndicator.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [self.view addSubview:arrowIndicator];
    
    ///注册收藏变动监听
    [QSCoreDataManager setCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andCallBack:^(COREDATA_DATA_TYPE dataType, DATA_CHANGE_TYPE changeType, NSString *paramsID, id params) {
        
        self.isHouseCollectedChange = YES;
        
    }];

}

///搭建无收藏的UI
- (void)createNoRecordUI
{
    
    self.noRecordsView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f + 44.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f)];
    self.noRecordsView.hidden = YES;
    [self.view addSubview:self.noRecordsView];
    
    ///无记录说明信息
    UIImageView *tipsImage = [[UIImageView alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 75.0f) / 2.0f, self.noRecordsView.frame.size.height / 2.0f - 85.0f, 75.0f, 85.0f)];
    tipsImage.image = [UIImage imageNamed:IMAGE_PUBLIC_NOCOLLECTED];
    [self.noRecordsView addSubview:tipsImage];
    
    ///提示信息
    self.noRecordsTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, tipsImage.frame.origin.y + tipsImage.frame.size.height + 15.0f, SIZE_DEFAULT_MAX_WIDTH, 20.0f)];
    self.noRecordsTipsLabel.text = @"暂无二手房源收藏历史";
    self.noRecordsTipsLabel.textAlignment = NSTextAlignmentCenter;
    self.noRecordsTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    self.noRecordsTipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [self.noRecordsView addSubview:self.noRecordsTipsLabel];
    
    ///按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    buttonStyle.title = @"看看二手房源";
    
    self.noRecordsButton = [UIButton createBlockButtonWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 160.0f) / 2.0f, self.noRecordsTipsLabel.frame.origin.y + self.noRecordsTipsLabel.frame.size.height + 25.0f, 160.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///进入新的房源列表
        QSYHousesNormalListViewController *houseListVC = [[QSYHousesNormalListViewController alloc] initWithHouseType:self.currentHouseType];
        [self.navigationController pushViewController:houseListVC animated:YES];
        
    }];
    self.noRecordsButton.titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_18];
    [self.noRecordsView addSubview:self.noRecordsButton];
    
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
            QSSecondHouseDetailViewController *detailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:houseInfoModel.title andDetailID:houseInfoModel.id_ andDetailType:houseType];
            
            ///删除物业回调
            detailVC.deletePropertyCallBack = ^(BOOL isDelete){
            
                self.isHouseCollectedChange = YES;
            
            };
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
            
            ///获取房子模型
            QSRentHouseInfoDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSRentHouseDetailViewController *detailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:houseInfoModel.title andDetailID:houseInfoModel.id_ andDetailType:houseType];
            
            detailVC.deletePropertyCallBack = ^(BOOL isDelete){
            
                self.isHouseCollectedChange = YES;
            
            };
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - 视图将要出现/消失时根据数据变动处理事务
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if (self.isHouseCollectedChange) {
        
        self.isHouseCollectedChange = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.currentListView.header beginRefreshing];
            
        });
        
    }
    
}

- (void)gotoTurnBackAction
{
    
    ///注销列表监听
    [QSCoreDataManager setCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andCallBack:nil];
    [super gotoTurnBackAction];
    
}

@end
