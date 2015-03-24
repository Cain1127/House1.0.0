//
//  QSPOrderDetailBookedViewController.m
//  House
//
//  Created by CoolTea on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailBookedViewController.h"
#import "QSPOrderDetailTitleLabel.h"
#import "QSPOrderDetailShowingsTimeView.h"
#import "QSPHouseSummaryView.h"
#import "QSPOrderDetailAddressView.h"
#import "QSPOrderDetailPersonInfoView.h"
#import "QSPOrderBottomButtonView.h"
#import "QSPOrderBookTimeViewController.h"
#import "QSCoreDataManager+User.h"
#import "QSOrderDetailReturnData.h"
#import "QSCustomHUDView.h"

@interface QSPOrderDetailBookedViewController ()

@property (nonatomic, strong) QSOrderDetailInfoDataModel *orderDetailData;
@property (nonatomic, strong) QSPOrderDetailTitleLabel *titleTipLabel;
@property (nonatomic, strong) QSPOrderDetailShowingsTimeView *showingsTimeView;
@property (nonatomic, strong) QSPHouseSummaryView *houseInfoSView;
@property (nonatomic, strong) QSPOrderDetailAddressView *addressView;
@property (nonatomic, strong) QSPOrderDetailPersonInfoView *personView;

@end

@implementation QSPOrderDetailBookedViewController
@synthesize orderData;

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:TITLE_VIEWCONTROLLER_TITLE_BOOKINGORDERSLIST];
    
}


///搭建主展示UI
- (void)createMainShowUI
{
    ///头部标题
    NSString *titleTip = @"";
    
    ///预约时间
    NSMutableArray *timeArray = nil;
    
    ///房源数据
    id houseData = nil;
    
    //订单数据
    id orderList = nil;
    
    if (self.orderData && [self.orderData isKindOfClass:[QSOrderListItemData class]]) {
        
        if (self.orderData.orderInfoList&&[self.orderData.orderInfoList count]>0) {
            
            orderList = self.orderData.orderInfoList;
            
            QSOrderListOrderInfoDataModel *orderItem = [self.orderData.orderInfoList objectAtIndex:0];
            if (orderItem&&[orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                titleTip = [orderItem getStatusStr];
            }
            
            NSString *timeStr = [NSString stringWithFormat:@"%@ %@-%@",orderItem.appoint_date,orderItem.appoint_start_time,orderItem.appoint_end_time];
            
            timeArray = [NSMutableArray arrayWithObjects:timeStr, nil];
            
        }
        
        if (self.orderData.houseData) {
            houseData = self.orderData.houseData;
        }
        
    }
    
    self.titleTipLabel = [[QSPOrderDetailTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 44) withTitle:titleTip];
    [self.view addSubview:self.titleTipLabel];
    
    //底部按钮
    QSPOrderBottomButtonView *changeOrderButtonView = [[QSPOrderBottomButtonView alloc] initAtTopLeft:CGPointZero withButtonCount:1 andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
        
        NSLog(@"changeOrderButton");
        QSPOrderBookTimeViewController *bookTimeVc = [[QSPOrderBookTimeViewController alloc] init];
        [bookTimeVc setVcType:bBookTypeViewControllerChange];
        if (self.orderData) {
            
        }
//        [bookTimeVc setHouseInfo:<#(QSWSecondHouseInfoDataModel *)#>];
        [self.navigationController pushViewController:bookTimeVc animated:YES];
        
    }];
    [changeOrderButtonView setFrame:CGRectMake(changeOrderButtonView.frame.origin.x, SIZE_DEVICE_HEIGHT -changeOrderButtonView.frame.size.height, changeOrderButtonView.frame.size.width, changeOrderButtonView.frame.size.height)];
    [self.view addSubview:changeOrderButtonView];
    
    QSScrollView *scrollView = [[QSScrollView alloc] initWithFrame:CGRectMake(_titleTipLabel.frame.origin.x, _titleTipLabel.frame.origin.y+_titleTipLabel.frame.size.height, SIZE_DEVICE_WIDTH, changeOrderButtonView.frame.origin.y-(_titleTipLabel.frame.origin.y+_titleTipLabel.frame.size.height))];
    [self.view addSubview:scrollView];
    
    ///看房时间
    self.showingsTimeView = [[QSPOrderDetailShowingsTimeView alloc] initAtTopLeft:CGPointMake(0.0f, 0.0f) withTimeData:timeArray];
    [scrollView addSubview:self.showingsTimeView];
    
    ///房源简介
    self.houseInfoSView = [[QSPHouseSummaryView alloc] initAtTopLeft:CGPointMake(0.0f, self.showingsTimeView.frame.origin.y+self.showingsTimeView.frame.size.height) withHouseData:houseData andCallBack:^(UIButton *button) {
        NSLog(@"房源 clickBt");
    }];
    [scrollView addSubview:_houseInfoSView];
    ///将房源简介引用添加进看房时间控件管理作动态高度扩展
    [self.showingsTimeView addAfterView:&_houseInfoSView];
    
    ///地址栏
    self.addressView = [[QSPOrderDetailAddressView alloc] initAtTopLeft:CGPointMake(0.0f, self.houseInfoSView.frame.origin.y+self.houseInfoSView.frame.size.height) withHouseData:houseData andCallBack:^(UIButton *button) {
        
        NSLog(@"地图定位 clickBt");
        
        if (!self.orderDetailData || ![self.orderDetailData isKindOfClass:[QSOrderDetailInfoDataModel class]]) {
            NSLog(@"QSOrderDetailInfoDataModel 错误");
            return;
        }
        if (self.orderDetailData.house_msg) {
            
            //房源坐标
//            self.orderDetailData.house_msg.coordinate_x;
//            self.orderDetailData.house_msg.coordinate_y;
            
        }
        
    }];
    [scrollView addSubview:_addressView];
    ///将地址栏引用添加进看房时间控件管理作动态高度扩展
    [self.showingsTimeView addAfterView:&_addressView];
    
    //业主信息栏
    self.personView = [[QSPOrderDetailPersonInfoView alloc] initAtTopLeft:CGPointMake(0.0f, _addressView.frame.origin.y+_addressView.frame.size.height) withOrderData:self.orderData andCallBack:^(UIButton *button) {
        
        NSLog(@"askButton");
        
    }];
    [scrollView addSubview:self.personView];
    ///将业主信息栏引用添加进看房时间控件管理作动态高度扩展
    [self.showingsTimeView addAfterView:&_personView];

    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, self.personView.frame.origin.y+self.personView.frame.size.height)];
    
    
    [self getDetailData];
    
}

