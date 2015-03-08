//
//  QSScrollView.m
//  House
//
//  Created by ysmeng on 15/3/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSScrollView.h"

@implementation QSScrollView

#pragma mark - 重写初始化方法，取消滚动条
- (instancetype)init
{

    if (self = [super init]) {
        
        ///取消滚动条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
    }
    
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
    }
    
    return self;

}

@end
