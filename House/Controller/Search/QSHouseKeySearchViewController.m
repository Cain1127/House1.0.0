//
//  QSHouseKeySearchViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHouseKeySearchViewController.h"
#import "QSYSearchHousesViewController.h"

#import "QSCustomPickerView.h"

#import "NSDate+Formatter.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSCoreDataManager+SearchHistory.h"
#import "QSCoreDataManager+House.h"
#import "QSLocalSearchHistoryDataModel.h"

#import "QSBaseConfigurationDataModel.h"

#import "MJRefresh.h"
#import "Pinyin4Objc.h"

@interface QSHouseKeySearchViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (assign) BOOL isRefresh;                                  //!<视图出现时是否更新列表
@property (nonatomic,strong) UITableView *searchItemView;           //!<列表
@property (nonatomic,strong) UISearchBar *seachTextField;           //!<搜索框
@property (nonatomic,strong) UIView *noRecordsRootView;             //!<没有记录底view
@property (nonatomic,strong) QSCustomPickerView *houseTypePicker;   //!<导航栏列表类型选择
@property (nonatomic,retain) NSMutableArray *localDataSource;       //!<本地数据
@property (nonatomic,retain) NSMutableArray *searchDataSource;      //!<数据源
@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;            //!<房源类型

@end

@implementation QSHouseKeySearchViewController

#pragma mark - 初始化
- (instancetype)initWithHouseType:(FILTER_MAIN_TYPE)houseType
{

    if (self = [super init]) {
        
        ///保存当前房源类型
        self.houseType = houseType;
        self.isRefresh = NO;
        
    }
    
    return self;

}

#pragma mark - UI搭建
-(void)createNavigationBarUI
{
    
    ///中间选择列表类型按钮
    QSBaseConfigurationDataModel *tempModel = [QSCoreDataManager getHouseListMainTypeModelWithID:[NSString stringWithFormat:@"%d",self.houseType]];
    self.houseTypePicker = [[QSCustomPickerView alloc] initWithFrame:CGRectMake(5.0f, 22.0f, 80.0f, 40.0f) andPickerType:cCustomPickerTypeNavigationBarHouseMainType andPickerViewStyle:cCustomPickerStyleLeftArrow andCurrentSelectedModel:tempModel andIndicaterCenterXPoint:0.0f andPickedCallBack:^(PICKER_CALLBACK_ACTION_TYPE callBackType,NSString *selectedKey, NSString *selectedVal) {
        
        ///弹出时，回收键盘
        if (pPickerCallBackActionTypeShow == callBackType) {
            
            [self.seachTextField resignFirstResponder];
            
        }
        
        ///选择不同的列表类型，事件处理
        if (pPickerCallBackActionTypePicked == callBackType) {
            
            ///保存类型
            self.houseType = [selectedKey intValue];
            
            ///刷新数据
            [self.searchItemView.header beginRefreshing];
            
        }
        
    }];
    [self.view addSubview:self.houseTypePicker];
    
    ///创建导航栏搜索输入框
    self.seachTextField = [[UISearchBar alloc]initWithFrame:CGRectMake(self.houseTypePicker.frame.origin.x +  self.houseTypePicker.frame.size.width + 8.0f, 27.0f, SIZE_DEVICE_WIDTH - self.houseTypePicker.frame.size.width - 44.0f - 15.0f, 30.0f)];
    self.seachTextField.placeholder = [NSString stringWithFormat:@"请输入小区名称或地址"];
    self.seachTextField.returnKeyType = UIReturnKeySearch;
    self.seachTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.seachTextField.delegate = self;
    self.seachTextField.backgroundImage = [UIImage imageNamed:IMAGE_PUBLIC_SEARCHBAR_BG];
    self.seachTextField.clipsToBounds = YES;
    self.seachTextField.layer.cornerRadius = 6.0f;
    self.seachTextField.layer.borderColor = [COLOR_CHARACTERS_LIGHTGRAY CGColor];
    self.seachTextField.layer.borderWidth = 1.0f;
    [self.view addSubview:self.seachTextField];
    
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
    
    [super createMainShowUI];
    
    ///创建无记录
    self.noRecordsRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    self.noRecordsRootView.hidden = YES;
    [self createNoRecordsUI];
    [self.view addSubview:self.noRecordsRootView];
    
    ///初始化数据源
    self.localDataSource = [NSMutableArray array];
    self.searchDataSource = [[NSMutableArray alloc] init];
    
    self.searchItemView = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) style:UITableViewStylePlain];
    
    ///设置数据源和代理
    self.searchItemView.delegate = self;
    self.searchItemView.dataSource = self;
    self.searchItemView.backgroundColor = [UIColor clearColor];
    
    ///取消滚动条
    self.searchItemView.showsHorizontalScrollIndicator = NO;
    self.searchItemView.showsVerticalScrollIndicator = NO;
    
    ///取消分隔样式
    self.searchItemView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.searchItemView];
    
    ///添加刷新
    [self.searchItemView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getLocalSearchHistoryData)];
    [self.searchItemView.header beginRefreshing];
   
}

