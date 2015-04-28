//
//  QSYShowImageDetailViewController.h
//  House
//
//  Created by ysmeng on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

///图片查看器的类型
typedef enum
{

    sShowImageOriginalVCTypeSingleEdit = 99,//!<带编辑功能的单图片查看
    sShowImageOriginalVCTypeMultiEdit,      //!<带编辑功能的多图片查看

}SHOW_IMAGE_ORIGINAL_VCTYPE;

typedef enum
{

    sShowImageOriginalActionTypeDelete = 99,//!<删除图片

}SHOW_IMAGE_ORIGINAL_ACTION_TYPE;

///回调block类型
typedef void(^SHOWIMAGECALLBACKBLOCK)(SHOW_IMAGE_ORIGINAL_ACTION_TYPE actionType,id deleteObject,int deleteIndex);

@interface QSYShowImageDetailViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-03-26 16:03:56
 *
 *  @brief          创建一个查看单图片的视图，显示一个图片
 *
 *  @param image    图片
 *  @param title    标题
 *  @param vcType   图片查看页面的类型
 *  @param callBack 图片查看页面相关事件的回调
 *
 *  @return         返回当前创建的图片查看器
 *
 *  @since          1.0.0
 */
- (instancetype)initWithImage:(UIImage *)image andTitle:(NSString *)title andType:(SHOW_IMAGE_ORIGINAL_VCTYPE)vcType andCallBack:(SHOWIMAGECALLBACKBLOCK)callBack;

/**
 *  @author         yangshengmeng, 15-03-26 16:03:18
 *
 *  @brief          创建一个查看图集的视图
 *
 *  @param images   图片数组
 *  @param index    当前页码
 *  @param title    标题
 *  @param vcType   查看图片控制器的类型
 *  @param callBack 相关事件的回调
 *
 *  @return         返回当前创建的图片查看器
 *
 *  @since 1.0.0
 */
- (instancetype)initWithImages:(NSArray *)images andCurrentIndex:(int)index andTitle:(NSString *)title andType:(SHOW_IMAGE_ORIGINAL_VCTYPE)vcType andCallBack:(SHOWIMAGECALLBACKBLOCK)callBack;

/**
 *  @author             yangshengmeng, 15-04-28 09:04:17
 *
 *  @brief              创建一个图片浏览窗口，通过给定的图片url
 *
 *  @param urlsList     图片集数组，其中必须包涵图片字段的内容项
 *  @param imageKey     图片字段
 *  @param currentIndex 当前显示页
 *  @param title        标题
 *  @param vcType       图片集查看类型
 *  @param callBack     图片集查看器的事件回调
 *
 *  @return             返回当前创建的图片集查看器
 *
 *  @since              1.0.0
 */
- (instancetype)initWithImageURLs:(NSArray *)urlsList andURLKey:(NSString *)imageKey andCurrentIndex:(int)currentIndex andTitle:(NSString *)title andType:(SHOW_IMAGE_ORIGINAL_VCTYPE)vcType andCallBack:(SHOWIMAGECALLBACKBLOCK)callBack;

/**
 *  @author             yangshengmeng, 15-04-28 09:04:35
 *
 *  @brief              根据给定的图片根请求地址和图片集中图片urlKVC的关键字，创建一个图片查看器
 *
 *  @param urlsList     图片url的集合
 *  @param imageKey     图片相对地址所在的KVC字关键字
 *  @param rootURL      图片请求的根地址
 *  @param currentIndex 当前显示图片的下标
 *  @param title        标题
 *  @param vcType       图片集类型
 *  @param callBack     图片集查看器相关事件
 *
 *  @return             返回当前创建的图片集查看器
 *
 *  @since              1.0.0
 */
- (instancetype)initWithImageURLs:(NSArray *)urlsList andURLKey:(NSString *)imageKey andImageRootURL:(NSString *)rootURL andCurrentIndex:(int)currentIndex andTitle:(NSString *)title andType:(SHOW_IMAGE_ORIGINAL_VCTYPE)vcType andCallBack:(SHOWIMAGECALLBACKBLOCK)callBack;

@end
