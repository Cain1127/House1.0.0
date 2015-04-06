//
//  QSCollectionVerticalFlowLayout.h
//  House
//
//  Created by ysmeng on 15/4/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-01-30 17:01:29
 *
 *  @brief  自定义瀑布流的代理
 *
 *  @since  1.0.0
 */
@class QSCollectionVerticalFlowLayout;
@protocol QSCollectionVerticalFlowLayoutDelegate <NSObject>

@required
///通过代理，获取头信息的高度
- (CGFloat)heightForCustomVerticalFlowLayoutHeader;

///通过代理，获取垂直方向的间隙
- (CGFloat)gapVerticalForCustomVerticalFlowItem;

///通过代理，获取瀑布流元素的大小
- (CGFloat)customVerticalFlowLayout:(QSCollectionVerticalFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface QSCollectionVerticalFlowLayout : UICollectionViewLayout

///瀑布流布局器的代理
@property (nonatomic,assign) id<QSCollectionVerticalFlowLayoutDelegate> delegate;

/**
 *  @author             yangshengmeng, 15-04-05 22:04:29
 *
 *  @brief              按给定的宽度，创建一个带有一行头信息的布局器
 *
 *  @param width        瀑布注元素的宽度
 *
 *  @return             返回当前创建的布局器
 *
 *  @since              1.0.0
 */
- (instancetype)initWithItemWidth:(CGFloat)width;

@end
