//
//  UIImage+Compressed.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compressed)

/**
 *  @author         yangshengmeng, 15-01-21 17:01:38
 *
 *  @brief          按给定的大小压缩图片
 *
 *  @param aSize    给定的大小
 *
 *  @return         返回压缩后的图片
 *
 *  @since          1.0.0
 */
- (UIImage *)compressedImageWithSize:(CGSize)aSize;

@end
