//
//  QSTabBarViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTabBarViewController.h"
#import "QSMasterViewController.h"

@interface QSTabBarViewController ()

@property (nonatomic,retain) NSArray *tabbarButtonInfoArray;//!<tabbar按钮相关信息数组
@property (nonatomic,strong) QSTabbar *customTabbarView;    //!<自定义的tabbar

@end

@implementation QSTabBarViewController

#pragma mark - tabbar初始化
/**
 *  @author yangshengmeng, 15-01-17 13:01:49
 *
 *  @brief  初始化：tabbar初始化时添加配置的VC
 *
 *  @return 返回初始化后的tabbar控制器
 *
 *  @since  1.0.0
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        ///隐藏自身的tabbar
        self.tabBar.hidden = YES;
        
    }
    
    return self;

}

#pragma mark - 获取本地tabbar的配置信息
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
    self.selectedIndex = 0;
    
    ///创建自定义tabbar
    self.customTabbarView = [[QSTabbar alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 49.0f, SIZE_DEVICE_WIDTH, 49.0f) andTabbarButtonArray:self.tabbarButtonInfoArray andTabbarTapCallBack:^(int index) {
        
        ///选择某个下标的VC
        self.selectedIndex = index;
        
    }];
    [self.view addSubview:self.customTabbarView];
    
}

@end
