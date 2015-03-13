//
//  QSPOrderDetailPersonInfoView.h
//  House
//
//  Created by CoolTea on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSPOrderDetailPersonInfoView : UIView

@property (nonatomic,copy) void(^blockButtonCallBack)(UIButton *button);

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withHouseData:(id)houseData andCallBack:(void(^)(UIButton *button))callBack;

- (instancetype)initWithFrame:(CGRect)frame withHouseData:(id)houseData andCallBack:(void(^)(UIButton *button))callBack;

- (void)setHouseData:(id)houseData;

@end
