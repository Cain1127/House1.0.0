//
//  QSYAppDelegate.m
//  House
//
//  Created by ysmeng on 15/1/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAppDelegate.h"
#import "QSRequestManager.h"
#import "QSAdvertViewController.h"
#import "QSConfigurationReturnData.h"
#import "QSBaseConfigurationReturnData.h"
#import "QSCoreDataManager+App.h"
#import "QSAlertMessageViewController.h"
#import "QSMapManager.h"
#import "QSCityInfoReturnData.h"
#import "QSCustomHUDView.h"

@interface QSYAppDelegate ()

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
    
    ///非主线程任务操作线程初始化
    self.appDelegateOperationQueue = dispatch_queue_create(QUEUE_REQUEST_OPERATION, DISPATCH_QUEUE_CONCURRENT);
    
    ///显示广告页
    QSAdvertViewController *advertVC = [[QSAdvertViewController alloc] init];
    self.window.rootViewController = advertVC;
    
    ///开始定位用户当前位置
    [QSMapManager getUserLocation];
    
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
    
    return YES;
    
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

//返回CoreData操作的NSPersistentStoreCoordinator
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

@end
