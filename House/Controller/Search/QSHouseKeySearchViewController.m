//
//  QSHouseKeySearchViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHouseKeySearchViewController.h"
#import "ColorHeader.h"
#import "ImageHeader.h"
#import "QSCoreDataManager+SearchHistory.h"

@interface QSHouseKeySearchViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,retain) NSMutableArray *localSearchHistoryDataSource;//!<数据源

@end

@implementation QSHouseKeySearchViewController

#pragma mark -重写数据源
-(void)setDataSource:(NSMutableArray *)dataSource
{
    
//    [QSCoreDataManager addLocalSearchHistory:(QSCDLocalSearchHistoryDataModel *)]
    
    ///获取本地搜索历史
    self.localSearchHistoryDataSource = [[NSMutableArray alloc] initWithArray:[QSCoreDataManager getLocalSearchHistory]];
  
}


#pragma mark -添加导航栏视图
-(void)createNavigationBarUI
{
    [super createNavigationBarUI];
    
   ///创建导航栏搜索输入框
    UITextField *seachTextField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH-150.0f, 30.0f)];
    
    seachTextField.backgroundColor=[UIColor whiteColor];
    
    ///设置站位文字
    seachTextField.placeholder=[NSString stringWithFormat:@"请输入小区名称或地址"];
    
    /// 设置字体与边框类型
    seachTextField.font=[UIFont systemFontOfSize:14.0f];
    seachTextField.borderStyle=UITextBorderStyleRoundedRect;
    
    ///设置键盘的返回按钮点击类型
    seachTextField.returnKeyType=UIReturnKeySearch;
    seachTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    
    seachTextField.delegate=self;
    
    ///添加导航栏中间搜索栏
    [self setNavigationBarMiddleView:seachTextField];
    
    
    ///添加右侧交叉按钮
    __weak UIViewController *weakSelf = self;
    UIButton *corssButton=[UIButton createBlockButtonWithButtonStyle:nil andCallBack:^(UIButton *button) {
        
        if ([weakSelf respondsToSelector:@selector(gotoTurnBackAction)]) {
            
            [weakSelf performSelector:@selector(gotoTurnBackAction)];
            
        }
        
    }];
   
    [corssButton setImage:[UIImage imageNamed:IMAGE_NAVIGATIONBAR_CORSS_NORMAL] forState:UIControlStateNormal];
    
    //添加导航栏右边图片
    [self setNavigationBarRightView:corssButton];
    
}

#pragma mark -添加中间视图
- (void)createMainShowUI
{
    [super createMainShowUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (self.localSearchHistoryDataSource) {
        
        ///加载有搜索历史界面
        [self setupTableView];
        
    }
    
    ///加载没有搜索历史记录界面
    [self setupHistoryView];
    
   
   
}

///添加没有搜索历史记录界面
-(void)setupHistoryView
{
    
    ///添加没有搜索历史记录图片
    UIImageView *seachImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH *0.5 -40.0f, 150.0f, 75.0f, 85.0f)];
    seachImageView.image=[UIImage imageNamed:IMAGE_SEARCH_SEARCHSTATUS];
    [self.view addSubview:seachImageView];
    
    
    ///添加没有搜索历史记录
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 240.0f, SIZE_DEVICE_WIDTH, 30.0f)];
    label.text=@"没有搜索历史记录";
    
    ///设置文字居中
    label.textAlignment=NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    
}

///添加tableView
-(void)setupTableView
{
 
    CGRect rect=CGRectMake(0, 64, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-64.0f-49.0f);
    UITableView *tableView=[[UITableView alloc]initWithFrame:rect];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];

}

///返回的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 5;
    
}

#pragma mark - 返回每一个搜索历史记录Cell
///返回每一个搜索记录显示cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   static NSString *acell=@"cellIndentifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:acell];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:acell];
        
        cell.textLabel.text=@"历史搜索关键词";
        
        cell.textLabel.text=_localSearchHistoryDataSource[0];
    }
    return cell;
}

#pragma mark -设置列表Header信息
///添加列表头部view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIButton *headButton=[UIButton createBlockButtonWithFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        NSLog(@"清空历史记录");
    }];
    
    headButton.backgroundColor=COLOR_CHARACTERS_YELLOW;
  
    [headButton setTintColor:COLOR_CHARACTERS_NORMAL];
    [headButton setTitle:@"点击清空历史记录" forState:UIControlStateNormal];
    
    headButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;

    return headButton;
    
}

///设置列表头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 44.0f;
    
}

#pragma mark - 键盘回收事件
///键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    NSLog(@"搜索内容%@",textField.text);
    NSLog(@"搜索返回的内容%@",self.localSearchHistoryDataSource);
    
    return YES;
    
}
@end