///创建无记录提示UI
- (void)createNoRecordsUI
{
    
    ///添加没有搜索历史记录图片
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 75.0f) * 0.5, (SIZE_DEVICE_HEIGHT - 64.0f) / 2.0f - 85.0f, 75.0f, 85.0f)];
    searchImageView.image = [UIImage imageNamed:@"seach_seachstatus"];
    searchImageView.tag = 200;
    [self.noRecordsRootView addSubview:searchImageView];
    
    ///添加没有搜索历史记录
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, searchImageView.frame.origin.y + searchImageView.frame.size.height + 15.0f, SIZE_DEVICE_WIDTH, 30.0f)];
    tipsLabel.text = @"没有搜索历史记录";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    tipsLabel.tag = 201;
    [self.noRecordsRootView addSubview:tipsLabel];
    
}

///返回的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.searchDataSource count];
    
}

#pragma mark - 返回每一个搜索历史记录Cell
///返回每一个搜索记录显示cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *searchItemCell = @"searchItemCell";
    UITableViewCell *cellSearchItem = [tableView dequeueReusableCellWithIdentifier:searchItemCell];
    if (nil == cellSearchItem) {
        
        cellSearchItem = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchItemCell];
        cellSearchItem.backgroundColor = [UIColor whiteColor];
        cellSearchItem.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///分隔线
        UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 44.0f - 0.25f, SIZE_DEVICE_WIDTH - 20.0f, 0.25f)];
        sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [cellSearchItem addSubview:sepLabel];
        
    }
    
    ///搜索记录的标题
    QSLocalSearchHistoryDataModel *dataModel = self.searchDataSource[indexPath.row];
    cellSearchItem.textLabel.text = dataModel.search_keywork;
    
    return cellSearchItem;
    
}

#pragma mark - 设置列表Header信息
///添加列表头部view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if ([self.searchDataSource count] > 0) {
        
        UIButton *headButton=[UIButton createBlockButtonWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
            ///清空当前类型的数据，并刷新UI
            [QSCoreDataManager clearLocalSearchHistoryWithHouseType:self.houseType andCallBack:^(BOOL flag) {
                
                if (flag) {
                    
                    [self.searchItemView.header beginRefreshing];
                    
                }
                
            }];
        
        }];
        headButton.backgroundColor=COLOR_CHARACTERS_YELLOW;
        [headButton setTintColor:COLOR_CHARACTERS_GRAY];
        [headButton setTitle:@"点击清空历史记录" forState:UIControlStateNormal];
        headButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        
        return headButton;
        
    }
    
    return nil;
    
}

///设置列表头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ([self.searchDataSource count] > 0) {
        
        return 44.0f;
        
    }
    
    return 0.0f;
    
}

#pragma mark - 选择搜索历史
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///回收键盘
    [self.seachTextField resignFirstResponder];

    if ([self.searchDataSource count] > 0) {
        
        QSLocalSearchHistoryDataModel *tempModel = self.searchDataSource[indexPath.row];
        
        ///进入房源搜索列表
        QSYSearchHousesViewController *searchHouseVC = [[QSYSearchHousesViewController alloc] initWithHouseType:self.houseType andSearchKey:tempModel.search_keywork];
        searchHouseVC.addNewSearchCallBack = ^(BOOL isAdd,FILTER_MAIN_TYPE houseType){
        
            if (isAdd) {
                
                self.isRefresh = YES;
                QSBaseConfigurationDataModel *tempModel = [QSCoreDataManager getHouseListMainTypeModelWithID:[NSString stringWithFormat:@"%d",houseType]];
                [self.houseTypePicker resetPickerViewCurrentPickedModel:tempModel];
                
            }
        
        };
        [self.navigationController pushViewController:searchHouseVC animated:YES];
        
    }

}

#pragma mark - 获取搜索历史
- (void)getLocalSearchHistoryData
{
    
    ///清空原数据
    [self.localDataSource removeAllObjects];
    [self.searchDataSource removeAllObjects];

    NSArray *tempArray = [QSCoreDataManager getLocalSearchHistoryWithHouseType:self.houseType];
    if ([tempArray count] > 0) {
        
        [self.localDataSource addObjectsFromArray:tempArray];
        [self.searchDataSource addObjectsFromArray:tempArray];
        self.noRecordsRootView.hidden = YES;
        
    } else {
    
        self.noRecordsRootView.hidden = NO;
    
    }
    
    ///刷新数据
    [self.searchItemView reloadData];
    
    ///结束刷新动画
    [self.searchItemView.header endRefreshing];

}

#pragma mark - 点击键盘搜索事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    [self searchBarTextDidEndEditing:searchBar];

}

