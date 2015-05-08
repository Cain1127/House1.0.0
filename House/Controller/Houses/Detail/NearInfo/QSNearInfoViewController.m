//
//  QSNearInfoViewController.m
//  House
//
//  Created by 王树朋 on 15/4/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSNearInfoViewController.h"

#import "QSScrollView.h"

#import "QSImageView+Block.h"
#import "UIImageView+CacheImage.h"
#import "NSString+Calculation.h"
#import "URLHeader.h"
#import "QSBlockButton.h"
#import "QSBlockButtonStyleModel.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#import "MJRefresh.h"
#import <objc/runtime.h>


#define APIKey      @"0f36774bd285a275b3b8e496e45fe6d9"

#define kDefaultLocationZoomLevel       16.1
#define kDefaultControlMargin           22
#define kDefaultCalloutViewMargin       -8

@interface QSNearInfoViewController ()<MAMapViewDelegate, AMapSearchDelegate>

{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    
    CLLocation *_currentLocation;
    
    NSArray *_pois;
    
    NSMutableArray *_annotations;
}

@property(nonatomic,copy) NSString *address;            //!<周边信息地址
@property(nonatomic,assign) double coordinate_x;       //!<周边经度
@property(nonatomic,assign) double coordinate_y;       //!<周边纬度

@property(nonatomic,strong) QSScrollView *mapInfoView;  //!<地图UI
@property(nonatomic,strong) UITextView *infoTextView;   //!<底部说明信息UI
@property(nonatomic,assign) MAP_DETAIL_BUTTON_ACTION_TYPE mapLineType;

@property(nonatomic,copy) NSMutableString *resultNameString;
@property(nonatomic,copy) NSMutableString *resultAddressString;

@property(nonatomic,strong) MAPointAnnotation *annotation0;


@end

@implementation QSNearInfoViewController

-(instancetype)initWithAddress:(NSString *)address  andTitle:(NSString *)title andCoordinate_x:(NSString *)coordinate_x andCoordinate_y:(NSString *)coordinate_y
{
    
    if (self = [super init]) {
        
        self.address=address;
        self.coordinate_x=[coordinate_x doubleValue];
        self.coordinate_y=[coordinate_y doubleValue];
        self.title=title;
    }
    
    return self;
}

-(void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"周边信息"];
    
}

-(void)createMainShowUI
{
    
    QSScrollView *topView=[[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 50.0f)];
    [self.view addSubview:topView];
    [self createNearInfoUI:topView];
    
    self.mapInfoView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f,topView.frame.origin.y+topView.frame.size.height, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-64.0f-50.0f)];
    [self.view addSubview:self.mapInfoView];
    
    [self.mapInfoView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getMapInfo)];
    [self.mapInfoView.header beginRefreshing];
    
}

#pragma mark -添加顶部导航类型UI
///添加户型UI
-(void)createNearInfoUI:(QSScrollView *)view
{
    
    ///每个控件的宽度
    CGFloat width = 35.0f;
    ///每个户型信息项之间的间隙
    CGFloat gap = 40.0f;
    
    ///获取配置信息
    NSString *path = [[NSBundle mainBundle] pathForResource:PLIST_FILE_NAME_HOUSEDETAIL_AROUND_CHANNELBAR ofType:PLIST_FILE_TYPE];
    NSArray *packInfos = [[NSDictionary dictionaryWithContentsOfFile:path] valueForKey:@"around_channelbar"];
    
    ///底图
    __block UIImageView *sixFormImage = [[UIImageView alloc] initWithFrame:CGRectMake(gap, 5.0f, width, 40.0f)];
    sixFormImage.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_HOUSETYPE_SIXFORM];
    [view addSubview:sixFormImage];
    
    ///循环创建户型信息
    for (int i = 0; i < [packInfos count]; i++) {
        
        ///配置字典
        NSDictionary *infoDict = packInfos[i];
        
        QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
        buttonStyle.imagesNormal = [infoDict valueForKey:@"normal"];
        buttonStyle.imagesSelected = [infoDict valueForKey:@"selected"];
        
        ///主标题信息
        UIButton *titleButton = [QSBlockButton createBlockButtonWithFrame:CGRectMake(gap + (width + gap) * i-4.5f, 5.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            ///如果当前按钮已是选择状态，则不进行事件
            if (button.selected) {
                
                return;
                
            }
            
            ///更换类型
            self.mapLineType = i +101;
            
            ///刷新数据
            [self searchAction:[infoDict valueForKey:@"keywords"]];
            
            ///移动六角形
            [UIView animateWithDuration:0.3f animations:^{
                
                sixFormImage.frame = CGRectMake(gap + (width + gap) * i, sixFormImage.frame.origin.y, sixFormImage.frame.size.width, sixFormImage.frame.size.height);
                
            }];
            
        }];
        
        [titleButton addTarget:self action:@selector(changeChannelBarButtonStatus:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:titleButton];
        
    }
    
    ///判断是否需要开启滚动
    if ((width * [packInfos count] + gap * ([packInfos count] + 1)) > view.frame.size.width) {
        
        view.contentSize = CGSizeMake((width * [packInfos count] + gap * ([packInfos count] + 1)) + 10.0f, view.frame.size.height);
        
    }
    
}

