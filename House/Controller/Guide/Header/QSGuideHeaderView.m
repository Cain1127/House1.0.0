//
//  QSGuideHeaderView.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSGuideHeaderView.h"
#import "QSBlockButtonStyleModel+Normal.h"

@implementation QSGuideHeaderView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        ///搭建UI
        [self createGuideHeaderUI];
        
    }
    
    return self;

}

#pragma mark - 背景图片UI
- (void)createGuideHeaderUI
{

    ///背景图片
    QSImageView *backgoundImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 88.0f - 40.0f - 8.0f)];
    backgoundImageView.backgroundColor = COLOR_CHARACTERS_YELLOW;
    [self addSubview:backgoundImageView];

}

@end
