//
//  UITextField+RightArrow.m
//  House
//
//  Created by ysmeng on 15/1/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "UITextField+RightArrow.h"

@implementation UITextField (RightArrow)

+ (UITextField *)createRightArrowTextField
{

    QSRightArrowTextField *textField = [[QSRightArrowTextField alloc] init];
    
    return textField;

}

/**
 *  @author yangshengmeng, 15-01-23 14:01:32
 *
 *  @brief  创建一个有大小的，右侧带有箭头的输入框
 *
 *  @return 返回一个右侧带有箭头的输入框
 *
 *  @since  1.0.0
 */
+ (UITextField *)createRightArrowTextFieldWithFrame:(CGRect)frame
{

    QSRightArrowTextField *textField = [[QSRightArrowTextField alloc] initWithFrame:frame];
    
    return textField;

}

@end

@implementation QSRightArrowTextField

#pragma mark - 初始化
- (instancetype)init
{

    if (self = [super init]) {
        
        ///添加右侧剪头
        [self addRightArrow];
        
    }
    
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        ///添加右侧剪头
        [self addRightArrow];
        
    }
    
    return self;

}

#pragma mark - 添加右而剪头
- (void)addRightArrow
{

    QSImageView *rightArrowView = [[QSImageView alloc] init];
    rightArrowView.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = rightArrowView;

}

@end