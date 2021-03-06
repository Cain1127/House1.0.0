//
//  QSPSalerBookedOrderListsTableViewCell.m
//  House
//
//  Created by CoolTea on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPSalerBookedOrderListsTableViewCell.h"
#import "UIKit+AFNetworking.h"
#import "CoreHeader.h"
#include <objc/runtime.h>
#import "QSOrderListReturnData.h"
#import "QSYTalkPTPViewController.h"
#import "QSYPopCustomView.h"
#import "QSYCallTipsPopView.h"
#import "QSCustomHUDView.h"
#import "QSPOrderDetailActionReturnBaseDataModel.h"
#import "QSPSalerBookedOrdersListsViewController.h"
#import "QSPOrderTipsButtonPopView.h"
#import "QSPSalerTransactionOrderListViewController.h"
#import "QSYContactComplaintViewController.h"

///关联
static char stateLabelKey;      //!<状态Label关联key
static char personNameLabelKey; //!<房客名字Label关联key
static char infoLabelKey;       //!<时间,出价等简介Label关联key
static char leftActionBtKey;    //!<右部左边按钮关联key
static char rightActionBtKey;   //!<右部右边按钮关联key

@interface QSPSalerBookedOrderListsTableViewCell ()

@property(nonatomic,strong) QSOrderListItemData *orderData;
@property(nonatomic,assign) NSInteger       selectedIndex;

@end

@implementation QSPSalerBookedOrderListsTableViewCell

@synthesize parentViewController;

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///UI搭建
        [self createListCellUI];
        
    }
    return self;
    
}

