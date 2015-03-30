//
//  QSCollectionWaterFlowLayout.h
//  House
//
//  Created by ysmeng on 15/1/30.
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
@class QSCollectionWaterFlowLayout;
@protocol QSCollectionWaterFlowLayoutDelegate <NSObject>

@required
/**
 *  @author                     yangshengmeng, 15-01-31 09:01:09
 *
 *  @brief                      返回对应section中，给定布局方向的默认宽或高
 *
 *  @param collectionViewLayout 当前布局器
 *  @param collectionView       当前collectionView
 *  @param section              当前section
 *
 *  @return                     回当前section中固定的宽或高
 *
 *  @since                      1.0.0
 */
- (CGFloat)customWaterFlowLayout:(QSCollectionWaterFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView defaultSizeOfItemInSection:(NSInteger)section;

/**
 *  @author                     yangshengmeng, 15-01-31 09:01:12
 *
 *  @brief                      返回给定坐标的cell的非布局方向的宽或高
 *
 *  @param collectionViewLayout 当前布局器
 *  @param collectionView       当前collectionView
 *  @param indexPath            当前cell的下标
 *
 *  @return                     返回当前下标的cell非布局方向的宽或高
 *
 *  @since                      1.0.0
 */
- (CGFloat)customWaterFlowLayout:(QSCollectionWaterFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView defaultScrollSizeOfItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  @author                     yangshengmeng, 15-01-31 09:01:44
 *
 *  @brief                      返回指定Section中非布局方向的默认间隙
 *
 *  @param collectionViewLayout 当前布局器
 *  @param collectionView       当前collectionView
 *  @param indexPath            当前cell的坐标
 *
 *  @return                     返回当前坐标系的非布局方向间隙
 *
 *  @since                      1.0.0
 */
- (CGFloat)customWaterFlowLayout:(QSCollectionWaterFlowLayout *)collectionViewLayout collectionView:(UICollectionView *)collectionView defaultScrollSpaceOfItemInSection:(NSInteger)section;

@optional

/**
 *  @author                     yangshengmeng, 15-01-31 09:01:51
 *
 *  @brief                      要求返回当前section的列头列数
 *
 *  @param collectionViewLayout 当前布局器
 *  @param collectionView       当前collectionView
 *  @param section              当前的section
 *
 *  @return                     返回当前section的列头列数
 *
 *  @since                      1.0.0
 */
- (NSInteger)numberOfColumnInSection:(NSInteger)section;

@end

/**
 *  @author yangshengmeng, 15-01-30 17:01:15
 *
 *  @brief  自定义瀑布流布局器
 *
 *  @since  1.0.0
 */
@interface QSCollectionWaterFlowLayout : UICollectionViewLayout

///瀑布流布局器的代理
@property (nonatomic,assign) id<QSCollectionWaterFlowLayoutDelegate> delegate;

/**
 *  @author                 yangshengmeng, 15-01-30 18:01:05
 *
 *  @brief                  创建一个给定布局方向，同时有默认方向的尺寸布局器
 *
 *  @param direction        布局方向
 *  @param headerRowNumber  列头的数量
 *  @param defaultSize      默认尺寸：垂直布局时，表示默认的宽度；水平布局时表示默认高度
 *  @param defaultSpace     默认的间隙：垂直布局时，默认的上下间隙；水平布局时，表示左右间隙
 *
 *  @return                 返回当前创建的布局器
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)direction;

@end
