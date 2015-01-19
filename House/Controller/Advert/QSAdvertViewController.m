//
//  QSAdvertViewController.m
//  House
//
//  Created by ysmeng on 15/1/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAdvertViewController.h"
#import "QSAutoScrollView.h"

@interface QSAdvertViewController ()<QSAutoScrollViewDelegate>

@end

@implementation QSAdvertViewController

#pragma mark - UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    QSAutoScrollView *autoScrollView = [[QSAutoScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT) andDelegate:self andScrollDirectionType:aAutoScrollDirectionTypeRightToLeft andShowPageIndex:YES andShowTime:3.0f andTapCallBack:^(id params) {
        
        NSLog(@"=============================%@",params);
        
    }];
    
    [self.view addSubview:autoScrollView];
    
    /**
     *  ///加载tabbar控制器
     QSTabBarViewController *tabbarVC = [[QSTabBarViewController alloc] init];
     
     ///加载到rootViewController上
     self.window.rootViewController = tabbarVC;
     */
    
}

#pragma mark - 广告总页数
- (int)numberOfScrollPage:(QSAutoScrollView *)autoScrollView
{

    return 3;

}

#pragma mark - 返回指定下标的广告页
- (UIView *)autoScrollViewShowView:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{

    UIView *advertView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 100.0f, SIZE_DEVICE_WIDTH - 60.0f, 60.0f)];
    titleLabel.text = [NSString stringWithFormat:@"%d",index];
    titleLabel.font = [UIFont boldSystemFontOfSize:60.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [advertView addSubview:titleLabel];
    
    if (index == 0) {
        
        advertView.backgroundColor = [UIColor redColor];
        
    }
    
    if (index == 1) {
        
        advertView.backgroundColor = [UIColor orangeColor];
        
    }
    
    if (index == 2) {
        
        advertView.backgroundColor = [UIColor blueColor];
        
    }
    
    return advertView;

}

#pragma mark - 单击广告页时的回调参数
- (id)autoScrollViewTapCallBackParams:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{

    return [NSString stringWithFormat:@"%d",index];

}

@end
