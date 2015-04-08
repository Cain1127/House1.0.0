//
//  QSPOrderDetailPersonInfoView.h
//  House
//
//  Created by CoolTea on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetalSubBaseView.h"

typedef enum
{
    
    pPersonButtonTypePhone = 100,   //!<电话按钮
    pPersonButtonTypeAsk,           //!<咨询按钮
    
}PERSON_INFO_BUTTON_TYPE;

@interface QSPOrderDetailPersonInfoView : QSPOrderDetalSubBaseView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withOrderData:(id)orderData andCallBack:(void(^)(PERSON_INFO_BUTTON_TYPE buttonType, UIButton *button))callBack;

- (instancetype)initWithFrame:(CGRect)frame withOrderData:(id)orderData andCallBack:(void(^)(PERSON_INFO_BUTTON_TYPE buttonType, UIButton *button))callBack;

- (void)setOrderData:(id)orderData;

@end
