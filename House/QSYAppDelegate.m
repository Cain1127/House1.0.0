//
//  QSYAppDelegate.m
//  House
//
//  Created by ysmeng on 15/1/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAppDelegate.h"

#import "QSAdvertViewController.h"
#import "QSWDeveloperHomeViewController.h"
#import "QSTabBarViewController.h"
#import "QSLoginViewController.h"

#import "QSCityInfoReturnData.h"
#import "QSConfigurationReturnData.h"
#import "QSBaseConfigurationReturnData.h"
#import "QSYLoginReturnData.h"
#import "QSUserDataModel.h"
#import "QSMapManager.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+User.h"

#import "QSRequestManager.h"
#import "QSSocketManager.h"

#import "QSCustomHUDView.h"

#import "QSMapManager.h"

#import <BaiduPushSDK/BPush.h>

///分享访问链接
static NSString *const app_URL = @"http://www.baidu.com/";

///友盟分享appkey
static NSString *const shareSDK_Key = @"5535be0d67e58e4e96003357";

 ///微信分享appID
static NSString *const Wechat_Key = @"wxc1d288df9337eb74";

///微信分享appSecret
static NSString *const appSecret_Key = @"0c4264acc43c08c808c1d01181a23387";

@interface QSYAppDelegate () <BPushDelegate>

///非主线程任务处理使用的自定义线程
@property (nonatomic, strong) dispatch_queue_t appDelegateOperationQueue;

