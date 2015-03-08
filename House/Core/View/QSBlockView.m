//
//  QSBlockView.m
//  House
//
//  Created by ysmeng on 15/3/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBlockView.h"

@interface QSBlockView ()

@property (nonatomic,copy) void(^singleTapBlock)(BOOL flag);//!<单击时的回调

@end

@implementation QSBlockView

#pragma mark - 初始化
/**
 *  @author                     yangshengmeng, 15-03-08 13:03:28
 *
 *  @brief                      根据给定的单击回调block，创建一个带有单击回调的 UIView
 *
 *  @param singleTapCallBack    单击时的回调
 *
 *  @return                     返回当前创建的回调View
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithSingleTapBlock:(void(^)(BOOL flag))singleTapCallBack
{

    if (self = [super init]) {
        
        ///保存回调
        if (singleTapCallBack) {
            
            self.singleTapBlock = singleTapCallBack;
            
        }
        
        [self addSingleTapGesture];
        
    }
    
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame andSingleTapCallBack:(void(^)(BOOL flag))singleTapCallBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///保存回调
        if (singleTapCallBack) {
            
            self.singleTapBlock = singleTapCallBack;
            
        }
        
        [self addSingleTapGesture];
        
    }
    
    return self;

}

#pragma mark - 添加单击手势
- (void)addSingleTapGesture
{

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockViewCallBack)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];

}

#pragma mark - 单击时回调block
- (void)blockViewCallBack
{

    if (self.singleTapBlock) {
        
        self.singleTapBlock(YES);
        
    }

}

@end
