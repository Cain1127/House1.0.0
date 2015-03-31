//
//  QSPOrderDetailBookedViewController.m
//  House
//
//  Created by CoolTea on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailBookedViewController.h"
#import "QSPOrderBookTimeViewController.h"
#import "QSCoreDataManager+User.h"
#import "QSOrderDetailReturnData.h"
#import "QSCustomHUDView.h"

#import "QSPOrderDetailTitleLabel.h"
#import "QSPOrderDetailShowingsTimeView.h"
#import "QSPOrderDetailHouseInfoView.h"
#import "QSPOrderDetailAddressView.h"
#import "QSPOrderDetailPersonInfoView.h"
#import "QSPOrderBottomButtonView.h"
#import "QSPOrderDetailShowingsActivitiesView.h"
#import "QSPOrderDetailHousePriceView.h"
#import "QSPOrderDetailActivitiesPhoneView.h"
#import "QSPOrderDetailOtherPriceView.h"
#import "QSPOrderDetailMyPriceView.h"
#import "QSPOrderDetailInputMyPriceView.h"
#import "QSPOrderDetailTransactionPriceView.h"
#import "QSPOrderDetailBargainingPriceHistoryView.h"
#import "QSPOrderDetailRemarkRejectPriceView.h"
#import "QSPOrderDetailOrderCancelByOwnerTipView.h"
#import "QSPOrderDetailCommentNoteTipsView.h"
#import "QSPOrderDetailOrderCancelByMeTipView.h"
#import "QSPOrderDetailComplaintAndCommentButtonView.h"
#import "QSPOrderDetailAppointAgainAndPriceAgainButtonView.h"
#import "QSPOrderDetailAppointAgainAndRejectPriceButtonView.h"
#import "QSPOrderDetailRejectAndAcceptAppointmentButtonView.h"
#import "QSPOrderDetailCancelTransAndWarmBuyerButtonView.h"
#import "QSPOrderDetailChangeOrderButtonView.h"
#import "QSPOrderDetailConfirmOrderButtonView.h"
#import "QSPOrderDetailSubmitPriceButtonView.h"
#import "QSPOrderDetailAppointmentSalerAgainButtonView.h"
#import "QSPOrderDetailChangeAppointmentButtonView.h"

@interface QSPOrderDetailBookedViewController ()

@property (nonatomic, strong) UIView *contentBgView;

@property (nonatomic, strong) QSOrderDetailInfoDataModel *orderDetailData;