///CoreData相关的对象
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation QSYAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize mainObjectContext = _mainObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    ///消除通知提醒条数
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    ///非主线程任务操作线程初始化
    self.appDelegateOperationQueue = dispatch_queue_create(QUEUE_APPDELEGATE_QUEUE, DISPATCH_QUEUE_CONCURRENT);
    
    ///更新本地通知状态
    NSString *is_recieve_push = [[NSUserDefaults standardUserDefaults] valueForKey:@"is_recieve_push"];
    if ([is_recieve_push intValue] == 9000) {
        
        ///不接收通知
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
    
        [[NSUserDefaults standardUserDefaults] setObject:@"1000" forKey:@"is_recieve_push"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    }
    
    ///判断是否是通过通知列表进入：弹出提示，同时保存通知
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        
        ///取得 APNs 标准信息内容
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"is_push_in"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
    
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_push_in"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    }
    
    ///判断是否是开发商
    NSString *isDevelop = [[NSUserDefaults standardUserDefaults] objectForKey:@"is_develop"];
    if ([isDevelop intValue] == 1) {
        
        ///进入开发商页面
        QSWDeveloperHomeViewController *developerVC = [[QSWDeveloperHomeViewController alloc] init];
        
        UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:developerVC];
        [developerVC.navigationController setNavigationBarHidden:YES];
        
        ///修改默认的用户类型
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"is_develop"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.window.rootViewController = navigationVC;
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_develop"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        ///显示广告页
        QSAdvertViewController *advertVC = [[QSAdvertViewController alloc] init];
        self.window.rootViewController = advertVC;
    
    }
    
    ///注册通知
    [BPush setupChannel:launchOptions]; //!<添加基本配置必须
    [BPush setDelegate:self];           //!<设置代理必须
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID intValue] <= 0) {
        
        [BPush setTag:@"-1"];
        
    }
    
    ///开始自登录
    NSString *localCount = [QSCoreDataManager getLoginCount];
    NSString *psw = [QSCoreDataManager getLoginPassword];
    if ([localCount length] > 0 && [psw length] >= 6) {
        
        [self autoLoginAction:localCount andPassword:psw];
        
    } else {
        
        ///进入应用即连接socket
        [QSSocketManager sendOnLineMessage];
        
        ///百度推送tag值
        if ([userID intValue] > 0) {
            
            NSString *useUserID = [NSString stringWithFormat:@"%@_",userID];
            [BPush delTag:APPLICATION_NSSTRING_SETTING(useUserID, @"-1")];
            [BPush setTag:@"-1"];
            
        }
    
        ///将登录状态信息改为非登录
        [QSCoreDataManager updateLoginStatus:NO andCallBack:^(BOOL flag) {
            
        }];
    
    }
    
    ///注册通知接收类型
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert |
                                                       UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
        
    } else {
        
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeAlert
         | UIRemoteNotificationTypeBadge
         | UIRemoteNotificationTypeSound];
        
    }
    
    ///设置友盟key
    [UMSocialData setAppKey:shareSDK_Key];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:Wechat_Key appSecret:appSecret_Key url:app_URL];
    
    ///注册被踢下线时的监听
    [QSSocketManager registSocketServerOffLineNotification:^(LOGIN_CHECK_ACTION_TYPE loginStatus, NSString *info) {
        
        if (lLoginCheckActionTypeOffLine == loginStatus) {
            
            NSString *tipsString = @"您已经下线";
            if ([info length] > 0) {
                
                tipsString = info;
                
            }
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(tipsString, 2.5f, ^(){
                
                ///重新创建主页
                if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                    
                    UINavigationController *rootView = (UINavigationController *)self.window.rootViewController;
                    [rootView popToRootViewControllerAnimated:YES];
                    
                }
                
                if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
                    
                    QSTabBarViewController *rootView = (QSTabBarViewController *)self.window.rootViewController;
                    UINavigationController *firstNavigationVC = (UINavigationController *)rootView.selectedViewController;
                    UIViewController *firstVC = (UIViewController *)[firstNavigationVC.viewControllers lastObject];
                    [firstVC.navigationController popToRootViewControllerAnimated:YES];
                    
                }
                
            })
            
        }
        
    }];
    
    ///通过子线程下载配置信息
    dispatch_async(self.appDelegateOperationQueue, ^{
        
        ///HUD
        __block QSCustomHUDView *hud;
        
        ///第一次运行时，下载城市信息
        BOOL isFirstLaunch = [QSCoreDataManager getApplicationIsFirstLaunchStatus];
        if (isFirstLaunch) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                ///显示HUD
                hud = [QSCustomHUDView showCustomHUDWithTips:@"爷爷...爷爷，我正在努力加载基础数据中……" andHeaderTips:@"准备下载配置信息"];
                
            });
            
            [self downloadApplicationCityInfo];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [hud hiddenCustomHUD];
                
            });
            
        }
        
        ///下载配置信息
        [self downloadApplicationBasInfo];
        
    });
    
    ///获取当前用户经纬度
    [QSMapManager getUserLocation:^(BOOL isLocationSuccess, double longitude, double latitude) {
        
        if (!isLocationSuccess) {
            
            NSLog(@"=====获取当前用户经纬度失败=====");
            return ;
            
        }
        
        NSLog(@"=====当前用户经度:%lf=====",longitude);
        NSLog(@"=====当前用户纬度:%lf=====",latitude);
        
    }];

    return YES;
    
}

