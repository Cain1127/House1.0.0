//
//  QSPBuyerTransactionOrderListCompletedView.h
//  House
//
//  Created by CoolTea on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSPBuyerTransactionOrderListCompletedView : UIView

@property (nonatomic, strong) UIViewController *parentViewController;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)getCompleteListHeaderData;

@end
