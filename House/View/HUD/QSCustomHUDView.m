//
//  QSCustomHUDView.m
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomHUDView.h"

@interface QSCustomHUDView ()

@property (nonatomic,copy) NSString *mainTips;      //!<主要提示信息
@property (nonatomic,copy) NSString *headerTips;    //!<前置显示的提示信息
@property (nonatomic,copy) NSString *footerTips;    //!<后置显示的提示信息
@property (nonatomic,retain) NSTimer *loadingTimer; //!<加载定时器
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;//!<指示器
@property (nonatomic,strong) UILabel *tipsLabel;                    //!<信息提示框

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
    
    [self hiddenCustomHUDWithFooterTips:footerTips andCallBack:nil];

}

- (void)hiddenCustomHUDWithFooterTips:(NSString *)footerTips andCallBack:(void(^)(BOOL flag))callBack
{

    [self hiddenCustomHUDWithFooterTips:footerTips andDelayTime:1.0f andCallBack:callBack];

}

- (void)hiddenCustomHUDWithFooterTips:(NSString *)footerTips andDelayTime:(CGFloat)time
{

    [self hiddenCustomHUDWithFooterTips:footerTips andDelayTime:time andCallBack:nil];

}

- (void)hiddenCustomHUDWithFooterTips:(NSString *)footerTips andDelayTime:(CGFloat)delayTime andCallBack:(void(^)(BOOL flag))callBack
{
    
    ///判断是否有退出时的提示信息
    if (footerTips) {
            
        self.tipsLabel.text = footerTips;
        
        ///按给定的时间显示后移除
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime + 0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.alpha = 0.0f;
                
            } completion:^(BOOL finished) {
                
                ///判断是否有回调
                if (callBack) {
                    
                    callBack(YES);
                    
                }
                
                [self removeFromSuperview];
                
            }];
            
        });
        
    } else {
    
        ///按给定的时间显示后移除
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime + 0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.alpha = 0.0f;
                
            } completion:^(BOOL finished) {
                
                ///判断是否有回调
                if (callBack) {
                    
                    callBack(YES);
                    
                }
                
                [self removeFromSuperview];
                
            }];
            
        });
    
    }

}

#pragma mark - 开启自定义HUD动画
- (void)startCustomHUDAnimination
{
    
    if (self.headerTips) {
        
        self.tipsLabel.text = self.headerTips;
        
        ///0.5秒后显示主提示信息
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.tipsLabel.text = self.mainTips;
            
        });
        
    } else {
    
        self.tipsLabel.text = self.mainTips;
    
    }
    
    ///转为系统指示
    [self.indicatorView startAnimating];

}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame andTips:(NSString *)tips andHeaderTips:(NSString *)headerTips
{

    if (self = [super initWithFrame:frame]) {
        
        ///保存提示信息
        self.mainTips = tips;
        self.headerTips = headerTips;
        
        ///添加转动
        [self createCustomHUDUI];
        
    }
    
    return self;

}

///创建自定义HUD的UI
- (void)createCustomHUDUI
{

    ///背景颜色
    self.backgroundColor = COLOR_CHARACTERS_BLACKH;
    
    ///系统指示
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.frame = CGRectMake(SIZE_DEVICE_WIDTH / 2.0f - 30.0f, SIZE_DEVICE_HEIGHT / 2.0f - 42.0f, 60.0f, 60.0f);
    [self addSubview:self.indicatorView];
    
    self.tipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.indicatorView.frame.origin.y + self.indicatorView.frame.size.width + 5.0f, SIZE_DEFAULT_MAX_WIDTH, VIEW_SIZE_NORMAL_BUTTON_HEIGHT)];
    self.tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    self.tipsLabel.textColor = [UIColor whiteColor];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tipsLabel];

}

@end