#pragma mark - 开始登录
///开始登录
- (void)autoLoginAction:(NSString *)count andPassword:(NSString *)password
{
    
    ///参数
    NSDictionary *params = @{@"mobile" : count,
                             @"password" : password};
    
    __block NSString *oldUserID = [QSCoreDataManager getUserID];
    
    ///登录
    [QSRequestManager requestDataWithType:rRequestTypeLogin andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///登录成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///修改用户登录状态
            [QSCoreDataManager updateLoginStatus:YES andCallBack:^(BOOL flag) {
                
                [QSCoreDataManager saveLoginCount:count andCallBack:^(BOOL flag) {
                    
                    [QSCoreDataManager saveLoginPassword:password andCallBack:^(BOOL flag) {
                        
                        QSYLoginReturnData *tempModel = resultData;
                        QSUserDataModel *userModel = tempModel.userInfo;
                        
                        [QSCoreDataManager saveLoginUserData:userModel andCallBack:^(BOOL flag) {
                            
                            ///重新发送上线
                            [QSSocketManager sendOnLineMessage];
                            
                            ///重置推送tag
                            if ([oldUserID intValue] > 0) {
                                
                                NSString *oldUseUserID = [NSString stringWithFormat:@"%@_",oldUserID];
                                [BPush delTag:APPLICATION_NSSTRING_SETTING(oldUseUserID, @"-1")];
                                
                            }
                            NSString *userID = [NSString stringWithFormat:@"%@_",userModel.id_];
                            [BPush setTag:APPLICATION_NSSTRING_SETTING(userID, @"-1")];
                            
                            ///显示提示信息
                             APPLICATION_LOG_INFO(@"登录", @"成功")
                            
                            ///重置收藏和关注记录
                            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                
                                [QSLoginViewController loadIntentionCommunityDataToServer];
                                
                            });
                            
                        }];
                        
                    }];
                    
                }];
                
            }];
            
        } else {
            
            NSString *tips = @"登录失败，请稍后再试";
            if (resultData) {
                
                tips = [resultData valueForKey:@"info"];
                
            }
            
            ///设置推送tag
            if ([oldUserID intValue] <= 0) {
                
                [BPush setTag:@"-1"];
                
            } else {
            
                NSString *useUserID = [NSString stringWithFormat:@"%@_",oldUserID];
                [BPush delTag:APPLICATION_NSSTRING_SETTING(useUserID, @"-1")];
                [BPush setTag:@"-1"];
            
            }
            
            ///打印提示信息
            APPLICATION_LOG_INFO(@"登录", tips)
            
            ///修改登录状态
            [QSCoreDataManager updateLoginStatus:NO andCallBack:^(BOOL flag) {
                
                [QSCoreDataManager saveLoginCount:@"" andCallBack:^(BOOL flag) {
                    
                    [QSCoreDataManager saveLoginPassword:@"" andCallBack:^(BOOL flag) {}];
                    
                }];
                
            }];
            
        }
        
    }];
    
}

#pragma mark - 请求城市信息
- (void)downloadApplicationCityInfo
{

    [QSRequestManager requestDataWithType:rRequestTypeAppBaseCityInfo andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///转换模型
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSCityInfoReturnData *headerModel = resultData;
            
            ///保存省份信息
            [QSCoreDataManager updateBaseConfigurationList:headerModel.cityInfoHeaderData.provinceList andKey:@"province"];
            
            ///保存城市信息
            for (QSProvinceDataModel *provinceModel in headerModel.cityInfoHeaderData.provinceList) {
                
                [QSCoreDataManager updateBaseConfigurationList:provinceModel.cityList andKey:[NSString stringWithFormat:@"city%@",provinceModel.key]];
                
            }
            
            ///更改应用进入状态
            [QSCoreDataManager updateApplicationIsFirstLaunchStatus:@"1"];
            
        }
        
    }];

}

#pragma mark - 请求应用配置信息
- (void)downloadApplicationBasInfo
{

    ///下载配置信息
    [QSRequestManager requestDataWithType:rRequestTypeAppBaseInfo andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///转换模型
        QSConfigurationReturnData *configModel = resultData;
        
        ///更新token信息
        [QSCoreDataManager updateApplicationCurrentToken:configModel.configurationHeaderData.t];
        [QSCoreDataManager updateApplicationCurrentTokenID:[NSString stringWithFormat:@"%@",configModel.configurationHeaderData.t_id]];
        
        ///更新版本信息
        [QSCoreDataManager updateApplicationCurrentVersion:[NSString stringWithFormat:@"%@",configModel.configurationHeaderData.version]];
        
        ///配置信息检测
        [self checkConfigurationInfo:configModel.configurationHeaderData.configurationList];
        
    }];
    
}

