//
//  QSChatViewController.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSChatViewController.h"

#import "QSChatContactsView.h"
#import "QSChatMessagesView.h"
#import "QSYPopCustomView.h"
#import "QSYLoginTipsPopView.h"

#import "QSSocketManager.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

@interface QSChatViewController ()

@end

@implementation QSChatViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///设置标题
    [self setNavigationBarTitle:TITLE_VIEWCONTROLLER_TITLE_CHAT];
    
    ///导航栏工具按钮
    UIButton *toolButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:[QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeTool] andCallBack:^(UIButton *button) {
        
        ///进入搜索页
        [self gotoToolViewController];
        
    }];
    [self setNavigationBarRightView:toolButton];

}

///搭建主展示UI
- (void)createMainShowUI
{

    ///由于此页面是放置在tabbar页面上的，所以中间可用的展示高度是设备高度减去导航栏和底部tabbar的高度
    __block CGFloat mainHeightFloat = SIZE_DEVICE_HEIGHT - 64.0f - 49.0f;
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.titleFont = [UIFont systemFontOfSize:16.0f];
    buttonStyle.titleNormalColor = COLOR_CHARACTERS_BLACK;
    buttonStyle.titleHightedColor = COLOR_CHARACTERS_YELLOW;
    buttonStyle.bgColorSelected = COLOR_CHARACTERS_LIGHTYELLOW;
    
    ///按钮指针
    __block UIButton *messageButton;
    __block UIButton *contactButton;
    
    ///指示三角指针
    __block QSImageView *tipsImage;
    
    ///消息列表指针
    __block QSChatMessagesView *messageListView;
    
    ///联系人指针
    __block QSChatContactsView *contactListView;
    
    ///消息按钮
    buttonStyle.title = @"消息";
    messageButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH / 2.0f, 40.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断
        if (button.selected) {
            
            return;
            
        }
        
        ///转换选择状态
        contactButton.selected = NO;
        button.selected = YES;
        
        ///创建消息列表
        messageListView = [[QSChatMessagesView alloc] initWithFrame:CGRectMake(-SIZE_DEVICE_WIDTH, 104.0f, SIZE_DEVICE_WIDTH, mainHeightFloat - 40.0f) andUserType:uUserCountTypeTenant];
        [self.view addSubview:messageListView];
        
        ///动画移动
        [UIView animateWithDuration:0.3 animations:^{
            
            messageListView.frame = CGRectMake(0.0f, 104.0f, SIZE_DEVICE_WIDTH, mainHeightFloat - 40.0f);
            contactListView.frame = CGRectMake(SIZE_DEVICE_WIDTH, 104.0f, SIZE_DEVICE_WIDTH, mainHeightFloat - 40.0f);
            tipsImage.frame = CGRectMake(SIZE_DEVICE_WIDTH / 4.0f - 8.0f, tipsImage.frame.origin.y, tipsImage.frame.size.width, tipsImage.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            [contactListView removeFromSuperview];
            contactListView = nil;
            
        }];
        
    }];
    messageButton.selected = YES;
    [self.view addSubview:messageButton];
    
    ///联系人按钮
    buttonStyle.title = @"联系人";
    contactButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 2.0f, 64.0f, SIZE_DEVICE_WIDTH / 2.0f, 40.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断
        if (button.selected) {
            
            return;
            
        }
        
        ///转换选择状态
        messageButton.selected = NO;
        button.selected = YES;
        
        ///创建联系人列表
        contactListView = [[QSChatContactsView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, 104.0f, SIZE_DEVICE_WIDTH, mainHeightFloat - 40.0f) andUserType:uUserCountTypeTenant andCallBack:^(CONTACT_LIST_ACTION_TYPE actionType, id params) {
            
            switch (actionType) {
                    ///查看二手房
                case cContactListActionTypeLookSecondHandHouse:
                {
                
                    ///发送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:nHomeSecondHandHouseActionNotification object:@"3"];
                    
                    ///进入二手房列表
                    self.tabBarController.selectedIndex = 1;
                
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        [self.view addSubview:contactListView];
        
        ///检测登录
        if (lLoginCheckActionTypeUnLogin == [self checkLogin]) {
            
            ///弹出提示
            __block QSYPopCustomView *popView;
            QSYLoginTipsPopView *loginTipsView = [[QSYLoginTipsPopView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 124.0f) andCallBack:^(LOGIN_TIPS_ACTION_TYPE actionType) {
                
                [popView hiddenCustomPopview];
                
                switch (actionType) {
                        ///取消
                    case lLoginTipsActionTypeCancel:
                        
                        break;
                        
                        ///登录
                    case lLoginTipsActionTypeLogin:
                    {
                        
                        [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                            
                            if (lLoginCheckActionTypeLogined == flag ||
                                lLoginCheckActionTypeReLogin == flag) {
                                
                                [contactListView rebuildContactsView];
                                
                            }
                            
                        }];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }];
            
            popView = [QSYPopCustomView popCustomView:loginTipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
            }];
            
        }
        
        ///动画移动
        [UIView animateWithDuration:0.3 animations:^{
            
            contactListView.frame = CGRectMake(0.0f, 104.0f, SIZE_DEVICE_WIDTH, mainHeightFloat - 40.0f);
            messageListView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, 104.0f, SIZE_DEVICE_WIDTH, mainHeightFloat - 40.0f);
            tipsImage.frame = CGRectMake(SIZE_DEVICE_WIDTH * 3.0f / 4.0f - 8.0f, tipsImage.frame.origin.y, tipsImage.frame.size.width, tipsImage.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            [messageListView removeFromSuperview];
            messageListView = nil;
            
        }];
        
    }];
    [self.view addSubview:contactButton];
    
    ///指示三角
    tipsImage = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 4.0f - 8.0f, contactButton.frame.origin.y + contactButton.frame.size.height - 5.0f, 16.0f, 5.0f)];
    tipsImage.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [self.view addSubview:tipsImage];
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, contactButton.frame.origin.y + contactButton.frame.size.height - 0.5f, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLabel];
    [self.view sendSubviewToBack:sepLabel];
    
    ///首先创建消息列表
    messageListView = [[QSChatMessagesView alloc] initWithFrame:CGRectMake(0.0f, 104.0f, SIZE_DEVICE_WIDTH, mainHeightFloat - 40.0f) andUserType:uUserCountTypeTenant];
    [self.view addSubview:messageListView];

}

#pragma mark - 点击工具按钮
- (void)gotoToolViewController
{

    

}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self hiddenBottomTabbar:NO];
    [super viewWillAppear:animated];
    
}

@end
