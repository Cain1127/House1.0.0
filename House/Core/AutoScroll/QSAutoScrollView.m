//
//  QSAutoScrollView.m
//  House
//
//  Created by ysmeng on 15/1/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAutoScrollView.h"

@interface QSAutoScrollView ()

@property (assign) AUTOSCROLL_DIRECTION_TYPE autoScrollDirectionType;   //!<自滚动方向
@property (assign) BOOL isShowPageIndex;                                //!<是否显示页码指示器
@property (assign) BOOL isAutoScroll;                                   //!<是否开启自滚动
@property (assign) int sumPage;                                         //!<总的是滚动页数
@property (assign) int currentIndex;                                    //!<当前显示的下标
@property (assign) CGFloat currentShowTime;                             //!<当前显示页的显示时间
@property (nonatomic,assign) id<QSAutoScrollViewDelegate> delegate;     //!<数据源代理
@property (nonatomic,copy) void(^autoScrollViewTapCallBack)(id params); //!<单击滚动view时的回调

@property (nonatomic,strong) NSTimer *autoScrollTimer;                  //!<自滚动的定时器
@property (nonatomic,unsafe_unretained) UIView *currentShowCell;        //!<当前显示的视图
@property (nonatomic,unsafe_unretained) UIView *nextShowCell;           //!<准备显示视图
@property (nonatomic,strong) UIPageControl *pageControll;               //!<页码控制器

@end

@implementation QSAutoScrollView

