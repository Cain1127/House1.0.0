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

    sShowImageOriginalVCTypeEdit = 99,//!<带编辑功能的图片查看

}SHOW_IMAGE_ORIGINAL_VCTYPE;

typedef enum
{

    sShowImageOriginalActionTypeDelete = 99,//!<删除图片

}SHOW_IMAGE_ORIGINAL_ACTION_TYPE;

///回调block类型
typedef void(^SHOWIMAGECALLBACKBLOCK)(SHOW_IMAGE_ORIGINAL_ACTION_TYPE actionType);

@interface QSYShowImageDetailViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-03-26 16:03:52
 *
 *  @brief          根据给定的图片，创建一个查看原图的图片查看页面
 *
 *  @param image    图片
 *
 *  @return         返回图片原图查看页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithImage:(UIImage *)image andType:(SHOW_IMAGE_ORIGINAL_VCTYPE)vcType andCallBack:(SHOWIMAGECALLBACKBLOCK)callBack;

@end
