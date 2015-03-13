//
//  QSCustomHUDView.m
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomHUDView.h"

#import <objc/runtime.h>

///指示器使用自定义或者系统指示控制宏
#define ___USE_SYSTEM_INDICATOR___
//#define ___USE_CUSTOM_INDICATOR___

///关联
static char LoadingImageViewKey;//!<转动图片关联key
static char TipsLabelKey;       //!<提示信息的关联Key

@interface QSCustomHUDView ()

@property (nonatomic,copy) NSString *mainTips;  //!<主要提示信息
@property (nonatomic,copy) NSString *headerTips;//!<前置显示的提示信息
@property (nonatomic,copy) NSString *footerTips;//!<后置显示的提示信息
@property (nonatomic,retain) NSTimer *loadingTimer;//!<加载定时器

/**
 *  @author             yangshengmeng, 15-01-27 14:01:34
 *
 *  @brief              根据给定的提示信息创建一个自定义的HUD
 *
 *  @param frame        位置和大小
 *  @param tips         主要提示信息，没有则不显示
 *  @param headerTips   前面先显示的提示信息
 *
 *  @return             返回当前创建的HUD
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andTips:(NSString *)tips andHeaderTips:(NSString *)headerTips;

@end

@implementation QSCustomHUDView

#pragma mark - 显示HUD
/**
 *  @author yangshengmeng, 15-01-27 12:01:41
 *
 *  @brief  显示自定义的HUD
 *
 *  @return 返回当前显示的HUD
 *
 *  @since  1.0.0
 */
+ (instancetype)showCustomHUD
{

    return [self showCustomHUDWithTips:@"努力加载中……"];

}

/**
 *  @author     yangshengmeng, 15-01-27 13:01:03
 *
 *  @brief      显示一个自定义的HUD，并且显示给定的提示信息
 *
 *  @param tips 给定的提示信息
 *
 *  @return     返回当前显示的HUD
 *
 *  @since      1.0.0
 */
+ (instancetype)showCustomHUDWithTips:(NSString *)tips
{

    return [self showCustomHUDWithTips:tips andHeaderTips:@"准备加载……"];

}

/**
 *  @author             yangshengmeng, 15-01-27 13:01:48
 *
 *  @brief              显示一个有前置提示信息的自定义HUD
 *
 *  @param tips         主要提示信息
 *  @param headerTips   前置提示信息
 *
 *  @return             返回当前显示的HUD
 *
 *  @since              1.0.0
 */
+ (instancetype)showCustomHUDWithTips:(NSString *)tips andHeaderTips:(NSString *)headerTips
{

    QSCustomHUDView *hudView = [[QSCustomHUDView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT) andTips:tips andHeaderTips:headerTips];
    
    ///使用自定义动画
    hudView.alpha = 0.0f;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:hudView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        hudView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [hudView startCustomHUDAnimination];
            
        }
        
    }];
    
    return hudView;

}

#pragma mark - 隐藏HUD
/**
 *  @author yangshengmeng, 15-01-27 13:01:17
 *
 *  @brief  隐藏自定义HUD
 *
 *  @since  1.0.0
 */
- (void)hiddenCustomHUD
{

    ///动画退出
    [self hiddenCustomHUDWithFooterTips:@"加载成功……"];

}

/**
 *  @author             yangshengmeng, 15-01-27 13:01:32
 *
 *  @brief              隐藏自定义HUD，并且移除前显示给定的信息
 *
 *  @param footerTips   移除前显示的提示信息
 *
 *  @since              1.0.0
 */
- (void)hiddenCustomHUDWithFooterTips:(NSString *)footerTips
{
    
    ///停止动画
    UIView *loadingImageView = objc_getAssociatedObject(self, &LoadingImageViewKey);
#ifdef ___USE_SYSTEM_INDICATOR___
    UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)loadingImageView;
    [indicatorView stopAnimating];
#endif
#ifdef ___USE_CUSTOM_INDICATOR___
    [self.loadingTimer invalidate];
