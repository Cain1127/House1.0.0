//
//  QSPOrderDetailBookedViewController.m
//  House
//
//  Created by CoolTea on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//
//                      .::::.
//                      .::::::::.
//                     :::::::::::  女神保佑 代码无bug
//                 ..:::::::::::'
//               '::::::::::::'
//                 .::::::::::
//            '::::::::::::::..
//                 ..::::::::::::.
//               ``::::::::::::::::
//                ::::``:::::::::'        .:::.
//               ::::'   ':::::'       .::::::::.
//             .::::'      ::::     .:::::::'::::.
//            .:::'       :::::  .:::::::::' ':::::.
//           .::'        :::::.:::::::::'      ':::::.
//          .::'         ::::::::::::::'         ``::::.
//      ...:::           ::::::::::::'              ``::.
//     ```` ':.          ':::::::::'                  ::::..
//                        '.:::::'                    ':'````..
//
//


#import "QSPOrderDetailBookedViewController.h"
#import "QSPOrderBookTimeViewController.h"
#import "QSCoreDataManager+User.h"
#import "QSOrderDetailReturnData.h"
#import "QSCustomHUDView.h"
#import "QSYCallTipsPopView.h"
#import "QSYPopCustomView.h"

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
#import "QSPOrderDetailAppointAgainButtonView.h"
#import "QSPOrderDetailAppointAgainAndRejectPriceButtonView.h"
#import "QSPOrderDetailRejectAndAcceptAppointmentButtonView.h"
#import "QSPOrderDetailCancelTransAndWarmBuyerButtonView.h"
#import "QSPOrderDetailChangeOrderButtonView.h"
#import "QSPOrderDetailConfirmOrderButtonView.h"
#import "QSPOrderDetailConfirmOrderDisableButtonView.h"
#import "QSPOrderDetailSubmitPriceButtonView.h"
#import "QSPOrderDetailAppointmentSalerAgainButtonView.h"
#import "QSPOrderDetailChangeAppointmentButtonView.h"
#import "QSPOrderDetailComplaintAndCompletedButtonView.h"
#import "QSPOrderDetailCancelAppointmentButtonView.h"
#import "QSPOrderDetailAcceptOrRejectApplicationView.h"
#import "QSPOrderDetailAppointAgainOrCancelApplicationView.h"
#import "QSPOrderDetailAppointAgainAndApplicationBargainView.h"
#import "QSPOrderDetailCancelTransAndCompleteButtonView.h"
#import "QSPOrderDetailCancelTransAndWarmSalerButtonView.h"
#import "QSPOrderDetailRejectPriceButtonView.h"

#import "QSSecondHouseDetailViewController.h"
#import "QSRentHouseDetailViewController.h"
#import "QSSearchMapViewController.h"

#import "QSPOrderDetailActionReturnBaseDataModel.h"
#import "QSYTalkPTPViewController.h"
#import "QSYPostMessageSimpleModel.h"

#import "QSPOrderDetailActionReturnBaseDataModel.h"
#import "QSPOrderDetailActionReturnBaseDataModel.h"

#import "QSYContactComplaintViewController.h"
#import "QSPOrderEvaluationListingsViewController.h"

#import "QSMortgageCalculatorViewController.h"

#import "QSPOrderTipsButtonPopView.h"


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
@property (nonatomic, strong) QSPOrderDetailComplaintAndCompletedButtonView *complaintAndCompletedButtonView;  //!<我要投诉和完成看房按钮View
@property (nonatomic, strong) QSPOrderDetailAppointAgainAndPriceAgainButtonView *appointAgainAndPriceAgainButtonView;  //!<再次预约和我要议价按钮View
@property (nonatomic, strong) QSPOrderDetailAppointAgainButtonView *appointAgainButtonView;  //!<再次预约按钮View
@property (nonatomic, strong) QSPOrderDetailAppointAgainAndRejectPriceButtonView *appointAgainAndRejectPriceButtonView;  //!<再次预约和拒绝还价按钮View
@property (nonatomic, strong) QSPOrderDetailRejectAndAcceptAppointmentButtonView *rejectAndAcceptAppointmentButtonView;    //!<拒绝预约和接受预约按钮View
@property (nonatomic, strong) QSPOrderDetailCancelTransAndWarmBuyerButtonView *cancelTransactionAndWarmBuyerButtonView;    //!<取消成交和提醒房客按钮View
@property (nonatomic, strong) QSPOrderDetailCancelTransAndWarmSalerButtonView *cancelTransAndWarmSalerButtonView;           //!<取消成交和提醒业主按钮View
@property (nonatomic, strong) QSPOrderDetailCancelTransAndCompleteButtonView *cancelTransAndCompleteButtonView;         //!<取消成交和确认成交按钮View
@property (nonatomic, strong) QSPOrderDetailAcceptOrRejectApplicationView *acceptOrRejectApplicationView;      //!<接受申请和拒绝申请按钮View
@property (nonatomic, strong) QSPOrderDetailAppointAgainOrCancelApplicationView *appointAgainOrCancelApplicationView;       //!<再次预约、取消申请按钮View
@property (nonatomic, strong)  QSPOrderDetailAppointAgainAndApplicationBargainView *appointAgainAndApplicationBargainView;      //!<再次预约、申请议价按钮View
    

//ScrollView底部悬浮按钮
@property (nonatomic, strong) QSPOrderDetailChangeOrderButtonView *changeOrderButtonView;  //!<修改订单按钮View
@property (nonatomic, strong) QSPOrderDetailCancelAppointmentButtonView *cancelAppointmentButtonView;     //!<取消预约按钮View
@property (nonatomic, strong) QSPOrderDetailConfirmOrderButtonView *confirmOrderButtonView; //!<房源非常满意，我要成交按钮View
@property (nonatomic, strong) QSPOrderDetailConfirmOrderDisableButtonView *confirmOrderDisableButtonView; //!<房源非常满意，我要成交不能点击按钮View
@property (nonatomic, strong) QSPOrderDetailSubmitPriceButtonView *submitPriceButtonView;  //!<提交出价按钮View
@property (nonatomic, strong) QSPOrderDetailAppointmentSalerAgainButtonView *appointmentSalerAgainButtonView;    //!<重新预约业主按钮View
@property (nonatomic, strong) QSPOrderDetailChangeAppointmentButtonView *changeAppointmentButtonView;    //!<修改预约按钮View
@property (nonatomic, strong) QSPOrderDetailRejectPriceButtonView *rejectPriceButtonView;           //!<拒绝还价按钮View

@end

@implementation QSPOrderDetailBookedViewController
@synthesize orderListItemData, selectedIndex, orderID, orderType;

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    NSString *titleStr = @"订单详情";
    if (orderType == mOrderWithUserTypeAppointment) {//预约订单
        titleStr = TITLE_VIEWCONTROLLER_TITLE_BOOKINGORDERSLIST ;
    }else if (orderType == mOrderWithUserTypeTransaction) {//成交订单
        titleStr = TITLE_VIEWCONTROLLER_TITLE_TRANSATIONORDERSLIST ;
    }
    [self setNavigationBarTitle:titleStr];
    
}


///搭建主展示UI
- (void)createMainShowUI
{
    
    self.contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.contentBgView];
    
}

