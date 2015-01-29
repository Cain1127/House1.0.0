//
//  QSNavigationBar.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSNavigationBar.h"

#import <objc/runtime.h>

///关联key
static char NavigationBarLeftKey;   //!<左侧视图的关联key
static char NavigationBarRightKey;  //!<右侧视图的关联key
static char NavigationBarMiddleKey; //!<右侧视图的关联key

@implementation QSNavigationBar

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///添加左中右三个底view
        [self createNavigationBarInitUI];
        
    }
    
    return self;

}

///搭建导航栏初始UI
- (void)createNavigationBarInitUI
{

    ///左侧根视图
    QSImageView *leftRootView = [[QSImageView alloc] init];
    leftRootView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:leftRootView];
    objc_setAssociatedObject(self, &NavigationBarLeftKey, leftRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///中间根视图
    QSImageView *middleRootView = [[QSImageView alloc] init];
    middleRootView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:middleRootView];
    objc_setAssociatedObject(self, &NavigationBarMiddleKey, middleRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///右侧根视图
    QSImageView *rightRootView = [[QSImageView alloc] init];
    rightRootView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:rightRootView];
    objc_setAssociatedObject(self, &NavigationBarRightKey, rightRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///约束参数
    NSDictionary *___viewDict = NSDictionaryOfVariableBindings(leftRootView,middleRootView,rightRootView);
    
    ///约束
    NSString *___hVFL_all = @"H:|-0-[leftRootView(44)]-10-[middleRootView(>=212)]-10-[rightRootView(44)]-0-|";
    NSString *___vVFL_middleRootView = @"V:|-20-[middleRootView(44)]-0-|";
    NSString *___vVFL_rightRootView = @"V:|-20-[rightRootView(44)]-0-|";
    NSString *___vVFL_leftRootView = @"V:|-20-[leftRootView(44)]-0-|";
    
    ///添加约束
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_all options:NSLayoutFormatAlignAllLastBaseline metrics:nil views:___viewDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_middleRootView options:NSLayoutFormatAlignAllCenterX metrics:nil views:___viewDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_rightRootView options:NSLayoutFormatAlignAllCenterX metrics:nil views:___viewDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_leftRootView options:NSLayoutFormatAlignAllCenterX metrics:nil views:___viewDict]];
    
    ///底部划分线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - 0.5f, SIZE_DEVICE_WIDTH, 0.5f)];
    lineLabel.backgroundColor = COLOR_CHARACTERS_GRAY;
    lineLabel.alpha = 0.5f;
    [self addSubview:lineLabel];

}

#pragma mark - 导航栏相关设置
/**
 *  @author             yangshengmeng, 15-01-17 14:01:16
 *
 *  @brief              通过图片的名字，设置导航栏背景图片
 *
 *  @param imageName    背景图片名字
 *
 *  @since              1.0.0
 */
- (void)setNavigationBarBackgroudImageWithImageName:(NSString *)imageName
{

    [self setNavigationBarBackgroudImageWithImage:[UIImage imageNamed:imageName]];

}

/**
 *  @author         yangshengmeng, 15-01-17 14:01:57
 *
 *  @brief          通过图片设置导航栏背景图片
 *
 *  @param image    图片
 *
 *  @since          1.0.0
 */
- (void)setNavigationBarBackgroudImageWithImage:(UIImage *)image
{

    self.image = image;

}

/**
 *  @author         yangshengmeng, 15-01-17 14:01:24
 *
 *  @brief          设置导航栏中间标题
 *
 *  @param title    标题
 *
 *  @since          1.0.0
 */
- (void)setNavigationBarTitle:(NSString *)title
{

    ///清空原中间视图
    UIView *middleRootView = objc_getAssociatedObject(self, &NavigationBarMiddleKey);
    [self removeSubviewsWithView:middleRootView];
    
    ///创建标题
    QSLabel *titleLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, middleRootView.frame.size.width, middleRootView.frame.size.height)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:FONT_NAVIGATIONBAR_TITLE];
    titleLabel.textColor = COLOR_CHARACTERS_GRAY;
    
    [middleRootView addSubview:titleLabel];

}

/**
 *  @author         yangshengmeng, 15-01-17 14:01:42
 *
 *  @brief          添加一个自定义的中间视图
 *
 *  @param view     中间视图
 *
 *  @since          1.0.0
 */
