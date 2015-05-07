//
//  QSYSearchHousesViewController.m
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSearchHousesViewController.h"
#import "QSWHousesMapDistributionViewController.h"
#import "QSNewHouseDetailViewController.h"
#import "QSCommunityDetailViewController.h"
#import "QSSecondHouseDetailViewController.h"
#import "QSRentHouseDetailViewController.h"

#import "QSCustomPickerView.h"
#import "QSYSearchSecondHandHouseList.h"
#import "QSYSearchRentHouseList.h"
#import "QSYSearchNewHouseList.h"
#import "QSYSearchCommunityList.h"

#import "NSDate+Formatter.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+SearchHistory.h"

#import "QSLocalSearchHistoryDataModel.h"
#import "QSNewHouseInfoDataModel.h"
#import "QSCommunityDataModel.h"
#import "QSHouseInfoDataModel.h"
#import "QSRentHouseInfoDataModel.h"

#import "MJRefresh.h"

@interface QSYSearchHousesViewController () <UITextFieldDelegate>

@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;                    //!<房源类型
@property (nonatomic,copy) NSString *searchKey;                             //!<搜索关键字
@property (nonatomic,unsafe_unretained) UICollectionView *currentListView;  //!<当前列表指针
@property (assign) BOOL isNeedRefresh;                                      //!<是否需要刷新

///导航栏选择器
@property (nonatomic,strong) QSCustomPickerView *houseTypePicker;

@end

@implementation QSYSearchHousesViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-15 13:04:25
 *
 *  @brief              创建搜索房源列表
 *
 *  @param houseType    房源类型
 *  @param searchKey    搜索的关键字
 *
 *  @return             返回当前创建的搜索列表
 *
 *  @since              1.0.0
 */
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
            
            ///清空输入框的内容
            seachTextField.text = nil;
            
            ///保存类型
            self.houseType = [selectedKey intValue];
            
            ///刷新数据
            [self createMainShowUI];
            
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
    seachTextField.text = APPLICATION_NSSTRING_SETTING_NIL(self.searchKey);
    [self.view addSubview:seachTextField];
    
    ///取消搜索按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeCancel];
    
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 44.0f, 20.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        [self gotoTurnBackAction];
        
    }];
    [self.view addSubview:cancelButton];
    
    ///分隔线
    UILabel *sepLine = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 64.0f - 0.25f, SIZE_DEVICE_WIDTH, 0.25f)];
    sepLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLine];

}

