//
//  QSPOrderTipsButtonPopView.h
//  House
//
//  Created by CoolTea on 15/4/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define     DefaultHeight       160.0f

///提示按钮的类型
typedef enum
{
    
    oOrderButtonTipsActionTypeCancel = 0,     //!<取消
    oOrderButtonTipsActionTypeConfirm,        //!<确定
    
}ORDER_BUTTON_TIPS_ACTION_TYPE;

typedef enum
{
    
    oOrderButtonTipsViewTypeSalerInputPrice = 101,          //!<业主输入房源出价
    oOrderButtonTipsViewTypeTransactionBuyerOrSalerPrice,   //!<业主/房客成交价格
    oOrderButtonTipsViewTypeAcceptBuyerOrSalerPrice,        //!<业主/房客接受房客还价
    oOrderButtonTipsViewTypeAcceptOrRejectAppointment,      //!<接受拒绝再预约
}ORDER_BUTTON_TIPS_VIEW_TYPE;

@interface QSPOrderTipsButtonPopView : UIView

@property (nonatomic, strong) UIViewController *parentViewController;

- (instancetype)initWithView:(ORDER_BUTTON_TIPS_VIEW_TYPE)viewType andCallBack:(void(^)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType))callBack;

//输入房源出价

/**
 *  初始化输入提交房价覆盖View
 *
 *  @param houseTitle 房源标题
 *  @param buyerPrice 房源价格
 *  @param userType   对方用户身份
 *  @param callBack   回调
 *
 *  @return 返回房价输入界面
 */
- (instancetype)initWithInputPriceVieWithHouseTitle:(NSString*)houseTitle WithPrice:(NSString*)buyerPrice withUserType:(USER_COUNT_TYPE)userType withHouseType:(NSString*)houseType  andCallBack:(void(^)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType))callBack;

/**
 *  初始化业主/房客预约阶段接受成交还价覆盖View
 *
 *  @param houseTitle 房源标题
 *  @param buyerPrice 房源价格
 *  @param userType   对方用户身份
 *  @param callBack   回调
 *
 *  @return 业主/房客接受还价覆盖View界面
 */
- (instancetype)initWithAcceptPriceVieWithHouseTitle:(NSString*)houseTitle WithPrice:(NSString*)buyerPrice withUserType:(USER_COUNT_TYPE)userType withHouseType:(NSString*)houseType  andCallBack:(void(^)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType))callBack;

/**
 *  初始化业主/房客成交阶段接受成交还价覆盖View
 *
 *  @param buyerPrice 房源价格
 *  @param userType   对方用户身份
 *  @param callBack   回调
 *
 *  @return 业主/房客接受还价覆盖View界面
 */
- (instancetype)initWithAcceptPriceVieWithPrice:(NSString*)buyerPrice withUserType:(USER_COUNT_TYPE)userType withHouseType:(NSString*)houseType andCallBack:(void(^)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType))callBack;


/**
 *  初始化接受拒绝再预约覆盖View
 *
 *  @param 预约时间信息 预约时间提示信息
 *  @param userType   对方用户身份
 *  @param callBack   回调
 *
 *  @return 接受拒绝再预约覆盖View界面
 */
- (instancetype)initWithAcceptOrRejectAppointmentViewWithTip:(NSString*)tipInfo withUserType:(USER_COUNT_TYPE)userType andCallBack:(void(^)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType))callBack;


- (NSString*)getInputPrice;

@end
