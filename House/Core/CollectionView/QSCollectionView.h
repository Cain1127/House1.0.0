//
//  QSCollectionView.h
//  House
//
//  Created by ysmeng on 15/3/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSCollectionView : UICollectionView

/**
 *  @author                     yangshengmeng, 15-03-24 22:03:59
 *
 *  @brief                      创建自定义的UICollectionView
 *
 *  @param frame                大小和位置
 *  @param layout               布局器
 *  @param isHorizontalScroll   水平方向是否一直开启滚动
 *  @param isVerticalScroll     垂直方向是否一直开启滚动
 *
 *  @return                     返回当前创建的自定义CollectedView
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout andHorizontalScroll:(BOOL)isHorizontalScroll andVerticalScroll:(BOOL)isVerticalScroll;

@end
