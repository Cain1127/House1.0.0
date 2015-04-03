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

//ScrollView底部悬浮按钮
@property (nonatomic, strong) QSPOrderDetailChangeOrderButtonView *changeOrderButtonView;  //!<修改订单按钮View
@property (nonatomic, strong) QSPOrderDetailCancelAppointmentButtonView *cancelAppointmentButtonView;     //!<取消预约按钮View
@property (nonatomic, strong) QSPOrderDetailConfirmOrderButtonView *confirmOrderButtonView; //!<房源非常满意，我要成交按钮View
@property (nonatomic, strong) QSPOrderDetailConfirmOrderDisableButtonView *confirmOrderDisableButtonView; //!<房源非常满意，我要成交不能点击按钮View
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
    
    if (!self.orderDetailData || ![self.orderDetailData  isKindOfClass:[QSOrderDetailInfoDataModel class]]) {
        
        NSLog(@"self.orderDetailData 数据不正确！");
        
        return;
    }
    
    if (self.orderDetailData) {
        
        titleTip = [self.orderDetailData getStatusTitle];
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
                    NSLog(@"QSPOrderDetailChangeOrderButtonView:修改订单");
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
                    break;
                default:
                    break;
            }
            
        }];
        [self.cancelAppointmentButtonView setCenterButtonType:nNormalButtonTypeCornerWhiteGray];
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
                    break;
                default:
                    break;
            }
            
        }];
        [self.contentBgView addSubview:self.confirmOrderButtonView];
        
    }

    //!<提交出价按钮View
    if (self.orderDetailData.isShowSubmitPriceButtonView) {
        
        viewBottomButtonOffsetY = SIZE_DEVICE_HEIGHT - (2*CONTENT_TOP_BOTTOM_OFFSETY+44.0f);
        self.submitPriceButtonView = [[QSPOrderDetailSubmitPriceButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewBottomButtonOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    NSLog(@"QSPOrderDetailSubmitPriceButtonView:提交出价按钮");
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
                    NSLog(@"QSPOrderDetailAppointmentSalerAgainButtonView:重新预约业主按钮按钮");
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
        }];
        [scrollView addSubview:_houseInfoView];
        ///将房源简介引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_houseInfoView];
        viewContentOffsetY = self.houseInfoView.frame.origin.y+self.houseInfoView.frame.size.height;
        
    }
    
    ///房源价格
    if (self.orderDetailData.isShowHousePriceView) {
        
        self.housePriceView = [[QSPOrderDetailHousePriceView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withHouseData:houseData andCallBack:^(UIButton *button) {
            NSLog(@" clickBt");
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
                
            }
            
        }];
        [scrollView addSubview:_addressView];
        ///将地址栏引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_addressView];
        viewContentOffsetY = _addressView.frame.origin.y+_addressView.frame.size.height;
        
    }
    
    //业主信息栏
    if (self.orderDetailData.isShowOwnerInfoView) {
        
        self.personView = [[QSPOrderDetailPersonInfoView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withOrderData:self.orderDetailData andCallBack:^(UIButton *button) {
            
            NSLog(@"askButton");
            
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
            
        }];
        [scrollView addSubview:self.myPriceView];
        ///将我的出价View引用添加进看房时间控件管理作动态高度扩展
        [self.showingsTimeView addAfterView:&_myPriceView];
        viewContentOffsetY = _myPriceView.frame.origin.y+_myPriceView.frame.size.height;
        
    }
    
    //!<输入我的出价View
    self.inputMyPriceView = [[QSPOrderDetailInputMyPriceView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY)];
    [scrollView addSubview:self.inputMyPriceView];
    ///将输入我的出价View引用添加进看房时间控件管理作动态高度扩展
    [self.showingsTimeView addAfterView:&_inputMyPriceView];
    [self.myPriceView addAfterView:&_inputMyPriceView];
    viewContentOffsetY = _inputMyPriceView.frame.origin.y+_inputMyPriceView.frame.size.height;
    if (!self.orderDetailData.isShowInputMyPriceView) {
        SetHeightToZero(self.inputMyPriceView);
    }
    
    //!<最后成交价View
    if (self.orderDetailData.isShowTransactionPriceView) {
        
        self.transactionPriceView = [[QSPOrderDetailTransactionPriceView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY)];
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
    
    //!<备注:拒绝还价将视为取消订单View
    if (self.orderDetailData.isShowRemarkRejectPriceView) {
        
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
        
        self.commentNoteTipsView = [[QSPOrderDetailCommentNoteTipsView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY)];
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
                    NSLog(@"QSPOrderDetailComplaintAndCommentButtonView:我要评价");
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailComplaintAndCommentButtonView:评价房源");
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
                    NSLog(@"QSPOrderDetailComplaintAndCompletedButtonView:我要评价");
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailComplaintAndCompletedButtonView:评价房源");
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
        
        self.appointAgainButtonView = [[QSPOrderDetailAppointAgainButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewBottomButtonOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeOne:
                    NSLog(@"QSPOrderDetailAppointAgainButtonView:再次预约");
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
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailAppointAgainAndPriceAgainButtonView:我要议价");
                    break;
                default:
                    break;
            }
            
        }];
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
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailAppointAgainAndRejectPriceButtonView:拒绝还价");
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
        
    }
    
    //!<拒绝预约和接受预约按钮View
    if (self.orderDetailData.isShowRejectAndAcceptAppointmentButtonView) {
        
        self.rejectAndAcceptAppointmentButtonView = [[QSPOrderDetailRejectAndAcceptAppointmentButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
            switch (buttonType) {
                case bBottomButtonTypeLeft:
                    NSLog(@"QSPOrderDetailRejectAndAcceptAppointmentButtonView:拒绝预约");
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailRejectAndAcceptAppointmentButtonView:接受预约");
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
                    break;
                case bBottomButtonTypeRight:
                    NSLog(@"QSPOrderDetailCancelTransAndWarmBuyerButtonView:提醒房客");
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
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, viewContentOffsetY+20)];
    
    //>***********中间ScrollView内容区
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self checkLoginAndShowLoginWithBlock:^(BOOL flag) {
    
//        [self getDetailData];
    
//    }];
    
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