#endif

    ///判断是否有退出时的提示信息
    if (footerTips) {
        
        UILabel *tipsLabel = objc_getAssociatedObject(self, &TipsLabelKey);
        if (tipsLabel) {
            
            [loadingImageView removeFromSuperview];
            tipsLabel.text = footerTips;
            
            ///0.5秒后移除
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.alpha = 0.0f;
                    
                } completion:^(BOOL finished) {
                    
                    [self removeFromSuperview];
                    
                }];
                
            });
            
        } else {
        
            tipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, loadingImageView.frame.origin.y + loadingImageView.frame.size.width + 5.0f, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT)];
            tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
            tipsLabel.textColor = COLOR_CHARACTERS_GRAY;
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:tipsLabel];
            
            [loadingImageView removeFromSuperview];
            tipsLabel.text = footerTips;
            
            ///0.5秒后移除
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.alpha = 0.0f;
                    
                } completion:^(BOOL finished) {
                    
                    [self removeFromSuperview];
                    
                }];
                
            });
        
        }
        
    }

}

#pragma mark - 开启自定义HUD动画
- (void)startCustomHUDAnimination
{
    
    ///图片框
    UIView *loadingImageView = objc_getAssociatedObject(self, &LoadingImageViewKey);
    
    ///提示信息框
    UILabel *tipsLabel = nil;
    
    if (self.mainTips) {
        
        tipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, loadingImageView.frame.origin.y + loadingImageView.frame.size.width + 5.0f, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT)];
        tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tipsLabel];
        objc_setAssociatedObject(self, &TipsLabelKey, tipsLabel, OBJC_ASSOCIATION_ASSIGN);
        
        ///判断是否存在前置提示信息
        if (self.headerTips) {
            
            tipsLabel.text = self.headerTips;
            
            ///0.5秒后显示主提示信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                tipsLabel.text = self.mainTips;
                
            });
            
        } else {
        
            tipsLabel.text = self.mainTips;
        
        }
        
    }
    
#ifdef ___USE_CUSTOM_INDICATOR___
    ///开启转动
    self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(loadingAniminationAction:) userInfo:nil repeats:YES];
    [self.loadingTimer fire];
#endif
    
#ifdef ___USE_SYSTEM_INDICATOR___
    ///转为系统指示
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)loadingImageView;
    [indicator startAnimating];
#endif

}

///不断转换图片的角度，表现出旋转的效果
- (void)loadingAniminationAction:(NSTimer *)timer
{

    static CGFloat rotationValue = 0.0f;
    rotationValue += 30.0f;
    UIImageView *loadingImageView = objc_getAssociatedObject(self, &LoadingImageViewKey);
    loadingImageView.transform = CGAffineTransformMakeRotation(rotationValue * M_PI/180);

}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame andTips:(NSString *)tips andHeaderTips:(NSString *)headerTips
{

    if (self = [super initWithFrame:frame]) {
        
        ///添加转动
        [self createCustomHUDUI];
        
        ///保存提示信息
        self.mainTips = tips;
        self.headerTips = headerTips;
        
    }
    
    return self;

}

///创建自定义HUD的UI
- (void)createCustomHUDUI
{

    ///背景颜色
    self.backgroundColor = COLOR_CHARACTERS_BLACKH;
    
#ifdef ___USE_SYSTEM_INDICATOR___
    ///系统指示
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.frame = CGRectMake(SIZE_DEVICE_WIDTH / 2.0f - 30.0f, SIZE_DEVICE_HEIGHT / 2.0f - 42.0f, 60.0f, 60.0f);
    [self addSubview:indicatorView];
    objc_setAssociatedObject(self, &LoadingImageViewKey, indicatorView, OBJC_ASSOCIATION_ASSIGN);
#endif
    
#ifdef ___USE_CUSTOM_INDICATOR___
    ///中间转动指示
    QSImageView *loadingImageView = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 2.0f - 20.0f, SIZE_DEVICE_HEIGHT / 2.0f - 42.0f, 40.0f, 40.0f)];
    loadingImageView.image = [UIImage imageNamed:IMAGE_PUBLIC_LOADING];
    [self addSubview:loadingImageView];
    
    objc_setAssociatedObject(self, &LoadingImageViewKey, loadingImageView, OBJC_ASSOCIATION_ASSIGN);
#endif

}

@end