///检测基本信息的版本：本操作要求处于子线程中，不允许在主线程里操作
- (void)checkConfigurationInfo:(NSArray *)configurationList
{
    
    ///暂时保存配置版本信息
    NSArray *tempConfigurationArray = [NSArray arrayWithArray:configurationList];
    
    ///获取本地配置版本数组
    NSArray *localConfigurationArray = [QSCoreDataManager getConfigurationList];
    
    ///判断本地配置版本信息
    if ((nil == localConfigurationArray) || (0 >= [localConfigurationArray count])) {
        
        ///本地暂无基本信息，则全部更新
        for (QSConfigurationDataModel *obj in tempConfigurationArray) {
            
            [self updateConfigurationInfoWithModel:obj];
            
        }
        
        return;
        
    }
    
    ///将两个数组转化为字典
    NSDictionary *newConfigurationDictionary = [self changeArrayToDictionary:tempConfigurationArray];
    NSDictionary *localConfigurationDictionary = [self changeArrayToDictionary:localConfigurationArray];
    
    ///检测本地版本和最新版本是否一致
    for (NSString *newKey in newConfigurationDictionary) {
        
        ///新的配置模型
        QSConfigurationDataModel *newConfDataModel = [newConfigurationDictionary valueForKey:newKey];
        
        ///本地配置模型
        QSConfigurationDataModel *localConfDataModel = [localConfigurationDictionary valueForKey:newKey];
        
        ///如果原来没有，则添加
        if (nil == localConfDataModel) {
            
            ///版本不致，则更新对应的配置信息
            [self updateConfigurationInfoWithModel:newConfDataModel];
            
        } else {
        
            ///检测版本
            if (([newConfDataModel.conf isEqualToString:localConfDataModel.conf]) &&
                (!([newConfDataModel.c_v isEqualToString:localConfDataModel.c_v]))) {
                
                ///版本不致，则更新对应的配置信息
                [self updateConfigurationInfoWithModel:newConfDataModel];
                
            }
        
        }
        
    }

}

///将数组转化为字典，方便进行数组内的对象进行比效
- (NSDictionary *)changeArrayToDictionary:(NSArray *)array
{
    
    ///临时字典
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    ///遍历转换
    for (QSConfigurationDataModel *obj in array) {
        
        [tempDict setObject:obj forKey:obj.conf];
        
    }
    
    return [NSDictionary dictionaryWithDictionary:tempDict];

}

#pragma mark - 下载配置信息
- (void)updateConfigurationInfoWithModel:(QSConfigurationDataModel *)confModel
{

    ///在子线程中执行网络请求
    dispatch_sync(self.appDelegateOperationQueue, ^{
        
        [QSRequestManager requestDataWithType:rRequestTypeAppBaseInfoConfiguration andParams:confModel.getBaseConfigurationRequestParams andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///判断是否请求成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                ///模型转换
                QSBaseConfigurationReturnData *dataModel = resultData;
                
                ///保存配置信息
                [QSCoreDataManager updateConfigurationWithModel:confModel];
                
                ///将对应的版本信息插入配置库中
                [QSCoreDataManager updateBaseConfigurationList:dataModel.baseConfigurationHeaderData.baseConfigurationList andKey:confModel.conf];
                
            } else {
            
                NSLog(@"==================请求配置信息失败=======================");
                NSLog(@"当前配置信息项为：conf : %@,error : %@",confModel.conf,errorInfo);
                NSLog(@"==================请求配置信息失败=======================");
            
            }
            
        }];
        
    });

}

#pragma mark - 应用退出前保存数据
- (void)applicationWillTerminate:(UIApplication *)application
{
    
    ///应用退出前进行保存动作
    [self saveContextWithWait:YES];
    
    ///保存离线消息
    [QSSocketManager saveMemoryMessage];
    
    ///退出登录状态
    [QSRequestManager requestDataWithType:rRequestTypeLogout andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        [QSCoreDataManager updateUnirecordFieldWithKey:@"QSCDUserDataModel" andUpdateField:@"is_login" andFieldNewValue:@"0"];
        
    }];
    
}