@property (nonatomic, strong) QSPOrderDetailTitleLabel *titleTipLabel;          //!<详情标题View
@property (nonatomic, strong) QSPOrderDetailShowingsTimeView *showingsTimeView; //!<看房时间View
@property (nonatomic, strong) QSPOrderDetailShowingsActivitiesView *showingsActivitiesView; //!<看房活动简介View
@property (nonatomic, strong) QSPOrderDetailHouseInfoView *houseInfoView;  //!<房源简介View
@property (nonatomic, strong) QSPOrderDetailHousePriceView *housePriceView;         //!<房源售价单价View
@property (nonatomic, strong) QSPOrderDetailAddressView *addressView;   //!<地址栏View
@property (nonatomic, strong) QSPOrderDetailPersonInfoView *personView; //!<业主信息View
@property (nonatomic, strong) QSPOrderDetailActivitiesPhoneView *activitiesPhoneView;    //!<看房活动联系电话View
@property (nonatomic, strong) QSPOrderDetailOtherPriceView *otherPriceView;         //!<对方出价View
@property (nonatomic, strong) QSPOrderDetailMyPriceView *myPriceView;            //!<我的出价View
@property (nonatomic, strong) QSPOrderDetailInputMyPriceView *inputMyPriceView;       //!<输入我的出价View
@property (nonatomic, strong) QSPOrderDetailTransactionPriceView *transactionPriceView;   //!<最后成交价View
@property (nonatomic, strong) QSPOrderDetailBargainingPriceHistoryView *bargainingPriceHistoryView; //!<和对方议价记录View
@property (nonatomic, strong) QSPOrderDetailRemarkRejectPriceView *remarkRejectPriceView;  //!<备注:拒绝还价将视为取消订单View
@property (nonatomic, strong) QSPOrderDetailOrderCancelByOwnerTipView *orderCancelByOwnerTipView;     //!<订单取消原因：业主取消预约View
@property (nonatomic, strong) QSPOrderDetailCommentNoteTipsView *commentNoteTipsView;    //!<预约结束评价提示View
@property (nonatomic, strong) QSPOrderDetailOrderCancelByMeTipView *orderCancelByMeTipView;     //!<订单取消原因：我取消预约View
@property (nonatomic, strong) QSPOrderDetailComplaintAndCommentButtonView *complaintAndCommentButtonView;  //!<我要投诉和评价房源按钮View
@property (nonatomic, strong) QSPOrderDetailAppointAgainAndPriceAgainButtonView *appointAgainAndPriceAgainButtonView;  //!<再次预约和我要议价按钮View
@property (nonatomic, strong) QSPOrderDetailAppointAgainAndRejectPriceButtonView *appointAgainAndRejectPriceButtonView;  //!<再次预约和拒绝还价按钮View
@property (nonatomic, strong) QSPOrderDetailRejectAndAcceptAppointmentButtonView *rejectAndAcceptAppointmentButtonView;    //!<拒绝预约和接受预约按钮View
@property (nonatomic, strong) QSPOrderDetailCancelTransAndWarmBuyerButtonView *cancelTransactionAndWarmBuyerButtonView;    //!<取消成交和提醒房客按钮View
@property (nonatomic, strong) QSPOrderDetailChangeOrderButtonView *changeOrderButtonView;  //!<修改订单按钮View
@property (nonatomic, strong) QSPOrderDetailConfirmOrderButtonView *confirmOrderButtonView; //!<房源非常满意，我要成交按钮View
@property (nonatomic, strong) QSPOrderDetailSubmitPriceButtonView *submitPriceButtonView;  //!<提交出价按钮View
@property (nonatomic, strong) QSPOrderDetailAppointmentSalerAgainButtonView *appointmentSalerAgainButtonView;    //!<重新预约业主按钮View
@property (nonatomic, strong) QSPOrderDetailChangeAppointmentButtonView *changeAppointmentButtonView;    //!<修改预约按钮View


@end

@implementation QSPOrderDetailBookedViewController
@synthesize orderListItemData, selectedIndex, orderID;

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:TITLE_VIEWCONTROLLER_TITLE_BOOKINGORDERSLIST];
    
}


///搭建主展示UI
- (void)createMainShowUI
{
    
    self.contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.contentBgView];
    
    [self getDetailData];
}