///键盘回收
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    
    ///保存搜索
    if ([searchBar.text length] > 0) {
        
        NSString *inputString = searchBar.text;
        
        ///保存搜索记录
        QSLocalSearchHistoryDataModel *tempModel = [[QSLocalSearchHistoryDataModel alloc] init];
        tempModel.search_keywork = inputString;
        tempModel.search_time = [NSDate currentDateTimeStamp];
        tempModel.search_type = [NSString stringWithFormat:@"%d",self.houseType];
        
        [QSCoreDataManager addLocalSearchHistory:tempModel andCallBack:^(BOOL flag) {}];
        
        ///刷新列表
        [self.searchItemView.header beginRefreshing];
        
        ///清空原信息
        searchBar.text = nil;
        
        ///进入搜索房源结果页
        QSYSearchHousesViewController *searchHouseVC = [[QSYSearchHousesViewController alloc] initWithHouseType:self.houseType andSearchKey:inputString];
        searchHouseVC.addNewSearchCallBack = ^(BOOL isAdd,FILTER_MAIN_TYPE houseType){
            
            if (isAdd) {
                
                self.isRefresh = YES;
                QSBaseConfigurationDataModel *tempModel = [QSCoreDataManager getHouseListMainTypeModelWithID:[NSString stringWithFormat:@"%d",houseType]];
                [self.houseTypePicker resetPickerViewCurrentPickedModel:tempModel];
                
            }
            
        };
        [self.navigationController pushViewController:searchHouseVC animated:YES];
        
    }
    
}

#pragma mark - 搜索框内容改变时匹配结果
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    ///获取输入的关键字
    NSString *searchKey = searchText;
    
    ///判断是否清空事件
    if (nil == searchText || 0 >= [searchText length]) {
        
        self.noRecordsRootView.hidden = YES;
        [self.searchDataSource removeAllObjects];
        [self.searchDataSource addObjectsFromArray:self.localDataSource];
        [self.searchItemView reloadData];
        return;
        
    }
    
    ///清空原数据
    [self.searchDataSource removeAllObjects];
    
    if (searchKey.length > 0 && ![self isIncludeChineseInString:searchKey]) {
        
        ///搜索关键字转为小写
        NSString *tempSearchKey = [searchKey lowercaseString];
        
        for (int i = 0;i < self.localDataSource.count;i++) {
            
            ///临时模型
            QSLocalSearchHistoryDataModel *tempModel = self.localDataSource[i];
            
            if ([self isIncludeChineseInString:tempModel.search_keywork]) {
                
                HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
                [outputFormat setToneType:ToneTypeWithoutTone];
                [outputFormat setVCharType:VCharTypeWithV];
                [outputFormat setCaseType:CaseTypeLowercase];
                NSString *tempPinYinStr = [PinyinHelper toHanyuPinyinStringWithNSString:tempModel.search_keywork withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
                
                NSRange titleResult = [tempPinYinStr rangeOfString:tempSearchKey options:NSCaseInsensitiveSearch];
                
                if (titleResult.length > 0) {
                    
                    [self.searchDataSource addObject:tempModel];
                    continue;
                    
                }
                
                NSArray *tempArray = [tempPinYinStr componentsSeparatedByString:@" "];
                NSMutableString *tempPinYinHeadStr = [NSMutableString string];
                for (int i = 0; i < [tempArray count]; i++) {
                    
                    NSString *singleWord = tempArray[i];
                    if ([singleWord length] > 0) {
                        
                        char firstChar = [singleWord characterAtIndex:0];
                        if (firstChar >= 97 && firstChar <= 122) {
                            
                            [tempPinYinHeadStr appendString:[singleWord substringToIndex:1]];
                            
                        }
                        
                    }
                    
                }
                
                NSRange titleHeadResult = [tempPinYinHeadStr rangeOfString:searchKey options:NSCaseInsensitiveSearch];
                
                if (titleHeadResult.length > 0) {
                    
                    [self.searchDataSource addObject:tempModel];
                    
                }
                
            } else {
                
                NSRange titleResult = [tempModel.search_keywork rangeOfString:searchKey options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0) {
                    
                    [self.searchDataSource addObject:tempModel];
                    
                }
                
            }
            
        }
        
    } else if (searchKey.length > 0 && [self isIncludeChineseInString:searchKey]) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"search_keywork CONTAINS %@",searchKey];
        [self.searchDataSource addObjectsFromArray:[self.localDataSource filteredArrayUsingPredicate:predicate]];
        
    }
    
    ///判断是否需要显示记录
    if ([self.searchDataSource count] > 0) {
        
        self.noRecordsRootView.hidden = YES;
        
    } else {
    
        self.noRecordsRootView.hidden = NO;
    
    }
    
    ///刷新数据
    [self.searchItemView reloadData];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [super touchesBegan:touches withEvent:event];
    [self.seachTextField resignFirstResponder];

}

#pragma mark - 将要显示时判断是否需要主动刷新
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    if (self.isRefresh) {
        
        self.isRefresh = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.searchItemView.header beginRefreshing];
            
        });
        
    }

}

- (BOOL)isIncludeChineseInString:(NSString*)str
{
    
    for (int i=0; i<str.length; i++) {
        
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            
            return true;
            
        }
        
    }
    
    return false;
    
}

@end
