//
//  QSAdvertViewController.m
//  House
//
//  Created by ysmeng on 15/1/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAdvertViewController.h"
#import "QSCoreDataManager+Advert.h"
#import "QSCoreDataManager+Guide.h"
#import "QSAutoScrollView.h"
#import "QSTabBarViewController.h"
#import "QSYAppDelegate.h"
#import "QSGuideViewController.h"
#import "QSAdvertReturnData.h"
#import "NSDate+Formatter.h"

@interface QSAdvertViewController ()<QSAutoScrollViewDelegate>

@property (nonatomic,assign) BOOL isShowAdvert;             //!<是否显示广告栏的标记：YES-显示,NO-不显示
@property (nonatomic,assign) GUIDE_STATUS isShowGuideIndex; //!<是否显示指引页标记：YES-显示,NO-不显示

@property (nonatomic,retain) NSMutableArray *advertsDataSource;//!<广告数组

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
    rightInfoLabel.text = APPLICATION_RIGHT_INFO;
    rightInfoLabel.textColor = COLOR_CHARACTERS_NORMAL;
    rightInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    rightInfoLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:rightInfoLabel];
    
    ///如果是第一次运行，直接显示指引页，暂不显示广告页
    if (gGuideStatusNoRecord == self.isShowGuideIndex) {
        
        [self gotoGuideIndexViewController];
        return;
        
    }
    
    ///获取上次显示时间戳
    NSString *lastAdvertShowTime = [QSCoreDataManager getAdvertLastShowTime];
    
    ///判断是否有时间戳
    if (lastAdvertShowTime) {
                
        ///获取时间差
        NSTimeInterval advertTimeInterval = [[NSDate date] timeIntervalSinceDate:[NSDate timeStampStringToNSDate:lastAdvertShowTime]];
        
        ///判断是否超过一小时
        if (advertTimeInterval > (60.0f * 60.0f)) {
            
            ///再次显示广告
            [self prepareShowAdvert];
            
        } else {
        
            ///不显示广告
            [self nextStepFilter];
        
        }
        
    } else {
    
        ///如若本地没有写入广告最后显示时间，则必须进行广告请求
        [self prepareShowAdvert];
    
    }
    
}

#pragma mark - 显示广告
- (void)prepareShowAdvert
{

    ///开始请求数据
    [QSRequestManager requestDataWithType:rRequestTypeAdvert andCallBack:^void(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求结果过滤
        switch (resultStatus) {
                
                ///请求成功
            case rRequestResultTypeSuccess:
                
                [self handleRequestResult:resultData];
                
                ///更新广告最后显示时间戳
                [QSCoreDataManager updateAdvertLastShowTime:[NSDate currentDateTimeStamp]];
                
                break;
                
                ///服务端返回false
            case rRequestResultTypeFail:
                
                ///服务端响应失败，进行下一页面显示
                [self nextStepFilter];
                
                break;
                
                ///数据解析失败
            case rRequestResultTypeDataAnalyzeFail:
                
                ///当前无可用网络
            case rRequestResultTypeNoNetworking:
                
                ///网络不稳定
            case rRequestResultTypeBadNetworking:
            {
                
                ///查找本地是否有缓存广告，有则显示，无则跳过
                QSAdvertReturnData *adverReturnData = (QSAdvertReturnData *)[QSAdvertReturnData getModelDataFromCoreData];
                
                if (nil == adverReturnData) {
                    
                    [self nextStepFilter];
                    
                } else {
                
                    [self handleRequestResult:adverReturnData];
                    
                    ///更新广告最后显示时间戳
                    [QSCoreDataManager updateAdvertLastShowTime:[NSDate currentDateTimeStamp]];
                
                }
                
            }
                break;
                
            default:
                break;
        }
        
    }];

}

#pragma mark - 进入指引页
- (void)gotoGuideIndexViewController
{

    QSGuideViewController *guideView = [[QSGuideViewController alloc] init];
    ///加载到rootViewController上
    QSYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = guideView;
    
    ///修改指引状态
    [QSCoreDataManager updateAppGuideIndexStatus:gGuideStatusUnneedDisplay];

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

#pragma mark - 处理返回的请求结果
- (void)handleRequestResult:(id)resultData
{

    ///转换模型
    QSAdvertReturnData *advertReturnData = resultData;
    
    ///将数据本地化
    [advertReturnData saveModelDataIntoCoreData];
    
    ///保存广告页数组
    self.advertsDataSource = nil;
    self.advertsDataSource = [[NSMutableArray alloc] initWithArray:advertReturnData.advertHeaderData.advertsArray];
    
    ///每页广告的显示时间
    CGFloat showTime = [advertReturnData.advertHeaderData.time floatValue] / [self.advertsDataSource count];
    
    ///是否显示页码控制器
    BOOL isAutoScroll = [self.advertsDataSource count] > 1;
    
    QSAutoScrollView *autoScrollView = [[QSAutoScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) andDelegate:self andScrollDirectionType:aAutoScrollDirectionTypeRightToLeft andShowPageIndex:isAutoScroll andShowTime:showTime andTapCallBack:^(id params) {
        
        ///如果回调的参数有效，跳转链接
        if (params) {
            
            [[UIApplication sharedApplication] openURL:params];
            
        }
        
    }];
    
    [self.view addSubview:autoScrollView];
    
    ///广告总时长后进入主页
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(([advertReturnData.advertHeaderData.time floatValue] + 1.0f) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self nextStepFilter];
        
    });

}

#pragma mark - 判断是否进入指引页，或者直接进入主页面
- (void)nextStepFilter
{

    ///判断是否需要显示指引页
    if (gGuideStatusNeedDispay == self.isShowGuideIndex) {
        
        [self gotoGuideIndexViewController];
        
    } else {
        
        ///进入主功能页
        [self gotoAppMainViewController];
        
    }

}

#pragma mark - 广告总页数
- (int)numberOfScrollPage:(QSAutoScrollView *)autoScrollView
{

    return (int)[self.advertsDataSource count];

}

#pragma mark - 返回指定下标的广告页
- (UIView *)autoScrollViewShowView:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{

    ///广告页的自定义view
    QSImageView *advertView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    
    ///广告数据模型
    QSAdvertInfoDataModel *model = self.advertsDataSource[index];
    
    ///加载图片
    [advertView loadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",URLFDangJiaImageIPHome,model.img]] placeholderImage:nil];
    
    return advertView;

}

#pragma mark - 单击广告页时的回调参数
- (id)autoScrollViewTapCallBackParams:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{

    ///广告数据模型
    QSAdvertInfoDataModel *model = self.advertsDataSource[index];
    return model.url;

}

@end
