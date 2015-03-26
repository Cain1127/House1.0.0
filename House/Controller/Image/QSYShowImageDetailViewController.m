//
//  QSYShowImageDetailViewController.m
//  House
//
//  Created by ysmeng on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYShowImageDetailViewController.h"

@interface QSYShowImageDetailViewController ()

@property (nonatomic,assign) SHOW_IMAGE_ORIGINAL_VCTYPE *showType;  //!<图片展示页的类型
@property (nonatomic,copy) SHOWIMAGECALLBACKBLOCK showImageCallBack;//!<展示图片页面相关事件回调
@property (nonatomic,retain) UIImage *image;                        //!<传进来的图片

@end

@implementation QSYShowImageDetailViewController

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
- (instancetype)initWithImage:(UIImage *)image andType:(SHOW_IMAGE_ORIGINAL_VCTYPE)vcType andCallBack:(SHOWIMAGECALLBACKBLOCK)callBack
{

    if (self = [super init]) {
        
        ///保存图片
        self.image = image;
        
        ///保存类型
        
        
        ///保存回调
        
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@""];

}

@end
