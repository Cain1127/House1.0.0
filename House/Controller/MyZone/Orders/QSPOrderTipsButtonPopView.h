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
    
    oOrderButtonTipsViewTypeSalerInputPrice = 101,      //!<业主输入房源出价
    oOrderButtonTipsViewTypeAcceptBuyerPrice,           //!<业主接受房客还价
    
}ORDER_BUTTON_TIPS_VIEW_TYPE;

@interface QSPOrderTipsButtonPopView : UIView

@property (nonatomic, strong) UIViewController *parentViewController;

- (instancetype)initWithView:(ORDER_BUTTON_TIPS_VIEW_TYPE)viewType andCallBack:(void(^)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType))callBack;

//业主输入房源出价
- (instancetype)initWithSalerInputPriceVieWithHouseTitle:(NSString*)houseTitle WithBuyerPrice:(NSString*)buyerPrice wandCallBack:(void(^)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType))callBack;

//业主接受房客还价
- (instancetype)initWithAcceptBuyerPriceVieWithHouseTitle:(NSString*)houseTitle WithBuyerPrice:(NSString*)buyerPrice wandCallBack:(void(^)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType))callBack;

- (NSString*)getInputPrice;

@end
