//
//  QSPOrderCancelReasonViewController.m
//  House
//
//  Created by CoolTea on 15/4/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderCancelReasonViewController.h"
#import "QSPOrderBottomButtonView.h"

@interface QSPOrderCancelReasonViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *reasonList;

@end

@implementation QSPOrderCancelReasonViewController
@synthesize orderID;

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:@"取消预约"];
    
}


///搭建主展示UI
- (void)createMainShowUI
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 40.0f)];
    [titleLabel setBackgroundColor:COLOR_CHARACTERS_GRAY];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:FONT_BODY_16]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"请选择取消预约原因"];
    
    [self.view addSubview:titleLabel];
    
    self.reasonList = [NSMutableArray arrayWithObjects:@"中介骚扰", @"发布虚假信息", @"没有空", @"不想看了", @"其他原因", nil];
    
    QSPOrderBottomButtonView *submitBtView = [[QSPOrderBottomButtonView alloc] initAtTopLeft:CGPointMake(0.0f, 0.0f) withButtonCount:1 andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
        
        switch (buttonType) {
            case bBottomButtonTypeOne:
                
                break;
                
            default:
                break;
        }
        
    }];
    [submitBtView setCenterBtTitle:@"提交"];
    
    ///原因列表
    UITableView *reasonListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, titleLabel.frame.origin.y+titleLabel.frame.size.height, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 40.0f-submitBtView.frame.size.height)];
    
    ///取消滚动条
    reasonListTableView.showsHorizontalScrollIndicator = NO;
    reasonListTableView.showsVerticalScrollIndicator = NO;
    
    ///数据源
    reasonListTableView.dataSource = self;
    reasonListTableView.delegate = self;
    
//    ///取消选择状态
//    reasonListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    reasonListTableView.tableHeaderView = [[UIView alloc] init];
    
    [self.view addSubview:reasonListTableView];

    [submitBtView setFrame:CGRectMake(submitBtView.frame.origin.x, reasonListTableView.frame.origin.y+reasonListTableView.frame.size.height, submitBtView.frame.size.width, submitBtView.frame.size.height)];
    [self.view addSubview:submitBtView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger count = 0;
    if (self.reasonList) {
        count = [self.reasonList count];
    }

    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///复用标签
    static NSString *BookingOrderListsTableViewCellName = @"reasonListsTableViewCell";
    
    ///从复用队列中获取cell
    UITableViewCell *cellSystem = [tableView dequeueReusableCellWithIdentifier:BookingOrderListsTableViewCellName];
    
    ///判断是否需要重新创建
    if (nil == cellSystem) {
        
        cellSystem = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BookingOrderListsTableViewCellName];
        
        ///取消选择状态
//        cellSystem.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return cellSystem;
    
}


@end
