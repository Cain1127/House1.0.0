//
//  QSTabBarViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTabBarViewController.h"
#import "QSMasterViewController.h"

#import "QSCoreDataManager+User.h"
#import "QSSocketManager.h"

@interface QSTabBarViewController ()

@property (nonatomic,assign) int intCurrentIndex;           //!<初始化时的显示页下标
@property (nonatomic,retain) NSArray *tabbarButtonInfoArray;//!<tabbar按钮相关信息数组
@property (nonatomic,strong) QSTabbar *customTabbarView;    //!<自定义的tabbar

@end

@implementation QSTabBarViewController

#pragma mark - tabbar初始化
/**
 *  @author         yangshengmeng, 15-02-04 18:02:39
 *
 *  @brief          根据给定的下标初始化主页面，并且首先显示指定的下标VC
 *
 *  @param index    当前显示的下标
 *
 *  @return         返回当前创建的tabbar控制器
 *
 *  @since          1.0.0
 */
- (instancetype)initWithCurrentIndex:(int)index
{

    if (self = [super init]) {
        
        ///隐藏自身的tabbar
        self.tabBar.hidden = YES;
        
        self.intCurrentIndex = index;
        
    }
    
    return self;

}

#pragma mark - 获取本地tabbar的配置信息
///获取tabbar配置信息
- (void)getTabbarSettingPlistFile
{

    ///获取路径
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:PLIST_FILE_NAME_TABBAR ofType:PLIST_FILE_TYPE];
    
    ///获取plist字典
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    ///获取tabbar数据
    NSArray *tempTabbarInfoArray = [plistDict valueForKey:@"tabbar_info"];
    
    ///保存按钮信息
    self.tabbarButtonInfoArray = [NSArray arrayWithArray:tempTabbarInfoArray];

}

#pragma mark - 视图已加载后创建自定义视图
- (void)viewDidLoad
{
    
    [super viewDidLoad];
        
    ///获取tabbar栏按钮信息及所对应的控制器
    [self getTabbarSettingPlistFile];
    
    ///背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    ///临时数组，用来放所有的VC
    NSMutableArray *tempViewControllers = [[NSMutableArray alloc] init];
    
    ///根据配置信息初始化tabbar
    for (int i = 0; i < [self.tabbarButtonInfoArray count]; i++) {
        
        ///获取配置信息
        NSDictionary *tempDict = self.tabbarButtonInfoArray[i];
        
        ///类名
        NSString *className = [tempDict valueForKey:@"class"];
        
        ///创建类
        QSMasterViewController *tempVC = [[NSClassFromString(className) alloc] init];
        
        ///套入navigation
        UINavigationController *tempNavigationVC = [[UINavigationController alloc] initWithRootViewController:tempVC];
        
        ///隐藏导航栏
        tempVC.navigationController.navigationBarHidden = YES;
        
        ///添加到数组中
        [tempViewControllers addObject:tempNavigationVC];
        
    }
    
    ///加载VC数组
    self.viewControllers = tempViewControllers;
    
    ///创建自定义tabbar
    self.customTabbarView = [[QSTabbar alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 49.0f, SIZE_DEVICE_WIDTH, 49.0f) andTabbarButtonArray:self.tabbarButtonInfoArray andTabbarTapCallBack:^(int index) {
        
        ///选择某个下标的VC
        self.selectedIndex = index;
        
    }];
    [self.view addSubview:self.customTabbarView];
    
    self.selectedIndex = (self.intCurrentIndex >= 0 && self.intCurrentIndex < [self.tabbarButtonInfoArray count]) ? self.intCurrentIndex : 0;
    
    ///注册消息监听
    [QSSocketManager registCurrentUnReadMessageCountNotification:^(int msgNum) {
        
        ///判断当前是否选择发现，不是时显示消息提醒
        if (2 == self.selectedIndex) {
            
            [self.customTabbarView setUpperRightCornerTipsWithString:@"0" andIndex:2];
            return;
            
        }
        
        ///在发现按钮的右上角显示提示信息
        if (msgNum > 0) {
            
            NSString *tipsString;
            if (msgNum > 99) {
                
                tipsString = @"99+";
                
            } else {
            
                tipsString = [NSString stringWithFormat:@"%d",msgNum];
            
            }
            [self.customTabbarView setUpperRightCornerTipsWithString:tipsString andIndex:2];
            
        }
        
    }];
    
}

#pragma mark - 显示或者隐藏tabbar
/**
 *  @author     yangshengmeng, 15-01-17 23:01:01
 *
 *  @brief      隐藏/显示tabbar：flag：YES-隐藏 NO-显示
 *
 *  @param flag YES-隐藏，NO-显示
 *
 *  @since      1.0.0
 */
- (void)hiddenBottomTabbar:(BOOL)flag
{

    ///flag为真时隐藏
    if (flag) {
        
        ///动画转动并隐藏
        [UIView animateWithDuration:0.3 animations:^{
            
            ///转动
            self.customTabbarView.transform = CGAffineTransformMakeRotation(M_PI);
            
            ///变透明
            self.customTabbarView.alpha = 0.0f;
            
        }];
        
    } else {
    
        [UIView animateWithDuration:0.3 animations:^{
            
            ///恢复转动
            self.customTabbarView.transform = CGAffineTransformIdentity;
            
            ///显示
            self.customTabbarView.alpha = 1.0f;
            
        }];
    
    }

}

#pragma mark - 重写tabbar重置当前选择的tabbar
///重写设置当前选择状态的view，重选时，修改tabbar相关的状态
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{

    [super setSelectedIndex:selectedIndex];
    [self.customTabbarView setUpperRightCornerTipsWithString:@"0" andIndex:selectedIndex];
    [self.customTabbarView setCurrentSelectedIndex:(int)selectedIndex];

}

@end
