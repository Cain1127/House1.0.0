//
//  QSAdvertViewController.m
//  House
//
//  Created by ysmeng on 15/1/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAdvertViewController.h"
#import "QSAutoScrollView.h"
#import "QSTabBarViewController.h"
#import "QSYAppDelegate.h"
#import "QSGuideViewController.h"
#import "QSAdvertReturnData.h"

@interface QSAdvertViewController ()<QSAutoScrollViewDelegate>

@property (nonatomic,assign) BOOL isShowAdvert;     //!<是否显示广告栏的标记：YES-显示,NO-不显示
@property (nonatomic,assign) BOOL isShowGuideIndex; //!<是否显示指引页标记：YES-显示,NO-不显示

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
    rightInfoLabel.text = @"Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.";
    rightInfoLabel.textColor = COLOR_CHARACTERS_NORMAL;
    rightInfoLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    rightInfoLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:rightInfoLabel];
    
    ///开始请求数据
    [QSRequestManager requestDataWithType:rRequestTypeAdvert andCallBack:^void(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求结果过滤
        switch (resultStatus) {
                
                ///请求成功
            case rRequestResultTypeSuccess:
                
                [self handleRequestResult:resultData];
                
                break;
                
                ///服务端返回false
            case rRequestResultTypeFail:
                
                ///服务端响应失败，进行下一页面显示
                [self nextStepFilter];
                
                break;
                
                ///数据解析失败
            case rRequestResultTypeDataAnalyzeFail:
                
                
                
                break;
                
                ///当前无可用网络
            case rRequestResultTypeNoNetworking:
                
                
                
                break;
                
                ///网络不稳定
            case rRequestResultTypeBadNetworking:
                
                
                
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
    if (self.isShowGuideIndex) {
        
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