#pragma mark - 初始化
/**
 *  @author                 yangshengmeng, 15-01-19 11:01:16
 *
 *  @brief                  根据代理和滚动类型，创建一个类广告自滚动的视图
 *
 *  @param frame            在父视图中的位置和大小
 *  @param delegate         滚动视图的代理
 *  @param directionType    滚动的方向
 *
 *  @return                 返回一个自滚动的视图
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame
                  andDelegate:(id<QSAutoScrollViewDelegate>)delegate
       andScrollDirectionType:(AUTOSCROLL_DIRECTION_TYPE)directionType
             andShowPageIndex:(BOOL)pageIndexFlag
                 isAutoScroll:(BOOL)isAutoScroll
                  andShowTime:(CGFloat)currentShowTime
               andTapCallBack:(void (^)(id))callBack
{

    return [self initWithFrame:frame
                   andDelegate:delegate
        andScrollDirectionType:directionType
              andShowPageIndex:pageIndexFlag
                andCurrentPage:0
                  isAutoScroll:isAutoScroll
                   andShowTime:currentShowTime
                andTapCallBack:callBack];

}

/**
 *  @author                 yangshengmeng, 15-03-26 17:03:14
 *
 *  @brief                  创建一个类广告自滚动的展示view
 *
 *  @param frame            大小和位置
 *  @param delegate         代理
 *  @param directionType    滚动方向的类型
 *  @param pageIndexFlag    是否显示页码指示器
 *  @param currentPage      当前页
 *  @param showTime         每一页的显示时间
 *  @param callBack         点击当前显示页时的回调
 *
 *  @return                 返回当前创建的自滚动view
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame
                  andDelegate:(id<QSAutoScrollViewDelegate>)delegate
       andScrollDirectionType:(AUTOSCROLL_DIRECTION_TYPE)directionType
             andShowPageIndex:(BOOL)pageIndexFlag
               andCurrentPage:(int)currentPage
                 isAutoScroll:(BOOL)isAutoScroll
                  andShowTime:(CGFloat)showTime
               andTapCallBack:(void(^)(id params))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存代理
        self.delegate = delegate;
        
        ///保存滚动方向
        self.autoScrollDirectionType = directionType;
        
        ///是否显示页码指示器
        self.isShowPageIndex = pageIndexFlag;
        
        ///当前显示的页码
        self.currentIndex = currentPage;
        
        ///是否自滚动
        self.isAutoScroll = isAutoScroll;
        
        ///保存显示时间：如果时间小于0.5，则默认2秒
        if (showTime > 0.5f) {
            
            self.currentShowTime = showTime;
            
        } else {
            
            self.currentShowTime = 2.0f;
            
        }
        
        ///保存回调
        if (callBack) {
            
            self.autoScrollViewTapCallBack = callBack;
            
        }
        
        ///创建UI
        [self createAutoShowViewUI];
        
        ///添加单击手势
        [self addTapGesture];
        
    }
    
    return self;

}

#pragma mark - 搭建滚动UI
///搭建滚动UI
- (void)createAutoShowViewUI
{
    
    ///如果代理不存在，则不执行
    if (nil == self.delegate) {
        
        return;
        
    }
    
    ///判断需要显示的数量
    int sumPage = [self.delegate numberOfScrollPage:self];
    
    ///如果没有提供显示的总数页，则不创建展示页
    if (0 >= sumPage) {
        
        return;
        
    }

    ///获取滚动的页数
    self.sumPage = sumPage;

    ///判断是否只有一个：如果只有一个，当前页码为0
    if (1 == self.sumPage) {
        
        ///更新相关参数
        self.currentIndex = 0;
        
    }
    
    ///通过代理获取当前显示view和下一个显示view
    self.currentShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:self.currentIndex];
    self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];

    ///重置frame，保证显示全
    CGFloat showHeight = self.frame.size.width * self.currentShowCell.frame.size.height / self.currentShowCell.frame.size.width;
    self.currentShowCell.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, showHeight);
    
    ///从上往下/从下往上滚动
    CGFloat nextShowHeight = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
    if (self.autoScrollDirectionType == aAutoScrollDirectionTypeTopToBottom ||
        self.autoScrollDirectionType == aAutoScrollDirectionTypeBottomToTop) {
        
        self.nextShowCell.frame = CGRectMake(0.0f, -nextShowHeight, self.frame.size.width, nextShowHeight);
        
    } else {
    
        self.nextShowCell.frame = CGRectMake(-self.frame.size.width, 0.0f, self.frame.size.width, nextShowHeight);
    
    }
    
    [self addSubview:self.currentShowCell];
    [self addSubview:self.nextShowCell];
    
    ///添加滑动手势
    [self addSwipeGesture];
    
    ///页码指示
    if (self.isShowPageIndex) {
        
        [self showPageIndexControl:YES];
        
    }
    
    ///判断是否开启定时器
    if (self.isAutoScroll) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.currentShowTime + 2.0f) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            ///开始切换视图
            [self startAnimination];
            
        });
        
    }
    
}

#pragma mark - 添加页码指示器
///创建页码指示
- (void)showPageIndexControl:(BOOL)flag
{

    if (flag) {
        
        if (nil == self.pageControll) {
            
            self.pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
            
        }
    
        self.pageControll.hidden = NO;
        self.pageControll.numberOfPages = self.sumPage;
        self.pageControll.currentPage = self.currentIndex;
        self.pageControll.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControll.currentPageIndicatorTintColor = [UIColor blackColor];;
        self.pageControll.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height - 40.0f);
        [self addSubview:self.pageControll];
        
    } else {
    
        if (self.pageControll) {
            
            self.pageControll.hidden = YES;
            
        }
    
    }

}

#pragma mark - 开始动画
- (void)startAnimination
{
    
    ///开启定时器
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:(self.currentShowTime + 3.0f) target:self selector:@selector(changeCurrentShowView:) userInfo:nil repeats:YES];
    [self.autoScrollTimer fire];

}

///切换当前显示的视图
- (void)changeCurrentShowView:(NSTimer *)timer
{

    switch (self.autoScrollDirectionType) {
            
            ///从上到下滚动
        case aAutoScrollDirectionTypeTopToBottom:
        {
            
            ///重置下一个页面的frame
            self.nextShowCell.frame = CGRectMake(0.0f, -self.nextShowCell.frame.size.height, self.nextShowCell.frame.size.width, self.nextShowCell.frame.size.height);
            
            ///动画切换后刷新左右指针
            [self animationChangeView:CGRectMake(0.0f, self.currentShowCell.frame.size.height, self.currentShowCell.frame.size.width, self.currentShowCell.frame.size.height) andWillShowView:self.nextShowCell andShowingAction:^(void){
                
                ///更新当前显示的下标
                self.currentIndex = [self getRightPrepareShowViewIndex];
                
                ///更新页码指示
                if (self.isShowPageIndex) {
                    
                    self.pageControll.currentPage = self.currentIndex;
                    
                }
                
            } andFinishCallBack:^(BOOL finish) {
                
                if (finish) {
                    
                    ///移除原显示页
                    [self.currentShowCell removeFromSuperview];
                    
                    ///更新当前显示view
                    self.currentShowCell = self.nextShowCell;
                    self.nextShowCell = nil;
                    
                    ///更新下一页视图
                    self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
                    
                    ///下一页添加到滚动视图上
                    CGFloat nextShowHeight = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
                    self.nextShowCell.frame = CGRectMake(0.0f, -nextShowHeight, self.frame.size.width, nextShowHeight);
                    
                    ///加载
                    [self insertSubview:self.nextShowCell atIndex:0];
                    
                }
                
            }];
            
        }
            break;
            
            ///从下到上滚动
        case aAutoScrollDirectionTypeBottomToTop:
        {
            
            ///重置下一个页面的frame
            self.nextShowCell.frame = CGRectMake(0.0f, self.nextShowCell.frame.size.height, self.nextShowCell.frame.size.width, self.nextShowCell.frame.size.height);
            
            ///动画切换后刷新左右指针
            [self animationChangeView:CGRectMake(0.0f, -self.currentShowCell.frame.size.height, self.currentShowCell.frame.size.width, self.currentShowCell.frame.size.height) andWillShowView:self.nextShowCell andShowingAction:^(void){
                
                ///更新当前显示的下标
                self.currentIndex = [self getLeftPrepareShowViewIndex];
                
                if (self.isShowPageIndex) {
                    
                    ///更新页码指示
                    self.pageControll.currentPage = self.currentIndex;
                    
                }
                
            } andFinishCallBack:^(BOOL finish) {
                
                if (finish) {
                    
                    ///移除原显示页
                    [self.currentShowCell removeFromSuperview];
                    
                    self.currentShowCell = self.nextShowCell;
                    self.nextShowCell = nil;
                    
                    ///更新下一页视图
                    self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getLeftPrepareShowViewIndex]];
                    
                    ///下一页添加到滚动视图上
                    CGFloat nextShowHeight = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
                    self.nextShowCell.frame = CGRectMake(0.0f, nextShowHeight, self.frame.size.width, nextShowHeight);
                    
                    ///加载
                    [self insertSubview:self.nextShowCell atIndex:0];
                    
                }
                
            }];
            
        }
            break;
            
            ///从左到右滚动
        case aAutoScrollDirectionTypeLeftToRight:
        {
            
            ///重置下一个页面的frame
            self.nextShowCell.frame = CGRectMake(-self.nextShowCell.frame.size.width, 0.0f, self.nextShowCell.frame.size.width, self.nextShowCell.frame.size.height);
            
            ///动画切换后刷新左右指针
            [self animationChangeView:CGRectMake(self.currentShowCell.frame.size.width, 0.0f, self.currentShowCell.frame.size.width, self.currentShowCell.frame.size.height) andWillShowView:self.nextShowCell andShowingAction:^(void){
                
                ///更新当前显示的下标
                self.currentIndex = [self getLeftPrepareShowViewIndex];
                
                if (self.isShowPageIndex) {
                    
                    ///更新页码指示
                    self.pageControll.currentPage = self.currentIndex;
                    
                }
                
            } andFinishCallBack:^(BOOL finish) {
                
                if (finish) {
                    
                    ///移除原显示页
                    [self.currentShowCell removeFromSuperview];
                    
                    self.currentShowCell = self.nextShowCell;
                    self.nextShowCell = nil;
                    
                    ///更新下一页视图
                    self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getLeftPrepareShowViewIndex]];
                    
                    ///下一页添加到滚动视图上
                    CGFloat nextShowHeight = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
                    self.nextShowCell.frame = CGRectMake(-self.frame.size.width, 0.0f, self.frame.size.width, nextShowHeight);
                    
                    ///加载
                    [self insertSubview:self.nextShowCell atIndex:0];
                    
                }
                
            }];
            
        }
            break;
            
            ///从右到左滚动
        case aAutoScrollDirectionTypeRightToLeft:
        {
            
            ///重置下一个页面的frame
            self.nextShowCell.frame = CGRectMake(self.nextShowCell.frame.size.width, 0.0f, self.nextShowCell.frame.size.width, self.nextShowCell.frame.size.height);
            
            ///动画切换后刷新左右指针
            [self animationChangeView:CGRectMake(-self.currentShowCell.frame.size.width, 0.0f, self.currentShowCell.frame.size.width, self.currentShowCell.frame.size.height) andWillShowView:self.nextShowCell andShowingAction:^(void){
                
                ///更新当前显示的下标
                self.currentIndex = [self getRightPrepareShowViewIndex];
                
                ///更新页码指示
                self.pageControll.currentPage = self.currentIndex;
                
            } andFinishCallBack:^(BOOL finish) {
                
                if (finish) {
                    
                    ///移除原显示页
                    [self.currentShowCell removeFromSuperview];
                    
                    self.currentShowCell = self.nextShowCell;
                    self.nextShowCell = nil;
                    
                    ///更新下一页视图
                    self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
                    
                    ///下一页添加到滚动视图上
                    CGFloat nextShowHeight = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
                    self.nextShowCell.frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width, nextShowHeight);
                    
                    ///加载
                    [self insertSubview:self.nextShowCell atIndex:0];
                    
                }
                
            }];
            
        }
            break;
            
    }

}

///动画切换当前页面和将要显示页面
- (void)animationChangeView:(CGRect)currentViewChangedFrame andWillShowView:(UIView *)view andShowingAction:(void(^)(void))showingAction andFinishCallBack:(void(^)(BOOL finish))callBack
{
    
    ///获取当前显示页的frame
    CGRect currentShowFrame = self.currentShowCell.frame;

    ///动画插入
    [UIView animateWithDuration:0.3 animations:^{
        
        self.currentShowCell.frame = currentViewChangedFrame;
        view.frame = CGRectMake(currentShowFrame.origin.x, currentShowFrame.origin.y, view.frame.size.width, view.frame.size.height);
        
        showingAction();
        
    } completion:^(BOOL finished) {
        
        ///回调
        callBack(finished);
        
    }];

}

#pragma mark - 返回左右将要显示view的下标
///返回左侧将要显示的view下标
- (int)getLeftPrepareShowViewIndex
{

    int leftIndex = self.currentIndex - 1;
    
    if (leftIndex < 0) {
        
        leftIndex = self.sumPage - 1;
        
    }
    
    return leftIndex;

}

///返回右侧将要显示的view下标
- (int)getRightPrepareShowViewIndex
{
    
    int rightIndex = self.currentIndex + 1;
    
    if (rightIndex >= self.sumPage) {
        
        rightIndex = 0;
        
    }
    
    return rightIndex;
    
}

#pragma mark - 添加单击手势
- (void)addTapGesture
{

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoScrollViewTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];

}

///单击时将对应的参数回调
- (void)autoScrollViewTapAction:(UITapGestureRecognizer *)tap
{

    ///取出当前显示view相关参数
    id params = [self.delegate autoScrollViewTapCallBackParams:self viewForShowAtIndex:self.currentIndex];
    
    ///回调
    if (self.autoScrollViewTapCallBack) {
        
        self.autoScrollViewTapCallBack(params);
        
    }

}

#pragma mark - 添加滑动手势
- (void)addSwipeGesture
{

    
    switch (self.autoScrollDirectionType) {
            
            ///从上滑到下
        case aAutoScrollDirectionTypeTopToBottom:
            
            ///从下滑到上
        case aAutoScrollDirectionTypeBottomToTop:
            
            [self addUpSwipeGesture];
            [self addDownSwipeGesture];
            
            break;
            
            ///从左滑到右
        case aAutoScrollDirectionTypeLeftToRight:
            
            ///从右滑到左
        case aAutoScrollDirectionTypeRightToLeft:
            
            [self addLeftSwipeGesture];
            [self addRightSwipeGesture];
            
            break;
            
        default:
            break;
    }
    
}

///添加向左侧滑动手动
- (void)addLeftSwipeGesture
{

    ///向左滑动
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoScrollViewLeftSwipeAction:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeft];

}

///向左滑动时的事件
- (void)autoScrollViewLeftSwipeAction:(UISwipeGestureRecognizer *)swipe
{
    
    ///定时器延迟三秒执行
    [self.autoScrollTimer setFireDate:[[NSDate date] dateByAddingTimeInterval:3.5f]];
    
    ///移除原下一页
    [self.nextShowCell removeFromSuperview];
    
    ///重新获取下一页
    self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
    
    ///重置下一页的frame
    CGFloat heightNextCell = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
    self.nextShowCell.frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width, heightNextCell);
    
    [self insertSubview:self.nextShowCell atIndex:0];
    
    ///动画显示
    [self animationChangeView:CGRectMake(-self.currentShowCell.frame.size.width, 0.0f, self.currentShowCell.frame.size.width, self.currentShowCell.frame.size.height) andWillShowView:self.nextShowCell andShowingAction:^(void){
    
        ///更新当前显示的下标
        self.currentIndex = [self getRightPrepareShowViewIndex];
        
        if (self.pageControll) {
            
            ///更新页码指示
            self.pageControll.currentPage = self.currentIndex;
            
        }
        
    } andFinishCallBack:^(BOOL finish) {
        
        if (finish) {
            
            ///移除原显示页
            [self.currentShowCell removeFromSuperview];
            
            self.currentShowCell = self.nextShowCell;
            self.nextShowCell = nil;
            
            if (self.autoScrollDirectionType == aAutoScrollDirectionTypeRightToLeft) {
                
                ///更新下一页视图
                self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
                
                ///下一页添加到滚动视图上
                CGFloat newHeightNextCell = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
                self.nextShowCell.frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width, newHeightNextCell);
                
                ///加载
                [self insertSubview:self.nextShowCell atIndex:0];
                
            }
            
            if (self.autoScrollDirectionType == aAutoScrollDirectionTypeLeftToRight) {
                
                ///更新下一页视图
                self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getLeftPrepareShowViewIndex]];
                
                ///下一页添加到滚动视图上
                CGFloat newHeightNextCell = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
                self.nextShowCell.frame = CGRectMake(-self.frame.size.width, 0.0f, self.frame.size.width, newHeightNextCell);
                
                ///加载
                [self insertSubview:self.nextShowCell atIndex:0];
                
            }
            
        }
        
    }];

}

///添加向右滑动手势
- (void)addRightSwipeGesture
{

    ///向右滑动
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoScrollViewRightSwipeAction:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRight];

}

///向右滑动时的事件
- (void)autoScrollViewRightSwipeAction:(UISwipeGestureRecognizer *)swipe
{
    
    ///定时器延迟三秒执行
    [self.autoScrollTimer setFireDate:[[NSDate date] dateByAddingTimeInterval:3.5f]];
    
    ///移聊原下一页
    [self.nextShowCell removeFromSuperview];
    
    ///重新获取下一页
    self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getLeftPrepareShowViewIndex]];
    
    ///重置下一页的frame
    CGFloat heightNextCell = self.frame.size.width * self.nextShowCell.frame.size.height / self.frame.size.width;
    self.nextShowCell.frame = CGRectMake(-self.frame.size.width, 0.0f, self.frame.size.width, heightNextCell);
    
    [self insertSubview:self.nextShowCell atIndex:0];
    
    ///动画显示
    [self animationChangeView:CGRectMake(self.currentShowCell.frame.size.width, 0.0f, self.currentShowCell.frame.size.width, self.currentShowCell.frame.size.height) andWillShowView:self.nextShowCell andShowingAction:^(void){
    
        ///更新当前显示的下标
        self.currentIndex = [self getLeftPrepareShowViewIndex];
        
        if (self.pageControll) {
            
            ///更新页码指示
            self.pageControll.currentPage = self.currentIndex;
            
        }
        
    } andFinishCallBack:^(BOOL finish) {
        
        if (finish) {
            
            ///移除原显示页
            [self.currentShowCell removeFromSuperview];
            
            self.currentShowCell = self.nextShowCell;
            self.nextShowCell = nil;
            
            if (self.autoScrollDirectionType == aAutoScrollDirectionTypeLeftToRight) {
                
                ///更新下一页视图
                self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getLeftPrepareShowViewIndex]];
                
                ///下一页添加到滚动视图上
                CGFloat newHeightNextCell = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
                self.nextShowCell.frame = CGRectMake(-self.frame.size.width, 0.0f, self.frame.size.width, newHeightNextCell);
                
                ///加载
                [self insertSubview:self.nextShowCell atIndex:0];
                
            }
            
            if (self.autoScrollDirectionType == aAutoScrollDirectionTypeRightToLeft) {
                
                ///更新下一页视图
                self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
                
                ///下一页添加到滚动视图上
                CGFloat newHeightNextCell = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
                self.nextShowCell.frame = CGRectMake(self.frame.size.width, 0.0f, self.frame.size.width, newHeightNextCell);
                
                ///加载
                [self insertSubview:self.nextShowCell atIndex:0];
                
            }
            
        }
        
    }];
    
}

///添加向上滑动手势
- (void)addUpSwipeGesture
{

    ///左移
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoScrollViewUpSwipeAction:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeUp];

}

///向上滑动时的事件
- (void)autoScrollViewUpSwipeAction:(UISwipeGestureRecognizer *)swipe
{
    
    ///重置定时器
    [self.autoScrollTimer setFireDate:[[NSDate date] dateByAddingTimeInterval:3.5f]];
    
    ///移聊原下一页
    [self.nextShowCell removeFromSuperview];
    
    ///重置下一页数据
    self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getLeftPrepareShowViewIndex]];
    
    ///重置下一页的frame
    CGFloat heightNextCell = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
    self.nextShowCell.frame = CGRectMake(0.0f, heightNextCell, self.frame.size.width, heightNextCell);
    
    ///加载
    [self insertSubview:self.nextShowCell atIndex:0];
    
    ///动画显示
    [self animationChangeView:CGRectMake(0.0f, -self.currentShowCell.frame.size.height, self.currentShowCell.frame.size.width, self.currentShowCell.frame.size.height) andWillShowView:self.nextShowCell andShowingAction:^(void){
    
        ///更新当前显示的下标
        self.currentIndex = [self getLeftPrepareShowViewIndex];
        
        if (self.pageControll) {
            
            ///更新页码指示
            self.pageControll.currentPage = self.currentIndex;
            
        }
        
    } andFinishCallBack:^(BOOL finish) {
        
        if (finish) {
            
            ///移除原显示页
            [self.currentShowCell removeFromSuperview];
            
            self.currentShowCell = self.nextShowCell;
            self.nextShowCell = nil;
            
            ///更新下一页视图
            if (self.autoScrollDirectionType == aAutoScrollDirectionTypeBottomToTop) {
                
                self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getLeftPrepareShowViewIndex]];
                
                ///下一页添加到滚动视图上
                CGFloat newheightNextCell = self.frame.size.width * self.nextShowCell.frame.size.height / self.frame.size.width;
                self.nextShowCell.frame = CGRectMake(0.0f, newheightNextCell, self.frame.size.width, newheightNextCell);
                
                ///加载
                [self insertSubview:self.nextShowCell atIndex:0];
                
            }
            
            if (self.autoScrollDirectionType == aAutoScrollDirectionTypeTopToBottom) {
                
                self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
                
                ///下一页添加到滚动视图上
                CGFloat newheightNextCell = self.frame.size.width * self.nextShowCell.frame.size.height / self.frame.size.width;
                self.nextShowCell.frame = CGRectMake(0.0f, -newheightNextCell, self.frame.size.width, newheightNextCell);
                
                ///加载
                [self insertSubview:self.nextShowCell atIndex:0];
                
            }
            
        }
        
    }];
    
}

///添加向下滑动手势
- (void)addDownSwipeGesture
{

    ///下移
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoScrollViewDownSwipeAction:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeDown];

}

///向下滑动时的事件
- (void)autoScrollViewDownSwipeAction:(UISwipeGestureRecognizer *)swipe
{
    
    ///重置定时器
    [self.autoScrollTimer setFireDate:[[NSDate date] dateByAddingTimeInterval:3.5f]];
    
    ///移聊原下一页
    [self.nextShowCell removeFromSuperview];
    
    ///重置下一页数据
    self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
    
    ///重置下一页的frame
    CGFloat heightNextCell = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
    self.nextShowCell.frame = CGRectMake(0.0f, -heightNextCell, self.frame.size.width, heightNextCell);
    
    ///加载
    [self insertSubview:self.nextShowCell atIndex:0];
    
    ///动画显示
    [self animationChangeView:CGRectMake(0.0f, self.currentShowCell.frame.size.height, self.currentShowCell.frame.size.width, self.currentShowCell.frame.size.height) andWillShowView:self.nextShowCell andShowingAction:^(void){
    
        ///更新当前显示的下标
        self.currentIndex = [self getRightPrepareShowViewIndex];
        
        ///更新页码指示
        self.pageControll.currentPage = self.currentIndex;
        
    } andFinishCallBack:^(BOOL finish) {
        
        if (finish) {
            
            ///移除原显示页
            [self.currentShowCell removeFromSuperview];
            
            self.currentShowCell = self.nextShowCell;
            self.nextShowCell = nil;
            
            if (self.autoScrollDirectionType == aAutoScrollDirectionTypeTopToBottom) {
                
                ///更新下一页视图
                self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
                
                ///下一页添加到滚动视图上
                CGFloat newHeightNextCell = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.height;
                self.nextShowCell.frame = CGRectMake(0.0f, -newHeightNextCell, self.frame.size.width, newHeightNextCell);
                
                ///加载
                [self insertSubview:self.nextShowCell atIndex:0];
                
            }
            
            if (self.autoScrollDirectionType == aAutoScrollDirectionTypeBottomToTop) {
                
                ///更新下一页视图
                self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getLeftPrepareShowViewIndex]];
                
                ///下一页添加到滚动视图上
                CGFloat newHeightNextCell = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
                self.nextShowCell.frame = CGRectMake(0.0f, newHeightNextCell, self.frame.size.width, newHeightNextCell);
                
                ///加载
                [self insertSubview:self.nextShowCell atIndex:0];
                
            }
            
        }
        
    }];
    
}

#pragma mark - 重新加载滚动视图
/**
 *  @author yangshengmeng, 15-03-12 17:03:15
 *
 *  @brief  重新加载滚动视图
 *
 *  @since  1.0.0
 */