///AppDelegate中saveContext方法，每次privateContext调用save方法成功之后都要call这个方法
- (void)saveContextWithWait:(BOOL)needWait
{
    
    ///中间管理器
    __block NSManagedObjectContext *mainSaveObjectContext = [self mainObjectContext];
    
    if (nil == mainSaveObjectContext) {
        
        return;
    
    }
    
    ///如果主管理器已有改变，则保存
    if ([mainSaveObjectContext hasChanges]) {
        
        NSLog(@"====================CoreData开始暂存数据====================");
        
        [mainSaveObjectContext performBlockAndWait:^{
            
            NSError *error = nil;
            if (![mainSaveObjectContext save:&error]) {
                
                NSLog(@"====================CoreData暂存数据失败====================");
                NSLog(@"Save main context failed and error is %@", error);
                NSLog(@"====================CoreData暂存数据失败====================");
            
            } else {
            
                NSLog(@"====================CoreData暂存数据成功====================");
            
            }
        
        }];
    
    }
    
    ///根管理器
    __block NSManagedObjectContext *rootSaveObjectContext = [self managedObjectContext];
    
    ///判断根CoreData上下文管理器
    if (nil == rootSaveObjectContext) {
        
        return;
    
    }
    
    if ([rootSaveObjectContext hasChanges]) {
        
        NSLog(@"====================CoreData真正开始保存数据====================");
        
        if (needWait) {
            
            [rootSaveObjectContext performBlockAndWait:^{
                
                NSError *error = nil;
                if (![rootSaveObjectContext save:&error]) {
                    
                    NSLog(@"======================CoreData数据更新失败========================");
                    NSLog(@"Save root context failed and error is %@", error);
                    NSLog(@"======================CoreData数据更新失败========================");
                    
                } else {
                    
                    NSLog(@"======================CoreData数据更新成功========================");
                    
                }
                
            }];
            
        } else {
            
            [rootSaveObjectContext performBlock:^{
                
                NSError *error = nil;
                if (![rootSaveObjectContext save:&error]) {
                    
                    NSLog(@"======================CoreData数据更新失败========================");
                    NSLog(@"Save root context failed and error is %@", error);
                    NSLog(@"======================CoreData数据更新失败========================");
                    
                } else {
                
                    NSLog(@"======================CoreData数据更新成功========================");
                
                }
                
            }];
            
        }
        
    }

}

#pragma mark - 百度推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{

    NSLog(@"通知注册失败：%@",error);

}

///必须，如果正确调用了setDelegate，在bindChannel之后，结果在这个回调中返回。
///若绑定失败，请进行重新绑定，确保至少绑定成功一次
- (void) onMethod:(NSString *)method response:(NSDictionary *)data
{
    
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        
        APPLICATION_LOG_INFO(@"百度推送代理回调日志", data)
        
#if 0
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
#endif
        
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [BPush handleNotification:userInfo];
    
}

///应用进入后台时，启动本地通知
- (void)applicationWillEnterForeground:(UIApplication *)application
{

    [[NSUserDefaults standardUserDefaults] setObject:@"2000" forKey:@"is_recieve_push"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

///应用进入前台时，关闭本地通知
- (void)applicationWillResignActive:(UIApplication *)application
{

    [[NSUserDefaults standardUserDefaults] setObject:@"1000" forKey:@"is_recieve_push"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

#pragma mark - CoreData相关操作

///返回CoreData操作的根上下文
- (NSManagedObjectContext *)managedObjectContext
{
    
    if (_managedObjectContext != nil) {
        
        return _managedObjectContext;
        
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        
    }
    
    return _managedObjectContext;
    
}

///返回CoreData操作的main上下文
- (NSManagedObjectContext *)mainObjectContext
{

    if (_mainObjectContext != nil) {
        
        return _mainObjectContext;
        
    }
    
    _mainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainObjectContext.parentContext = [self managedObjectContext];
    
    return _mainObjectContext;

}

///返回CoreData数据管理模型
- (NSManagedObjectModel *)managedObjectModel
{
    
    if (_managedObjectModel != nil) {
        
        return _managedObjectModel;
        
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"House" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
    
}

///返回CoreData操作的NSPersistentStoreCoordinator
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (_persistentStoreCoordinator != nil) {
        
        return _persistentStoreCoordinator;
        
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"House.sqlite"];
    
    NSLog(@"=======================================");
    NSLog(@"CoreData储值路径：%@",storeURL);
    NSLog(@"=======================================");
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        ///在这里添加CoreData错误处理代理
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        
    }    
    
    return _persistentStoreCoordinator;
    
}

#pragma mark - 获取应用沙盒目录
///获取应用沙盒目录
- (NSURL *)applicationDocumentsDirectory
{
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
}

#pragma mark - 分享系统回调
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    
//    return  [UMSocialSnsService handleOpenURL:url];
//    
//}
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    
//    return  [UMSocialSnsService handleOpenURL:url];
//    
//}


@end