- (void)createListCellUI
{
    
    //状态
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 16.0f, MY_ZONE_ORDER_LIST_CELL_WIDTH-100, 20)];
    [stateLabel setFont:[UIFont systemFontOfSize:FONT_BODY_12]];
    [self.contentView addSubview:stateLabel];
    
    objc_setAssociatedObject(self, &stateLabelKey, stateLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //业主、经纪人、开发商
    UILabel *personNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(stateLabel.frame.origin.x, stateLabel.frame.origin.y+stateLabel.frame.size.height, stateLabel.frame.size.width, 20)];
    [personNameLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
    [personNameLabel setTextColor:COLOR_CHARACTERS_BLACK];
    [self.contentView addSubview:personNameLabel];
    
    objc_setAssociatedObject(self, &personNameLabelKey, personNameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //时间
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(personNameLabel.frame.origin.x, personNameLabel.frame.origin.y+personNameLabel.frame.size.height, personNameLabel.frame.size.width, personNameLabel.frame.size.height)];
    [infoLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
    [self.contentView addSubview:infoLabel];
    
    objc_setAssociatedObject(self, &infoLabelKey, infoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    
    //右部左按钮
    QSBlockButtonStyleModel *leftActionBtStyle = [[QSBlockButtonStyleModel alloc] init];
    //    leftActionBtStyle.imagesNormal = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
    //    leftActionBtStyle.imagesHighted = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
    UIButton *leftBt = [UIButton createBlockButtonWithFrame:CGRectMake(MY_ZONE_ORDER_LIST_CELL_WIDTH-70.0f, stateLabel.frame.origin.y+stateLabel.frame.size.height+8, 30.0f, 34.0f) andButtonStyle:leftActionBtStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"leftActionBt");
        if (500210 == button.tag  || 500213 == button.tag || 500250 == button.tag || 500232 == button.tag  || 500258 == button.tag ) {
            //打电话
            [self callPhone];
        }else if (500203 == button.tag || 500201 == button.tag) {
            //取消预约
//            __block QSPOrderTipsButtonPopView *popView = [[QSPOrderTipsButtonPopView alloc] initWithActionSelectedWithTip:@"是否取消房客预约？" andCallBack:^(UIButton *button, ORDER_BUTTON_TIPS_ACTION_TYPE actionType) {
//                
//                if (actionType == oOrderButtonTipsActionTypeCancel) {
//                    
//                }else if (actionType == oOrderButtonTipsActionTypeConfirm) {
//                    
//                    [self cancelAppointmentOrder];
//                    
//                }
//                
//            }];
//            
//            [popView setParentViewController:self.parentViewController];
//            if (self.parentViewController) {
//                [self.parentViewController.view addSubview:popView];
//            }
            
            NSString *orderID = @"";
            
            if (self.orderData) {
                
                if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
                    
                    NSArray *orderList = self.orderData.orderInfoList;
                    
                    if (orderList&&[orderList isKindOfClass:[NSArray class]]&&_selectedIndex<[orderList count]) {
                        
                        QSOrderListOrderInfoDataModel *orderItem = [orderList objectAtIndex:_selectedIndex];
                        
                        if (orderItem && [orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                            
                            orderID = orderItem.id_;
                            
                        }
                        
                    }
                }
            }
            
            QSYContactComplaintViewController *ccVc = [[QSYContactComplaintViewController alloc] initWithCancelOrderWithSueder:@"SALER" andOrderID:orderID WithDesc:@"业主取消订单" andCallBack:^(BOOL isComplaint) {
                
            }];
            
            if (self.parentViewController) {
                [self.parentViewController.navigationController pushViewController:ccVc animated:YES];
            }

        }else if (500252 == button.tag ){
            //编辑还价
            NSString *houseName = @"";
            NSString *housePrice = @"";
            NSString *orderID = @"";
            NSString *houseType = @"";
            
            if (self.orderData) {
                
                if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
                    
                    houseName = self.orderData.houseData.title;
                    NSArray *orderList = self.orderData.orderInfoList;
                    
                    if (orderList&&[orderList isKindOfClass:[NSArray class]]&&_selectedIndex<[orderList count]) {
                        
                        QSOrderListOrderInfoDataModel *orderItem = [orderList objectAtIndex:_selectedIndex];
                        
                        if (orderItem && [orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                            
                            housePrice = orderItem.last_buyer_bid;
                            orderID = orderItem.id_;
                            houseType = orderItem.order_type;
                            
                        }
                        
                    }
                }
            }
            
            __block QSPOrderTipsButtonPopView *popView = [[QSPOrderTipsButtonPopView alloc] initWithInputPriceVieWithHouseTitle:houseName WithPrice:housePrice withUserType:uUserCountTypeTenant withHouseType:houseType andCallBack:^(UIButton *button, ORDER_BUTTON_TIPS_ACTION_TYPE actionType) {
                
                if (actionType == oOrderButtonTipsActionTypeConfirm) {
                    //提交还价
                    if (popView) {
                        
                        NSString *inputPrice = [popView getInputPrice];
                        NSScanner* scan = [NSScanner scannerWithString:inputPrice];
                        float val;
                        BOOL flag = [scan scanFloat:&val] && [scan isAtEnd];
                        
                        if (flag) {
                            
                            [self submitMyInputPrice:inputPrice ToOrderID:orderID];
                            
                        }else {
                            
                            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入正确的价格格式", 1.0f, ^(){
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
            }];
            [popView setParentViewController:self.parentViewController];
            if (self.parentViewController) {
                [self.parentViewController.view addSubview:popView];
            }
            
        }else if (500253 == button.tag ){
            //拒绝再议价
            __block QSPOrderTipsButtonPopView *popView = [[QSPOrderTipsButtonPopView alloc] initWithActionSelectedWithTip:@"是否拒绝房客申请议价？" andCallBack:^(UIButton *button, ORDER_BUTTON_TIPS_ACTION_TYPE actionType) {
                
                if (actionType == oOrderButtonTipsActionTypeCancel) {
                    
                }else if (actionType == oOrderButtonTipsActionTypeConfirm) {
                    
                    [self acceptOrRejectApplyBargain:NO];
                    
                }
                
            }];
            
            [popView setParentViewController:self.parentViewController];
            if (self.parentViewController) {
                [self.parentViewController.view addSubview:popView];
            }
            
        }
        
    }];
    [self.contentView addSubview:leftBt];
    
    objc_setAssociatedObject(self, &leftActionBtKey, leftBt, OBJC_ASSOCIATION_ASSIGN);
    
    //右部右按钮
    QSBlockButtonStyleModel *rightActionBtStyle = [[QSBlockButtonStyleModel alloc] init];
    //    rightActionBtStyle.imagesNormal = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
    //    rightActionBtStyle.imagesHighted = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
    UIButton *rightBt = [UIButton createBlockButtonWithFrame:CGRectMake(leftBt.frame.origin.x+leftBt.frame.size.width+4.0f, leftBt.frame.origin.y, leftBt.frame.size.width, leftBt.frame.size.height) andButtonStyle:rightActionBtStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"rightActionBt");
        
        if (500210 == button.tag  || 500213 == button.tag || 500250 == button.tag || 500232 == button.tag || 500258 == button.tag ) {
            //跳转去聊天
            [self goToChat];
            
        }else if (500203 == button.tag || 500201 == button.tag ) {
            //房主接受客人的预约
            __block QSPOrderTipsButtonPopView *popView = [[QSPOrderTipsButtonPopView alloc] initWithActionSelectedWithTip:@"是否接受房客的预约？" andCallBack:^(UIButton *button, ORDER_BUTTON_TIPS_ACTION_TYPE actionType) {
                
                if (actionType == oOrderButtonTipsActionTypeCancel) {
                    
                }else if (actionType == oOrderButtonTipsActionTypeConfirm) {
                    
                    [self commitAppointmentOrder];
                    
                }
                
            }];
            
            [popView setParentViewController:self.parentViewController];
            if (self.parentViewController) {
                [self.parentViewController.view addSubview:popView];
            }
            
        }else if ( 500230 == button.tag || 500231 == button.tag ){
            //房主确认租/买客预约看房
            
            __block QSPOrderTipsButtonPopView *popView = [[QSPOrderTipsButtonPopView alloc] initWithActionSelectedWithTip:@"是否已看完房？" andCallBack:^(UIButton *button, ORDER_BUTTON_TIPS_ACTION_TYPE actionType) {
                
                if (actionType == oOrderButtonTipsActionTypeCancel) {
                    
                }else if (actionType == oOrderButtonTipsActionTypeConfirm) {
                    
                    [self salerCommitInspectedOrder];
                    
                }
                
            }];
            
            [popView setParentViewController:self.parentViewController];
            if (self.parentViewController) {
                [self.parentViewController.view addSubview:popView];
            }
            
        }else if (500252 == button.tag || 500222 == button.tag || 500257 == button.tag){
            //同意还价
            NSString *houseName = @"";
            NSString *housePrice = @"";
            NSString *orderID = @"";
            NSString *houseType = @"";
            
            if (self.orderData) {
                
                if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
                    
                    houseName = self.orderData.houseData.title;
                    NSArray *orderList = self.orderData.orderInfoList;
                    
                    if (orderList&&[orderList isKindOfClass:[NSArray class]]&&_selectedIndex<[orderList count]) {
                        
                        QSOrderListOrderInfoDataModel *orderItem = [orderList objectAtIndex:_selectedIndex];
                        
                        if (orderItem && [orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                            
                            housePrice = orderItem.last_buyer_bid;
                            orderID = orderItem.id_;
                            houseType = orderItem.order_type;
                            
                        }
                        
                    }
                    
                    
                }
            }
            
            __block QSPOrderTipsButtonPopView *popView = [[QSPOrderTipsButtonPopView alloc] initWithAcceptPriceVieWithHouseTitle:houseName WithPrice:housePrice withUserType:uUserCountTypeTenant withHouseType:houseType andCallBack:^(UIButton *button, ORDER_BUTTON_TIPS_ACTION_TYPE actionType) {
                
                if (actionType == oOrderButtonTipsActionTypeConfirm) {
                    //接受还价
                    if (popView) {
                        
                        [self salerAcceptPriceWithOrderID:orderID];
                        
                    }
                    
                }
                
            }];
            [popView setParentViewController:self.parentViewController];
            if (self.parentViewController) {
                [self.parentViewController.view addSubview:popView];
            }
            
        }else if (500302 == button.tag ){
            //提醒房客
            [self noticeUserOnTransactionOrder];
            
        }else if (500301 == button.tag ){
            //确认完成订单
            __block QSPOrderTipsButtonPopView *popView = [[QSPOrderTipsButtonPopView alloc] initWithActionSelectedWithTip:@"是否确认完成订单？" andCallBack:^(UIButton *button, ORDER_BUTTON_TIPS_ACTION_TYPE actionType) {
                
                if (actionType == oOrderButtonTipsActionTypeCancel) {
                    
                }else if (actionType == oOrderButtonTipsActionTypeConfirm) {
                    
                    [self commitTransactionOrder];
                    
                }
                
            }];
            
            [popView setParentViewController:self.parentViewController];
            if (self.parentViewController) {
                [self.parentViewController.view addSubview:popView];
            }
            
//        }else if (500257 == button.tag ){
//            //成交预约订单
//            __block QSPOrderTipsButtonPopView *popView = [[QSPOrderTipsButtonPopView alloc] initWithActionSelectedWithTip:@"房客完成看房后，你的联系方式将对他公开？" andCallBack:^(UIButton *button, ORDER_BUTTON_TIPS_ACTION_TYPE actionType) {
//                
//                if (actionType == oOrderButtonTipsActionTypeCancel) {
//                    
//                }else if (actionType == oOrderButtonTipsActionTypeConfirm) {
//                    
//                    [self buyerOrSalerCommitAppointmentOrder];
//                    
//                }
//                
//            }];
//            
//            [popView setParentViewController:self.parentViewController];
//            if (self.parentViewController) {
//                [self.parentViewController.view addSubview:popView];
//            }
            
        }else if ( 500253 == button.tag ){
            //接受再议价
            __block QSPOrderTipsButtonPopView *popView = [[QSPOrderTipsButtonPopView alloc] initWithActionSelectedWithTip:@"是否接受房客申请议价？" andCallBack:^(UIButton *button, ORDER_BUTTON_TIPS_ACTION_TYPE actionType) {
                
                if (actionType == oOrderButtonTipsActionTypeCancel) {
                    
                }else if (actionType == oOrderButtonTipsActionTypeConfirm) {
                    
                    [self acceptOrRejectApplyBargain:YES];
                    
                }
                
            }];
            
            [popView setParentViewController:self.parentViewController];
            if (self.parentViewController) {
                [self.parentViewController.view addSubview:popView];
            }
            
        }else if (500220 == button.tag ){
            //完成预约订单，进入成交流程
            __block QSPOrderTipsButtonPopView *popView = [[QSPOrderTipsButtonPopView alloc] initWithActionSelectedWithTip:@"确认成交该房源，进入成交流程！" andCallBack:^(UIButton *button, ORDER_BUTTON_TIPS_ACTION_TYPE actionType) {
                
                if (actionType == oOrderButtonTipsActionTypeCancel) {
                    
                }else if (actionType == oOrderButtonTipsActionTypeConfirm) {
                    
                    [self buyerOrSalerCommitAppointmentOrder];
                    
                }
                
            }];
            
            [popView setParentViewController:self.parentViewController];
            if (self.parentViewController) {
                [self.parentViewController.view addSubview:popView];
            }
            
        }
        
    }];
    [self.contentView addSubview:rightBt];
    
    objc_setAssociatedObject(self, &rightActionBtKey, rightBt, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, MY_ZONE_ORDER_LIST_CELL_HEIGHT-0.5f, MY_ZONE_ORDER_LIST_CELL_WIDTH, 0.5f)];
    [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_BLACKH];
    [self.contentView addSubview:bottomLineLablel];
    
}

