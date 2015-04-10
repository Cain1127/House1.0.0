//
//  QSManager.m
//  SunTry
//
//  Created by 王树朋 on 15/1/30.
//  Copyright (c) 2015年 7tonline. All rights reserved.
//

#import "QSMapManager.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface QSMapManager () <CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic,strong) CLLocationManager *locMgr; //!<定位服务管理器
@property (nonatomic,strong) CLGeocoder *geocoder; //!<地址编码管理器


@end

@implementation QSMapManager

///初始化定位服务
-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        //if(![CLLocationManager locationServicesEnabled]) return nil;

        // 创建定位管理者
        self.locMgr = [[CLLocationManager alloc] init];
        
        //
        // 设置代理
        self.locMgr.delegate=self;
        
        self.locMgr.desiredAccuracy=kCLLocationAccuracyBest;
        self.locMgr.distanceFilter=10000.0f;
        //启动位置更新
        [self.locMgr startUpdatingLocation];
        
        //__IPHONE_OS_VERSION_MAX_ALLOWED
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
            
            //使用期间
            [self.locMgr requestWhenInUseAuthorization];
            //始终
            //or [self.locationManage requestAlwaysAuthorization]
        }
        
    }
    return self;
}

///获取当前用户位置信息
- (void)getUserLocation:(void (^)(BOOL isLocalSuccess,NSString *placename))CallBack
{
    
    ///1.定位
    //QSMapManager *manager=[[QSMapManager alloc]init];
    
    ///定位当前用户经纬度
    [self startUserLocation:^(BOOL isLocalSuccess, double longitude, double latitude) {
        
        ///判断是否定位成功
        if (!isLocalSuccess) {
            
            NSLog(@"=================用户经纬度定位失败=====================");
            return;
            
        }
        
        //成功打印出经纬度
        NSLog(@"================获取用户经纬度成功====================");
        NSLog(@"用户经纬度：%.6f--%.6f",longitude,latitude);
        NSLog(@"===================================================");
        
        ///如果定位成功，则开始地址反地理编码
        //1.包装位置
        CLLocationDegrees latitud=latitude;
        CLLocationDegrees longitud=longitude;
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitud
                                                     longitude:longitud];
        //2.反地理编码
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        
        [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (error) {//有错误
                NSLog(@"========================================");
                NSLog(@"============无法获取当前用户位置===========");
                NSLog(@"========================================");
            }
            
            else{//编码成功
                
                //取出最前面的地址
                CLPlacemark *pm=[placemarks firstObject];
                
                ///设置成功时的回调
                self.userPlacenameCallBack(YES,pm.name);
                
                //获取具体地址
                NSLog(@"============当前用户地址名==============");
                NSLog(@"%@",pm.name);
                NSLog(@"======================================");
                
                
                //打印出所有的信息
                
                //            NSLog(@"总共找到%d个地址",placemarks.count);
                //            for (CLPlacemark *pm in placemarks) {
                //                NSLog(@"------地址开始-------");
                //                NSLog(@"%f %f %@",pm.location.coordinate.latitude, pm.location.coordinate.longitude, pm.name);
                //                [pm.addressDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                //                    NSLog(@"%@ %@",key,obj);
                //                }];
                //                NSLog(@"--------地址结束-------");
                //           }
                
            }
            
        }];
        
    }];
    if (CallBack) {
        self.userPlacenameCallBack=CallBack;
    }
    
}

#pragma mark -开启定位服务
-(void)startUserLocation:(void(^)(BOOL isLocalSuccess,double longitude,double latitude))callBack
{
    
    [self.locMgr startUpdatingLocation];
    
    if (callBack) {
        
        ///保存用户位置定位的回调
        self.userLoationCallBack=callBack;
    }
    
}

#pragma mark - CLLocationManagerDelegate
/*!
 *  @author wangshupeng, 15-01-30 18:01:29
 *
 *  @brief  只要定位到用户就会调用
 *
 *  @param manager   定位服务
 *  @param locations 用户坐标数组对象
 *
 *  @since 1.0
 */

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    if (self.userLoationCallBack) {
        
        // 1.取出位置对象
        CLLocation *loc = [locations firstObject];
        
        // 2.取出经纬度
        CLLocationCoordinate2D coordinate = loc.coordinate;
        
        //3.设置成功的回调
        self.userLoationCallBack(YES,coordinate.longitude,coordinate.latitude);
        
        // 3.打印经纬度
        NSLog(@"didUpdateLocations定位坐标代理方法回调成功------%f %f", coordinate.latitude, coordinate.longitude);
        
    }
    
    // 停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
    [manager stopUpdatingLocation];
}

#pragma mark - 定位代理（iOS8新增）
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locMgr respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [self.locMgr requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}

///**
// *  计算2个经纬度之间的直线距离
// */
//- (void)countLineDistance
//{
//    // 计算2个经纬度之间的直线距离
//    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:40 longitude:116];
//    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:41 longitude:116];
//    CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
//    NSLog(@"%f", distance);
//}
//

@end
