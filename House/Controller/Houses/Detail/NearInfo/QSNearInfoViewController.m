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

static char TitleButtonKey;  ///导航按钮关联

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
@property(nonatomic,assign) CGFloat coordinate_x;       //!<经度
@property(nonatomic,assign) CGFloat coordinate_y;       //!<纬度

@property(nonatomic,strong) QSScrollView *mapInfoView;  //!<地图UI
@property(nonatomic,strong) UITextView *infoTextView;   //!<底部说明信息UI

@property(nonatomic,copy) NSMutableString *resultNameString;
@property(nonatomic,copy) NSMutableString *resultAddressString;


@end

@implementation QSNearInfoViewController

-(instancetype)initWithAddress:(NSString *)address andCoordinate_x:(NSString *)coordinate_x andCoordinate_y:(NSString *)coordinate_y
{
    
    if (self = [super init]) {
        
        self.address=address;
        self.coordinate_x=[coordinate_x floatValue];
        self.coordinate_y=[coordinate_y floatValue];
        
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
    
    ///总的户型信息个数
    int sum=7;
    
    ///循环创建户型信息
    for (int i = 0; i < sum; i++) {
        
        ///获取模型
        ///底图
        UIImageView *sixFormImage = [QSImageView createBlockImageViewWithFrame:CGRectMake((i+1)*gap + i*width, 5.0f, width, 40.0f) andSingleTapCallBack:^{
            
        }];
        sixFormImage.backgroundColor=[UIColor whiteColor];
        [view addSubview:sixFormImage];
        
        QSBlockButtonStyleModel *buttonStyle=[[QSBlockButtonStyleModel alloc] init];
        
        switch (i) {
            case 0:
                buttonStyle.imagesNormal=IMAGE_HOUSES_DETAIL_BUS_NORMAL;
                buttonStyle.imagesHighted=IMAGE_HOUSES_DETAIL_BUS_HIGHLIGHTED;
                
                break;
                
            case 1:
                buttonStyle.imagesNormal=IMAGE_HOUSES_DETAIL_METRO_NORMAL;
                buttonStyle.imagesHighted=IMAGE_HOUSES_DETAIL_METRO_NORMAL;
                
                break;
                
            case 2:
                buttonStyle.imagesNormal=IMAGE_HOUSES_DETAIL_HOSPITAL_NORMAL;
                buttonStyle.imagesHighted=IMAGE_HOUSES_DETAIL_HOSPITAL_HIGHLIGHTED;
                
                break;
                
            case 3:
                
                buttonStyle.imagesNormal=IMAGE_HOUSES_DETAIL_SCHOOL_NORMAL;
                buttonStyle.imagesHighted=IMAGE_HOUSES_DETAIL_SCHOOL_HIGHLIGHTED;
                
                break;
                
            case 4:
                buttonStyle.imagesNormal=IMAGE_HOUSES_DETAIL_CATERING_NORMAL;
                buttonStyle.imagesHighted=IMAGE_HOUSES_DETAIL_CATERING_HIGHLIGHTED;
                break;
                
            case 5:
                buttonStyle.imagesNormal=IMAGE_HOUSES_DETAIL_BUS_NORMAL;
                
                break;
                
            case 6:
                buttonStyle.imagesNormal=IMAGE_HOUSES_DETAIL_BUS_NORMAL;
                
                break;
                
            default:
                break;
        }
        
        
        ///主标题信息
        UIButton *titleButton = [QSBlockButton createBlockButtonWithFrame:CGRectMake(2.0f, 5.0f, sixFormImage.frame.size.width , 30.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            NSLog(@"点击事件");
            
            switch (i) {
                case 0:
                    [self searchAction:@"公交"];
                    _infoTextView.text=self.resultAddressString;
                    
                    
                    break;
                    
                case 1:
                    [self searchAction:@"地铁"];
                    
                    _infoTextView.text=self.resultAddressString;

                    break;
                    
                case 2:
                    [self searchAction:@"医院"];
                    _infoTextView.text=self.resultNameString;

                    
                    break;
                    
                case 3:
                    
                    [self searchAction:@"学校"];
                    _infoTextView.text=self.resultNameString;

                    
                    break;
                    
                case 4:
                    [self searchAction:@"餐饮"];
                    _infoTextView.text=self.resultNameString;

                    break;
                    
                case 5:
                    
                    [self searchAction:@"超市"];
                    _infoTextView.text=self.resultNameString;

                    
                    break;
                    
                case 6:
                    
                    [self searchAction:@"商场"];
                    _infoTextView.text=self.resultNameString;

                    
                    break;
                    
                default:
                    break;
            }
            
            //view.contentOffset = CGPointMake(view.frame.size.width * i, 0.0f);
            
            sixFormImage.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_HOUSETYPE_SIXFORM];
            
            //            ///移动UI
            //            [UIView animateWithDuration:0.3f animations:^{
            //
            //                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            //
            //
            //            } completion:^(BOOL finished) {
            //
            //                view.frame=CGRectMake(view.frame.size.width*i, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            //
            //            }];
            
        }];
        
        
        [sixFormImage addSubview:titleButton];
        
    }
    
    ///判断是否需要开启滚动
    if ((width * sum + gap * (sum - 1)) > view.frame.size.width) {
        
        view.contentSize = CGSizeMake((width * sum + gap * (sum + 1)) + 10.0f, view.frame.size.height);
        
    }
    
}