- (void)createSubViewsUI
{
    ///头部标题
    NSString *titleTip = @"";
    
    ///预约时间
    NSMutableArray *timeArray = nil;
    
    ///房源数据
    id houseData = nil;
    
    //议价历史列表数据
    id bargainList = nil;
    
//    if (self.orderListItemData && [self.orderListItemData isKindOfClass:[QSOrderListItemData class]]) {
//        
//        if (self.orderListItemData.orderInfoList&&[self.orderListItemData.orderInfoList count]>0) {
//            
//            orderList = self.orderListItemData.orderInfoList;
//            
//            QSOrderListOrderInfoDataModel *orderItem = [self.orderListItemData.orderInfoList objectAtIndex:selectedIndex];
//            if (orderItem&&[orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
//                titleTip = [orderItem getStatusTitle];
//            }
//            
//            NSString *timeStr = [NSString stringWithFormat:@"%@ %@-%@",orderItem.appoint_date,orderItem.appoint_start_time,orderItem.appoint_end_time];
//            
//            timeArray = [NSMutableArray arrayWithObjects:timeStr, nil];
//            
//        }
//        
//        if (self.orderListItemData.houseData) {
//            houseData = self.orderListItemData.houseData;
//        }
//        
//    }
    
    if (self.orderDetailData) {
        
        titleTip = [self.orderDetailData getStatusTitle];
        timeArray = [NSMutableArray arrayWithArray:self.orderDetailData.appoint_list];
        houseData = self.orderDetailData.house_msg;
        bargainList = self.orderDetailData.bargain_list;
    }
    
    self.titleTipLabel = [[QSPOrderDetailTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 44) withTitle:titleTip];
    [self.contentBgView addSubview:self.titleTipLabel];
    
    //底部按钮
    QSPOrderBottomButtonView *changeOrderButtonView = [[QSPOrderBottomButtonView alloc] initAtTopLeft:CGPointZero withButtonCount:1 andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
        
        NSLog(@"changeOrderButton");
        QSPOrderBookTimeViewController *bookTimeVc = [[QSPOrderBookTimeViewController alloc] init];
        [bookTimeVc setVcType:bBookTypeViewControllerChange];
        if (self.orderDetailData) {
            
        }
        //        [bookTimeVc setHouseInfo:<#(QSWSecondHouseInfoDataModel *)#>];
        [self.navigationController pushViewController:bookTimeVc animated:YES];
        
    }];
    [changeOrderButtonView setFrame:CGRectMake(changeOrderButtonView.frame.origin.x, SIZE_DEVICE_HEIGHT -changeOrderButtonView.frame.size.height, changeOrderButtonView.frame.size.width, changeOrderButtonView.frame.size.height)];
    [self.contentBgView addSubview:changeOrderButtonView];
    
    QSScrollView *scrollView = [[QSScrollView alloc] initWithFrame:CGRectMake(_titleTipLabel.frame.origin.x, _titleTipLabel.frame.origin.y+_titleTipLabel.frame.size.height, SIZE_DEVICE_WIDTH, changeOrderButtonView.frame.origin.y-(_titleTipLabel.frame.origin.y+_titleTipLabel.frame.size.height))];
    [self.contentBgView addSubview:scrollView];
    
    ///看房时间
    self.showingsTimeView = [[QSPOrderDetailShowingsTimeView alloc] initAtTopLeft:CGPointMake(0.0f, 0.0f) withTimeData:timeArray];
    [scrollView addSubview:self.showingsTimeView];
    
    ///房源简介
    self.houseInfoView = [[QSPOrderDetailHouseInfoView alloc] initAtTopLeft:CGPointMake(0.0f, self.showingsTimeView.frame.origin.y+self.showingsTimeView.frame.size.height) withHouseData:houseData andCallBack:^(UIButton *button) {
        NSLog(@"房源 clickBt");
    }];
    [scrollView addSubview:_houseInfoView];
    ///将房源简介引用添加进看房时间控件管理作动态高度扩展
    [self.showingsTimeView addAfterView:&_houseInfoView];
    
    ///房源价格
    self.housePriceView = [[QSPOrderDetailHousePriceView alloc] initAtTopLeft:CGPointMake(0.0f, self.houseInfoView.frame.origin.y+self.houseInfoView.frame.size.height) withHouseData:houseData andCallBack:^(UIButton *button) {
        NSLog(@" clickBt");
    }];
    [scrollView addSubview:_housePriceView];
    ///将房源价格引用添加进看房时间控件管理作动态高度扩展
    [self.showingsTimeView addAfterView:&_housePriceView];
    
    ///地址栏
    self.addressView = [[QSPOrderDetailAddressView alloc] initAtTopLeft:CGPointMake(0.0f, self.housePriceView.frame.origin.y+self.housePriceView.frame.size.height) withHouseData:houseData andCallBack:^(UIButton *button) {
        
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
    self.personView = [[QSPOrderDetailPersonInfoView alloc] initAtTopLeft:CGPointMake(0.0f, _addressView.frame.origin.y+_addressView.frame.size.height) withOrderData:self.orderDetailData andCallBack:^(UIButton *button) {
        
        NSLog(@"askButton");
        
    }];
    [scrollView addSubview:self.personView];
    ///将业主信息栏引用添加进看房时间控件管理作动态高度扩展
    [self.showingsTimeView addAfterView:&_personView];
    
    ///对方出价View
    self.otherPriceView = [[QSPOrderDetailOtherPriceView alloc] initAtTopLeft:CGPointMake(0.0f, _personView.frame.origin.y+_personView.frame.size.height) withOrderData:self.orderDetailData andCallBack:^(UIButton *button) {
        
        NSLog(@"接受房价Button");
        
    }];
    [scrollView addSubview:self.otherPriceView];
    ///将对方出价View引用添加进看房时间控件管理作动态高度扩展
    [self.showingsTimeView addAfterView:&_otherPriceView];
    
    ///我的出价View
    self.myPriceView = [[QSPOrderDetailMyPriceView alloc] initAtTopLeft:CGPointMake(0.0f, _otherPriceView.frame.origin.y+_otherPriceView.frame.size.height) withOrderData:self.orderDetailData andCallBack:^(UIButton *button) {
        
        NSLog(@"接受房价Button");
        
    }];
    [scrollView addSubview:self.myPriceView];
    ///将我的出价View引用添加进看房时间控件管理作动态高度扩展
    [self.showingsTimeView addAfterView:&_myPriceView];
    
    ///和对方议价记录View
    self.bargainingPriceHistoryView = [[QSPOrderDetailBargainingPriceHistoryView alloc] initAtTopLeft:CGPointMake(0.0f, self.myPriceView.frame.origin.y+self.myPriceView.frame.size.height) withOrderData:self.orderDetailData];
    [scrollView addSubview:self.bargainingPriceHistoryView];
    ///将和对方议价记录View引用添加进看房时间控件管理作动态高度扩展
    [self.showingsTimeView addAfterView:&_bargainingPriceHistoryView];
    
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, self.bargainingPriceHistoryView.frame.origin.y+self.bargainingPriceHistoryView.frame.size.height+20)];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self checkLoginAndShowLoginWithBlock:^(BOOL flag) {
    
//        [self getDetailData];
    
//    }];
    
}

