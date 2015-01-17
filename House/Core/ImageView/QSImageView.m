//
//  QSImageView.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSImageView.h"

@implementation QSImageView

#pragma mark - 重写初始化方法：开启用户交互
- (instancetype)init
{

    if (self = [super init]) {
        
        ///开启用户交互
        self.userInteractionEnabled = YES;
        
    }
    
    return self;

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{

    if (self = [super initWithCoder:aDecoder]) {
        
        ///开启用户交互
        self.userInteractionEnabled = YES;
        
    }
    
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        ///开启用户交互
        self.userInteractionEnabled = YES;
        
    }
    
    return self;

}

- (instancetype)initWithImage:(UIImage *)image
{

    if (self = [super initWithImage:image]) {
        
        ///开启用户交互
        self.userInteractionEnabled = YES;
        
    }
    
    return self;

}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{

    if (self = [super initWithImage:image highlightedImage:highlightedImage]) {
        
        ///开启用户交互
        self.userInteractionEnabled = YES;
        
    }
    
    return self;

}

@end