- (void)setNavigationBarMiddleView:(UIView *)view
{

    ///清空原中间视图
    UIView *middleRootView = objc_getAssociatedObject(self, &NavigationBarMiddleKey);
    [self removeSubviewsWithView:middleRootView];
    
    NSLog(@"===================中间控件原frame=========================");
    NSLog(@"frame = %@",NSStringFromCGRect(view.frame));
    NSLog(@"===================中间控件原frame=========================");
    
    ///重置frame
    CGRect newFrame = [self resetSubviewFrameWithView:middleRootView andSubview:view];
    view.frame = newFrame;
    
    NSLog(@"===================中间控件新frame=========================");
    NSLog(@"frame = %@",NSStringFromCGRect(view.frame));
    NSLog(@"===================中间控件新frame=========================");
    
    ///加载
    [middleRootView addSubview:view];

}

/**
 *  @author     yangshengmeng, 15-01-17 14:01:04
 *
 *  @brief      设置导航栏右侧视图
 *
 *  @param view 右侧显示视图
 *
 *  @since      1.0.0
 */
- (void)setNavigationBarRightView:(UIView *)view
{

    ///清空原中间视图
    UIView *rightRootView = objc_getAssociatedObject(self, &NavigationBarRightKey);
    [self removeSubviewsWithView:rightRootView];
    
    ///重置frame
    CGRect newFrame = [self resetSubviewFrameWithView:rightRootView andSubview:view];
    view.frame = newFrame;
    
    ///加载
    [rightRootView addSubview:view];

}

/**
 *  @author     yangshengmeng, 15-01-17 14:01:33
 *
 *  @brief      设置左侧显示视图
 *
 *  @param view 左侧视图
 *
 *  @since      1.0.0
 */
- (void)setNavigationBarLeftView:(UIView *)view
{

    ///清空原中间视图
    UIView *leftRootView = objc_getAssociatedObject(self, &NavigationBarLeftKey);
    [self removeSubviewsWithView:leftRootView];
    
    ///重置frame
    CGRect newFrame = [self resetSubviewFrameWithView:leftRootView andSubview:view];
    view.frame = newFrame;
    
    ///加载
    [leftRootView addSubview:view];

}

#pragma mark - 清空给定view上的子view
/**
 *  @author     yangshengmeng, 15-01-17 15:01:14
 *
 *  @brief      清空给定view上的子view
 *
 *  @param view 需要清空子view的父view
 *
 *  @since      1.0.0
 */
- (void)removeSubviewsWithView:(UIView *)view
{

    for (UIView *tempView in [view subviews]) {
        
        [tempView removeFromSuperview];
        
    }

}

#pragma mark - 根据给定的父视图重置需要加载子view的frame
/**
 *  @author             yangshengmeng, 15-01-17 15:01:35
 *
 *  @brief              根据给定的父视图重置需要加载子view的frame
 *
 *  @param superView    父view
 *  @param view         子view
 *
 *  @since              1.0.0
 */
- (CGRect)resetSubviewFrameWithView:(UIView *)superView andSubview:(UIView *)view
{

    CGRect superFrame = superView.frame;
    CGRect subviewFrame = view.frame;
    
    ///判断宽是否需要重置
    if (subviewFrame.size.width > superFrame.size.width) {
        
        subviewFrame = CGRectMake(subviewFrame.origin.x, subviewFrame.origin.y, superFrame.size.width, subviewFrame.size.height);
        
    }
    
    ///如果子视图的宽小于30，重置为30
    if (subviewFrame.size.width < 30.0f) {
        
        subviewFrame = CGRectMake(subviewFrame.origin.x, subviewFrame.origin.y, 30.0f, subviewFrame.size.height);
        
    }
    
    ///判断高是否需要重置
    if (subviewFrame.size.height > superFrame.size.height) {
        
        subviewFrame = CGRectMake(subviewFrame.origin.x, subviewFrame.origin.y, subviewFrame.size.width, superFrame.size.height);
        
    }
    
    ///如果子视图的高度小于30，重置为30
    if (subviewFrame.size.height < 30.0f) {
        
        subviewFrame = CGRectMake(subviewFrame.origin.x, subviewFrame.origin.y, subviewFrame.size.width, 30.0f);
        
    }
    
    ///重置x,y坐标
    subviewFrame = CGRectMake((superFrame.size.width - subviewFrame.size.width) / 2.0f, (superFrame.size.height - subviewFrame.size.height) / 2.0f, subviewFrame.size.width, subviewFrame.size.height);
    
    return subviewFrame;

}

@end