#pragma mark - 同步修改按钮状态
- (void)changeChannelBarButtonStatus:(UIButton *)button
{
    
    for (UIView *obj in [button.superview subviews]) {
        
        if ([obj isKindOfClass:[UIButton class]]) {
            
            UIButton *tempButton = (UIButton *)obj;
            tempButton.selected = NO;
            
        }
        
    }
    
    button.selected = YES;
    
}

#pragma mark -添加地图信息UI
///添加地图信息
-(void)createMapInfoUI
{
    
    [self initAttributes];
    [self initMapView];
    
    self.infoTextView=[[UITextView alloc] initWithFrame:CGRectMake(25.0f, _mapView.frame.origin.y+_mapView.frame.size.height+10.0f, SIZE_DEVICE_WIDTH-50.0f, 100.0f)];
    
    [_mapInfoView addSubview:self.infoTextView];
    self.infoTextView.font = [UIFont systemFontOfSize:14.0f];
    _mapInfoView.contentSize = CGSizeMake(SIZE_DEVICE_WIDTH, _infoTextView.frame.size.height+_mapView.frame.size.height+10.0f);
    
    [self initSearch];
    
}

- (void)initAttributes
{
    _annotations = [NSMutableArray array];
    _pois = [[NSArray alloc] init];
}

- (void)initMapView
{
    
    [MAMapServices sharedServices].apiKey = APIKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-50.0f-64.0f-76.0f)];
    
    _mapView.delegate = self;
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, kDefaultControlMargin);
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, kDefaultControlMargin);
    [_mapView setZoomLevel:kDefaultLocationZoomLevel animated:YES];
    
    [self.mapInfoView addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;
    
    //[self houseAddressAction];
    
    
}

///添加房子位置大头针
- (void)houseAddressAction
{
    if (self.coordinate_x)
    {
        ///获取房子的大头针位置
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(self.coordinate_y, self.coordinate_x);
        
        ///大头针加入地图
        [_mapView addAnnotation:annotation];
        [_annotations addObject:annotation];
        
    }
}


///搜索周边信息
- (void)initSearch
{
    
    _search = [[AMapSearchAPI alloc] initWithSearchKey:APIKey Delegate:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///默认选中第一个
        [self searchAction:@"公交"];
        
    });
    
    
}

- (void)searchAction:(NSString *)keywords
{
    
    if (!self.coordinate_x || _search == nil)
    {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"无法找到该地名", 1.0f, ^(){})
        return;
        
    }
    
    ///清空标注
    if ([_mapView.overlays count] > 0) {
        
        [_mapView removeOverlays:_mapView.overlays];
        
    }
    
    if ([_mapView.annotations count] > 0) {
        
        [_mapView removeAnnotations:_mapView.annotations];
        
    }
    [_annotations removeAllObjects];
    
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType = AMapSearchType_PlaceAround;
    request.location = [AMapGeoPoint locationWithLatitude:self.coordinate_y longitude:self.coordinate_x];
    
    request.keywords = keywords;
    request.radius = 1000;
    
    [_search AMapPlaceSearch:request];
    
}

