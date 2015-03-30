//
//  QSYReleasePickCommunityViewController.m
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleasePickCommunityViewController.h"

#import "QSYReleasePickCommunityTableViewCell.h"

#import "QSRequestManager.h"

#import "QSCommunityListReturnData.h"
#import "QSCommunityDataModel.h"

#import "MJRefresh.h"

@interface QSYReleasePickCommunityViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

///选择小区后的回调block
@property (nonatomic,copy) void(^releasePickedCommunityCallBack)(BOOL flag,id pickModel);

@property (nonatomic,strong) UITableView *listView;                 //!<列表view
@property (nonatomic,retain) QSCommunityListReturnData *dataModel;  //!<数据源
@property (nonatomic,copy) NSString *searchKey;                     //!<搜索的关键字

@end

@implementation QSYReleasePickCommunityViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-25 16:03:04
 *
 *  @brief          创建发布物业时，选择小区的窗口
 *
 *  @param callBack 选择小区后的回调
 *
 *  @return         返回当前创建的小区选择窗口
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPickedCallBack:(void(^)(BOOL flag,id pickModel))callBack
{

    if (self = [super init]) {
        
        ///保存回调
        if (callBack) {
            
            self.releasePickedCommunityCallBack = callBack;
            
        }
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"选择小区"];

}

- (void)createMainShowUI
{
    
    ///输入框
    __block UITextField *inputField = [[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 72.0f, SIZE_DEFAULT_MAX_WIDTH - 49.0f, 44.0f)];
    inputField.placeholder = @"请输入小区名称";
    inputField.delegate = self;
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    inputField.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:inputField];
    
    ///搜索按钮
    UIButton *searchButton = [UIButton createBlockButtonWithFrame:CGRectMake(inputField.frame.origin.x + inputField.frame.size.width + 5.0f, inputField.frame.origin.y, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        NSString *inputString = inputField.text;
        
        ///判断是否有输入内容
        if ([inputString length] <= 0) {
            
            [inputField becomeFirstResponder];
            return;
            
        }
        
        ///保存搜索关键字
        self.searchKey = inputString;
        
        ///回收键盘
        [inputField resignFirstResponder];
        
        ///刷新数据
        [self.listView.header beginRefreshing];
        
    }];
    [searchButton setImage:[UIImage imageNamed:IMAGE_NAVIGATIONBAR_SEARCH_NORMAL] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:IMAGE_NAVIGATIONBAR_SEARCH_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.view addSubview:searchButton];

    ///小区列表
    CGFloat ypoint = inputField.frame.origin.y + inputField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, ypoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - ypoint) style:UITableViewStylePlain];
    
    ///取消滚动条
    self.listView.showsHorizontalScrollIndicator = NO;
    self.listView.showsVerticalScrollIndicator = NO;
    
    ///取消分隔样式
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///数据源
    self.listView.dataSource = self;
    self.listView.delegate = self;
    
    ///添加头尾刷新
    [self.listView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getHeaderData)];
    [self.listView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    
    [self.view addSubview:self.listView];
    
    ///开始就请求数据
    [self.listView.header beginRefreshing];

}

#pragma mark - 列表相关设置
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.dataModel.communityListHeaderData.communityList count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50.0f + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *normalCell = @"normalCell";
    QSYReleasePickCommunityTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCell];
    if (nil == cellNormal) {
        
        cellNormal = [[QSYReleasePickCommunityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
        
    }
    
    ///取消选择时的样式
    cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ///刷新UI
    [cellNormal updateReleasePickCommunityCellUI:self.dataModel.communityListHeaderData.communityList[indexPath.row]];
    
    return cellNormal;

}

#pragma mark - 选择小区
///选择小区
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.releasePickedCommunityCallBack) {
        
        self.releasePickedCommunityCallBack(YES,self.dataModel.communityListHeaderData.communityList[indexPath.row]);
        
    }
    
    ///返回上一页
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - 请求数据
///请求头部数据
- (void)getHeaderData
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
            self.dataModel = nil;
            
            ///判断是否有房子数据
            if ([resultDataModel.communityListHeaderData.communityList count] > 0) {
                
                ///更新数据源
                self.dataModel = resultDataModel;
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///刷新数据
                [self.listView reloadData];
                
            });
            
            ///结束刷新动画
            [self.listView.header endRefreshing];
            [self.listView.footer endRefreshing];
            
        } else {
            
            ///结束刷新动画
            [self.listView.header endRefreshing];
            [self.listView.footer endRefreshing];
            
        }
        
    }];

}

///获取更多数据
- (void)getMoreData
{

    ///判断是否最大页码
    if ([self.dataModel.communityListHeaderData.per_page intValue] == [self.dataModel.communityListHeaderData.total_page intValue]) {
        
        ///结束刷新动画
        [self.listView.header endRefreshing];
        [self.listView.footer endRefreshing];
        return;
        
    }
    
    ///封装参数：主要是添加页码控制
    NSDictionary *temParams = @{@"commend" : @"Y",
                                @"now_page" : [NSString stringWithFormat:@"%@",self.dataModel.communityListHeaderData.next_page],
                                @"page_num" : @"10",
                                @"title" : (([self.searchKey length] > 0) ? self.searchKey : @"")};
    
    [QSRequestManager requestDataWithType:rRequestTypeCommunity andParams:temParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断请求
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///请求成功后，转换模型
            QSCommunityListReturnData *resultDataModel = resultData;
            
            ///更改房子数据
            NSMutableArray *localArray = [NSMutableArray arrayWithArray:self.dataModel.communityListHeaderData.communityList];
            
            ///更新数据源
            self.dataModel = resultDataModel;
            [localArray addObjectsFromArray:resultDataModel.communityListHeaderData.communityList];
            self.dataModel.communityListHeaderData.communityList = localArray;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ///刷新数据
                [self.listView reloadData];
                
            });
            
            ///结束刷新动画
            [self.listView.header endRefreshing];
            [self.listView.footer endRefreshing];
            
        } else {
            
            ///结束刷新动画
            [self.listView.header endRefreshing];
            [self.listView.footer endRefreshing];
            
        }
        
    }];

}

#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    
    ///如果输入有内容
    if ([textField.text length] > 0) {
        
        ///保存搜索关键字
        self.searchKey = textField.text;
        
        ///刷新数据
        [self.listView.header beginRefreshing];
        
    }
    
    return YES;

}

@end