#pragma mark -添加地图信息UI
///添加地图信息
-(void)createMapInfoUI
{
    
    [self initAttributes];
    [self initMapView];
    
    self.infoTextView=[[UITextView alloc] initWithFrame:CGRectMake(25.0f, _mapView.frame.origin.y+_mapView.frame.size.height+10.0f, SIZE_DEVICE_WIDTH-50.0f, 100.0f)];
    
    [_mapInfoView addSubview:self.infoTextView];
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
    
    [self.mapInfoView addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;

    [self reGeoAction];
    
    
}

///获取房子位置
- (void)reGeoAction
{
    if (self.coordinate_x)
    {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        
        request.location = [AMapGeoPoint locationWithLatitude:self.coordinate_x longitude:self.coordinate_y];
        
        [_search AMapReGoecodeSearch:request];
    }
}


///搜索周边信息
- (void)initSearch
{
    
    _search = [[AMapSearchAPI alloc] initWithSearchKey:APIKey Delegate:self];
    
}

- (void)searchAction:(NSString *)keywords
{
    if (!self.coordinate_x || _search == nil)
    {
        NSLog(@"search failed");
        return;
    }
    
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType = AMapSearchType_PlaceAround;
    request.location = [AMapGeoPoint locationWithLatitude:self.coordinate_x longitude:self.coordinate_y];
    
    request.keywords = keywords;
    
    [_search AMapPlaceSearch:request];
    
}

#pragma mark - 地图搜索代理方法回调

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    ///搜索失败提示
    NSLog(@"request :%@, error :%@", request, error);
}

///房子位置搜索信息回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"response :%@", response);
    
    NSString *title = response.regeocode.addressComponent.city;
    if (title.length == 0)
    {
        // 直辖市的city为空，取province
        title = response.regeocode.addressComponent.province;
    }
    
    // 更新我的位置title
    _mapView.userLocation.title = title;
    _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    
}

///房子周边信息回调
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    
    NSLog(@"request: %@", request);
    NSLog(@"response: %@", response);
    
    if (response.pois.count > 0)
    {
        
        _pois = [NSArray arrayWithArray:response.pois];
        
        NSMutableString *resultNameString = [[NSMutableString alloc] init];
        NSMutableString *resultAddressString = [[NSMutableString alloc] init];
        
        for (int i = 0; i < response.pois.count;i++) {
            
            AMapPOI *poi = _pois[i];
            
            [resultNameString appendString:poi.name];
            [resultAddressString appendString:poi.address];
            
        }
        
        self.resultNameString=resultNameString;
        self.resultAddressString=resultAddressString;
        

        // 清空标注
        [_mapView removeAnnotations:_annotations];
        [_annotations removeAllObjects];
        
    }
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