- (void)updateData:(id)data
{
    
    if (!data || ![data isKindOfClass:[QSOrderDetailInfoDataModel class]]) {
        NSLog(@"QSOrderDetailInfoDataModel 错误");
        return;
    }
    
    QSOrderDetailInfoDataModel *detailData = (QSOrderDetailInfoDataModel*)data;
    
    if (_titleTipLabel) {
        [_titleTipLabel setTitle:[detailData getStatusStr]];
    }
    
    if (_houseInfoSView) {
        [_houseInfoSView setHouseData:detailData.house_msg];
    }
    
    if (_addressView) {
        [_addressView setHouseData:detailData.house_msg];
    }
    
    if (_personView) {
        [_personView setOrderData:self.orderDetailData];
    }
    
    if (_showingsTimeView) {
        [_showingsTimeView setTimeData:detailData.appoint_list];
    }
    
}

- (void)getDetailData
{
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    NSString *orderID = nil;
    if (self.orderData && [self.orderData isKindOfClass:[QSOrderListItemData class]]) {
        if (self.orderData.orderInfoList&&[self.orderData.orderInfoList count]>0) {
            
            QSOrderListOrderInfoDataModel *orderItem = [self.orderData.orderInfoList objectAtIndex:0];
            if (orderItem&&[orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                
                orderID = orderItem.id_;
                
            }
        }
    }
    
    if (!orderID || [orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            [self.navigationController popViewControllerAnimated:YES];
        })
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
//    id_	true	string	订单id
//    user_id	true	string	获取的用户id
    
    [tempParam setObject:orderID forKey:@"id_"];
    //TODO:获取用户ID
    NSString *userID = [QSCoreDataManager getUserID];
    [tempParam setObject:(userID ? userID : @"1") forKey:@"user_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderDetailData andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSOrderDetailReturnData *headerModel = resultData;
        
        ///转换模型
        if (rRequestResultTypeSuccess == resultStatus) {
            
            self.orderDetailData = headerModel.orderDetailData;
            [self updateData:self.orderDetailData];
            
        }else{
            
            if (headerModel&&[headerModel isKindOfClass:[QSHeaderDataModel class]]) {
                TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.info, 1.0f, ^(){
                
                    [self.navigationController popViewControllerAnimated:YES];
                    
                })
            }
            
        }
        
        [hud hiddenCustomHUD];
        
    }];
    
}

@end
