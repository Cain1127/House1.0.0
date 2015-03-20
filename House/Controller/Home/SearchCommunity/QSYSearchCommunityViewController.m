//
//  QSYSearchCommunityViewController.m
//  House
//
//  Created by ysmeng on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSearchCommunityViewController.h"

#import "QSYSelectedCommunityTableViewCell.h"
#import "QSCustomHUDView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSCoreDataManager+Filter.h"

#import "QSFilterDataModel.h"
#import "QSCommunityListReturnData.h"
#import "QSCommunityDataModel.h"

#import "MJRefresh.h"

#import <objc/runtime.h>

///关联
static char ListViewKey;//!<列表的关联

@interface QSYSearchCommunityViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

///选择一个小区后的回调
@property (nonatomic,copy) void(^pickedCommunityCallBack)(BOOL flag,QSCommunityDataModel *communityModel);

@property (nonatomic,retain) QSCommunityListReturnData *dataSourceModel;//!<小区数据源
@property (nonatomic,copy) NSString *searchKey;                         //!<搜索文字

@end

@implementation QSYSearchCommunityViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-12 17:03:05
 *
 *  @brief          根据回调创建一个小区添加关注的页面
 *
 *  @param callBack 选择一个小区后的回调
 *
 *  @return         返回小区关注选择页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPickedCallBack:(void(^)(BOOL flag,QSCommunityDataModel *communityModel))callBack
{

    if (self = [super init]) {
        
        ///保存回调
        if (callBack) {
            
            self.pickedCommunityCallBack = callBack;
            
        }
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    ///搜索框
    __block UITextField *inputField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEFAULT_MAX_WIDTH, 30.0f)];
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    inputField.delegate = self;
    inputField.placeholder = @"请输入小区名称或地址";
    inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    inputField.returnKeyType = UIReturnKeySearch;
    [self setNavigationBarMiddleView:inputField];
    
    ///搜索按钮
    UIButton *searchButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeSearch] andCallBack:^(UIButton *button) {
        
        ///获取输入内容
        NSString *inputText = inputField.text;
        if (nil == inputField || 0 >= [inputText length]) {
            
            [inputField becomeFirstResponder];
            return;
            
        }
        
        ///回收键盘
        [inputField resignFirstResponder];
        
        ///保存搜索关键字
        self.searchKey = inputText;
        
        ///重新请求数据
        [self reloadHeaderData];
        
    }];
    [self setNavigationBarRightView:searchButton];
    
}

- (void)createMainShowUI
{
    
    ///列表
    UITableView *communityListView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 84.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 84.0f) style:UITableViewStylePlain];
    communityListView.showsHorizontalScrollIndicator = NO;
    communityListView.showsVerticalScrollIndicator = NO;
    communityListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    communityListView.dataSource = self;
    communityListView.delegate = self;
    
    ///添加头尾刷新
    [communityListView addHeaderWithTarget:self action:@selector(getCommendCommunityHeaderData)];
    [communityListView addFooterWithTarget:self action:@selector(getCommendCommunityFooterData)];
    
    [self.view addSubview:communityListView];
    objc_setAssociatedObject(self, &ListViewKey, communityListView, OBJC_ASSOCIATION_ASSIGN);
    
    ///一开始就请求数据
    [communityListView headerBeginRefreshing];

}

#pragma mark - 返回有多少个小区
///返回有多少个小区
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.dataSourceModel.communityListHeaderData.communityList count];

}

#pragma mark - 返回每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 350.0f / 690.0f * SIZE_DEFAULT_MAX_WIDTH + 39.5f + 5.0f + 25.0f + 20.0f;

}

#pragma mark - 返回每个小区的信息cell
///返回每个小区的信息cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *normalCellName = @"normalCell";
    QSYSelectedCommunityTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCellName];
    
    if (nil == cellNormal) {
        
        cellNormal = [[QSYSelectedCommunityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellName];
        
    }
    
    ///取消选择风格
    cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ///刷新UI
    [cellNormal updateSelectedCommunityCellUI:self.dataSourceModel.communityListHeaderData.communityList[indexPath.row]];
    
    return cellNormal;

}

#pragma mark - 选择小区后回调
///选择小区后回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ///重置选择状态
    [self setCommunitySelectedStatus:(int)indexPath.row];
    
    ///刷新数据
    [self reloadData];
    
    ///获取模型
    QSCommunityDataModel *tempModel = self.dataSourceModel.communityListHeaderData.communityList[indexPath.row];
    
    ///判断是否已登录
    if (![self checkLogin]) {
        
        if (self.pickedCommunityCallBack) {
            
            self.pickedCommunityCallBack(YES,tempModel);
            
        }
        
        ///显示tabbar
        if (self.hiddenCustomTabbarWhenPush) {
            
            [self hiddenBottomTabbar:NO];
            
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
    
        ///将收藏上传服务器：显示HUD
        __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在添加关注"];
        
        ///封装参数
        NSDictionary *params = @{@"obj_id" : tempModel.id_,
                                 @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeCommunity]};
        
        [QSRequestManager requestDataWithType:rRequestTypeCommunityIntention andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///隐藏HUD
            [hud hiddenCustomHUDWithFooterTips:@"已分享成功"];
            
            ///同步服务端成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                tempModel.is_syserver = @"1";
                
                ///回调
                if (self.pickedCommunityCallBack) {
                    
                    self.pickedCommunityCallBack(YES,tempModel);
                    
                }
                
                ///显示tabbar
                if (self.hiddenCustomTabbarWhenPush) {
                    
                    [self hiddenBottomTabbar:NO];
                    
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                
                tempModel.is_syserver = @"0";
                
                ///回调
                if (self.pickedCommunityCallBack) {
                    
                    self.pickedCommunityCallBack(YES,tempModel);
                    
                }
                
                ///显示tabbar
                if (self.hiddenCustomTabbarWhenPush) {
                    
                    [self hiddenBottomTabbar:NO];
                    
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        }];
        
    }

}