- (void)createMainShowUI
{

    ///先清除原列表
    if (self.currentListView) {
        
        [self.currentListView removeFromSuperview];
        
    }
    
    ///无记录提示UI
    UILabel *tipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, SIZE_DEVICE_WIDTH, 44.0f)];
    tipsLabel.hidden = YES;
    tipsLabel.text = @"抱谦，我们未找到符合条件的房源，以下是为你推荐的房源";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    tipsLabel.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    tipsLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:tipsLabel];
    [self.view sendSubviewToBack:tipsLabel];
    
    ///根据不同的类型，创建不同的列表UI
    switch (self.houseType) {
            
            ///新房列表
        case fFilterMainTypeNewHouse:
        {
            
            QSYSearchNewHouseList *listView = [[QSYSearchNewHouseList alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) andSearchKey:self.searchKey andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
                
                ///过滤回调类型
                switch (actionType) {
                        ///进入详情页
                    case hHouseListActionTypeGotoDetail:
                        
                        [self gotoHouseDetail:tempModel];
                        
                        break;
                        
                        ///搜索结果集有数据
                    case hHouseListActionTypeSearchHaveResult:
                    {
                        
                        ///判断是否需要移动
                        if (tipsLabel.hidden) {
                            
                            return;
                            
                        }
                        
                        [UIView animateWithDuration:0.3f animations:^{
                            
                            tipsLabel.hidden = YES;
                            tipsLabel.frame = CGRectMake(tipsLabel.frame.origin.x, 20.0f, tipsLabel.frame.size.width, tipsLabel.frame.size.height);
                            self.currentListView.frame = CGRectMake(self.currentListView.frame.origin.x, 64.0f, self.currentListView.frame.size.width, SIZE_DEVICE_HEIGHT - 64.0f);
                            
                        }];
                        
                    }
                        break;
                        
                        ///搜索结果集无数据
                    case hHouseListActionTypeSearchNoResult:
                    {
                        
                        ///当前已显示提示
                        if (!tipsLabel.hidden) {
                            
                            return;
                            
                        }
                        
                        [UIView animateWithDuration:0.3f animations:^{
                            
                            tipsLabel.hidden = NO;
                            tipsLabel.frame = CGRectMake(tipsLabel.frame.origin.x, 64.0f, tipsLabel.frame.size.width, tipsLabel.frame.size.height);
                            self.currentListView.frame = CGRectMake(self.currentListView.frame.origin.x, 64.0f + 44.0f, self.currentListView.frame.size.width, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f);
                            
                        }];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }];
            
            listView.alwaysBounceVertical = YES;
            [self.view addSubview:listView];
            self.currentListView = listView;
            
        }
            break;
            
            ///小区列表
        case fFilterMainTypeCommunity:
        {
            
            ///创建小区的列表UI
            QSYSearchCommunityList *listView = [[QSYSearchCommunityList alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) andSearchKey:self.searchKey andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
                
                ///过滤回调类型
                switch (actionType) {
                        ///进入详情页
                    case hHouseListActionTypeGotoDetail:
                        
                        [self gotoHouseDetail:tempModel];
                        
                        break;
                        
                        ///搜索结果集有数据
                    case hHouseListActionTypeSearchHaveResult:
                    {
                        
                        ///判断是否需要移动
                        if (tipsLabel.hidden) {
                            
                            return;
                            
                        }
                        
                        [UIView animateWithDuration:0.3f animations:^{
                            
                            tipsLabel.hidden = YES;
                            tipsLabel.frame = CGRectMake(tipsLabel.frame.origin.x, 20.0f, tipsLabel.frame.size.width, tipsLabel.frame.size.height);
                            self.currentListView.frame = CGRectMake(self.currentListView.frame.origin.x, 64.0f, self.currentListView.frame.size.width, SIZE_DEVICE_HEIGHT - 64.0f);
                            
                        }];
                        
                    }
                        break;
                        
                        ///搜索结果集无数据
                    case hHouseListActionTypeSearchNoResult:
                    {
                        
                        ///当前已显示提示
                        if (!tipsLabel.hidden) {
                            
                            return;
                            
                        }
                        
                        [UIView animateWithDuration:0.3f animations:^{
                            
                            tipsLabel.hidden = NO;
                            tipsLabel.frame = CGRectMake(tipsLabel.frame.origin.x, 64.0f, tipsLabel.frame.size.width, tipsLabel.frame.size.height);
                            self.currentListView.frame = CGRectMake(self.currentListView.frame.origin.x, 64.0f + 44.0f, self.currentListView.frame.size.width, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f);
                            
                        }];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }];
            
            listView.alwaysBounceVertical = YES;
            [self.view addSubview:listView];
            self.currentListView = listView;
            
        }
            break;
            
            ///二手房列表
        case fFilterMainTypeSecondHouse:
        {
            
            ///瀑布流布局器
            QSYSearchSecondHandHouseList *listView = [[QSYSearchSecondHandHouseList alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) andSearchKey:self.searchKey andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType,id tempModel) {
                
                ///过滤回调类型
                switch (actionType) {
                        ///进入详情页
                    case hHouseListActionTypeGotoDetail:
                        
                        [self gotoHouseDetail:tempModel];
                        
                        break;
                        
                        ///搜索结果集有数据
                    case hHouseListActionTypeSearchHaveResult:
                    {
                        
                        ///判断是否需要移动
                        if (tipsLabel.hidden) {
                            
                            return;
                            
                        }
                        
                        [UIView animateWithDuration:0.3f animations:^{
                            
                            tipsLabel.hidden = YES;
                            tipsLabel.frame = CGRectMake(tipsLabel.frame.origin.x, 20.0f, tipsLabel.frame.size.width, tipsLabel.frame.size.height);
                            self.currentListView.frame = CGRectMake(self.currentListView.frame.origin.x, 64.0f, self.currentListView.frame.size.width, SIZE_DEVICE_HEIGHT - 64.0f);
                            
                        }];
                        
                    }
                        break;
                        
                        ///搜索结果集无数据
                    case hHouseListActionTypeSearchNoResult:
                    {
                        
                        ///当前已显示提示
                        if (!tipsLabel.hidden) {
                            
                            return;
                            
                        }
                        
                        [UIView animateWithDuration:0.3f animations:^{
                            
                            tipsLabel.hidden = NO;
                            tipsLabel.frame = CGRectMake(tipsLabel.frame.origin.x, 64.0f, tipsLabel.frame.size.width, tipsLabel.frame.size.height);
                            self.currentListView.frame = CGRectMake(self.currentListView.frame.origin.x, 64.0f + 44.0f, self.currentListView.frame.size.width, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f);
                            
                        }];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }];
            
            listView.alwaysBounceVertical = YES;
            [self.view addSubview:listView];
            self.currentListView = listView;
            
        }
            break;
            
            ///出租房列表
        case fFilterMainTypeRentalHouse:
        {
            
            QSYSearchRentHouseList *listView = [[QSYSearchRentHouseList alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) andSearchKey:self.searchKey andCallBack:^(HOUSE_LIST_ACTION_TYPE actionType, id tempModel) {
                
                ///过滤回调类型
                switch (actionType) {
                        ///进入详情页
                    case hHouseListActionTypeGotoDetail:
                        
                        [self gotoHouseDetail:tempModel];
                        
                        break;
                        
                        ///搜索结果集有数据
                    case hHouseListActionTypeSearchHaveResult:
                    {
                        
                        ///判断是否需要移动
                        if (tipsLabel.hidden) {
                            
                            return;
                            
                        }
                        
                        [UIView animateWithDuration:0.3f animations:^{
                            
                            tipsLabel.hidden = YES;
                            tipsLabel.frame = CGRectMake(tipsLabel.frame.origin.x, 20.0f, tipsLabel.frame.size.width, tipsLabel.frame.size.height);
                            self.currentListView.frame = CGRectMake(self.currentListView.frame.origin.x, 64.0f, self.currentListView.frame.size.width, SIZE_DEVICE_HEIGHT - 64.0f);
                            
                        }];
                        
                    }
                        break;
                        
                        ///搜索结果集无数据
                    case hHouseListActionTypeSearchNoResult:
                    {
                        
                        ///当前已显示提示
                        if (!tipsLabel.hidden) {
                            
                            return;
                            
                        }
                        
                        [UIView animateWithDuration:0.3f animations:^{
                            
                            tipsLabel.hidden = NO;
                            tipsLabel.frame = CGRectMake(tipsLabel.frame.origin.x, 64.0f, tipsLabel.frame.size.width, tipsLabel.frame.size.height);
                            self.currentListView.frame = CGRectMake(self.currentListView.frame.origin.x, 64.0f + 44.0f, self.currentListView.frame.size.width, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f);
                            
                        }];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }];
            
            listView.alwaysBounceVertical = YES;
            [self.view addSubview:listView];
            self.currentListView = listView;
            
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - 点击房源进入房源详情页
///点击房源
- (void)gotoHouseDetail:(id)dataModel
{
    
    ///根据不同的列表，进入同的详情页
    switch (self.houseType) {
            ///进入新房详情
        case fFilterMainTypeNewHouse:
        {
            
            ///获取房子模型
            QSNewHouseInfoDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSNewHouseDetailViewController *detailVC = [[QSNewHouseDetailViewController alloc] initWithTitle:houseInfoModel.title andLoupanID:houseInfoModel.loupan_id andLoupanBuildingID:houseInfoModel.loupan_building_id andDetailType:self.houseType];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
            ///进入小区详情
        case fFilterMainTypeCommunity:
        {
            
            ///获取房子模型
            QSCommunityDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSCommunityDetailViewController *detailVC = [[QSCommunityDetailViewController alloc] initWithTitle:houseInfoModel.title andCommunityID:houseInfoModel.id_ andCommendNum:@"10" andHouseType:@"second"];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
            ///进入二手房详情
        case fFilterMainTypeSecondHouse:
        {
            
            ///获取房子模型
            QSHouseInfoDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSSecondHouseDetailViewController *detailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:([houseInfoModel.title length] > 0 ? houseInfoModel.title : houseInfoModel.village_name) andDetailID:houseInfoModel.id_ andDetailType:self.houseType];
            
            ///删除物业时刷新
            detailVC.deletePropertyCallBack = ^(BOOL isDelete){
            
                self.isNeedRefresh = YES;
            
            };
            
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
            
            ///进入出租房详情
        case fFilterMainTypeRentalHouse:
        {
            
            ///获取房子模型
            QSRentHouseInfoDataModel *houseInfoModel = dataModel;
            
            ///进入详情页面
            QSRentHouseDetailViewController *detailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:([houseInfoModel.title  length] > 0 ? houseInfoModel.title : houseInfoModel.village_name) andDetailID:houseInfoModel.id_ andDetailType:self.houseType];
            
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

#pragma mark - 点击键盘上的搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    if ([textField.text length] > 0) {
        
        self.searchKey = textField.text;
        
        ///保存搜索记录
        QSLocalSearchHistoryDataModel *tempModel = [[QSLocalSearchHistoryDataModel alloc] init];
        tempModel.search_keywork = self.searchKey;
        tempModel.search_time = [NSDate currentDateTimeStamp];
        tempModel.search_type = [NSString stringWithFormat:@"%d",self.houseType];
        
        [QSCoreDataManager addLocalSearchHistory:tempModel andCallBack:^(BOOL flag) {
        
            if (flag && self.addNewSearchCallBack) {
                
                self.addNewSearchCallBack(YES,self.houseType);
                
            }
        
        }];
        
        ///刷新数据
        if (self.currentListView) {
            
            if ([self.currentListView respondsToSelector:@selector(reloadDataWithSearchKey:)]) {
                
                [self.currentListView performSelector:@selector(reloadDataWithSearchKey:) withObject:self.searchKey];
                
            }
            
        }
        
    } else {
    
        self.searchKey = textField.text;
        
        ///刷新数据
        if (self.currentListView) {
            
            if ([self.currentListView respondsToSelector:@selector(reloadDataWithSearchKey:)]) {
                
                [self.currentListView performSelector:@selector(reloadDataWithSearchKey:) withObject:self.searchKey];
                
            }
            
        }
    
    }
    
    [textField resignFirstResponder];
    
    return YES;

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