- (void)reloadAutoScrollView
{
    
    ///停止定时器
    if ([self.autoScrollTimer isValid]) {
        
        [self.autoScrollTimer setFireDate:[NSDate distantFuture]];
        
    }
    
    ///清空原显示
    [self.currentShowCell removeFromSuperview];
    [self.nextShowCell removeFromSuperview];
    self.currentShowCell = nil;
    self.nextShowCell = nil;
    
    ///关闭用户交互
    self.userInteractionEnabled = NO;
    
    ///如果代理不存在，则不刷新
    if (nil == self.delegate) {
        
        return;
        
    }
    
    ///判断需要显示的数量
    int sumPage = [self.delegate numberOfScrollPage:self];
    
    ///如果没有提供显示的总数页，则不创建展示页
    if (0 >= sumPage) {
        
        self.sumPage = 0;
        return;
        
    }
    
    ///获取滚动的页数
    self.sumPage = sumPage;
    
    ///当前页码为0
    self.currentIndex = 0;
    
    ///通过代理获取当前显示view和下一个显示view
    self.currentShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:self.currentIndex];
    self.nextShowCell = [self.delegate autoScrollViewShowView:self viewForShowAtIndex:[self getRightPrepareShowViewIndex]];
    
    ///重置frame，保证显示全
    CGFloat showHeight = self.frame.size.width * self.currentShowCell.frame.size.height / self.currentShowCell.frame.size.width;
    self.currentShowCell.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, showHeight);
    
    ///从上往下/从下往上滚动
    CGFloat nextShowHeight = self.frame.size.width * self.nextShowCell.frame.size.height / self.nextShowCell.frame.size.width;
    if (self.autoScrollDirectionType == aAutoScrollDirectionTypeTopToBottom ||
        self.autoScrollDirectionType == aAutoScrollDirectionTypeBottomToTop) {
        
        self.nextShowCell.frame = CGRectMake(0.0f, -nextShowHeight, self.frame.size.width, nextShowHeight);
        
    } else {
        
        self.nextShowCell.frame = CGRectMake(-self.frame.size.width, 0.0f, self.frame.size.width, nextShowHeight);
        
    }
    
    [self insertSubview:self.currentShowCell atIndex:0];
    [self insertSubview:self.nextShowCell atIndex:0];
    
    ///页码指示
    if (self.isShowPageIndex) {
        
        [self showPageIndexControl:YES];
        
    }
    
    ///判断是否开启定时器
    if (self.isAutoScroll) {
        
        [self.autoScrollTimer setFireDate:[[NSDate date] dateByAddingTimeInterval:3.5f]];
        
    }
    
    ///开启用户交互
    self.userInteractionEnabled = YES;

}

@end
