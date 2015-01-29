//
//  QSImageView+Block.m
//  House
//
//  Created by ysmeng on 15/1/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSImageView+Block.h"

@implementation QSImageView (Block)

/**
 *  @author         yangshengmeng, 15-01-29 15:01:10
 *
 *  @brief          创建一个有单击事件的图片view
 *
 *  @param frame    大小和位置
 *  @param callBack 单击时的回调
 *
 *  @since          1.0.0
 */
+ (UIImageView *)createBlockImageViewWithFrame:(CGRect)frame andSingleTapCallBack:(void(^)(void))callBack
{

    QSBlockImageView *imageView = [[QSBlockImageView alloc] initWithFrame:frame andSingleTapCallBack:callBack];
    
    return imageView;

}

@end

@interface QSBlockImageView ()

@property (nonatomic,copy) void(^imageViewSingleTapCallBack)(void);//!<单击时的回调

@end

@implementation QSBlockImageView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-01-29 15:01:40
 *
 *  @brief          匿名的初始化方法
 *
 *  @param frame    大小和位置
 *  @param callBack 单击时的回调
 *
 *  @return         返回当前创建的单击图片view
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSingleTapCallBack:(void (^)(void))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///保存回调
        if (callBack) {
            
            self.imageViewSingleTapCallBack = callBack;
            
        }
        
        ///添加单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewSingleTapAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
    }
    
    return self;

}

///图片view单击时的回调
- (void)imageViewSingleTapAction:(UITapGestureRecognizer *)tap
{

    if (self.imageViewSingleTapCallBack) {
        
        self.imageViewSingleTapCallBack();
        
    }

}

@end