- (void)createSubViewsUI
{
    
    if (self.contentBgView) {
        
        for (UIView *view in [self.contentBgView subviews]) {
            
            [view removeFromSuperview];
            
        }
        
    }
    
    ///头部标题
    NSString *titleTip = @"";
    
    ///预约时间
    NSMutableArray *timeArray = nil;
    
    ///房源数据
    id houseData = nil;
    
    //议价历史列表数据
    id bargainList = nil;
    
    if (!self.orderDetailData || ![self.orderDetailData  isKindOfClass:[QSOrderDetailInfoDataModel class]]) {
        
        NSLog(@"self.orderDetailData 数据不正确！");
        
        return;
    }
    
    if (self.orderDetailData) {
        
        titleTip = [NSString stringWithFormat:@"%@(%@)[%@]",[self.orderDetailData getStatusTitle],self.orderDetailData.order_status,self.orderID];
        timeArray = [NSMutableArray arrayWithArray:self.orderDetailData.appoint_list];
        houseData = self.orderDetailData.house_msg;
        bargainList = self.orderDetailData.bargain_list;
        
    }
    
    //
    CGFloat viewTitleOffsetY = 64.0f;
    CGFloat viewContentOffsetY = 0.0f;
    CGFloat viewBottomButtonOffsetY = SIZE_DEVICE_HEIGHT;
    
    //***********顶部标题<
    
    if (self.orderDetailData.isShowTitleView) {
        
        self.titleTipLabel = [[QSPOrderDetailTitleLabel alloc] initWithFrame:CGRectMake(0.0f, viewTitleOffsetY, SIZE_DEVICE_WIDTH, 44) withTitle:titleTip];
        [self.contentBgView addSubview:self.titleTipLabel];
        viewTitleOffsetY = self.titleTipLabel.frame.origin.y+self.titleTipLabel.frame.size.height;
        
    }
    
    //>***********顶部标题
    
    
    //***********底部按钮<
    
    //!<修改订单按钮View
    //可点击
    if (self.orderDetailData.isShowChangeOrderButtonEnableView) {
        
        viewBottomButtonOffsetY = SIZE_DEVICE_HEIGHT - (2*CONTENT_TOP_BOTTOM_OFFSETY+44.0f);
        
        self.changeOrderButtonView = [[QSPOrderDetailChangeOrderButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewBottomButtonOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    {
                        
                        QSPOrderBookTimeViewController *btVc = [[QSPOrderBookTimeViewController alloc] initWithSubmitCallBack:^(BOOKTIME_RESULT_TYPE resultTag,NSString *orderID) {
                            
                            if (bBookResultTypeSucess == resultTag) {
                                //修改成功,更新详情
                                [self getDetailData];
                            }
                            
                        }];
                        [btVc setVcType:bBookTypeViewControllerChange];
                        [btVc setOrderID:self.orderDetailData.id_];
                        if (self.orderDetailData.house_msg) {
                            [btVc setHouseInfo:self.orderDetailData.house_msg];
                        }
                        if (self.orderDetailData.order_type &&[self.orderDetailData.order_type isKindOfClass:[NSString class]]) {
                            
                            //500101:一手房购买订单, 500102 二手房，500103出租房
                            if ([self.orderDetailData.order_type isEqualToString:@"500101"])
                            {
                                
                                [btVc setHouseType:fFilterMainTypeNewHouse];
                                
                            }else if ([self.orderDetailData.order_type isEqualToString:@"500102"])
                            {
                                
                                [btVc setHouseType:fFilterMainTypeSecondHouse];
                                
                            }else if ([self.orderDetailData.order_type isEqualToString:@"500103"])
                            {
                                
                                [btVc setHouseType:fFilterMainTypeRentalHouse];
                                
                            }
                            
                        }
                        [self.navigationController pushViewController:btVc animated:YES];
                        
                    }
                    break;
                default:
                    break;
            }
            
        }];
        [self.contentBgView addSubview:self.changeOrderButtonView];
        
    }
    //不能点击
    if (self.orderDetailData.isShowChangeOrderButtonDisableView) {
        
        viewBottomButtonOffsetY = SIZE_DEVICE_HEIGHT - (2*CONTENT_TOP_BOTTOM_OFFSETY+44.0f);
        
        self.changeOrderButtonView = [[QSPOrderDetailChangeOrderButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewBottomButtonOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    NSLog(@"QSPOrderDetailChangeOrderButtonView:修改订单");
                    break;
                default:
                    break;
            }
            
        }];
        [self.changeOrderButtonView setCenterButtonType:nNormalButtonTypeCornerWhiteGray];
        [self.contentBgView addSubview:self.changeOrderButtonView];
        
    }
    
    //取消预约
    if (self.orderDetailData.isShowCancelAppointmentButtonView){
        
        viewBottomButtonOffsetY = SIZE_DEVICE_HEIGHT - (2*CONTENT_TOP_BOTTOM_OFFSETY+44.0f);
        
        self.cancelAppointmentButtonView = [[QSPOrderDetailCancelAppointmentButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewBottomButtonOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    NSLog(@"QSPOrderDetailCancelAppointmentButtonView:取消预约");
                    [self cancelAppointmentOrder];
                    break;
                default:
                    break;
            }
            
        }];
        [self.cancelAppointmentButtonView setCenterButtonType:nNormalButtonTypeCornerYellow];
        [self.contentBgView addSubview:self.cancelAppointmentButtonView];

    }
    
    //!<房源非常满意，我要成交不能点击按钮View
    if (self.orderDetailData.isShowConfirmOrderDisableButtonView) {
        
        viewBottomButtonOffsetY = SIZE_DEVICE_HEIGHT - (2*CONTENT_TOP_BOTTOM_OFFSETY+44.0f);
        self.confirmOrderDisableButtonView = [[QSPOrderDetailConfirmOrderDisableButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewBottomButtonOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    NSLog(@"QSPOrderDetailConfirmOrderDisableButtonView:不能点击房源非常满意，我要成交按钮");
                    break;
                default:
                    break;
            }
            
        }];
        [self.contentBgView addSubview:self.confirmOrderDisableButtonView];
        
    }
    
    //!<房源非常满意，我要成交按钮View
    if (self.orderDetailData.isShowConfirmOrderButtonView) {
        
        viewBottomButtonOffsetY = SIZE_DEVICE_HEIGHT - (2*CONTENT_TOP_BOTTOM_OFFSETY+44.0f);
        self.confirmOrderButtonView = [[QSPOrderDetailConfirmOrderButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewBottomButtonOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    NSLog(@"QSPOrderDetailConfirmOrderButtonView:房源非常满意，我要成交按钮");
                    [self buyerOrSalerCommitAppointmentOrder];
                    break;
                default:
                    break;
            }
            
        }];
        [self.contentBgView addSubview:self.confirmOrderButtonView];
        
        if ([@"500252" isEqualToString:self.orderDetailData.order_status] || [@"500231" isEqualToString:self.orderDetailData.order_status]) {
            [self.confirmOrderButtonView disableButtons];
        }
        
        viewBottomButtonOffsetY = SIZE_DEVICE_HEIGHT - (2*CONTENT_TOP_BOTTOM_OFFSETY+44.0f);
        self.submitPriceButtonView = [[QSPOrderDetailSubmitPriceButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewBottomButtonOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    NSLog(@"QSPOrderDetailSubmitPriceButtonView:提交出价按钮");
                    [self submitMyInputPrice];
                    break;
                default:
                    break;
            }
            
        }];
        [self.contentBgView addSubview:self.submitPriceButtonView];
        
        [self.submitPriceButtonView setHidden:YES];
        
    }
    
    //!<拒绝还价按钮View
    if (self.orderDetailData.isShowRejectPriceButtonView) {
        
        viewBottomButtonOffsetY = SIZE_DEVICE_HEIGHT - (2*CONTENT_TOP_BOTTOM_OFFSETY+44.0f);
        self.rejectPriceButtonView = [[QSPOrderDetailRejectPriceButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewBottomButtonOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    NSLog(@"QSPOrderDetailChangeAppointmentButtonView:拒绝还价按钮按钮");
                    [self salerRejectPrice];
                    break;
                default:
                    break;
            }
        }];
        [self.contentBgView addSubview:self.rejectPriceButtonView];
        
        if ([self.orderDetailData.order_status isEqualToString:@"500257"]) {
            [self.rejectPriceButtonView disableButtons];
        }
        
        viewBottomButtonOffsetY = SIZE_DEVICE_HEIGHT - (2*CONTENT_TOP_BOTTOM_OFFSETY+44.0f);
        self.submitPriceButtonView = [[QSPOrderDetailSubmitPriceButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewBottomButtonOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    NSLog(@"QSPOrderDetailSubmitPriceButtonView:提交出价按钮");
                    [self submitMyInputPrice];
                    break;
                default:
                    break;
            }
            
        }];
        [self.contentBgView addSubview:self.submitPriceButtonView];
        
        [self.submitPriceButtonView setHidden:YES];
    }

    //!<提交出价按钮View
    if (self.orderDetailData.isShowSubmitPriceButtonView) {
        
        viewBottomButtonOffsetY = SIZE_DEVICE_HEIGHT - (2*CONTENT_TOP_BOTTOM_OFFSETY+44.0f);
        self.submitPriceButtonView = [[QSPOrderDetailSubmitPriceButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewBottomButtonOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    NSLog(@"QSPOrderDetailSubmitPriceButtonView:提交出价按钮");
                    [self submitMyInputPrice];
                    break;
                default:
                    break;
            }
            
        }];
        [self.contentBgView addSubview:self.submitPriceButtonView];
        
    }

    //!<重新预约业主按钮View
    if (self.orderDetailData.isShowAppointmentSalerAgainButtonView) {
        
        viewBottomButtonOffsetY = SIZE_DEVICE_HEIGHT - (2*CONTENT_TOP_BOTTOM_OFFSETY+44.0f);
        self.appointmentSalerAgainButtonView = [[QSPOrderDetailAppointmentSalerAgainButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewBottomButtonOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    {
                        QSPOrderBookTimeViewController *bookTimeVc = [[QSPOrderBookTimeViewController alloc] initWithSubmitCallBack:^(BOOKTIME_RESULT_TYPE resultTag,NSString  *orderID) {
                            
                            if (bBookResultTypeSucess == resultTag) {
                                [self getDetailData];
                            }
                            
                        }];
                        if (self.orderDetailData.order_type &&[self.orderDetailData.order_type isKindOfClass:[NSString class]]) {
                            
                            //500101:一手房购买订单, 500102 二手房，500103出租房
                            if ([self.orderDetailData.order_type isEqualToString:@"500101"])
                            {
                                
                                [bookTimeVc setHouseType:fFilterMainTypeNewHouse];
                                
                            }else if ([self.orderDetailData.order_type isEqualToString:@"500102"])
                            {
                                
                                [bookTimeVc setHouseType:fFilterMainTypeSecondHouse];
                                
                            }else if ([self.orderDetailData.order_type isEqualToString:@"500103"])
                            {
                                
                                [bookTimeVc setHouseType:fFilterMainTypeRentalHouse];
                                
                            }
                            
                        }
                        [bookTimeVc setVcType:bBookTypeViewControllerBook];
                        [bookTimeVc setHouseInfo:self.orderDetailData.house_msg];
                        [self.navigationController pushViewController:bookTimeVc animated:YES];
                    }
                    break;
                default:
                    break;
            }
        }];
        [self.contentBgView addSubview:self.appointmentSalerAgainButtonView];
        
    }

    //!<修改预约按钮View
    if (self.orderDetailData.isShowChangeAppointmentButtonView) {
        
        viewBottomButtonOffsetY = SIZE_DEVICE_HEIGHT - (2*CONTENT_TOP_BOTTOM_OFFSETY+44.0f);
        self.changeAppointmentButtonView = [[QSPOrderDetailChangeAppointmentButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewBottomButtonOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    NSLog(@"QSPOrderDetailChangeAppointmentButtonView:修改预约按钮按钮");
                    break;
                default:
                    break;
            }
        }];
        [self.contentBgView addSubview:self.changeAppointmentButtonView];
        
    }
    
    //>***********底部按钮
    
    
    //***********中间ScrollView内容区<
    
    QSScrollView *scrollView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, viewTitleOffsetY, SIZE_DEVICE_WIDTH, viewBottomButtonOffsetY-viewTitleOffsetY)];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentBgView addSubview:scrollView];
    
    //!<看房活动简介View
    if (self.orderDetailData.isShowShowingsActivitiesView) {
        
        self.showingsActivitiesView = [[QSPOrderDetailShowingsActivitiesView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withActivityData:nil];
        [scrollView addSubview:self.showingsActivitiesView];
        viewContentOffsetY = self.showingsActivitiesView.frame.origin.y + self.showingsActivitiesView.frame.size.height;
        
    }
    
    ///看房时间
    if (self.orderDetailData.isShowShowingsTimeView) {
        
        self.showingsTimeView = [[QSPOrderDetailShowingsTimeView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withTimeData:timeArray];
        [scrollView addSubview:self.showingsTimeView];
        viewContentOffsetY = self.showingsTimeView.frame.origin.y + self.showingsTimeView.frame.size.height;
        
    }
    
    
    ///房源简介
    if (self.orderDetailData.isShowHouseInfoView) {
        
        self.houseInfoView = [[QSPOrderDetailHouseInfoView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withHouseData:houseData andCallBack:^(UIButton *button) {
            NSLog(@"房源 clickBt");
            
            QSOrderDetailInfoHouseDataModel *houseData = self.orderDetailData.house_msg;
            if (houseData) {
                
                //500101:一手房购买订单, 500102 二手房，500103出租房
                if ([self.orderDetailData.order_type isEqualToString:@"500101"])
                {
                }else if ([self.orderDetailData.order_type isEqualToString:@"500102"])
                {
                    
                    QSSecondHouseDetailViewController *sVc = [[QSSecondHouseDetailViewController alloc] initWithTitle:houseData.village_name andDetailID:houseData.id_ andDetailType:fFilterMainTypeSecondHouse];
                    [self.navigationController pushViewController:sVc animated:YES];
                    
                }else if ([self.orderDetailData.order_type isEqualToString:@"500103"])
                {
                    
                    QSRentHouseDetailViewController *rVc = [[QSRentHouseDetailViewController alloc] initWithTitle:houseData.village_name andDetailID:houseData.id_ andDetailType:fFilterMainTypeRentalHouse];
                    [self.navigationController pushViewController:rVc animated:YES];
                    
                }
                
            }
            
        }];
        [scrollView addSubview:_houseInfoView];
        ///将房源简介引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_houseInfoView];
        viewContentOffsetY = self.houseInfoView.frame.origin.y+self.houseInfoView.frame.size.height;
        
    }
    
    ///房源价格
    if (self.orderDetailData.isShowHousePriceView) {
        
        self.housePriceView = [[QSPOrderDetailHousePriceView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withOrderData:self.orderDetailData andCallBack:^(UIButton *button) {
            
            NSLog(@"price compute clickBt");
            
            NSString *totalPrice = @"";
            
            if (houseData) {
                
                if ([houseData isKindOfClass:[QSOrderListHouseInfoDataModel class]]) {
                    
                    QSOrderListHouseInfoDataModel *data = (QSOrderListHouseInfoDataModel*)houseData;
                    
                    totalPrice = data.house_price;
                }
            }
            
            if (totalPrice&& totalPrice.floatValue>0) {
                
                QSMortgageCalculatorViewController *mcVC = [[QSMortgageCalculatorViewController alloc] initWithHousePrice:totalPrice.floatValue/10000.0f];
                
                [self.navigationController pushViewController:mcVC animated:YES];
                
            }
            
        }];
        [scrollView addSubview:_housePriceView];
        ///将房源价格引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_housePriceView];
        viewContentOffsetY = self.housePriceView.frame.origin.y+self.housePriceView.frame.size.height;
        
    }
    
    ///地址栏
    if (self.orderDetailData.isShowAddressView) {
        self.addressView = [[QSPOrderDetailAddressView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withHouseData:houseData andCallBack:^(UIButton *button) {
            
            NSLog(@"地图定位 clickBt");
            
            if (!self.orderDetailData || ![self.orderDetailData isKindOfClass:[QSOrderDetailInfoDataModel class]]) {
                NSLog(@"QSOrderDetailInfoDataModel 错误");
                return;
            }
            
            if (self.orderDetailData.house_msg) {
                
                //房源坐标
                //            self.orderDetailData.house_msg.coordinate_x;
                //            self.orderDetailData.house_msg.coordinate_y;
                QSSearchMapViewController *mapSearchVC = [[QSSearchMapViewController alloc] initWithTitle:self.orderDetailData.house_msg.title andCoordinate_x:self.orderDetailData.house_msg.coordinate_x andCoordinate_y:self.orderDetailData.house_msg.coordinate_y];
                [self.navigationController pushViewController:mapSearchVC animated:YES];
                
            }
            
        }];
        [scrollView addSubview:_addressView];
        ///将地址栏引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_addressView];
        viewContentOffsetY = _addressView.frame.origin.y+_addressView.frame.size.height;
        
    }
    
    //业主/房客信息栏
    if (self.orderDetailData.isShowPersonInfoView) {
        
        self.personView = [[QSPOrderDetailPersonInfoView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withOrderData:self.orderDetailData andCallBack:^(PERSON_INFO_BUTTON_TYPE buttonType,UIButton *button) {
            
            NSString *phoneStr = @"";
            NSString *ownerNameStr = @"";
            
            QSOrderListOrderInfoPersonInfoDataModel *personInfo = self.orderDetailData.saler_msg;
            
            if ([self.orderDetailData getUserType] == uUserCountTypeOwner) {
                
                //业主角色
                phoneStr = self.orderDetailData.buyer_phone;
                ownerNameStr = self.orderDetailData.buyer_name;
                
            }else if ([self.orderDetailData getUserType] == uUserCountTypeTenant) {
                //房客角色
                
                if (personInfo && [personInfo isKindOfClass:[QSOrderListOrderInfoPersonInfoDataModel class]]) {
                    
                    ownerNameStr = personInfo.username;
                    phoneStr = personInfo.mobile;
                    
                }
                
            }
            
            
            switch (buttonType) {
                    ///联系业主
                case pPersonButtonTypePhone:
                    {
                        if (phoneStr&&![phoneStr isEqualToString:@""]) {
                            
                            ///弹出框
                            __block QSYPopCustomView *popView;
                            
                            QSYCallTipsPopView *callTipsView = [[QSYCallTipsPopView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 130.0f, SIZE_DEVICE_WIDTH, 130.0f) andName:ownerNameStr andPhone:phoneStr andCallBack:^(CALL_TIPS_CALLBACK_ACTION_TYPE actionType) {
                                
                                ///回收弹框
                                [popView hiddenCustomPopview];
                                
                                ///确认打电话
                                if (cCallTipsCallBackActionTypeConfirm == actionType) {
                                    
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneStr]]];
                                    
                                }
                                
                            }];
                            
                            popView = [QSYPopCustomView popCustomViewWithoutChangeFrame:callTipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                                
                            }];
                        }
                    }
                    break;
                case pPersonButtonTypeAsk:
                    {
                        
                        if (personInfo) {
                            
                            QSYTalkPTPViewController *talkVC = [[QSYTalkPTPViewController alloc] initWithUserModel:[personInfo transformToSimpleDataModel]];
                            [self.navigationController pushViewController:talkVC animated:YES];
                            
                        }
                        
                    }
                    
                    break;
                default:
                    break;
            }
            
        }];
        [scrollView addSubview:self.personView];
        ///将业主信息栏引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_personView];
        viewContentOffsetY = _personView.frame.origin.y+_personView.frame.size.height;
        
    }
    
    //!<看房活动联系电话View
    if (self.orderDetailData.isShowActivitiesPhoneView) {
        
        self.activitiesPhoneView = [[QSPOrderDetailActivitiesPhoneView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withOrderData:self.orderDetailData andCallBack:^(UIButton *button) {
            
            NSLog(@"activitiesPhoneButton");
            
        }];
        [scrollView addSubview:self.activitiesPhoneView];
        ///将业主信息栏引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_activitiesPhoneView];
        viewContentOffsetY = _activitiesPhoneView.frame.origin.y+_activitiesPhoneView.frame.size.height;
        
    }
    
    ///对方出价View
    if (self.orderDetailData.isShowOtherPriceView) {
        
        self.otherPriceView = [[QSPOrderDetailOtherPriceView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withOrderData:self.orderDetailData andCallBack:^(UIButton *button) {
            
            NSLog(@"接受房价Button");
            [self salerAcceptPrice];
            
        }];
        [scrollView addSubview:self.otherPriceView];
        ///将对方出价View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_otherPriceView];
        viewContentOffsetY = _otherPriceView.frame.origin.y+_otherPriceView.frame.size.height;
        
    }
    
    ///我的出价View
    if (self.orderDetailData.isShowMyPriceView) {
        
        self.myPriceView = [[QSPOrderDetailMyPriceView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withOrderData:self.orderDetailData andCallBack:^(UIButton *button) {
            
            NSLog(@"出价Button");
            if (self.inputMyPriceView) {
                [self.inputMyPriceView setFrameHeightToShowHeight];
            }
            
            if (self.rejectPriceButtonView) {
                [self.rejectPriceButtonView setHidden:YES];
            }
            
            if (self.submitPriceButtonView) {
                [self.submitPriceButtonView setHidden:YES];
            }
            
            if (self.submitPriceButtonView) {
                [self.submitPriceButtonView setHidden:NO];
            }
            
        }];
        [scrollView addSubview:self.myPriceView];
        ///将我的出价View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_myPriceView];
        viewContentOffsetY = _myPriceView.frame.origin.y+_myPriceView.frame.size.height;
        
    }
    
    //!<输入我的出价View
    self.inputMyPriceView = [[QSPOrderDetailInputMyPriceView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY)];
    
    if ([self.orderDetailData.order_type isEqualToString:@"500103"]) {
        //出租房出价
        [self.inputMyPriceView setPlaceholder:@"输入您的房源估价（单位为元）"];
        
    }else {
        
        [self.inputMyPriceView setPlaceholder:@"输入您的房源估价(单位为万元)"];
        
    }
    
    [scrollView addSubview:self.inputMyPriceView];
    ///将输入我的出价View引用添加进看房时间控件管理作动态高度扩展
    [self.showingsTimeView addAfterView:&_inputMyPriceView];
    [self.myPriceView addAfterView:&_inputMyPriceView];
    if (!self.orderDetailData.isShowInputMyPriceView) {
        SetHeightToZero(self.inputMyPriceView);
    }
    viewContentOffsetY = _inputMyPriceView.frame.origin.y+_inputMyPriceView.frame.size.height;
    
    //!<最后成交价View
    if (self.orderDetailData.isShowTransactionPriceView) {
        
        self.transactionPriceView = [[QSPOrderDetailTransactionPriceView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withOrderData:self.orderDetailData];
        [scrollView addSubview:self.transactionPriceView];
        ///将我的出价View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_transactionPriceView];
        [self.myPriceView addAfterView:&_transactionPriceView];
        viewContentOffsetY = self.transactionPriceView.frame.origin.y+self.transactionPriceView.frame.size.height;
        
    }
    
    
    ///和对方议价记录View
    if (self.orderDetailData.isShowBargainingPriceHistoryView) {
        
        self.bargainingPriceHistoryView = [[QSPOrderDetailBargainingPriceHistoryView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withOrderData:self.orderDetailData];
        [scrollView addSubview:self.bargainingPriceHistoryView];
        ///将和对方议价记录View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_bargainingPriceHistoryView];
        [self.myPriceView addAfterView:&_bargainingPriceHistoryView];
        viewContentOffsetY = self.bargainingPriceHistoryView.frame.origin.y+self.bargainingPriceHistoryView.frame.size.height;
        
    }
    
    //!<备注:拒绝还价将视为取消订单View  需要显示，或者特殊显示时提示
    if (self.orderDetailData.isShowRemarkRejectPriceView || (self.orderDetailData.o_expand_1&&[self.orderDetailData.o_expand_1 isKindOfClass:[NSString class]]&&[self.orderDetailData.o_expand_1 isEqualToString:@"500202"])) {
        
        self.remarkRejectPriceView = [[QSPOrderDetailRemarkRejectPriceView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withRemarkTip:@"备注：拒绝还价将视为取消订单"];
        [scrollView addSubview:self.remarkRejectPriceView];
        ///将备注信息View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_remarkRejectPriceView];
        [self.bargainingPriceHistoryView addAfterView:&_remarkRejectPriceView];
        [self.myPriceView addAfterView:&_remarkRejectPriceView];
        viewContentOffsetY = self.remarkRejectPriceView.frame.origin.y+self.remarkRejectPriceView.frame.size.height;
        
    }
    
    //!<订单取消原因：业主取消预约View
    if (self.orderDetailData.isShowOrderCancelByOwnerTipView) {
        
        self.orderCancelByOwnerTipView = [[QSPOrderDetailOrderCancelByOwnerTipView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withRemarkTip:@"订单取消原因：业主取消预约!"];
        [scrollView addSubview:self.orderCancelByOwnerTipView];
        ///将备注信息View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_orderCancelByOwnerTipView];
        [self.bargainingPriceHistoryView addAfterView:&_orderCancelByOwnerTipView];
        [self.myPriceView addAfterView:&_orderCancelByOwnerTipView];
        viewContentOffsetY = self.orderCancelByOwnerTipView.frame.origin.y+self.orderCancelByOwnerTipView.frame.size.height;
        
    }

    
    //!<订单取消原因：我取消预约View
    if (self.orderDetailData.isShowOrderCancelByMeTipView) {
        
        self.orderCancelByMeTipView = [[QSPOrderDetailOrderCancelByMeTipView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withRemarkTip:@"订单取消原因：我取消预约!"];
        [scrollView addSubview:self.orderCancelByMeTipView];
        ///将备注信息View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_orderCancelByMeTipView];
        [self.bargainingPriceHistoryView addAfterView:&_orderCancelByMeTipView];
        [self.myPriceView addAfterView:&_orderCancelByMeTipView];
        viewContentOffsetY = self.orderCancelByMeTipView.frame.origin.y+self.orderCancelByMeTipView.frame.size.height;
        
    }

    //!<预约结束评价提示View
    if (self.orderDetailData.isShowCommentNoteTipsView) {
        
        self.commentNoteTipsView = [[QSPOrderDetailCommentNoteTipsView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withOrderData:self.orderDetailData];
        [scrollView addSubview:self.commentNoteTipsView];
        ///将预约结束评价View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_commentNoteTipsView];
        [self.bargainingPriceHistoryView addAfterView:&_commentNoteTipsView];
        [self.myPriceView addAfterView:&_commentNoteTipsView];
        viewContentOffsetY = self.commentNoteTipsView.frame.origin.y+self.commentNoteTipsView.frame.size.height;
        
    }

    //!<我要投诉和评价房源按钮View
    if (self.orderDetailData.isShowComplaintAndCommentButtonView) {
        
        self.complaintAndCommentButtonView = [[QSPOrderDetailComplaintAndCommentButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeLeft:
                    
                    NSLog(@"QSPOrderDetailComplaintAndCommentButtonView:我要投诉");
                    [self complaintSaler];
                    
                    break;
                case bBottomButtonTypeRight:
                    
                    NSLog(@"QSPOrderDetailComplaintAndCommentButtonView:评价房源");
                    {
                        
                        QSPOrderEvaluationListingsViewController *elVc = [[QSPOrderEvaluationListingsViewController alloc] init];
                        [elVc setOrderID:self.orderID];
                        [self.navigationController pushViewController:elVc animated:YES];
                        
                    }
                    break;
                default:
                    break;
            }
            
        }];
        [scrollView addSubview:self.complaintAndCommentButtonView];
        ///将按钮View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_complaintAndCommentButtonView];
        [self.bargainingPriceHistoryView addAfterView:&_complaintAndCommentButtonView];
        [self.myPriceView addAfterView:&_complaintAndCommentButtonView];
        viewContentOffsetY = self.complaintAndCommentButtonView.frame.origin.y+self.complaintAndCommentButtonView.frame.size.height;
        
    }

    //!<我要投诉和完成看房按钮View
    if (self.orderDetailData.isShowComplaintAndCompletedButtonView) {
        
        self.complaintAndCompletedButtonView = [[QSPOrderDetailComplaintAndCompletedButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeLeft:
                    NSLog(@"QSPOrderDetailComplaintAndCompletedButtonView:我要投诉");
                    [self complaintBuyer];
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailComplaintAndCompletedButtonView:完成看房");
                    [self salerCommitInspectedOrder];
                    break;
                default:
                    break;
            }
            
        }];
        [scrollView addSubview:self.complaintAndCompletedButtonView];
        ///将按钮View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_complaintAndCompletedButtonView];
        [self.bargainingPriceHistoryView addAfterView:&_complaintAndCompletedButtonView];
        [self.myPriceView addAfterView:&_complaintAndCompletedButtonView];
        viewContentOffsetY = self.complaintAndCompletedButtonView.frame.origin.y+self.complaintAndCompletedButtonView.frame.size.height;
        
    }
    
    //!<再次预约按钮View
    if (self.orderDetailData.isShowAppointAgainView) {
        
        self.appointAgainButtonView = [[QSPOrderDetailAppointAgainButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    NSLog(@"QSPOrderDetailAppointAgainButtonView:再次预约");
                    [self appointmentAgainAction];
                    break;
                default:
                    break;
            }
        }];
        [scrollView addSubview:self.appointAgainButtonView];
        ///将按钮View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_appointAgainButtonView];
        [self.bargainingPriceHistoryView addAfterView:&_appointAgainButtonView];
        [self.myPriceView addAfterView:&_appointAgainButtonView];
        viewContentOffsetY = self.appointAgainButtonView.frame.origin.y+self.appointAgainButtonView.frame.size.height;
        
    }
    
    //!<再次预约和我要议价按钮View
    if (self.orderDetailData.isShowAppointAgainAndPriceAgainButtonView) {
        
        self.appointAgainAndPriceAgainButtonView = [[QSPOrderDetailAppointAgainAndPriceAgainButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeLeft:
                    NSLog(@"QSPOrderDetailAppointAgainAndPriceAgainButtonView:再次预约");
                    [self appointmentAgainAction];
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailAppointAgainAndPriceAgainButtonView:我要议价");
                    break;
                default:
                    break;
            }
            
        }];
        if ([@"500231" isEqualToString:self.orderDetailData.order_status]) {
            [self.appointAgainAndPriceAgainButtonView disableButtons];
        }
        [scrollView addSubview:self.appointAgainAndPriceAgainButtonView];
        ///将按钮View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_appointAgainAndPriceAgainButtonView];
        [self.bargainingPriceHistoryView addAfterView:&_appointAgainAndPriceAgainButtonView];
        [self.myPriceView addAfterView:&_appointAgainAndPriceAgainButtonView];
        viewContentOffsetY = self.appointAgainAndPriceAgainButtonView.frame.origin.y+self.appointAgainAndPriceAgainButtonView.frame.size.height;
        
    }
    
    //!<再次预约和拒绝还价按钮View
    if (self.orderDetailData.isShowAppointAgainAndRejectPriceButtonView) {
        
        self.appointAgainAndRejectPriceButtonView = [[QSPOrderDetailAppointAgainAndRejectPriceButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeLeft:
                    NSLog(@"QSPOrderDetailAppointAgainAndRejectPriceButtonView:再次预约");
                    [self appointmentAgainAction];
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailAppointAgainAndRejectPriceButtonView:拒绝还价");
                    //房客拒绝还价为直接取消订单
                    [self cancelAppointmentOrder];
                    break;
                default:
                    break;
            }
            
        }];
        [scrollView addSubview:self.appointAgainAndRejectPriceButtonView];
        ///将按钮View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_appointAgainAndRejectPriceButtonView];
        [self.bargainingPriceHistoryView addAfterView:&_appointAgainAndRejectPriceButtonView];
        [self.myPriceView addAfterView:&_appointAgainAndRejectPriceButtonView];
        viewContentOffsetY = self.appointAgainAndRejectPriceButtonView.frame.origin.y+self.appointAgainAndRejectPriceButtonView.frame.size.height;
        
        if ([@"500252" isEqualToString:self.orderDetailData.order_status]) {
            [self.appointAgainAndRejectPriceButtonView disableButtons];
        }
        
    }
    
    //!<拒绝预约和接受预约按钮View
    if (self.orderDetailData.isShowRejectAndAcceptAppointmentButtonView) {
        
        self.rejectAndAcceptAppointmentButtonView = [[QSPOrderDetailRejectAndAcceptAppointmentButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeLeft:
                    NSLog(@"QSPOrderDetailRejectAndAcceptAppointmentButtonView:拒绝预约");
                    [self cancelAppointmentOrder];
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailRejectAndAcceptAppointmentButtonView:接受预约");
                    [self commitAppointmentOrder];
                    break;
                default:
                    break;
            }
            
        }];
        [scrollView addSubview:self.rejectAndAcceptAppointmentButtonView];
        ///将按钮View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_rejectAndAcceptAppointmentButtonView];
        [self.bargainingPriceHistoryView addAfterView:&_rejectAndAcceptAppointmentButtonView];
        [self.myPriceView addAfterView:&_rejectAndAcceptAppointmentButtonView];
        viewContentOffsetY = self.rejectAndAcceptAppointmentButtonView.frame.origin.y+self.rejectAndAcceptAppointmentButtonView.frame.size.height;
        
    }
    
    //!<取消成交和提醒房客按钮View
    if (self.orderDetailData.isShowCancelTransAndWarmBuyerButtonView) {
        
        self.cancelTransactionAndWarmBuyerButtonView = [[QSPOrderDetailCancelTransAndWarmBuyerButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeLeft:
                    NSLog(@"QSPOrderDetailCancelTransAndWarmBuyerButtonView:取消成交");
                    [self cacelTransactionOrder];
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailCancelTransAndWarmBuyerButtonView:提醒房客");
                    [self noticeUserOnTransactionOrder];
                    break;
                default:
                    break;
            }
            
        }];
        [scrollView addSubview:self.cancelTransactionAndWarmBuyerButtonView];
        ///将按钮View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_cancelTransactionAndWarmBuyerButtonView];
        [self.bargainingPriceHistoryView addAfterView:&_cancelTransactionAndWarmBuyerButtonView];
        [self.myPriceView addAfterView:&_cancelTransactionAndWarmBuyerButtonView];
        viewContentOffsetY = self.cancelTransactionAndWarmBuyerButtonView.frame.origin.y+self.cancelTransactionAndWarmBuyerButtonView.frame.size.height;
        
    }
    
    if (self.orderDetailData.isShowCancelTransAndWarmSalerButtonView) {
        
        self.cancelTransAndWarmSalerButtonView = [[QSPOrderDetailCancelTransAndWarmSalerButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeLeft:
                    NSLog(@"QSPOrderDetailCancelTransAndWarmSalerButtonView:取消成交");
                    [self cacelTransactionOrder];
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailCancelTransAndWarmSalerButtonView:提醒业主");
                    [self noticeUserOnTransactionOrder];
                    break;
                default:
                    break;
            }
            
        }];
        [scrollView addSubview:self.cancelTransAndWarmSalerButtonView];
        ///将按钮View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_cancelTransAndWarmSalerButtonView];
        [self.bargainingPriceHistoryView addAfterView:&_cancelTransAndWarmSalerButtonView];
        [self.myPriceView addAfterView:&_cancelTransAndWarmSalerButtonView];
        viewContentOffsetY = self.cancelTransAndWarmSalerButtonView.frame.origin.y+self.cancelTransAndWarmSalerButtonView.frame.size.height;
        
    }
    
    //!<取消成交和确认成交按钮View
    if (self.orderDetailData.isShowCancelTransAndCompleteButtonView) {
        
        self.cancelTransAndCompleteButtonView = [[QSPOrderDetailCancelTransAndCompleteButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeLeft:
                    NSLog(@"QSPOrderDetailCancelTransAndCompleteButtonView:取消成交");
                    [self cacelTransactionOrder];
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailCancelTransAndCompleteButtonView:确认成交");
                    [self commitTransactionOrder];
                    break;
                default:
                    break;
            }
            
        }];
        [scrollView addSubview:self.cancelTransAndCompleteButtonView];
        ///将按钮View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_cancelTransAndCompleteButtonView];
        [self.bargainingPriceHistoryView addAfterView:&_cancelTransAndCompleteButtonView];
        [self.myPriceView addAfterView:&_cancelTransAndCompleteButtonView];
        viewContentOffsetY = self.cancelTransAndCompleteButtonView.frame.origin.y+self.cancelTransAndCompleteButtonView.frame.size.height;

    }
    
    //!<接受申请、拒绝申请按钮View
    if (self.orderDetailData.isShowAcceptOrRejectApplicationView) {
        
        self.acceptOrRejectApplicationView = [[QSPOrderDetailAcceptOrRejectApplicationView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeLeft:
                    NSLog(@"QSPOrderDetailAcceptOrRejectApplicationView:接受申请");
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailAcceptOrRejectApplicationView:拒绝申请");
                    break;
                default:
                    break;
            }
            
        }];
        [scrollView addSubview:self.acceptOrRejectApplicationView];
        ///将按钮View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_acceptOrRejectApplicationView];
        [self.bargainingPriceHistoryView addAfterView:&_acceptOrRejectApplicationView];
        [self.myPriceView addAfterView:&_acceptOrRejectApplicationView];
        viewContentOffsetY = self.acceptOrRejectApplicationView.frame.origin.y+self.acceptOrRejectApplicationView.frame.size.height;
        
    }
    
    //!<再次预约、取消申请按钮View
    if (self.orderDetailData.isShowAppointAgainOrCancelApplicationView) {
        
        self.appointAgainOrCancelApplicationView = [[QSPOrderDetailAppointAgainOrCancelApplicationView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeLeft:
                    NSLog(@"QSPOrderDetailAppointAgainOrCancelApplicationView:再次预约");
                    [self appointmentAgainAction];
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailAppointAgainOrCancelApplicationView:取消申请");
                    [self cancelAppointmentOrder];
                    break;
                default:
                    break;
            }
            
        }];
        [scrollView addSubview:self.appointAgainOrCancelApplicationView];
        ///将按钮View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_appointAgainOrCancelApplicationView];
        [self.bargainingPriceHistoryView addAfterView:&_appointAgainOrCancelApplicationView];
        [self.myPriceView addAfterView:&_appointAgainOrCancelApplicationView];
        viewContentOffsetY = self.appointAgainOrCancelApplicationView.frame.origin.y+self.appointAgainOrCancelApplicationView.frame.size.height;
        
    }
    
    //!<再次预约、申请议价按钮View
    if (self.orderDetailData.isShowAppointAgainAndApplicationBargainView) {
        
        self.appointAgainAndApplicationBargainView = [[QSPOrderDetailAppointAgainAndApplicationBargainView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeLeft:
                    NSLog(@"QSPOrderDetailAppointAgainAndApplicationBargainView:再次预约");
                    [self appointmentAgainAction];
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailAppointAgainAndApplicationBargainView:申请议价");
                    {
                        TIPS_ALERT_MESSAGE_CONFIRMBUTTON(nil,@"是否向业主提出议价申请?",@"取消",@"确认",^(int buttonIndex) {
                            
                            ///判断按钮事件:0取消
                            if (1 == buttonIndex) {
                                
                                [self buyerAskForBargainAgain];
                                
                            }
                            
                        })
                    }
                    break;
                default:
                    break;
            }
            
        }];
        [scrollView addSubview:self.appointAgainAndApplicationBargainView];
        ///将按钮View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_appointAgainAndApplicationBargainView];
        [self.bargainingPriceHistoryView addAfterView:&_appointAgainAndApplicationBargainView];
        [self.myPriceView addAfterView:&_appointAgainAndApplicationBargainView];
        viewContentOffsetY = self.appointAgainAndApplicationBargainView.frame.origin.y+self.appointAgainAndApplicationBargainView.frame.size.height;
        
    }
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, viewContentOffsetY+20)];
    
    //>***********中间ScrollView内容区
    
    
    if (self.orderDetailData.o_expand_1) {
        
        if ([self.orderDetailData.o_expand_1 isKindOfClass:[NSString class]]) {
            
            if ([self.orderDetailData.o_expand_1 isEqualToString:@"500202"]) {
                
                //设置提示信息
                if (self.remarkRejectPriceView) {
                    
                    
                    NSString *tipStr = @"";
                    
                    if (uUserCountTypeTenant == [self.orderDetailData getUserType]) {
                        
                        tipStr = @"温馨提示：你已再次预约业主看房，订单将暂时不可操作，待再次看房时间结束后开启。";
                        
                    }else if (uUserCountTypeOwner == [self.orderDetailData getUserType]) {
                        
                        tipStr = @"温馨提示：房客已再次预约你看房，订单将暂时不可操作，待再次看房时间结束后开启。";
                        
                    }
                    
                    [self.remarkRejectPriceView setTitleTip:tipStr];
                    
                }
                
                //禁用按钮  QSPOrderBottomButtonView
                
                for (UIView *view in [scrollView subviews]) {
                    
                    if ([view isKindOfClass:[QSPOrderBottomButtonView class]]) {
                        
                        [(QSPOrderBottomButtonView*)view disableButtons];
                        
                    }
                    
                }
                
                for (UIView *view in [self.contentBgView subviews]) {
                    
                    if ([view isKindOfClass:[QSPOrderBottomButtonView class]]) {
                        
                        [(QSPOrderBottomButtonView*)view disableButtons];
                        
                    }
                    
                }
                
                if (uUserCountTypeOwner == [self.orderDetailData getUserType]) {
                    //业主
                    
                    NSArray *timeList = self.orderDetailData.appoint_list;
                    
                    if (timeList&&[timeList isKindOfClass:[NSArray class]]) {
                        
                        //FIXME: 依赖预约时间列表的排序
                        QSOrderDetailAppointTimeDataModel *timeItem = [timeList objectAtIndex:[timeList count]-1];
                        
                        if (timeItem&&[timeItem isKindOfClass:[QSOrderDetailAppointTimeDataModel class]]) {
                            
                            QSPOrderTipsButtonPopView *acceptOrRejectAppointmentPopView = [[QSPOrderTipsButtonPopView alloc] initWithAcceptOrRejectAppointmentViewWithTip:[NSString stringWithFormat:@"房客再次预约看房\n预约时间:%@",timeItem.time] withUserType:[self.orderDetailData getUserType] andCallBack:^(UIButton *button, ORDER_BUTTON_TIPS_ACTION_TYPE actionType) {
                                
                                if (actionType == oOrderButtonTipsActionTypeCancel) {
                                    
                                    //拒绝再次预约
                                    [self cancelAppointmentOrder];
                                    
                                }else if (actionType == oOrderButtonTipsActionTypeConfirm) {
                                    
                                    //接受再次预约
                                    [self commitAppointmentOrder];
                                    
                                }
                                
                            }];
                            
                            [self.navigationController.view addSubview:acceptOrRejectAppointmentPopView];
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getDetailData];
    
    ///注册键盘弹出监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarHideAction:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - 键盘弹出和回收
- (void)keyboarShowAction:(NSNotification *)sender
{
    
    //上移：需要知道键盘高度和移动时间
    CGRect keyBoardRect = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval anTime;
    [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
    
    CGRect keyboardRect = [self.view convertRect:keyBoardRect fromView:nil];
    CGRect textFieldRect = [self.view convertRect:self.inputMyPriceView.frame fromView:self.inputMyPriceView.superview];
    
    if (textFieldRect.origin.y + textFieldRect.size.height + 2.0f > (self.view.frame.size.height-keyboardRect.size.height)) {
        
        [UIView animateWithDuration:anTime animations:^{
            
            [self.view setFrame:CGRectMake(self.view.frame.origin.x,  ((self.view.frame.size.height-keyboardRect.size.height) - (textFieldRect.origin.y + textFieldRect.size.height + 2.0f)), self.view.frame.size.width, self.view.frame.size.height)];
            
        }];
        
    }
    
}

- (void)keyboarHideAction:(NSNotification *)sender
{
    
    NSTimeInterval anTime;
    [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
    
    [UIView animateWithDuration:anTime animations:^{
        
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
    }];
    
}

#pragma mark - 获取订单详情数据
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
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
//    id_	true	string	订单id
//    user_id	true	string	获取的用户id
    
    [tempParam setObject:self.orderID forKey:@"id_"];
    
    REQUEST_TYPE requestType;
    if (orderType == mOrderWithUserTypeAppointment) {//预约订单
        requestType = rRequestTypeOrderAppointmentDetailData;
    }else if (orderType == mOrderWithUserTypeTransaction) {//成交订单
        requestType = rRequestTypeOrderTransationDetailData;
    }
    
    [QSRequestManager requestDataWithType:requestType andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSOrderDetailReturnData *headerModel = resultData;
        
        ///转换模型
        if (rRequestResultTypeSuccess == resultStatus) {
            
            self.orderDetailData = headerModel.orderDetailData;
            [self.orderDetailData updateViewsFlags];
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


#pragma mark - 请求取消预约订单
- (void)cancelAppointmentOrder
{
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
//    必选	类型及范围	说明
//    user_id	true	int	用户id
//    order_id	true	string	订单id
//    cause	true	string	取消的原因，字符串（暂定）
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    [tempParam setObject:@"" forKey:@"cause"];
 
    [QSRequestManager requestDataWithType:rRequestTypeOrderCancelAppointment andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        ///转换模型
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self getDetailData];
            
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

#pragma mark - 房主接受客人的预约

- (void)commitAppointmentOrder
{
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
//    必选	类型及范围	说明
//    user_id	true	string	确认的用户id(房主)
//    order_id	true	string	订单id
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderCommitAppointment andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self getDetailData];
            
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

#pragma mark - 房主确认完成看房
- (void)salerCommitInspectedOrder
{
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
//    必选	类型及范围	说明
//    user_id	true	string	操作用户id
//    order_id	true	string	订单id
//    score	true	float	总体分数,满分10分(房客确认的时候才需要)
//    manner_score	true	float	服务态度,满分10分(房客确认的时候才需要)
//    desc	true	string	评价描述(房客确认的时候才需要)
//    suitable	true	int	1:合适 4：不合适 (如果不是1，全部为不合适----房客确认的时候才需要)
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    [tempParam setObject:@"" forKey:@"score"];
    [tempParam setObject:@"" forKey:@"manner_score"];
    [tempParam setObject:@"" forKey:@"desc"];
    [tempParam setObject:@"" forKey:@"suitable"];
    
//    if (self.orderDetailData && [self.orderDetailData isKindOfClass:[QSOrderDetailInfoDataModel class]]) {
//        
//        if (uUserCountTypeTenant == [self.orderDetailData getUserType]) {
//            
//            [tempParam setObject:@"8" forKey:@"score"];
//            [tempParam setObject:@"7" forKey:@"manner_score"];
//            [tempParam setObject:@"不合适，还没添加评价描述" forKey:@"desc"];
//            [tempParam setObject:@"1" forKey:@"suitable"];//1:合适 4：不合适 (如果不是1，全部为不合适----房客确认的时候才需要)
//            
//        }
//    }
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderCommitInspected andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self getDetailData];
            
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

#pragma mark - 提交我的出价
- (void)submitMyInputPrice
{
    
    NSString *priceStr = nil;
    if (self.inputMyPriceView) {
        priceStr = [self.inputMyPriceView getInputPrice];
    }
    
    if (!priceStr || [priceStr isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入您的出价", 1.0f, ^(){
            
        })
        return;
        
    }
    
    NSScanner* scan = [NSScanner scannerWithString:priceStr];
    float val;
    BOOL flag = [scan scanFloat:&val] && [scan isAtEnd];
    
    if (!flag) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入正确的价格格式", 1.0f, ^(){
            
        })
        
    }
    
    NSString *housePrice = @"";
    
    if (self.orderDetailData) {
        
        if (self.orderDetailData || [self.orderDetailData isKindOfClass:[QSOrderDetailInfoDataModel class]]) {
            
            housePrice = self.orderDetailData.house_msg.house_price;
            if ([self.orderDetailData.order_type isEqualToString:@"500103"]) {
                //出租房
                housePrice = self.orderDetailData.house_msg.rent_price;
            }
        }
    }
    
    CGFloat inputPriceF = priceStr.floatValue*10000;
    
    if ([self.orderDetailData.order_type isEqualToString:@"500103"])
    {
        inputPriceF = priceStr.floatValue;
    }
    
    if (housePrice.floatValue < inputPriceF) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入小于房价的金额", 1.0f, ^(){
            
            if (self.inputMyPriceView ) {
                
                [self.inputMyPriceView setPrice:@""];
                
            }
            
        })
        
        return;
        
    }
    
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
//    必选	类型及范围	说明
//    user_id	true	string	用户id
//    order_id	true	string	订单id
//    price	true	float	价格，没单位， 就是说如果是要传递200W过来请自己补齐后面的0，eg:200W 就是 2000000

    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    
    if (![self.orderDetailData.order_type isEqualToString:@"500103"]) {
        
        //价格单位从万转元
        priceStr = [NSString stringWithFormat:@"%f",inputPriceF];
        
    }
    
    [tempParam setObject:priceStr forKey:@"price"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderSubmitBid andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self getDetailData];
            
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

#pragma mark - 业主拒绝还价
- (void)salerRejectPrice
{

    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
//    必选	类型及范围	说明
//    user_id	true	string	用户id
//    order_id	true	string	订单id
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderRejectPrice andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self getDetailData];
            
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

#pragma mark - 接受价格，接受还价
- (void)salerAcceptPrice
{
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    //    必选	类型及范围	说明
    //    user_id	true	string	用户id
    //    order_id	true	string	订单id
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderSalerAcceptPrice andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self getDetailData];
            
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

#pragma mark - 房客或业主成交预约订单
- (void)buyerOrSalerCommitAppointmentOrder
{
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    //    必选	类型及范围	说明
    //    user_id	true	string	用户id
    //    order_id	true	string	订单id
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderBuyerOrSalerCommitOrder andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self getDetailData];
            
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

#pragma mark - 取消成交订单
- (void)cacelTransactionOrder
{
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    //    必选	类型及范围	说明
    //    user_id	true	string	用户id
    //    order_id	true	string	订单id
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderCancelTransation andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self getDetailData];
            
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

#pragma mark - 确认成交订单
- (void)commitTransactionOrder
{
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    //    必选	类型及范围	说明
    //    user_id	true	string	用户id
    //    order_id	true	string	订单id
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderCommitTransation andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self getDetailData];
            
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


#pragma mark - 成交订单提醒对方
- (void)noticeUserOnTransactionOrder
{
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    //    必选	类型及范围	说明
    //    user_id	true	string	用户id
    //    order_id	true	string	订单id
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderTransationNoticeUser andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self getDetailData];
            
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

#pragma mark - 投诉业主
- (void)complaintSaler
{
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        return;
    }
    
    if (self.orderDetailData.saler_msg) {
        
        QSYContactComplaintViewController *ccVc = [[QSYContactComplaintViewController alloc] initWithIndicteeId:nil andSueder:[self.orderDetailData getUserType]==uUserCountTypeTenant?@"BUYER":@"SALER" andOrderID:self.orderID WithDesc:@"订单投诉-投诉业主" andCallBack:^(BOOL isComplaint) {
            
        }];
        
        [self.navigationController pushViewController:ccVc animated:YES];
        
    }
    
}

#pragma mark - 投诉房客
- (void)complaintBuyer
{
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        return;
    }
    
    if (self.orderDetailData.saler_msg) {
        
//        QSYContactComplaintViewController *ccVc = [[QSYContactComplaintViewController alloc] initWithContactID:self.orderDetailData.buyer_msg.id_ andContactName:self.orderDetailData.buyer_msg.username andOrderID:self.orderID andCallBack:^(BOOL isComplaint) {
//            
//            
//        }];
        
        QSYContactComplaintViewController *ccVc = [[QSYContactComplaintViewController alloc] initWithIndicteeId:nil andSueder:[self.orderDetailData getUserType]==uUserCountTypeTenant?@"BUYER":@"SALER" andOrderID:self.orderID WithDesc:@"订单投诉-投诉房客" andCallBack:^(BOOL isComplaint) {
            
        }];
        
        [self.navigationController pushViewController:ccVc animated:YES];
        
    }
    
}

#pragma mark - 再次预约
- (void)appointmentAgainAction{
    
    QSPOrderBookTimeViewController *btVc = [[QSPOrderBookTimeViewController alloc] initWithSubmitCallBack:^(BOOKTIME_RESULT_TYPE resultTag,NSString *orderID) {
        
        if (bBookResultTypeSucess == resultTag) {
            //修改成功,更新详情
            [self getDetailData];
        }
        
    }];
    [btVc setVcType:bBookTypeViewControllerBookAgain];
    [btVc setOrderID:self.orderDetailData.id_];
    if (self.orderDetailData.house_msg) {
        [btVc setHouseInfo:self.orderDetailData.house_msg];
    }
    if (self.orderDetailData.order_type &&[self.orderDetailData.order_type isKindOfClass:[NSString class]]) {
        
        //500101:一手房购买订单, 500102 二手房，500103出租房
        if ([self.orderDetailData.order_type isEqualToString:@"500101"])
        {
            
            [btVc setHouseType:fFilterMainTypeNewHouse];
            
        }else if ([self.orderDetailData.order_type isEqualToString:@"500102"])
        {
            
            [btVc setHouseType:fFilterMainTypeSecondHouse];
            
        }else if ([self.orderDetailData.order_type isEqualToString:@"500103"])
        {
            
            [btVc setHouseType:fFilterMainTypeRentalHouse];
            
        }
        
    }
    [self.navigationController pushViewController:btVc animated:YES];
    
}

#pragma mark - 房客申请议价
- (void)buyerAskForBargainAgain
{
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    //    必选	类型及范围	说明
    //    user_id	true	string	用户id
    //    order_id	true	string	订单id
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderAppointmentaApplyBargain andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self getDetailData];
            
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
