//
//  QSAdvertViewController.m
//  House
//
//  Created by ysmeng on 15/1/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAdvertViewController.h"
#import "QSAutoScrollView.h"
#import "QSTabBarViewController.h"
#import "QSYAppDelegate.h"
#import "QSGuideViewController.h"

@interface QSAdvertViewController ()<QSAutoScrollViewDelegate>

@property (nonatomic,assign) BOOL isShowAdvert;     //!<是否显示广告栏的标记：YES-显示,NO-不显示
@property (nonatomic,assign) BOOL isShowGuideIndex; //!<是否显示指引页标记：YES-显示,NO-不显示

@end

@implementation QSAdvertViewController

#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        ///获取指引状态
        self.isShowGuideIndex = [QSCoreDataManager getAppGuideIndexStatus];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ///白色背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    ///创建默认版权信息
    UILabel *rightInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, SIZE_DEVICE_HEIGHT - 54.0f, SIZE_DEVICE_WIDTH - 60.0f, 44.0f)];
    rightInfoLabel.text = @"Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.";
    rightInfoLabel.textColor = COLOR_CHARACTERS_NORMAL;
    rightInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    rightInfoLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:rightInfoLabel];
    
    QSAutoScrollView *autoScrollView = [[QSAutoScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) andDelegate:self andScrollDirectionType:aAutoScrollDirectionTypeRightToLeft andShowPageIndex:NO andShowTime:3.0f andTapCallBack:^(id params) {
        
        NSLog(@"=============================%@",params);
        
    }];
    
    [self.view addSubview:autoScrollView];
    
    ///10秒后进入主页
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///判断是否需要显示指引页
        if (self.isShowGuideIndex) {
            
            [self gotoGuideIndexViewController];
            
        } else {
            
            ///进入主功能页
            [self gotoAppMainViewController];
            
        }
        
    });
    
}

#pragma mark - 进入指引页
- (void)gotoGuideIndexViewController
{

    QSGuideViewController *guideView = [[QSGuideViewController alloc] init];
    ///加载到rootViewController上
    QSYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = guideView;

}

#pragma mark - 进入主显示页面
- (void)gotoAppMainViewController
{

    ///加载tabbar控制器
    QSTabBarViewController *tabbarVC = [[QSTabBarViewController alloc] init];
    
    ///加载到rootViewController上
    QSYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = tabbarVC;

}

#pragma mark - 广告总页数
- (int)numberOfScrollPage:(QSAutoScrollView *)autoScrollView
{

    return 1;

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
