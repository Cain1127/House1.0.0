//
//  UIImageView+CacheImage.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end
