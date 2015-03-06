//
//  QSHouseDetailViewController.m
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHouseDetailViewController.h"
#import "MJRefresh.h"

#import <objc/runtime.h>

///关联
static char RootscrollViewKey;//!<底view的关联key

@interface QSHouseDetailViewController () <UIScrollViewDelegate>

@property (nonatomic,copy) NSString *title;                 //!<标题
@property (nonatomic,copy) NSString *detailID;              //!<详情的ID
@property (nonatomic,assign) FILTER_MAIN_TYPE detailType;   //!<详情的类型

@end

@implementation QSHouseDetailViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-02-12 12:02:39
 *
 *  @brief              根据标题、ID创建详情页面，可以是房子详情，或者小区详情
 *
 *  @param title        标题
 *  @param detailID     详情的ID
 *  @param detailType   详情的类型：房子/小区等
 *
 *  @return             返回当前创建的详情页指针
 *
 *  @since              1.0.0
 */
- (instancetype)initWithTitle:(NSString *)title andDetailID:(NSString *)detailID andDetailType:(FILTER_MAIN_TYPE)detailType
{

    if (self = [super init]) {
        
        ///保存相关参数
        self.title = title;
        self.detailID = detailID;
        self.detailType = detailType;
        
    }
    
    return self;

}

#pragma mark - UI搭建
///重写导航栏，添加标题信息
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:(self.title ? self.title : @"详情")];

}

///主展示信息
- (void)createMainShowUI
{
    
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) ];
    
    ///取消滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    ///透明背影
    scrollView.backgroundColor=[UIColor redColor];
    
    ///设置数据源和代理
    scrollView.delegate = self;
    
    ///添加头部刷新
    [scrollView addHeaderWithTarget:self action:@selector(getDetailInfo)];
    [scrollView headerBeginRefreshing];
    
    [self.view addSubview:scrollView];
    objc_setAssociatedObject(self, &RootscrollViewKey, scrollView, OBJC_ASSOCIATION_ASSIGN);
    

}

#pragma mark -添加头部图片
///添加头部图片
- (void)createHeaderImageUI:(UIView *)view
{


}

#pragma mark -添加评分view
///添加评分view
-(void)createsScoreUI:(UIView *)view
{
    
    
}

#pragma mark -添加房子详情view
///添加房子详情view
-(void)createHouseDetailViewUI:(UIView *)view
{
    
    
}

#pragma mark -添加房子服务按钮view
///添加房子服务按钮view
-(void)createHouseServiceViewUI:(UIView *)view
{
    
    
}

#pragma mark -添加房子价钱变动view
///添加房子价钱变动view
-(void)createPriceChangeViewUI:(UIView *)view
{
    
    
}

#pragma mark -添加小区均价view
///添加小区均价view
-(void)createDistrictAveragePriceViewUI:(UIView *)view
{
    
    
}

#pragma mark -添加房源关注view
///添加房源关注view
-(void)createHouseAttentionViewUI:(UIView *)view
{
    
    
}

#pragma mark -添加评论view
///添加评论view
-(void)createCommentViewUI:(UIView *)view
{
    
    
}

#pragma mark -添加操作view
///添加操作view
-(void)createOperateViewUI:(UIView *)view
{
    
    
}

#pragma mark - 结束刷新动画
///结束刷新动画
- (void)endRefreshAnimination
{

    UIScrollView *scrollView = objc_getAssociatedObject(self, &RootscrollViewKey);
    [scrollView headerEndRefreshing];

}

#pragma mark - 请求详情信息
/**
 *  @author yangshengmeng, 15-02-12 14:02:44
 *
 *  @brief  请求详情信息
 *
 *  @since  1.0.0
 */
- (void)getDetailInfo
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self endRefreshAnimination];
        
    });

}

@end
