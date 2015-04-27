//
//  QSPOrderCancelReasonViewController.m
//  House
//
//  Created by CoolTea on 15/4/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderCancelReasonViewController.h"
#import "QSPOrderBottomButtonView.h"
#import "QSCustomHUDView.h"
#import "QSPOrderDetailActionReturnBaseDataModel.h"
#import "QSPOrderSubmitResultViewController.h"
#import "QSYShakeRecommendHouseViewController.h"
#import "QSPOrderDetailBookedViewController.h"

@interface QSPOrderCancelReasonViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *reasonList;
@property (nonatomic,strong) UITableView *reasonListTableView;

@end

@implementation QSPOrderCancelReasonViewController
@synthesize orderID, houseType;

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:@"取消预约"];
    
}


///搭建主展示UI
- (void)createMainShowUI
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 40.0f)];
    [titleLabel setBackgroundColor:COLOR_CHARACTERS_GRAY];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:FONT_BODY_18]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"请选择取消预约原因"];
    
    [self.view addSubview:titleLabel];
    
    self.reasonList = [NSMutableArray arrayWithObjects:@"中介骚扰", @"发布虚假信息", @"没有空", @"不想看了", @"其他原因", nil];
    
    QSPOrderBottomButtonView *submitBtView = [[QSPOrderBottomButtonView alloc] initAtTopLeft:CGPointMake(0.0f, 0.0f) withButtonCount:1 andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
        
        switch (buttonType) {
            case bBottomButtonTypeOne:
                [self cancelAppointmentOrder];
                break;
                
            default:
                break;
        }
        
    }];
    [submitBtView setCenterBtTitle:@"提交"];
    
    ///原因列表
    self.reasonListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, titleLabel.frame.origin.y+titleLabel.frame.size.height, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 40.0f-submitBtView.frame.size.height)];
    
    ///取消滚动条
    self.reasonListTableView.showsHorizontalScrollIndicator = NO;
    self.reasonListTableView.showsVerticalScrollIndicator = NO;
    
    ///数据源
    self.reasonListTableView.dataSource = self;
    self.reasonListTableView.delegate = self;
    
//    ///取消选择状态
//    reasonListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.reasonListTableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.reasonListTableView];

    [submitBtView setFrame:CGRectMake(submitBtView.frame.origin.x, self.reasonListTableView.frame.origin.y+self.reasonListTableView.frame.size.height, submitBtView.frame.size.width, submitBtView.frame.size.height)];
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
//        [cellSystem setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cellSystem.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cellSystem.textLabel setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
        
    }
    
    [cellSystem.textLabel setText:[self.reasonList objectAtIndex:indexPath.row]];
    
    return cellSystem;
    
}


#pragma mark - 请求取消预约订单
- (void)cancelAppointmentOrder
{
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        return;
    }
    
    NSIndexPath *selectedIndexPath = nil;
    if (self.reasonListTableView) {
        selectedIndexPath = [self.reasonListTableView indexPathForSelectedRow];
    }
    if (selectedIndexPath) {
        NSLog(@"selectedIndexPath : %ld",(long)selectedIndexPath.row);
        
    }else{
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择您要取消预约的原因", 1.0f, ^(){})
        return;
    }
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    //    必选	类型及范围	说明
    //    user_id	true	int	用户id
    //    order_id	true	string	订单id
    //    cause	true	string	取消的原因，字符串（暂定）
    
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    [tempParam setObject:[self.reasonList objectAtIndex:selectedIndexPath.row] forKey:@"cause"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderCancelAppointment andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        ///转换模型
        if (rRequestResultTypeSuccess == resultStatus) {
    
            TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.info, 1.0f, ^(){
                QSPOrderSubmitResultViewController *srVc = [[QSPOrderSubmitResultViewController alloc] initWithResultType:oOrderSubmitResultTypeCancelSuccessed andAutoBackCallBack:^(ORDER_SUBMIT_RESULT_BACK_TYPE backType){
                    
                    switch (backType) {
                        case oOrderSubmitResultBackTypeAuto:
                            
                            NSLog(@"auto back");
                            [self setTurnBackDistanceStep:2];
                            [self gotoTurnBackAction];
                            
                            break;
                        case oOrderSubmitResultBackTypeToDetail:
                            
                            NSLog(@"back 查看预约详情");
//                            {
//                                QSPOrderDetailBookedViewController *bookedVc = [[QSPOrderDetailBookedViewController alloc] init];
//                                [bookedVc setOrderID:orderID];
//                                [bookedVc setTurnBackDistanceStep:4];
//                                [bookedVc setOrderType:mOrderWithUserTypeAppointment];
//                                [self.navigationController pushViewController:bookedVc animated:NO];
//                            }
                            break;
                        case oOrderSubmitResultBackTypeToMoreHouse:
                            
                            NSLog(@"back 查看推荐房源");
                            {
                                QSYShakeRecommendHouseViewController *shakeRecommendHouseVC = [[QSYShakeRecommendHouseViewController alloc] initWithHouseType:houseType];
                                [self.navigationController pushViewController:shakeRecommendHouseVC animated:YES];
                                [shakeRecommendHouseVC setTurnBackDistanceStep:4];
                            }
                            break;
                        default:
                            break;
                    }
                    
                    
                }];
                
                [self presentViewController:srVc animated:YES completion:^{
                    
                }];
            })
    
        }
        
        ///转换模型
        if (headerModel) {
            
            if (headerModel&&[headerModel isKindOfClass:[QSPOrderDetailActionReturnBaseDataModel class]]) {
                TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.msg, 1.0f, ^(){
                    
                    
                })
            }else if (headerModel&&[headerModel isKindOfClass:[QSHeaderDataModel class]]) {
                TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.info, 1.0f, ^(){
                    
                    
                })
            }
            
        }
        
        [hud hiddenCustomHUD];
        
    }];
}


@end
