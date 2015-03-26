//
//  QSAutoScrollView.h
//  House
//
//  Created by ysmeng on 15/1/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief  自定义类广告自滚动view的协议，主要是方便添加滚动相关的数据源信息
 */
@class QSAutoScrollView;
@protocol QSAutoScrollViewDelegate <NSObject>

@required

///自滚动的总数
- (int)numberOfScrollPage:(QSAutoScrollView *)autoScrollView;

/**
 *  @author                 yangshengmeng, 15-01-19 11:01:27
 *
 *  @brief                  获取需要显示信息的view，同时需要传入一个单击时回调的参数
 *
 *  @param autoScrollView   自滚动view
 *  @param index            显示view
 *  @param params           单击时回调的参数
 *
 *  @return                 返回显示view
 *
 *  @since                  1.0.0
 */
- (UIView *)autoScrollViewShowView:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index;

/**
 *  @author yangshengmeng, 15-01-19 11:01:46
 *
 *  @brief  返回单击滚动栏时的回调参数
 *
 *  @return 返回单击时的参数
 *
 *  @since  1.0.0
 */
- (id)autoScrollViewTapCallBackParams:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index;

@end

typedef enum
{

    aAutoScrollDirectionTypeTopToBottom = 200,  //!<从上往下滚动
    aAutoScrollDirectionTypeBottomToTop,        //!<从下往上滚动
    aAutoScrollDirectionTypeLeftToRight,        //!<从左到右滚动
    aAutoScrollDirectionTypeRightToLeft         //!<从右到左滚动

}AUTOSCROLL_DIRECTION_TYPE;                     //!<自滚动view的滚动方向类型

/**
 *  @author yangshengmeng, 15-01-19 10:01:02
 *
 *  @brief  类广告自滚动的自定义view
 *
 *  @since  1.0.0
 */
@interface QSAutoScrollView : UIView

/**
 *  @author                 yangshengmeng, 15-01-19 11:01:16
 *
 *  @brief                  根据代理和滚动类型，创建一个类广告自滚动的视图
 *
 *  @param frame            在父视图中的位置和大小
 *  @param delegate         滚动视图的代理
 *  @param directionType    滚动的方向
 *
 *  @return                 返回一个自滚动的视图
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id<QSAutoScrollViewDelegate>)delegate andScrollDirectionType:(AUTOSCROLL_DIRECTION_TYPE)directionType andShowPageIndex:(BOOL)pageIndexFlag andShowTime:(CGFloat)showTime andTapCallBack:(void(^)(id params))callBack;

/**
 *  @author                 yangshengmeng, 15-03-26 17:03:14
 *
 *  @brief                  创建一个类广告自滚动的展示view
 *
 *  @param frame            大小和位置
 *  @param delegate         代理
 *  @param directionType    滚动方向的类型
 *  @param pageIndexFlag    是否显示页码指示器
 *  @param currentPage      当前页
 *  @param showTime         每一页的显示时间
 *  @param callBack         点击当前显示页时的回调
 *
 *  @return                 返回当前创建的自滚动view
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id<QSAutoScrollViewDelegate>)delegate andScrollDirectionType:(AUTOSCROLL_DIRECTION_TYPE)directionType andShowPageIndex:(BOOL)pageIndexFlag andCurrentPage:(int)currentPage andShowTime:(CGFloat)showTime andTapCallBack:(void(^)(id params))callBack;

/**
 *  @author yangshengmeng, 15-03-12 17:03:15
 *
 *  @brief  重新加载滚动视图
 *
 *  @since  1.0.0
 */
- (void)reloadAutoScrollView;

@end