#pragma mark - 设置选择状态
///设置选择状态
- (void)setCommunitySelectedStatus:(int)index
{

    for (int i = 0; i < [self.dataSourceModel.communityListHeaderData.communityList count]; i++) {
        
        QSCommunityDataModel *tempModel = self.dataSourceModel.communityListHeaderData.communityList[index];
        
        if (i != index) {
            
            tempModel.isSelectedStatus = 0;
            
        } else {
        
            tempModel.isSelectedStatus = 1;
        
        }
        
    }

}

#pragma mark - 结束刷新动画
///结束刷新动画
- (void)endLoadingAnimination
{

    UITableView *tableView = objc_getAssociatedObject(self, &ListViewKey);
    [tableView headerEndRefreshing];
    [tableView footerEndRefreshing];

}

#pragma mark - 主动发起头部刷新
///主动发起头部刷新
- (void)reloadHeaderData
{

    UITableView *tableView = objc_getAssociatedObject(self, &ListViewKey);
    [tableView headerBeginRefreshing];

}

#pragma mark - 重新生成列表
///重新生成列表
- (void)reloadData
{

    UITableView *tableView = objc_getAssociatedObject(self, &ListViewKey);
    [tableView reloadData];

}

#pragma mark - 网络请求数据
///请求头数据
- (void)getCommendCommunityHeaderData
{

    ///封装参数：主要是添加页码控制
    NSDictionary *temParams = @{@"commend" : @"Y",
                                @"now_page" : @"1",
                                @"page_num" : @"10",
                                @"title" : (([self.searchKey length] > 0) ? self.searchKey : @"")};
    
    [QSRequestManager requestDataWithType:rRequestTypeCommunity andParams:temParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断请求
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///请求成功后，转换模型
            QSCommunityListReturnData *resultDataModel = resultData;
            
            ///将数据模型置为nil
            self.dataSourceModel = nil;
            
            ///判断是否有房子数据
            if ([resultDataModel.communityListHeaderData.communityList count] <= 0) {
                
                ///没有记录，显示暂无记录提示
                [self showNoRecordTips:YES];
                
            } else {
                
                ///移除暂无记录
                [self showNoRecordTips:NO];
                
                ///更新数据源
                self.dataSourceModel = resultDataModel;
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///刷新数据
                [self reloadData];
                
            });
            
            ///结束刷新动画
            [self endLoadingAnimination];
            
        } else {
            
            ///结束刷新动画
            [self endLoadingAnimination];
            
            ///由于是第一页，请求失败，显示暂无记录
            [self showNoRecordTips:YES];
            
        }
        
    }];

}

///请求更新数据
- (void)getCommendCommunityFooterData
{
    
    ///判断是否最大页码
    if ([self.dataSourceModel.communityListHeaderData.per_page intValue] == [self.dataSourceModel.communityListHeaderData.total_page intValue]) {
        
        ///结束刷新动画
        [self endLoadingAnimination];
        return;
        
    }
    
    ///封装参数：主要是添加页码控制
    NSDictionary *temParams = @{@"commend" : @"Y",
                                @"now_page" : [NSString stringWithFormat:@"%@",self.dataSourceModel.communityListHeaderData.next_page],
                                @"page_num" : @"10",
                                @"title" : (([self.searchKey length] > 0) ? self.searchKey : @"")};
    
    [QSRequestManager requestDataWithType:rRequestTypeCommunity andParams:temParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断请求
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///请求成功后，转换模型
            QSCommunityListReturnData *resultDataModel = resultData;
            
            ///更改房子数据
            NSMutableArray *localArray = [NSMutableArray arrayWithArray:self.dataSourceModel.communityListHeaderData.communityList];
            
            ///更新数据源
            self.dataSourceModel = resultDataModel;
            [localArray addObjectsFromArray:resultDataModel.communityListHeaderData.communityList];
            self.dataSourceModel.communityListHeaderData.communityList = localArray;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///刷新数据
                [self reloadData];
                
            });
            
            ///结束刷新动画
            [self endLoadingAnimination];
            
        } else {
            
            ///结束刷新动画
            [self endLoadingAnimination];
            
        }
        
    }];
    
}

#pragma mark - 点击搜索时，回收键盘
///点击搜索时，回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    
    ///判断是否存在输入内容
    if ([textField.text length] > 0) {
        
        self.searchKey = textField.text;
        
        ///刷新数据
        [self reloadHeaderData];
        
    }
    
    return YES;

}

@end