- (void)updateCellWith:(id)Data withIndex:(NSInteger)index
{
    _selectedIndex = index;
    self.orderData = (QSOrderListItemData*)Data;
    
    [self setTag:index];
    
    UILabel *stateLabel = objc_getAssociatedObject(self, &stateLabelKey);
    if (stateLabel) {
        [stateLabel setText:@""];
    }
    
    UILabel *personNameLabel = objc_getAssociatedObject(self, &personNameLabelKey);
    if (personNameLabel) {
        [personNameLabel setText:@""];
    }
    
    UILabel *infoLabel = objc_getAssociatedObject(self, &infoLabelKey);
    if (infoLabel) {
        [infoLabel setAttributedText:nil];
    }
    
    UIButton *rightBt = objc_getAssociatedObject(self, &rightActionBtKey);
    if (rightBt) {
        [rightBt setTag:0];
        [rightBt setHidden:YES];
    }
    
    UIButton *leftBt = objc_getAssociatedObject(self, &leftActionBtKey);
    if (leftBt) {
        [leftBt setTag:0];
        [leftBt setHidden:YES];
    }
    
    //    QSOrderListItemData
    if (!Data || ![Data isKindOfClass:[QSOrderListItemData class]]) {
        return;
    }

//    if ([orderData getUserIsOwnerFlag]) {
        //非房客
        if (self.orderData.orderInfoList&&[self.orderData.orderInfoList count]>0) {
            
            QSOrderListOrderInfoDataModel *orderInfoData = [self.orderData.orderInfoList objectAtIndex:index];
            if (orderInfoData&&[orderInfoData isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                
                if (stateLabel) {
                    [stateLabel setText:[orderInfoData getStatusTitle]];
                }
                
                NSLog(@"%@ StatusTitle:%@",orderInfoData.order_status,stateLabel.text);
                
                if (personNameLabel) {
                    [personNameLabel setText:[NSString stringWithFormat:@"房客:%@",orderInfoData.buyer_name]];
                }
                
                NSArray *btList = [orderInfoData getButtonSource];
                
                if (btList&&[btList isKindOfClass:[NSArray class]]&&[btList count]>0) {
                    
                    if ([btList count]==1) {
                        
                        QSOrderButtonActionModel *rightBtAction = [btList objectAtIndex:0];
                        
                        if (rightBtAction&&[rightBtAction isKindOfClass:[QSOrderButtonActionModel class]]&&rightBt) {
                            
                            [rightBt setTag:rightBtAction.bottionActionTag];
                            [rightBt setImage:[UIImage imageNamed:rightBtAction.normalImg] forState:UIControlStateNormal];
                            [rightBt setImage:[UIImage imageNamed:rightBtAction.highLightImg] forState:UIControlStateHighlighted];
                            [rightBt setImage:[UIImage imageNamed:rightBtAction.highLightImg] forState:UIControlStateSelected];
                            [rightBt setHidden:NO];
                            
                        }
                        
                    }else if ([btList count]==2) {
                        
                        QSOrderButtonActionModel *rightBtAction = [btList objectAtIndex:0];
                        
                        if (rightBtAction&&[rightBtAction isKindOfClass:[QSOrderButtonActionModel class]]&&rightBt) {
                            
                            [rightBt setTag:rightBtAction.bottionActionTag];
                            [rightBt setImage:[UIImage imageNamed:rightBtAction.normalImg] forState:UIControlStateNormal];
                            [rightBt setImage:[UIImage imageNamed:rightBtAction.highLightImg] forState:UIControlStateHighlighted];
                            [rightBt setImage:[UIImage imageNamed:rightBtAction.highLightImg] forState:UIControlStateSelected];
                            [rightBt setHidden:NO];
                            
                        }
                        
                        QSOrderButtonActionModel *leftBtAction = [btList objectAtIndex:1];
                        
                        if (leftBtAction&&[leftBtAction isKindOfClass:[QSOrderButtonActionModel class]]&&leftBt) {
                            
                            [leftBt setTag:leftBtAction.bottionActionTag];
                            [leftBt setImage:[UIImage imageNamed:leftBtAction.normalImg] forState:UIControlStateNormal];
                            [leftBt setImage:[UIImage imageNamed:leftBtAction.highLightImg] forState:UIControlStateHighlighted];
                            [leftBt setImage:[UIImage imageNamed:leftBtAction.highLightImg] forState:UIControlStateSelected];
                            [leftBt setHidden:NO];
                            
                        }
                    }
                    
                }
                
            }
        }
      
//        
//    }else{
//        //房客
//
//    }
    
    if (infoLabel) {
        
        [infoLabel setAttributedText:[self.orderData getSummaryOnCellAttributedStringWithSelectIndex:_selectedIndex]];
        
    }

    
//        if (leftBt) {
//    
//            [leftBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL] forState:UIControlStateNormal];
//            [leftBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED] forState:UIControlStateHighlighted];
//            [leftBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED] forState:UIControlStateSelected];
//    
//        }
//    
//        if (rightBt) {
//    
//            [rightBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL] forState:UIControlStateNormal];
//            [rightBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED] forState:UIControlStateHighlighted];
//            [rightBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED] forState:UIControlStateSelected];
//    
//        }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 按钮响应

//跳转去聊天
- (void)goToChat
{
    
    if (self.orderData) {
        QSOrderListOrderInfoPersonInfoDataModel *personInfo = nil;
        if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
            
            NSArray *orderList = self.orderData.orderInfoList;
            
            if (orderList&&[orderList isKindOfClass:[NSArray class]]&&_selectedIndex<[orderList count]) {
                
                QSOrderListOrderInfoDataModel *orderItem = [orderList objectAtIndex:_selectedIndex];
                
                if (orderItem && [orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                    
                    if (orderItem.buyer_msg && [orderItem.buyer_msg isKindOfClass:[QSOrderListOrderInfoPersonInfoDataModel class]]) {
                        
                        personInfo = orderItem.buyer_msg;
                        
                    }
                    
                }
                
            }
            
        }
        
        if (self.parentViewController && personInfo) {
            
            QSYTalkPTPViewController *talkVC = [[QSYTalkPTPViewController alloc] initWithUserModel:[personInfo transformToSimpleDataModel]];
            [self.parentViewController.navigationController pushViewController:talkVC animated:YES];
            
        }
        
    }
    
}

//打电话操作
- (void)callPhone
{
    
    if (self.orderData) {
        
        NSString *phoneStr = nil;
        NSString *ownerNameStr = nil;
        
        if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
            
            NSArray *orderList = self.orderData.orderInfoList;
            
            if (orderList&&[orderList isKindOfClass:[NSArray class]]&&_selectedIndex<[orderList count]) {
                
                QSOrderListOrderInfoDataModel *orderItem = [orderList objectAtIndex:_selectedIndex];
                
                if (orderItem && [orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                    
                    phoneStr = orderItem.buyer_phone;
                    ownerNameStr = orderItem.buyer_name;
                    
                }
                
            }
            
        }
        
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
        }else{
            NSLog(@"电话号码为空！");
        }
    }
    
}

#pragma mark - 请求取消预约订单
- (void)cancelAppointmentOrder
{
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    //    必选	类型及范围	说明
    //    user_id	true	int	用户id
    //    order_id	true	string	订单id
    //    cause	true	string	取消的原因，字符串（暂定）
    
    NSString *orderID = nil;
    
    if (self.orderData) {
        
        if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
            
            NSArray *orderList = self.orderData.orderInfoList;
            
            if (orderList&&[orderList isKindOfClass:[NSArray class]]&&_selectedIndex<[orderList count]) {
                
                QSOrderListOrderInfoDataModel *orderItem = [orderList objectAtIndex:_selectedIndex];
                
                if (orderItem && [orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                    orderID = orderItem.id_;
                }
            }
        }
    }
    
    if (!orderID || [orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
//            if (self.parentViewController){
//                
//                [self.parentViewController.navigationController popViewControllerAnimated:YES];
//                
//            }
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:orderID forKey:@"order_id"];
    [tempParam setObject:@"" forKey:@"cause"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderCancelAppointment andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        ///转换模型
        if (headerModel) {
            
            if (headerModel&&[headerModel isKindOfClass:[QSHeaderDataModel class]]) {
                TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.msg, 1.0f, ^(){
                    
                    
                })
            }
            
        }
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            if (self.parentViewController && [self.parentViewController isKindOfClass:[QSPSalerBookedOrdersListsViewController class]]) {
                
                if (self.parentViewController) {
                    
                    if ([self.parentViewController isKindOfClass:[QSPSalerBookedOrdersListsViewController class]]) {
                        
                        [(QSPSalerBookedOrdersListsViewController*)(self.parentViewController) reloadCurrentShowList];
                        
                    }else if ([self.parentViewController isKindOfClass:[QSPSalerTransactionOrderListViewController class]]) {
                        
                        [(QSPSalerTransactionOrderListViewController*)(self.parentViewController) reloadAllShowList];
                        
                    }
                    
                }
                
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
    
    NSString *orderID = nil;
    
    if (self.orderData) {
        
        if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
            
            NSArray *orderList = self.orderData.orderInfoList;
            
            if (orderList&&[orderList isKindOfClass:[NSArray class]]&&_selectedIndex<[orderList count]) {
                
                QSOrderListOrderInfoDataModel *orderItem = [orderList objectAtIndex:_selectedIndex];
                
                if (orderItem && [orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                    orderID = orderItem.id_;
                }
            }
        }
    }
    
    if (!orderID || [orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
//            if (self.parentViewController){
//                
//                [self.parentViewController.navigationController popViewControllerAnimated:YES];
//                
//            }
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:orderID forKey:@"order_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderCommitAppointment andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        ///转换模型
        if (headerModel) {
            
            if (headerModel&&[headerModel isKindOfClass:[QSHeaderDataModel class]]) {
                TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.msg, 1.0f, ^(){
                    
                    
                })
            }
            
        }
        if (rRequestResultTypeSuccess == resultStatus) {
            
            if (self.parentViewController && [self.parentViewController isKindOfClass:[QSPSalerBookedOrdersListsViewController class]]) {
                
                if (self.parentViewController) {
                    
                    if ([self.parentViewController isKindOfClass:[QSPSalerBookedOrdersListsViewController class]]) {
                        
                        [(QSPSalerBookedOrdersListsViewController*)(self.parentViewController) reloadCurrentShowList];
                        
                    }else if ([self.parentViewController isKindOfClass:[QSPSalerTransactionOrderListViewController class]]) {
                        
                        [(QSPSalerTransactionOrderListViewController*)(self.parentViewController) reloadAllShowList];
                        
                    }
                    
                }
                
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
    
    NSString *orderID = nil;
    
    if (self.orderData) {
        
        if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
            
            NSArray *orderList = self.orderData.orderInfoList;
            
            if (orderList&&[orderList isKindOfClass:[NSArray class]]&&_selectedIndex<[orderList count]) {
                
                QSOrderListOrderInfoDataModel *orderItem = [orderList objectAtIndex:_selectedIndex];
                
                if (orderItem && [orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                    orderID = orderItem.id_;
                }
            }
        }
    }
    
    if (!orderID || [orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject: orderID forKey:@"order_id"];
    [tempParam setObject:@"" forKey:@"score"];
    [tempParam setObject:@"" forKey:@"manner_score"];
    [tempParam setObject:@"" forKey:@"desc"];
    [tempParam setObject:@"" forKey:@"suitable"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderCommitInspected andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            if (self.parentViewController && [self.parentViewController isKindOfClass:[QSPSalerBookedOrdersListsViewController class]]) {
                
                if (self.parentViewController) {
                    
                    if ([self.parentViewController isKindOfClass:[QSPSalerBookedOrdersListsViewController class]]) {
                        
                        [(QSPSalerBookedOrdersListsViewController*)(self.parentViewController) reloadCurrentShowList];
                        
                    }else if ([self.parentViewController isKindOfClass:[QSPSalerTransactionOrderListViewController class]]) {
                        
                        [(QSPSalerTransactionOrderListViewController*)(self.parentViewController) reloadAllShowList];
                        
                    }
                    
                }
                
            }
            
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
    
    
    NSString *orderID = nil;
    
    if (self.orderData) {
        
        if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
            
            NSArray *orderList = self.orderData.orderInfoList;
            
            if (orderList&&[orderList isKindOfClass:[NSArray class]]&&_selectedIndex<[orderList count]) {
                
                QSOrderListOrderInfoDataModel *orderItem = [orderList objectAtIndex:_selectedIndex];
                
                if (orderItem && [orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                    orderID = orderItem.id_;
                }
            }
        }
    }
    
    if (!orderID || [orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }

    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:orderID forKey:@"order_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderTransationNoticeUser andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            if (self.parentViewController) {
                
                if ([self.parentViewController isKindOfClass:[QSPSalerBookedOrdersListsViewController class]]) {
                    
                    [(QSPSalerBookedOrdersListsViewController*)(self.parentViewController) reloadCurrentShowList];
                    
                }else if ([self.parentViewController isKindOfClass:[QSPSalerTransactionOrderListViewController class]]) {
                    
                    [(QSPSalerTransactionOrderListViewController*)(self.parentViewController) reloadAllShowList];
                    
                }
                
            }
            
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
    
    NSString *orderID = nil;
    
    if (self.orderData) {
        
        if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
            
            NSArray *orderList = self.orderData.orderInfoList;
            
            if (orderList&&[orderList isKindOfClass:[NSArray class]]&&_selectedIndex<[orderList count]) {
                
                QSOrderListOrderInfoDataModel *orderItem = [orderList objectAtIndex:_selectedIndex];
                
                if (orderItem && [orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                    orderID = orderItem.id_;
                }
            }
        }
    }
    
    if (!orderID || [orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:orderID forKey:@"order_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderCommitTransation andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            if (self.parentViewController) {
                
                if ([self.parentViewController isKindOfClass:[QSPSalerBookedOrdersListsViewController class]]) {
                    
                    [(QSPSalerBookedOrdersListsViewController*)(self.parentViewController) reloadCurrentShowList];
                    
                }else if ([self.parentViewController isKindOfClass:[QSPSalerTransactionOrderListViewController class]]) {
                    
                    [(QSPSalerTransactionOrderListViewController*)(self.parentViewController) reloadAllShowList];
                    
                }
                
            }
            
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
- (void)submitMyInputPrice:(NSString*)priceStr ToOrderID:(NSString*)orderID
{
    
    if (!priceStr || [priceStr isEqualToString:@""]) {
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入您的出价", 1.0f, ^(){
            
        })
        return;
    }
    
    NSString *housePrice = @"";
    
    NSString *houseType = @"";
    
    if (self.orderData.orderInfoList&&[self.orderData.orderInfoList count]>0) {
        
        QSOrderListOrderInfoDataModel *orderInfoData = [self.orderData.orderInfoList objectAtIndex:_selectedIndex];
        if (orderInfoData&&[orderInfoData isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
            
            houseType = orderInfoData.order_type;
            
        }
    }
    
    if (self.orderData) {
        
        if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
            
            housePrice = self.orderData.houseData.house_price;
            
            if ([houseType isEqualToString:@"500103"]) {
                
                housePrice = self.orderData.houseData.rent_price;
                
            }
        }
    }
    
    CGFloat priceF = priceStr.floatValue*10000;
    
    if ([houseType isEqualToString:@"500103"]) {
        
        priceF = priceStr.floatValue;
        
    }
    
    if (housePrice.floatValue<priceF) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请输入小于房价的金额", 1.0f, ^(){
            
        })
        
        return;
        
    }
    
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    //    必选	类型及范围	说明
    //    user_id	true	string	用户id
    //    order_id	true	string	订单id
    //    price	true	float	价格，没单位， 就是说如果是要传递200W过来请自己补齐后面的0，eg:200W 就是 2000000
    
    
    if (!orderID || [orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:orderID forKey:@"order_id"];
    
    //价格单位从万转元
    priceStr = [NSString stringWithFormat:@"%f",priceF];
    [tempParam setObject:priceStr forKey:@"price"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderSubmitBid andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            if (self.parentViewController) {
                
                if ([self.parentViewController isKindOfClass:[QSPSalerBookedOrdersListsViewController class]]) {
                    
                    [(QSPSalerBookedOrdersListsViewController*)(self.parentViewController) reloadCurrentShowList];
                    
                }else if ([self.parentViewController isKindOfClass:[QSPSalerTransactionOrderListViewController class]]) {
                    
                    [(QSPSalerTransactionOrderListViewController*)(self.parentViewController) reloadAllShowList];
                    
                }
                
            }
            
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
- (void)salerAcceptPriceWithOrderID:(NSString*)orderID
{
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    //    必选	类型及范围	说明
    //    user_id	true	string	用户id
    //    order_id	true	string	订单id
    
    if (!orderID || [orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:orderID forKey:@"order_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderSalerAcceptPrice andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            if (self.parentViewController) {
                
                if ([self.parentViewController isKindOfClass:[QSPSalerBookedOrdersListsViewController class]]) {
                    
                    [(QSPSalerBookedOrdersListsViewController*)(self.parentViewController) reloadCurrentShowList];
                    
                }else if ([self.parentViewController isKindOfClass:[QSPSalerTransactionOrderListViewController class]]) {
                    
                    [(QSPSalerTransactionOrderListViewController*)(self.parentViewController) reloadAllShowList];
                    
                }
                
            }
            
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
    
    NSString *orderID = nil;
    
    if (self.orderData) {
        
        if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
            
            NSArray *orderList = self.orderData.orderInfoList;
            
            if (orderList&&[orderList isKindOfClass:[NSArray class]]&&_selectedIndex<[orderList count]) {
                
                QSOrderListOrderInfoDataModel *orderItem = [orderList objectAtIndex:_selectedIndex];
                
                if (orderItem && [orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                    orderID = orderItem.id_;
                }
            }
        }
    }
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    //    必选	类型及范围	说明
    //    user_id	true	string	用户id
    //    order_id	true	string	订单id
    
    if (!orderID || [orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:orderID forKey:@"order_id"];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderBuyerOrSalerCommitOrder andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            if (self.parentViewController) {
                
                if ([self.parentViewController isKindOfClass:[QSPSalerBookedOrdersListsViewController class]]) {
                    
                    [(QSPSalerBookedOrdersListsViewController*)(self.parentViewController) reloadCurrentShowList];
                    
                }else if ([self.parentViewController isKindOfClass:[QSPSalerTransactionOrderListViewController class]]) {
                    
                    [(QSPSalerTransactionOrderListViewController*)(self.parentViewController) reloadAllShowList];
                    
                }
                
            }
            
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

#pragma mark - 预约订单接受或拒绝再议价，flag: YES是接受，NO是拒绝不接受
- (void)acceptOrRejectApplyBargain:(BOOL)flag
{
    
    NSString *orderID = nil;
    
    if (self.orderData) {
        
        if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
            
            NSArray *orderList = self.orderData.orderInfoList;
            
            if (orderList&&[orderList isKindOfClass:[NSArray class]]&&_selectedIndex<[orderList count]) {
                
                QSOrderListOrderInfoDataModel *orderItem = [orderList objectAtIndex:_selectedIndex];
                
                if (orderItem && [orderItem isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                    orderID = orderItem.id_;
                }
            }
        }
    }
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    //    必选	类型及范围	说明
    //    user_id	true	string	用户id
    //    order_id	true	string	订单id
    
    if (!orderID || [orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        [hud hiddenCustomHUD];
        return;
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:orderID forKey:@"order_id"];
    if (flag) {
        [tempParam setObject:@"1" forKey:@"result"];
    }else {
        [tempParam setObject:@"0" forKey:@"result"];
    }
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderAppointmentAcceptOrRejectApplyBargain andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            if (self.parentViewController) {
                
                if ([self.parentViewController isKindOfClass:[QSPSalerBookedOrdersListsViewController class]]) {
                    
                    [(QSPSalerBookedOrdersListsViewController*)(self.parentViewController) reloadCurrentShowList];
                    
                }else if ([self.parentViewController isKindOfClass:[QSPSalerTransactionOrderListViewController class]]) {
                    
                    [(QSPSalerTransactionOrderListViewController*)(self.parentViewController) reloadAllShowList];
                    
                }
                
            }
            
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