#pragma mark - 地图搜索代理方法回调

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    ///搜索失败提示
    APPLICATION_LOG_INFO(request, error);
    TIPS_ALERT_MESSAGE_ANDTURNBACK(@"搜索失败", 1.0f, ^(){})
    
}

///房子周边信息回调
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    
    if (response.pois.count > 0)
    {
        
        _pois = [NSArray arrayWithArray:response.pois];
        
        NSMutableString *resultNameString = [[NSMutableString alloc] init];
        NSMutableString *resultAddressString = [[NSMutableString alloc] init];
        
        for (int i = 0; i < response.pois.count;i++) {
            
            AMapPOI *poi = _pois[i];
            
            ///获取返回的大头针位置
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            annotation.title = poi.name;
            annotation.subtitle = poi.address;
            
            ///大头针加入地图
            [_mapView addAnnotation:annotation];
            [_annotations addObject:annotation];
            
            ///拼接搜索反回结果
            [resultNameString appendString:poi.name];
            [resultAddressString appendString:poi.address];
            
        }

        ///小区所在地的大头针
        self.resultNameString = resultNameString;
        self.resultAddressString = resultAddressString;
        
        if (self.mapLineType==mMapBusButtonActionType ||
            self.mapLineType==mMapMetroButtonActionType) {
            
            _infoTextView.text = self.resultAddressString;
            
        } else {
            
            _infoTextView.text = self.resultNameString;
            
        }

        ///获取房子的大头针位置
        _annotation0 = [[MAPointAnnotation alloc] init];
        _annotation0.coordinate = CLLocationCoordinate2DMake(self.coordinate_y, self.coordinate_x);
        _annotation0.title = self.title;
        
        ///大头针加入地图
        [_mapView addAnnotation:_annotation0];
        [_annotations addObject:_annotation0];
        
        [_mapView selectAnnotation:_annotation0 animated:YES];
        
        ///地图显示所有大头针
        [_mapView showAnnotations:_annotations animated:YES];
        
    }
    
}

#pragma mark - 地图代理方法

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        switch (self.mapLineType) {
                
            case mMapBusButtonActionType:
                ///显示大头针图片
                annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_BUS_ANNOTION];
                
                if (annotation==_annotation0) {
                    annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_ANNOTION];
                    
                }
                break;
                
            case mMapMetroButtonActionType:
                ///显示大头针图片
                annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_METRO_ANNOTION];
                if (annotation==_annotation0) {
                    annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_ANNOTION];
                    
                }
                break;
            case mMapHospitalButtonActionType:
                ///显示大头针图片
                annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_HOSPITAL_ANNOTION];
                
                if (annotation==_annotation0) {
                    annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_ANNOTION];
                    
                }
                break;
            case mMapSchoolButtonActionType:
                ///显示大头针图片
                annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_SCHOOL_ANNOTION];
                
                if (annotation==_annotation0) {
                    annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_ANNOTION];
                    
                }
                break;
            case mMapCateringButtonActionType:
                ///显示大头针图片
                annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_CATERING_ANNOTION];
                
                if (annotation==_annotation0) {
                    annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_ANNOTION];
                    
                }
                break;
            case mMapSuperMarketButtonActionType:
                ///显示大头针图片
                annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_SUPERMARKET_ANNOTION];
                
                if (annotation==_annotation0) {
                    annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_ANNOTION];
                    
                }
                break;
            case mMapMarketButtonActionType:
                ///显示大头针图片
                annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_MARKET_ANNOTION];
                
                if (annotation==_annotation0) {
                    annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_ANNOTION];
                    
                }
                break;
                
            default:
                
                break;
        }
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = YES;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        //annotationView.centerOffset = CGPointMake(0, -10);
        return annotationView;
    }
    
    return nil;
}


#pragma mark -获取地图信息结束刷新
-(void)getMapInfo
{
    
    [self createMapInfoUI];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_mapInfoView.header endRefreshing];
        
    });
    
}

@end
