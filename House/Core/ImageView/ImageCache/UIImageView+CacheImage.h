//
//  UIImageView+CacheImage.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///图片完整性检测类型
typedef enum
{

    iImageValidTypeInValid = 999,   //!<无效图片Data
    iImageValidTypeHeaderInValid,   //!<图片Data头信息缺失
    iImageValidTypeFooterInValid,   //!<图片尾信息缺失
    iImageValidTypeValid,           //!<图片完整

}IMAGE_VALID_TYPE;

/**
 *  @author yangshengmeng, 15-01-21 15:01:31
 *
 *  @brief  本类主要是封装图片请求，并生成本地缓存
 *
 *  @since  1.0.0
 */
@interface UIImageView (CacheImage)

/**
 *  @author                 yangshengmeng, 15-01-21 15:01:48
 *
 *  @brief                  根据给定的URL请求图片，并配置本地缓存文件
 *
 *  @param url              请求图片的URL
 *  @param placeholderImage 请求失败时的默认图片
 *
 *  @since                  1.0.0
 */
- (void)loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;
- (void)loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage isCommpressed:(BOOL)flag;

/**
 *  @author         yangshengmeng, 15-05-01 16:05:27
 *
 *  @brief          检测图片是否有效
 *
 *  @param tempData 图片二进制信息
 *
 *  @return         返回检测结果
 *
 *  @since          1.0.0
 */
- (IMAGE_VALID_TYPE)checkJPEGValid:(NSData *)tempData;
+ (IMAGE_VALID_TYPE)checkJPEGValid:(NSData *)tempData;

@end