//- (void)updateData:(id)data
//{
//    
//    if (!data || ![data isKindOfClass:[QSOrderDetailInfoDataModel class]]) {
//        NSLog(@"QSOrderDetailInfoDataModel 错误");
//        return;
//    }
//    
//    QSOrderDetailInfoDataModel *detailData = (QSOrderDetailInfoDataModel*)data;
//    
//    if (_titleTipLabel) {
//        [_titleTipLabel setTitle:[detailData getStatusTitle]];
//        NSLog(@"%@ StatusTitle:%@",detailData.order_status,_titleTipLabel.text);
//    }
//    
//    if (_houseInfoView) {
//        [_houseInfoView setHouseData:detailData.house_msg];
//    }
//    
//    if (_addressView) {
//        [_addressView setHouseData:detailData.house_msg];
//    }
//    
//    if (_personView) {
//        [_personView setOrderData:self.orderDetailData];
//    }
//    
//    if (_showingsTimeView) {
//        [_showingsTimeView setTimeData:detailData.appoint_list];
//    }
//    
//}

- (void)getDetailData
{
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        if (self.orderListItemData && [self.orderListItemData isKindOfClass:[QSOrderListItemData class]]) {
            if (self.orderListItemData.orderInfoList&&[self.orderListItemData.orderInfoList count]>0) {
                
                QSOrderListOrderInfoDataModel *orderItem = [self.orderListItemData.orderInfoList objectAtIndex:selectedIndex];
                if (orderItem&&[orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                    
                    self.orderID = orderItem.id_;
                    
                }
            }
        }
        
    }
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            [self.navigationController popViewControllerAnimated:YES];
        })
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
//    id_	true	string	订单id
//    user_id	true	string	获取的用户id
    
    [tempParam setObject:self.orderID forKey:@"id_"];
    //TODO:获取用户ID
    NSString *userID = [QSCoreDataManager getUserID];
    [tempParam setObject:(userID ? userID : @"1") forKey:@"user_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderDetailData andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSOrderDetailReturnData *headerModel = resultData;
        
        ///转换模型
        if (rRequestResultTypeSuccess == resultStatus) {
            
            self.orderDetailData = headerModel.orderDetailData;
            [self.orderDetailData updateViewsFlags];
//            [self updateData:self.orderDetailData];
            [self createSubViewsUI];
            
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
