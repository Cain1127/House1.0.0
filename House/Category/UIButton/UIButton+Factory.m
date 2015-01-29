//
//  UIButton+Factory.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "UIButton+Factory.h"

@implementation UIButton (Factory)

/**
 *  @author             yangshengmeng, 15-01-29 16:01:30
 *
 *  @brief              创建指定类型的自定义按钮
 *
 *  @param frame        大小的位置
 *  @param buttonStyle  按钮属性模型
 *  @param buttonType   按钮类型
 *  @param gap          标题和图片的间障
 *  @param callBack     按钮的回调
 *
 *  @return             返回创建的按钮
 *
 *  @since              1.0.0
 */
/**
 *  @author             yangshengmeng, 15-01-29 16:01:30
 *
 *  @brief              创建指定类型的自定义按钮
 *
 *  @param frame        大小的位置
 *  @param buttonStyle  按钮属性模型
 *  @param buttonType   按钮类型
 *  @param titleHeight  标题所占的高度/宽度
 *  @param gap          标题和图片的间隙
 *  @param callBack     按钮的回调
 *
 *  @return             返回创建的按钮
 *
 *  @since              1.0.0
 */
+ (UIButton *)createCustomStyleButtonWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle andCustomButtonStyle:(CUSTOM_BUTTOM_STYLE)buttonType andTitleSize:(CGFloat)titleSize andMiddleGap:(CGFloat)gap andCallBack:(void(^)(UIButton *button))callBack
{

    switch (buttonType) {
            ///标题在顶部的按钮
        case cCustomButtonStyleTopTitle:
        {
        
            QSTopTitleButton *button = [[QSTopTitleButton alloc] initWithFrame:frame andButtonStyle:buttonStyle andTitleSize:titleSize andMiddleGap:gap andCallBack:callBack];
            
            return button;
        
        }
            break;
            
            ///标题在底部的按钮
        case cCustomButtonStyleBottomTitle:
        {
            
            QSBottomTitleButton *button = [[QSBottomTitleButton alloc] initWithFrame:frame andButtonStyle:buttonStyle andTitleSize:titleSize andMiddleGap:gap andCallBack:callBack];
            
            return button;
            
        }
            break;
            
            ///标题在左侧的按钮
        case cCustomButtonStyleLeftTitle:
        {
            
            QSLeftTitleButton *button = [[QSLeftTitleButton alloc] initWithFrame:frame andButtonStyle:buttonStyle andTitleSize:titleSize andMiddleGap:gap andCallBack:callBack];
            
            return button;
            
        }
            break;
            
            ///标题在右侧的按钮
        case cCustomButtonStyleRightTitle:
        {
            
            QSRightTitleButton *button = [[QSRightTitleButton alloc] initWithFrame:frame andButtonStyle:buttonStyle andTitleSize:titleSize andMiddleGap:gap andCallBack:callBack];
            
            return button;
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;

}

@end

#pragma mark - 标题在顶部的按钮类型
@interface QSTopTitleButton ()

@property (nonatomic,assign) CGFloat titleSize; //!<标题所占的大小:高/宽
@property (nonatomic,assign) CGFloat gap;       //!<图片和标题之间的间隙

@end

@implementation QSTopTitleButton

/**
 *  @author             yangshengmeng, 15-01-29 16:01:27
 *
 *  @brief              根据给定的按钮属性和风格，创建一个单击回调按钮
 *
 *  @param frame        大小的位置
 *  @param buttonStyle  按钮相关属性
 *  @param gap          图片的标题之间的间隙：默认为2.0
 *  @param callBack     单击按钮时的回调
 *
 *  @return             返回当前创建的按钮
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle andTitleSize:(CGFloat)titleSize andMiddleGap:(CGFloat)gap andCallBack:(void(^)(UIButton *button))callBack
{

    if (self = [super initWithFrame:frame andButtonStyle:buttonStyle]) {
        
        ///保存回调
        if (callBack) {
            
            self.blockButtonCallBack = callBack;
            
        }
        
        ///保存间隙
        self.gap = gap > 0.5f ? gap : 2.0f;
        
        ///保存标题占的大小
        self.titleSize = titleSize >= 10.0f ? titleSize : 15.0f;
        
    }
    
    return self;

}

///重写标题位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{

    return CGRectMake(0.0f, 0.0f, contentRect.size.width, self.titleSize);

}

///重写图片位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{

    return CGRectMake(0.0f, self.titleSize + self.gap, contentRect.size.width, contentRect.size.height - self.titleSize - self.gap);

}

@end

#pragma mark - 标题在底部的按钮类型
@interface QSBottomTitleButton ()

@property (nonatomic,assign) CGFloat titleSize; //!<标题所占的大小:高/宽
@property (nonatomic,assign) CGFloat gap;       //!<图片和标题之间的间隙

@end

@implementation QSBottomTitleButton

/**
 *  @author             yangshengmeng, 15-01-29 16:01:27
 *
 *  @brief              根据给定的按钮属性和风格，创建一个单击回调按钮
 *
 *  @param frame        大小的位置
 *  @param buttonStyle  按钮相关属性
 *  @param gap          图片的标题之间的间隙：默认为2.0
 *  @param callBack     单击按钮时的回调
 *
 *  @return             返回当前创建的按钮
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle andTitleSize:(CGFloat)titleSize andMiddleGap:(CGFloat)gap andCallBack:(void(^)(UIButton *button))callBack
{
    
    if (self = [super initWithFrame:frame andButtonStyle:buttonStyle]) {
        
        ///保存回调
        if (callBack) {
            
            self.blockButtonCallBack = callBack;
            
        }
        
        ///保存间隙
        self.gap = gap > 0.5f ? gap : 2.0f;
        
        ///保存标题占的大小
        self.titleSize = titleSize >= 10.0f ? titleSize : 15.0f;
        
    }
    
    return self;
    
}

///重写标题位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    return CGRectMake(0.0f, contentRect.size.height - self.titleSize, contentRect.size.width, self.titleSize);
    
}

///重写图片位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    return CGRectMake(0.0f, 0.0f, contentRect.size.width, contentRect.size.height - self.titleSize - self.gap);
    
}

@end

#pragma mark - 标题在左侧的按钮类型
@interface QSLeftTitleButton ()

@property (nonatomic,assign) CGFloat titleSize; //!<标题所占的大小:高/宽
@property (nonatomic,assign) CGFloat gap;       //!<图片和标题之间的间隙

@end

@implementation QSLeftTitleButton

/**
 *  @author             yangshengmeng, 15-01-29 16:01:27
 *
 *  @brief              根据给定的按钮属性和风格，创建一个单击回调按钮
 *
 *  @param frame        大小的位置
 *  @param buttonStyle  按钮相关属性
 *  @param gap          图片的标题之间的间隙：默认为2.0
 *  @param callBack     单击按钮时的回调
 *
 *  @return             返回当前创建的按钮
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle andTitleSize:(CGFloat)titleSize andMiddleGap:(CGFloat)gap andCallBack:(void(^)(UIButton *button))callBack
{
    
    if (self = [super initWithFrame:frame andButtonStyle:buttonStyle]) {
        
        ///保存回调
        if (callBack) {
            
            self.blockButtonCallBack = callBack;
            
        }
        
        ///保存间隙
        self.gap = gap > 0.5f ? gap : 2.0f;
        
        ///保存标题占的大小
        self.titleSize = titleSize >= 10.0f ? titleSize : frame.size.width - frame.size.height - gap;
        
    }
    
    return self;
    
}

///重写标题位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    return CGRectMake(0.0f, 0.0f, self.titleSize, contentRect.size.height);
    
}

///重写图片位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    return CGRectMake(self.titleSize + self.gap, 0.0f, contentRect.size.width - self.titleSize - self.gap, contentRect.size.height);
    
}

@end

#pragma mark - 标题在右侧的按钮类型
@interface QSRightTitleButton ()

@property (nonatomic,assign) CGFloat titleSize; //!<标题所占的大小:高/宽
@property (nonatomic,assign) CGFloat gap;       //!<图片和标题之间的间隙

@end

@implementation QSRightTitleButton

/**
 *  @author             yangshengmeng, 15-01-29 16:01:27
 *
 *  @brief              根据给定的按钮属性和风格，创建一个单击回调按钮
 *
 *  @param frame        大小的位置
 *  @param buttonStyle  按钮相关属性
 *  @param gap          图片的标题之间的间隙：默认为2.0
 *  @param callBack     单击按钮时的回调
 *
 *  @return             返回当前创建的按钮
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andButtonStyle:(QSBlockButtonStyleModel *)buttonStyle andTitleSize:(CGFloat)titleSize andMiddleGap:(CGFloat)gap andCallBack:(void(^)(UIButton *button))callBack
{
    
    if (self = [super initWithFrame:frame andButtonStyle:buttonStyle]) {
        
        ///保存回调
        if (callBack) {
            
            self.blockButtonCallBack = callBack;
            
        }
        
        ///保存间隙
        self.gap = gap > 0.5f ? gap : 2.0f;
        
        ///保存标题占的大小
        self.titleSize = titleSize >= 10.0f ? titleSize : frame.size.width - frame.size.height - self.gap;
        
    }
    
    return self;
    
}

///重写标题位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    return CGRectMake(contentRect.size.width - self.titleSize, 0.0f, self.titleSize, contentRect.size.height);
    
}

///重写图片位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    return CGRectMake(0.0f, 0.0f, contentRect.size.width - self.titleSize - self.gap, contentRect.size.height);
    
}

@end