//
//  QSHomeViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHomeViewController.h"
#import "QSTabBarViewController.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "QSHouseKeySearchViewController.h"
#import "QSNetworkingStatus.h"
#import "ColorHeader.h"
#import "QSCustomHUDView.h"

@interface QSHomeViewController ()
@property (weak, nonatomic) IBOutlet UIView *houseTypeView;//!< 房源view

//@property (weak, nonatomic) IBOutlet UIView *houseTypeViewOne;
//
//@property (weak, nonatomic) IBOutlet UIView *houseTypeViewTwo;
//
//@property (weak, nonatomic) IBOutlet UIView *houseTypeViewThree;
//
//@property (weak, nonatomic) IBOutlet UIView *houseTypeViewFour;
//
//@property (weak, nonatomic) IBOutlet UIView *houseTypeViewFive;
//
//@property (weak, nonatomic) IBOutlet UIButton *oneHouseButton;
//
//@property (weak, nonatomic) IBOutlet UIButton *secondHouseButton;
//
//@property (weak, nonatomic) IBOutlet UIButton *threeHouseButton;
//
//@property (weak, nonatomic) IBOutlet UIButton *salingButton;
//
//@property (weak, nonatomic) IBOutlet UIButton *bambooplateButton;


@end

@implementation QSHomeViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///添加右侧搜索按钮
    UIButton *searchButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeSearch] andCallBack:^(UIButton *button) {
        
        ///进入搜索页
        [self gotoSearchViewController];
        
    }];
    [self setNavigationBarRightView:searchButton];

}

-(void)createMainShowUI
{
    
    [super createMainShowUI];
    
    ///关注小区
    
    ///设置中间view
    ///顶部5个view宽高比例
//    _houseTypeViewOne.bounds = CGRectMake(0, 0, SIZE_DEVICE_WIDTH*0.35, SIZE_DEVICE_WIDTH*0.20);
//    _houseTypeViewTwo.bounds=CGRectMake(0, 0, SIZE_DEVICE_WIDTH*0.25, SIZE_DEVICE_WIDTH *0.20);
//    _houseTypeViewThree.bounds=CGRectMake(0, 0, SIZE_DEVICE_WIDTH*0.25, SIZE_DEVICE_WIDTH*0.20);
//    _houseTypeViewFour.bounds=CGRectMake(0, 0, SIZE_DEVICE_WIDTH*0.25, SIZE_DEVICE_WIDTH*0.20);
//    _houseTypeViewFive.bounds=_houseTypeViewFour.bounds;
//    
//    ///中间3个按钮宽高比例
//    _oneHouseButton.bounds=CGRectMake(0, 0, SIZE_DEVICE_WIDTH*0.28, SIZE_DEVICE_WIDTH*0.21);
//    _secondHouseButton.bounds=CGRectMake(0, 0, SIZE_DEVICE_WIDTH*0.18, SIZE_DEVICE_WIDTH*0.21);
//    _threeHouseButton.bounds=CGRectMake(0, 0, SIZE_DEVICE_WIDTH*0.18, SIZE_DEVICE_WIDTH*0.21);
//    
//    ///底部两按钮宽高比例
//    _salingButton.bounds=CGRectMake(0, 0, SIZE_DEVICE_WIDTH*0.16, SIZE_DEVICE_WIDTH*0.16);
//    _bambooplateButton.bounds=CGRectMake(0, 0, SIZE_DEVICE_WIDTH*0.16, SIZE_DEVICE_WIDTH*0.16);

    ///设置房源Label颜色
    self.houseTypeCountOneLabel.textColor = COLOR_CHARACTERS_YELLOW;
    self.houseTypeCountTwoLabel.textColor = COLOR_CHARACTERS_YELLOW;
    self.houseTypeCountThreeLabel.textColor = COLOR_CHARACTERS_YELLOW;
    self.houseTypeCountFourLabel.textColor = COLOR_CHARACTERS_YELLOW;
    self.houseTypeCountOtherLabel.textColor = COLOR_CHARACTERS_YELLOW;
    
    ///设置房源主view背景图片
    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.houseTypeView.frame.origin.x,self.houseTypeView.frame.origin.y,self.houseTypeView.frame.size.width,self.houseTypeView.frame.size.height)];
    backgroundImage.image=[UIImage imageNamed:@"nil"];
    [self.houseTypeView addSubview:backgroundImage];
    [self.houseTypeView sendSubviewToBack:backgroundImage];
    
}

#pragma mark - 进入搜索页面
- (void)gotoSearchViewController
{
    
    ///显示房源列表，并进入搜索页
    self.tabBarController.selectedIndex = 1;
    
    UIViewController *housesVC = self.tabBarController.viewControllers[1];
    
    ///判断是ViewController还是NavigationController
    if ([housesVC isKindOfClass:[UINavigationController class]]) {
        
        housesVC = ((UINavigationController *)housesVC).viewControllers[0];
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([housesVC respondsToSelector:@selector(gotoSearchViewController)]) {
            
            [housesVC performSelector:@selector(gotoSearchViewController)];
            
        }
        
    });
    
}

#pragma mark -按钮点击事件
///新房按钮点击事件
- (IBAction)newHouseButton:(id)sender
{
    
    
    
}

///二手房按钮点击事件
- (IBAction)secondHandHouseButton:(id)sender
{
    
    
    
}

///租房按钮点击事件
- (IBAction)rentingHouseButton:(id)sender
{
    
    
    
}

///我要放盘按钮点击事件
- (IBAction)saleHouseButton:(id)sender
{
    
    
    
}

///笋盘推荐按钮点击事件
- (IBAction)bambooplateHouseButton:(id)sender
{
    
    
    
}

@end
