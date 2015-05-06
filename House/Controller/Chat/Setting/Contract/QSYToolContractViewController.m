//
//  QSYToolContractViewController.m
//  House
//
//  Created by ysmeng on 15/4/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYToolContractViewController.h"
#import "QSYLocalHTMLShowViewController.h"

#import "QSBlockButtonStyleModel+Normal.h"

///模板类型
typedef enum
{

    cContractTempletTypeRent = 99,  //!<租房相关的合同
    cContractTempletTypeBuy,        //!<售房相关的合同

}CONTRACT_TEMPLET_TYPE;

@interface QSYToolContractViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *listView;     //!<列表
@property (nonatomic,retain) NSMutableArray *dataSource;//!<合同模板列表

@end

@implementation QSYToolContractViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"合同模板"];
    
}

- (void)createMainShowUI
{
    
    ///初始化数据
    self.dataSource = [NSMutableArray array];
    [self setDataSourceWithType:cContractTempletTypeRent];
    
    ///指示三角指针
    __block UIImageView *arrowIndicator;
    
    ///按钮指针
    __block UIButton *rentGuideButton;
    __block UIButton *salGuideButton;
    
    ///尺寸
    CGFloat widthButton = SIZE_DEVICE_WIDTH / 2.0f;
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.bgColorSelected = COLOR_CHARACTERS_LIGHTYELLOW;
    buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_16];
    
    ///租房合同
    buttonStyle.title = @"租房合同";
    rentGuideButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 64.0f, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///当前已处于选择状态
        if (button.selected) {
            
            return;
            
        }
        
        ///切换按钮状态
        button.selected = YES;
        salGuideButton.selected = NO;
        
        ///移动指示器
        [UIView animateWithDuration:0.3f animations:^{
            
            arrowIndicator.frame = CGRectMake(button.frame.origin.x + button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            ///重构数据源并刷新
            [self setDataSourceWithType:cContractTempletTypeRent];
            [self.listView reloadData];
            
        }];
        
    }];
    rentGuideButton.selected = YES;
    [self.view addSubview:rentGuideButton];
    
    ///售房合同
    buttonStyle.title = @"售房合同";
    salGuideButton = [UIButton createBlockButtonWithFrame:CGRectMake(rentGuideButton.frame.origin.x + rentGuideButton.frame.size.width, 64.0f, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///当前已处于选择状态
        if (button.selected) {
            
            return;
            
        }
        
        ///切换按钮状态
        button.selected = YES;
        rentGuideButton.selected = NO;
        
        ///移动指示器
        [UIView animateWithDuration:0.3f animations:^{
            
            arrowIndicator.frame = CGRectMake(button.frame.origin.x + button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            ///重构数据源并刷新
            [self setDataSourceWithType:cContractTempletTypeBuy];
            [self.listView reloadData];
            
        }];
        
    }];
    [self.view addSubview:salGuideButton];
    
    ///分隔线
    UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 64.0f + 44.0f - 0.25f, SIZE_DEVICE_WIDTH, 0.25f)];
    sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLineLabel];
    
    ///指示三角
    arrowIndicator = [[QSImageView alloc] initWithFrame:CGRectMake(rentGuideButton.frame.origin.x+rentGuideButton.frame.size.width / 2.0f - 7.5f, rentGuideButton.frame.origin.y + rentGuideButton.frame.size.height - 5.0f, 15.0f, 5.0f)];
    arrowIndicator.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [self.view addSubview:arrowIndicator];
    
    ///列表
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f + 44.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f) style:UITableViewStylePlain];
    self.listView.showsHorizontalScrollIndicator = NO;
    self.listView.showsVerticalScrollIndicator = NO;
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.listView.dataSource = self;
    self.listView.delegate = self;
    
    [self.view addSubview:self.listView];
    
}

#pragma mark - 列表格式设置
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.dataSource count];

}

#pragma mark - 返回每项模板
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *normalCell = @"normalCell";
    UITableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCell];
    if (nil == cellNormal) {
        
        cellNormal = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
        cellNormal.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cellNormal.textLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        cellNormal.textLabel.adjustsFontSizeToFitWidth = YES;
        cellNormal.textLabel.minimumScaleFactor = 12.0f;
        cellNormal.textLabel.numberOfLines = 2;
        cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ///分隔线
        UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f - 0.25f, SIZE_DEFAULT_MAX_WIDTH, 0.25f)];
        sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [cellNormal.contentView addSubview:sepLabel];
        
    }
    
    cellNormal.textLabel.text = [self.dataSource[indexPath.row] valueForKey:@"title"];
    
    return cellNormal;

}

#pragma mark - 查看详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row >= [self.dataSource count]) {
        
        return;
        
    }
    
    ///进入说明页
    QSYLocalHTMLShowViewController *detailVC = [[QSYLocalHTMLShowViewController alloc] initWithTitle:@"说明" andLocalHTMLFileName:[self.dataSource[indexPath.row] valueForKey:@"file_name"]];
    [self.navigationController pushViewController:detailVC animated:YES];

}

#pragma mark - 根据给定的类型，设置数据源
- (void)setDataSourceWithType:(CONTRACT_TEMPLET_TYPE)contractType
{

    ///配置信息文件路径
    NSString *infoPath = [[NSBundle mainBundle] pathForResource:PLIST_FILE_NAME_CHAT_TOOL_CONTRACT ofType:PLIST_FILE_TYPE];
    NSDictionary *rootDict = [NSDictionary dictionaryWithContentsOfFile:infoPath];
    
    switch (contractType) {
            ///售房相关合同模板
        case cContractTempletTypeBuy:
        {
            
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[rootDict valueForKey:@"sale_contract_list"]];
            
        }
            break;
            
            ///租房相关合同模板
        case cContractTempletTypeRent:
        {
            
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[rootDict valueForKey:@"rent_contract_list"]];
            
        }
            break;
            
        default:
            break;
    }

}

@end
