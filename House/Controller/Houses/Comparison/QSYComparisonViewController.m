//
//  QSYComparisonViewController.m
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYComparisonViewController.h"
#import "QSPOrderDetailBookedViewController.h"
#import "QSPOrderBookTimeViewController.h"

#import "QSCustomHUDView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "QSBlockButtonStyleModel+Normal.h"

#import "NSString+Calculation.h"
#import "NSDate+Formatter.h"

#import "QSCoreDataManager+Collected.h"
#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+House.h"

#import "QSRentHouseDetailDataModel.h"
#import "QSSecondHouseDetailDataModel.h"
#import "QSWSecondHouseInfoDataModel.h"
#import "QSWRentHouseInfoDataModel.h"

#import "MJRefresh.h"

@interface QSYComparisonViewController ()

@property (nonatomic,retain) NSMutableArray *houseOriginalList; //!<比一比的原始数据
@property (nonatomic,retain) NSMutableArray *houseList;         //!<比一比的UI可用数据
@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;        //!<房源类型
@property (nonatomic,strong) QSScrollView *infoRootView;        //!<信息底view

@end

@implementation QSYComparisonViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-19 23:03:35
 *
 *  @brief          创建比一比列表
 *
 *  @return         返回当前创建的比一比页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPickedHouseList:(NSArray *)houseList andHouseType:(FILTER_MAIN_TYPE)houseType
{

    if (self = [super init]) {
        
        ///保存参数
        self.houseType = houseType;
        self.houseList = [[NSMutableArray alloc] init];
        
        ///保存原始数据
        self.houseOriginalList = [[NSMutableArray alloc] initWithArray:houseList];
        
        ///计算并转换房源模型
        [self resetComparisonHouseList:houseList];
        
    }
    
    return self;

}

#pragma mark - 转换数据模型
- (void)resetComparisonHouseList:(NSArray *)originalList
{

    switch (self.houseType) {
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
        
            for (int i = 0; i < [originalList count]; i++) {
                
                [self.houseList addObject:[self comparisonChangeRentHouseModelToPrivaryModel:originalList[i]]];
                
            }
        
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
            
            for (int i = 0; i < [originalList count]; i++) {
                
                [self.houseList addObject:[self comparisonChangeSecondHandHouseModelToPrivaryModel:originalList[i]]];
                
            }
            
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"房源对比"];
    
    ///添加对比房源按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeAdd];
    
    UIButton *addCollectedButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///返回上一页
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [self setNavigationBarRightView:addCollectedButton];
    
}

- (void)createMainShowUI
{

    self.infoRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    [self.view addSubview:self.infoRootView];
    
    ///添加头部刷新
    [self.infoRootView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(createComparisonUI)];
    
    ///一开始就请求数据
    [self.infoRootView.header beginRefreshing];

}

#pragma mark - 比一比UI搭建
- (void)createComparisonUI
{

    ///获取数据个数
    NSInteger sumHouse = [self.houseList count];
    
    if (2 == sumHouse) {
        
        [self createTwoHouseComparisonUI];
        
    }
    
    if (3 == sumHouse) {
        
        [self createThreeHouseComparisonUI];
        
    }
    
    ///结束动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.infoRootView.header endRefreshing];
        
    });

}

///创建只有两个房源的比一比
- (void)createTwoHouseComparisonUI
{

    ///根据个数，计数UI的坐标和尺寸
    CGFloat widthBest = 111.0f * SIZE_DEVICE_WIDTH / 350.0f;
    CGFloat widthOther = SIZE_DEVICE_WIDTH -  SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 6.0f - widthBest;
    CGFloat xpointBest = 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat xpointOther = SIZE_DEVICE_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT - widthOther;
    
    ///推荐信息UI
    [self createRecommendHouseComparisonUIWithXPoint:xpointBest];
    [self createOtherHouseComparisonUIWithXPoint:xpointOther andWidth:widthOther andModel:self.houseList[1]];

}

///创建三个房源的比一比
- (void)createThreeHouseComparisonUI
{

    ///根据个数，计数UI的坐标和尺寸
    CGFloat widthBest = 111.0f * SIZE_DEVICE_WIDTH / 350.0f;
    CGFloat widthOther = (SIZE_DEVICE_WIDTH -  SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 4.0f - widthBest) / 2.0f;
    CGFloat xpointBest = (SIZE_DEVICE_WIDTH - widthBest) / 2.0f;
    CGFloat xpointLeft = SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat xpointRight = SIZE_DEVICE_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT - widthOther;
    
    ///暂时模型
    [self createRecommendHouseComparisonUIWithXPoint:xpointBest];
    [self createOtherHouseComparisonUIWithXPoint:xpointLeft andWidth:widthOther andModel:self.houseList[1]];
    [self createOtherHouseComparisonUIWithXPoint:xpointRight andWidth:widthOther andModel:self.houseList[2]];

}

///创建推荐房源的UI
- (void)createRecommendHouseComparisonUIWithXPoint:(CGFloat)xpoint
{

    ///推荐尺寸
    CGFloat heightBest = 125.0f * SIZE_DEVICE_HEIGHT / 667.0f;
    CGFloat widthBest = 111.0f * SIZE_DEVICE_WIDTH / 350.0f;
    
    ///比一比房源个数
    NSInteger sumHouse = [self.houseList count];
    
    ///标题大图
    QSImageView *titleImageView = [[QSImageView alloc] initWithFrame:CGRectMake(xpoint, 10.0f, widthBest, heightBest)];
    titleImageView.image = [UIImage imageNamed:IMAGE_COMPARISON_SIXFORM];
    [self createTitleInfo:titleImageView];
    [self.infoRootView addSubview:titleImageView];
    
    ///分隔线
    CGFloat xpiontSepLabel = (sumHouse >= 3) ? SIZE_DEFAULT_MARGIN_LEFT_RIGHT : xpoint;
    UILabel *headeSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpiontSepLabel, titleImageView.frame.origin.y + titleImageView.frame.size.height + 10.0f - 0.25f, self.infoRootView.frame.size.width - 2.0f * xpiontSepLabel, 0.25f)];
    headeSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.infoRootView addSubview:headeSepLabel];
    
    ///指示三角
    UIButton *indicatorButton = [UIButton createBlockButtonWithFrame:CGRectMake((titleImageView.frame.origin.x + titleImageView.frame.size.width / 2.0f) - 25.0f / 2.0f, titleImageView.frame.origin.y + titleImageView.frame.size.height + 20.0f, 25.0f, 6.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
    }];
    [indicatorButton setImage:[UIImage imageNamed:IMAGE_COMPARISON_INDICADE_NORMAL] forState:UIControlStateNormal];
    [indicatorButton setImage:[UIImage imageNamed:IMAGE_COMPARISON_INDICADE_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.infoRootView addSubview:indicatorButton];
    
    ///预约按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    buttonStyle.title = @"立即预约";
    CGFloat widthAppoint = (sumHouse == 2) ? widthBest : (widthBest + 3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT);
    CGFloat xpointAppoint = (sumHouse == 2) ? xpoint : ((SIZE_DEVICE_WIDTH - widthAppoint) / 2.0f);
    
    UIButton *appointButton = [UIButton createBlockButtonWithFrame:CGRectMake(xpointAppoint, indicatorButton.frame.origin.y + indicatorButton.frame.size.height, widthAppoint, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///已登录
        if (lLoginCheckActionTypeLogined == [self checkLogin]) {
            
            id tempDetailModel = self.houseOriginalList[0];
            NSString *isBook = [[tempDetailModel valueForKey:@"expandInfo"] valueForKey:@"is_book"];
            
            ///判断是否已预约
            if (0 >= [isBook length]) {
                
                if (fFilterMainTypeSecondHouse == self.houseType) {
                    
                    ///预约
                    [self bookSecondHandHouse];
                    
                }
                
                if (fFilterMainTypeRentalHouse == self.houseType) {
                    
                    ///预约
                    [self bookRentHouse];
                    
                }
                
            } else {
            
                if (fFilterMainTypeSecondHouse == self.houseType) {
                    
                    ///查看预约详情
                    [self gotoSecondHandHouseBookOrderInfo];
                    
                }
                
                if (fFilterMainTypeRentalHouse == self.houseType) {
                    
                    ///查看预约详情
                    [self gotoRentHouseBookOrderInfo];
                    
                }
            
            }
            
        } else {
        
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"登录后才可以进行预约", 1.5f, ^(){})
        
        }
        
    }];
    [self.infoRootView addSubview:appointButton];
    
    ///获取模型
    QSYComparisonDataModel *tempModel = self.houseList[0];
    
    ///收藏按钮
    QSBlockButtonStyleModel *shareButtonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeCollected];
    
    UIButton *shareButton = [UIButton createBlockButtonWithFrame:CGRectMake(appointButton.frame.origin.x + appointButton.frame.size.width + 10.0f, appointButton.frame.origin.y, 44.0f, appointButton.frame.size.height) andButtonStyle:shareButtonStyle andCallBack:^(UIButton *button) {
        
        ///判断是收藏还是删除收藏
        if (button.selected) {
            
            [self deleteHouseCollected:button];
            
        } else {
            
            [self addHouseCollected:button];
            
        }
        
    }];
    shareButton.selected = [QSCoreDataManager checkCollectedDataWithID:tempModel.houseID andCollectedType:self.houseType];
    [self.infoRootView addSubview:shareButton];
    
    ///地址信息
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, appointButton.frame.origin.y + appointButton.frame.size.height + 20.0f, widthBest, 15.0f)];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.textColor = COLOR_CHARACTERS_BLACK;
    addressLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    addressLabel.adjustsFontSizeToFitWidth = YES;
    addressLabel.text = [NSString stringWithFormat:@"%@|%@",tempModel.districe,tempModel.street];
    addressLabel.adjustsFontSizeToFitWidth = YES;
    [self.infoRootView addSubview:addressLabel];
    
    ///分隔线
    UILabel *addressSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpiontSepLabel, addressLabel.frame.origin.y + addressLabel.frame.size.height + 20.0f - 0.25f, self.infoRootView.frame.size.width - 2.0f * xpiontSepLabel, 0.25f)];
    addressSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.infoRootView addSubview:addressSepLabel];
    
    ///计算相关尺寸
    CGFloat caclWith = 0.0f;
    CGFloat widthResult = 0.0f;
    
    ///面积
    caclWith = [tempModel.area calculateStringDisplayWidthByFixedHeight:30.0f andFontSize:FONT_BODY_20] + 5.0f;
    widthResult = caclWith > (widthBest * 3.0f / 4.0f) ? (widthBest * 3.0f / 4.0f) : (caclWith < widthBest / 2.0f ? widthBest / 2.0f : caclWith);
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - widthResult - 15.0f) / 2.0f, addressLabel.frame.origin.y + addressLabel.frame.size.height + 40.0f, widthResult, 30.0f)];
    areaLabel.text = tempModel.area;
    areaLabel.textAlignment = NSTextAlignmentRight;
    areaLabel.textColor = COLOR_CHARACTERS_YELLOW;
    areaLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    areaLabel.adjustsFontSizeToFitWidth = YES;
    [self.infoRootView addSubview:areaLabel];
    
    ///单位
    UILabel *unitAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(areaLabel.frame.origin.x + areaLabel.frame.size.width, areaLabel.frame.origin.y + 10.0f, 15.0f, 15.0f)];
    unitAreaLabel.text = APPLICATION_AREAUNIT;
    unitAreaLabel.textAlignment = NSTextAlignmentLeft;
    unitAreaLabel.textColor = COLOR_CHARACTERS_YELLOW;
    unitAreaLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self.infoRootView addSubview:unitAreaLabel];
    
    ///室厅卫
    UILabel *houseTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, areaLabel.frame.origin.y + areaLabel.frame.size.height, widthBest, 15.0f)];
    houseTypeLabel.text = [NSString stringWithFormat:@"%@室%@厅%@卫",tempModel.house_shi,tempModel.house_ting,tempModel.house_wei];
    houseTypeLabel.textAlignment = NSTextAlignmentCenter;
    houseTypeLabel.textColor = COLOR_CHARACTERS_BLACK;
    houseTypeLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    houseTypeLabel.adjustsFontSizeToFitWidth = YES;
    [self.infoRootView addSubview:houseTypeLabel];
    
    ///分隔线
    UILabel *houseTypeSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpiontSepLabel, houseTypeLabel.frame.origin.y + houseTypeLabel.frame.size.height + 20.0f - 0.25f, self.infoRootView.frame.size.width - 2.0f * xpiontSepLabel, 0.25f)];
    houseTypeSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.infoRootView addSubview:houseTypeSepLabel];
    
    ///差异UI的坐标记录
    CGFloat ypointDifferentUI = houseTypeLabel.frame.origin.y + houseTypeLabel.frame.size.height + 40.0f;
    
    ///二手房创建的UI
    if (fFilterMainTypeSecondHouse == self.houseType) {
        
        ///总价
        caclWith = [tempModel.price calculateStringDisplayWidthByFixedHeight:30.0f andFontSize:FONT_BODY_20] + 5.0f;
        widthResult = caclWith > (widthBest * 3.0f / 4.0f) ? (widthBest * 3.0f / 4.0f) : (caclWith < widthBest / 2.0f ? widthBest / 2.0f : caclWith);
        UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - widthResult - 15.0f) / 2.0f, ypointDifferentUI, widthResult, 30.0f)];
        totalPriceLabel.text = tempModel.price;
        totalPriceLabel.textAlignment = NSTextAlignmentRight;
        totalPriceLabel.textColor = COLOR_CHARACTERS_YELLOW;
        totalPriceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
        totalPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:totalPriceLabel];
        
        ///单位
        UILabel *unitTotalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalPriceLabel.frame.origin.x + totalPriceLabel.frame.size.width, totalPriceLabel.frame.origin.y + 10.0f, 15.0f, 15.0f)];
        unitTotalPriceLabel.text = @"万";
        unitTotalPriceLabel.textAlignment = NSTextAlignmentLeft;
        unitTotalPriceLabel.textColor = COLOR_CHARACTERS_YELLOW;
        unitTotalPriceLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        [self.infoRootView addSubview:unitTotalPriceLabel];
        
        ///均价
        UILabel *avgPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, totalPriceLabel.frame.origin.y + totalPriceLabel.frame.size.height, widthBest, 15.0f)];
        avgPriceLabel.text = [NSString stringWithFormat:@"%@万/%@",tempModel.avg_price,APPLICATION_AREAUNIT];
        avgPriceLabel.textAlignment = NSTextAlignmentCenter;
        avgPriceLabel.textColor = COLOR_CHARACTERS_BLACK;
        avgPriceLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        avgPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:avgPriceLabel];
        
        ///分隔线
        UILabel *avgPriceSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpiontSepLabel, avgPriceLabel.frame.origin.y + avgPriceLabel.frame.size.height + 20.0f - 0.25f, self.infoRootView.frame.size.width - 2.0f * xpiontSepLabel, 0.25f)];
        avgPriceSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [self.infoRootView addSubview:avgPriceSepLabel];
        
        ///首付信息
        caclWith = [tempModel.downPayPrice calculateStringDisplayWidthByFixedHeight:30.0f andFontSize:FONT_BODY_20] + 5.0f;
        widthResult = caclWith > (widthBest - 60.0f) ? (widthBest - 60.0f) : (caclWith < widthBest / 2.0f ? widthBest / 2.0f : caclWith);
        UILabel *downPaymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - widthResult - 60.0f) / 2.0f, avgPriceLabel.frame.origin.y + avgPriceLabel.frame.size.height + 40.0f, widthResult, 30.0f)];
        downPaymentLabel.text = tempModel.downPayPrice;
        downPaymentLabel.textAlignment = NSTextAlignmentRight;
        downPaymentLabel.textColor = COLOR_CHARACTERS_YELLOW;
        downPaymentLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
        downPaymentLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:downPaymentLabel];
        
        ///单位
        UILabel *unitDownPayPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(downPaymentLabel.frame.origin.x + downPaymentLabel.frame.size.width, downPaymentLabel.frame.origin.y + 10.0f, 60.0f, 15.0f)];
        unitDownPayPriceLabel.text = @"万首付";
        unitDownPayPriceLabel.textAlignment = NSTextAlignmentLeft;
        unitDownPayPriceLabel.textColor = COLOR_CHARACTERS_YELLOW;
        unitDownPayPriceLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        unitDownPayPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:unitDownPayPriceLabel];
        
        ///月供
        UILabel *monthPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, downPaymentLabel.frame.origin.y + downPaymentLabel.frame.size.height, widthBest, 15.0f)];
        monthPriceLabel.text = [NSString stringWithFormat:@"月供%@元",tempModel.monthPrice];
        monthPriceLabel.textAlignment = NSTextAlignmentCenter;
        monthPriceLabel.textColor = COLOR_CHARACTERS_BLACK;
        monthPriceLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        monthPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:monthPriceLabel];
        
        ///分隔线
        UILabel *monthPriceSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpiontSepLabel, monthPriceLabel.frame.origin.y + monthPriceLabel.frame.size.height + 20.0f - 0.25f, self.infoRootView.frame.size.width - 2.0f * xpiontSepLabel, 0.25f)];
        monthPriceSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [self.infoRootView addSubview:monthPriceSepLabel];
        
        ///建筑时间
        UILabel *buildYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - 60.0f) / 2.0f, monthPriceLabel.frame.origin.y + monthPriceLabel.frame.size.height + 40.0f, 60.0f, 30.0f)];
        buildYearLabel.text = tempModel.buildingYear;
        buildYearLabel.textAlignment = NSTextAlignmentRight;
        buildYearLabel.textColor = COLOR_CHARACTERS_YELLOW;
        buildYearLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
        buildYearLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:buildYearLabel];
        
        ///单位
        UILabel *unitBuildYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(buildYearLabel.frame.origin.x + buildYearLabel.frame.size.width, buildYearLabel.frame.origin.y + 10.0f, 15.0f, 15.0f)];
        unitBuildYearLabel.text = @"年";
        unitBuildYearLabel.textAlignment = NSTextAlignmentLeft;
        unitBuildYearLabel.textColor = COLOR_CHARACTERS_YELLOW;
        unitBuildYearLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        [self.infoRootView addSubview:unitBuildYearLabel];
        
        ///产权年限
        UILabel *rightYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, buildYearLabel.frame.origin.y + buildYearLabel.frame.size.height, widthBest, 15.0f)];
        rightYearLabel.text = [NSString stringWithFormat:@"%@年使用权",tempModel.rightYear];
        rightYearLabel.textAlignment = NSTextAlignmentCenter;
        rightYearLabel.textColor = COLOR_CHARACTERS_BLACK;
        rightYearLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        rightYearLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:rightYearLabel];
        
        ///分隔线
        UILabel *rightYearSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpiontSepLabel, rightYearLabel.frame.origin.y + rightYearLabel.frame.size.height + 20.0f - 0.25f, self.infoRootView.frame.size.width - 2.0f * xpiontSepLabel, 0.25f)];
        rightYearSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [self.infoRootView addSubview:rightYearSepLabel];
        
        ///重置ypoint
        ypointDifferentUI = rightYearLabel.frame.origin.y + rightYearLabel.frame.size.height + 40.0f;
        
    }
    
    ///出租房UI
    if (fFilterMainTypeRentalHouse == self.houseType) {
        
        ///租金信息
        caclWith = [tempModel.price calculateStringDisplayWidthByFixedHeight:30.0f andFontSize:FONT_BODY_20] + 5.0f;
        widthResult = caclWith > (widthBest - 60.0f) ? (widthBest - 60.0f) : (caclWith < widthBest / 2.0f ? widthBest / 2.0f : caclWith);
        UILabel *rentPrice = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - widthResult - 60.0f) / 2.0f, ypointDifferentUI, widthResult, 30.0f)];
        rentPrice.text = tempModel.price;
        rentPrice.textAlignment = NSTextAlignmentRight;
        rentPrice.textColor = COLOR_CHARACTERS_YELLOW;
        rentPrice.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
        rentPrice.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:rentPrice];
        
        ///单位
        UILabel *unitDownPayPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(rentPrice.frame.origin.x + rentPrice.frame.size.width, rentPrice.frame.origin.y + 10.0f, 60.0f, 15.0f)];
        unitDownPayPriceLabel.text = @"元/月";
        unitDownPayPriceLabel.textAlignment = NSTextAlignmentLeft;
        unitDownPayPriceLabel.textColor = COLOR_CHARACTERS_YELLOW;
        unitDownPayPriceLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        unitDownPayPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:unitDownPayPriceLabel];
        
        ///租金支付方式
        UILabel *rentPayTypeLable = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, rentPrice.frame.origin.y + rentPrice.frame.size.height, widthBest, 15.0f)];
        rentPayTypeLable.text = tempModel.rentPayType;
        rentPayTypeLable.textAlignment = NSTextAlignmentCenter;
        rentPayTypeLable.textColor = COLOR_CHARACTERS_BLACK;
        rentPayTypeLable.font = [UIFont systemFontOfSize:FONT_BODY_14];
        rentPayTypeLable.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:rentPayTypeLable];
        
        ///分隔线
        UILabel *monthPriceSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpiontSepLabel, rentPayTypeLable.frame.origin.y + rentPayTypeLable.frame.size.height + 20.0f - 0.25f, self.infoRootView.frame.size.width - 2.0f * xpiontSepLabel, 0.25f)];
        monthPriceSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [self.infoRootView addSubview:monthPriceSepLabel];
        
        ///入住时间
        UILabel *leadTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, rentPayTypeLable.frame.origin.y + rentPayTypeLable.frame.size.height + 40.0f, widthBest, 30.0f)];
        leadTimeLabel.text = tempModel.leadTime;
        leadTimeLabel.textAlignment = NSTextAlignmentRight;
        leadTimeLabel.textColor = COLOR_CHARACTERS_GRAY;
        leadTimeLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
        leadTimeLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:leadTimeLabel];
        
        ///出租房当前状态
        UILabel *houseStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, leadTimeLabel.frame.origin.y + leadTimeLabel.frame.size.height, widthBest, 15.0f)];
        houseStatusLabel.text = tempModel.houseStatus;
        houseStatusLabel.textAlignment = NSTextAlignmentCenter;
        houseStatusLabel.textColor = COLOR_CHARACTERS_BLACK;
        houseStatusLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        houseStatusLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:houseStatusLabel];
        
        ///分隔线
        UILabel *rightYearSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpiontSepLabel, houseStatusLabel.frame.origin.y + houseStatusLabel.frame.size.height + 20.0f - 0.25f, self.infoRootView.frame.size.width - 2.0f * xpiontSepLabel, 0.25f)];
        rightYearSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [self.infoRootView addSubview:rightYearSepLabel];
        
        ///重置ypoint
        ypointDifferentUI = houseStatusLabel.frame.origin.y + houseStatusLabel.frame.size.height + 40.0f;
        
    }
    
    ///楼层信息
    UILabel *liftRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, ypointDifferentUI, widthBest, 30.0f)];
    liftRateLabel.text = [NSString stringWithFormat:@"%@/%@",tempModel.floor_which,tempModel.floor_sum];
    liftRateLabel.textAlignment = NSTextAlignmentCenter;
    liftRateLabel.textColor = COLOR_CHARACTERS_GRAY;
    liftRateLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    liftRateLabel.adjustsFontSizeToFitWidth = YES;
    [self.infoRootView addSubview:liftRateLabel];
    
    ///是否有电梯
    UILabel *liftTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, liftRateLabel.frame.origin.y + liftRateLabel.frame.size.height, widthBest, 15.0f)];
    liftTipsLabel.text = tempModel.lift;
    liftTipsLabel.textAlignment = NSTextAlignmentCenter;
    liftTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    liftTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self.infoRootView addSubview:liftTipsLabel];
    
    ///分隔线
    UILabel *liftSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpiontSepLabel, liftTipsLabel.frame.origin.y + liftTipsLabel.frame.size.height + 20.0f - 0.25f, self.infoRootView.frame.size.width - 2.0f * xpiontSepLabel, 0.25f)];
    liftSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.infoRootView addSubview:liftSepLabel];
    
    ///朝向
    UILabel *faceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, liftTipsLabel.frame.origin.y + liftTipsLabel.frame.size.height + 40.0f, widthBest, 30.0f)];
    faceLabel.text = tempModel.face;
    faceLabel.textAlignment = NSTextAlignmentCenter;
    faceLabel.textColor = COLOR_CHARACTERS_GRAY;
    faceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    faceLabel.adjustsFontSizeToFitWidth = YES;
    [self.infoRootView addSubview:faceLabel];
    
    ///装修
    UILabel *decorationLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, faceLabel.frame.origin.y + faceLabel.frame.size.height, widthBest, 15.0f)];
    decorationLabel.text = tempModel.decoration;
    decorationLabel.textAlignment = NSTextAlignmentCenter;
    decorationLabel.textColor = COLOR_CHARACTERS_BLACK;
    decorationLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    decorationLabel.adjustsFontSizeToFitWidth = YES;
    [self.infoRootView addSubview:decorationLabel];
    
    ///设置滚动
    if (decorationLabel.frame.origin.y + decorationLabel.frame.size.height + 20.0f > self.infoRootView.frame.size.height) {
        
        self.infoRootView.contentSize = CGSizeMake(self.infoRootView.frame.size.width, decorationLabel.frame.origin.y + decorationLabel.frame.size.height + 20.0f);
        
    }

}

///创建非推荐房源的UI
- (void)createOtherHouseComparisonUIWithXPoint:(CGFloat)xpoint andWidth:(CGFloat)widthBest andModel:(QSYComparisonDataModel *)tempModel
{
    
    ///推荐标题的高度
    CGFloat heightBest = 125.0f * SIZE_DEVICE_HEIGHT / 667.0f;
    CGFloat starYPoint = (heightBest - 70.0f) / 2.0f + 10.0f;
    
    ///标题信息
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, starYPoint, widthBest, 15.0f)];
    titleLabel.text = tempModel.communityName;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_CHARACTERS_BLACK;
    titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [self.infoRootView addSubview:titleLabel];
    
    ///评分
    CGFloat scoreWidth = [tempModel.score calculateStringDisplayWidthByFixedHeight:40.0f andFontSize:FONT_BODY_30] + 10.0f;
    CGFloat widthScore = (scoreWidth > widthBest ? widthBest * 3.0f / 4.0f : (scoreWidth < widthBest / 2.0f ? widthBest / 2.0f : scoreWidth));
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, titleLabel.frame.origin.y + titleLabel.frame.size.height, widthScore, 40.0f)];
    scoreLabel.text = tempModel.score;
    scoreLabel.textAlignment = NSTextAlignmentRight;
    scoreLabel.textColor = COLOR_CHARACTERS_YELLOW;
    scoreLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    scoreLabel.adjustsFontSizeToFitWidth = YES;
    [self.infoRootView addSubview:scoreLabel];
    
    ///评分单位
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(scoreLabel.frame.origin.x + scoreLabel.frame.size.width, scoreLabel.frame.origin.y + 15.0f, 15.0f, 15.0f)];
    unitLabel.text  =@"分";
    unitLabel.textAlignment = NSTextAlignmentLeft;
    unitLabel.textColor = COLOR_CHARACTERS_BLACK;
    unitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [self.infoRootView addSubview:unitLabel];
    
    ///星星
    QSImageView *grayStarImageView = [[QSImageView alloc] initWithFrame:CGRectMake(xpoint + (widthBest - 60.0f) / 2.0f, scoreLabel.frame.origin.y + scoreLabel.frame.size.height, 60.0f, 12.0f)];
    grayStarImageView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_STAR_GRAY];
    [self.infoRootView addSubview:grayStarImageView];
    
    ///黄星底view
    QSImageView *starRootView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (grayStarImageView.frame.size.width * ([tempModel.score floatValue] / 10.0f)), grayStarImageView.frame.size.height)];
    starRootView.clipsToBounds = YES;
    [grayStarImageView addSubview:starRootView];
    
    ///黄色星星
    QSImageView *yellowStarView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, grayStarImageView.frame.size.width, grayStarImageView.frame.size.height)];
    yellowStarView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_STAR_YELLOW];
    [starRootView addSubview:yellowStarView];

    ///地址信息
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, heightBest + 20.0f + 10.0f + 6.0f + 44.0f + 20.0f, widthBest, 15.0f)];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.textColor = COLOR_CHARACTERS_BLACK;
    addressLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    addressLabel.adjustsFontSizeToFitWidth = YES;
    addressLabel.text = [NSString stringWithFormat:@"%@|%@",tempModel.districe,tempModel.street];
    [self.infoRootView addSubview:addressLabel];
    
    ///计算相关尺寸
    CGFloat caclWith = 0.0f;
    CGFloat widthResult = 0.0f;
    
    ///面积
    caclWith = [tempModel.area calculateStringDisplayWidthByFixedHeight:30.0f andFontSize:FONT_BODY_20] + 5.0f;
    widthResult = caclWith > (widthBest * 3.0f / 4.0f) ? (widthBest * 3.0f / 4.0f) : (caclWith < widthBest / 2.0f ? widthBest / 2.0f : caclWith);
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - widthResult - 15.0f) / 2.0f, addressLabel.frame.origin.y + addressLabel.frame.size.height + 40.0f, widthResult, 30.0f)];
    areaLabel.text = tempModel.area;
    areaLabel.textAlignment = NSTextAlignmentRight;
    areaLabel.textColor = COLOR_CHARACTERS_GRAY;
    areaLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [self.infoRootView addSubview:areaLabel];
    
    ///单位
    UILabel *unitAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(areaLabel.frame.origin.x + areaLabel.frame.size.width, areaLabel.frame.origin.y + 10.0f, 15.0f, 15.0f)];
    unitAreaLabel.text = APPLICATION_AREAUNIT;
    unitAreaLabel.textAlignment = NSTextAlignmentLeft;
    unitAreaLabel.textColor = COLOR_CHARACTERS_GRAY;
    unitAreaLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self.infoRootView addSubview:unitAreaLabel];
    
    ///室厅卫
    UILabel *houseTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, areaLabel.frame.origin.y + areaLabel.frame.size.height, widthBest, 15.0f)];
    houseTypeLabel.text = [NSString stringWithFormat:@"%@室%@厅%@卫",tempModel.house_shi,tempModel.house_ting,tempModel.house_wei];
    houseTypeLabel.textAlignment = NSTextAlignmentCenter;
    houseTypeLabel.textColor = COLOR_CHARACTERS_BLACK;
    houseTypeLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self.infoRootView addSubview:houseTypeLabel];
    
    CGFloat ypointDifferentUI = houseTypeLabel.frame.origin.y + houseTypeLabel.frame.size.height + 40.0f;
    
    if (fFilterMainTypeSecondHouse == self.houseType) {
        
        ///总价
        caclWith = [tempModel.price calculateStringDisplayWidthByFixedHeight:30.0f andFontSize:FONT_BODY_20] + 5.0f;
        widthResult = caclWith > (widthBest * 3.0f / 4.0f) ? (widthBest * 3.0f / 4.0f) : (caclWith < widthBest / 2.0f ? widthBest / 2.0f : caclWith);
        UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - widthResult - 15.0f) / 2.0f, ypointDifferentUI, widthResult, 30.0f)];
        totalPriceLabel.text = tempModel.price;
        totalPriceLabel.textAlignment = NSTextAlignmentRight;
        totalPriceLabel.textColor = COLOR_CHARACTERS_GRAY;
        totalPriceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
        totalPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:totalPriceLabel];
        
        ///单位
        UILabel *unitTotalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalPriceLabel.frame.origin.x + totalPriceLabel.frame.size.width, totalPriceLabel.frame.origin.y + 10.0f, 15.0f, 15.0f)];
        unitTotalPriceLabel.text = @"万";
        unitTotalPriceLabel.textAlignment = NSTextAlignmentLeft;
        unitTotalPriceLabel.textColor = COLOR_CHARACTERS_GRAY;
        unitTotalPriceLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        [self.infoRootView addSubview:unitTotalPriceLabel];
        
        ///均价
        UILabel *avgPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, totalPriceLabel.frame.origin.y + totalPriceLabel.frame.size.height, widthBest, 15.0f)];
        avgPriceLabel.text = [NSString stringWithFormat:@"%@万/%@",tempModel.avg_price,APPLICATION_AREAUNIT];
        avgPriceLabel.textAlignment = NSTextAlignmentCenter;
        avgPriceLabel.textColor = COLOR_CHARACTERS_BLACK;
        avgPriceLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        avgPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:avgPriceLabel];
        
        ///首付信息
        caclWith = [tempModel.downPayPrice calculateStringDisplayWidthByFixedHeight:30.0f andFontSize:FONT_BODY_20] + 5.0f;
        widthResult = caclWith > (widthBest - 60.0f) ? (widthBest - 60.0f) : (caclWith < widthBest / 2.0f ? widthBest / 2.0f : caclWith);
        UILabel *downPaymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - widthResult - 60.0f) / 2.0f, avgPriceLabel.frame.origin.y + avgPriceLabel.frame.size.height + 40.0f, widthResult, 30.0f)];
        downPaymentLabel.text = tempModel.downPayPrice;
        downPaymentLabel.textAlignment = NSTextAlignmentRight;
        downPaymentLabel.textColor = COLOR_CHARACTERS_GRAY;
        downPaymentLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
        downPaymentLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:downPaymentLabel];
        
        ///单位
        UILabel *unitDownPayPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(downPaymentLabel.frame.origin.x + downPaymentLabel.frame.size.width, downPaymentLabel.frame.origin.y + 10.0f, 60.0f, 15.0f)];
        unitDownPayPriceLabel.text = @"万首付";
        unitDownPayPriceLabel.textAlignment = NSTextAlignmentLeft;
        unitDownPayPriceLabel.textColor = COLOR_CHARACTERS_GRAY;
        unitDownPayPriceLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        unitDownPayPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:unitDownPayPriceLabel];
        
        ///月供
        UILabel *monthPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, downPaymentLabel.frame.origin.y + downPaymentLabel.frame.size.height, widthBest, 15.0f)];
        monthPriceLabel.text = [NSString stringWithFormat:@"月供%@元",tempModel.monthPrice];
        monthPriceLabel.textAlignment = NSTextAlignmentCenter;
        monthPriceLabel.textColor = COLOR_CHARACTERS_BLACK;
        monthPriceLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        monthPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:monthPriceLabel];
        
        ///建筑时间
        UILabel *buildYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - 60.0f) / 2.0f, monthPriceLabel.frame.origin.y + monthPriceLabel.frame.size.height + 40.0f, 60.0f, 30.0f)];
        buildYearLabel.text = tempModel.buildingYear;
        buildYearLabel.textAlignment = NSTextAlignmentRight;
        buildYearLabel.textColor = COLOR_CHARACTERS_GRAY;
        buildYearLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
        buildYearLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:buildYearLabel];
        
        ///单位
        UILabel *unitBuildYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(buildYearLabel.frame.origin.x + buildYearLabel.frame.size.width, buildYearLabel.frame.origin.y + 10.0f, 15.0f, 15.0f)];
        unitBuildYearLabel.text = @"年";
        unitBuildYearLabel.textAlignment = NSTextAlignmentLeft;
        unitBuildYearLabel.textColor = COLOR_CHARACTERS_GRAY;
        unitBuildYearLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        [self.infoRootView addSubview:unitBuildYearLabel];
        
        ///产权年限
        UILabel *rightYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, buildYearLabel.frame.origin.y + buildYearLabel.frame.size.height, widthBest, 15.0f)];
        rightYearLabel.text = [NSString stringWithFormat:@"%@年使用权",tempModel.rightYear];
        rightYearLabel.textAlignment = NSTextAlignmentCenter;
        rightYearLabel.textColor = COLOR_CHARACTERS_BLACK;
        rightYearLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        rightYearLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:rightYearLabel];
        
        ///重置ypoint
        ypointDifferentUI = rightYearLabel.frame.origin.y + rightYearLabel.frame.size.height + 40.0f;
        
    }

    ///出租房UI
    if (fFilterMainTypeRentalHouse == self.houseType) {
        
        ///租金信息
        caclWith = [tempModel.price calculateStringDisplayWidthByFixedHeight:30.0f andFontSize:FONT_BODY_20] + 5.0f;
        widthResult = caclWith > (widthBest - 60.0f) ? (widthBest - 60.0f) : (caclWith < widthBest / 2.0f ? widthBest / 2.0f : caclWith);
        UILabel *rentPrice = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - widthResult - 60.0f) / 2.0f, ypointDifferentUI, widthResult, 30.0f)];
        rentPrice.text = tempModel.price;
        rentPrice.textAlignment = NSTextAlignmentRight;
        rentPrice.textColor = COLOR_CHARACTERS_YELLOW;
        rentPrice.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
        rentPrice.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:rentPrice];
        
        ///单位
        UILabel *unitDownPayPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(rentPrice.frame.origin.x + rentPrice.frame.size.width, rentPrice.frame.origin.y + 10.0f, 60.0f, 15.0f)];
        unitDownPayPriceLabel.text = @"元/月";
        unitDownPayPriceLabel.textAlignment = NSTextAlignmentLeft;
        unitDownPayPriceLabel.textColor = COLOR_CHARACTERS_YELLOW;
        unitDownPayPriceLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        unitDownPayPriceLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:unitDownPayPriceLabel];
        
        ///租金支付方式
        UILabel *rentPayTypeLable = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, rentPrice.frame.origin.y + rentPrice.frame.size.height, widthBest, 15.0f)];
        rentPayTypeLable.text = tempModel.rentPayType;
        rentPayTypeLable.textAlignment = NSTextAlignmentCenter;
        rentPayTypeLable.textColor = COLOR_CHARACTERS_BLACK;
        rentPayTypeLable.font = [UIFont systemFontOfSize:FONT_BODY_14];
        rentPayTypeLable.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:rentPayTypeLable];
        
        ///入住时间
        UILabel *leadTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, rentPayTypeLable.frame.origin.y + rentPayTypeLable.frame.size.height + 40.0f, widthBest, 30.0f)];
        leadTimeLabel.text = tempModel.leadTime;
        leadTimeLabel.textAlignment = NSTextAlignmentRight;
        leadTimeLabel.textColor = COLOR_CHARACTERS_GRAY;
        leadTimeLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
        leadTimeLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:leadTimeLabel];
        
        ///出租房当前状态
        UILabel *houseStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, leadTimeLabel.frame.origin.y + leadTimeLabel.frame.size.height, widthBest, 15.0f)];
        houseStatusLabel.text = tempModel.houseStatus;
        houseStatusLabel.textAlignment = NSTextAlignmentCenter;
        houseStatusLabel.textColor = COLOR_CHARACTERS_BLACK;
        houseStatusLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        houseStatusLabel.adjustsFontSizeToFitWidth = YES;
        [self.infoRootView addSubview:houseStatusLabel];
        
        ///重置ypoint
        ypointDifferentUI = houseStatusLabel.frame.origin.y + houseStatusLabel.frame.size.height + 40.0f;
        
    }
    
    ///楼层信息
    UILabel *liftRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, ypointDifferentUI, widthBest, 30.0f)];
    liftRateLabel.text = [NSString stringWithFormat:@"%@/%@",tempModel.floor_which,tempModel.floor_sum];
    liftRateLabel.textAlignment = NSTextAlignmentCenter;
    liftRateLabel.textColor = COLOR_CHARACTERS_GRAY;
    liftRateLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    liftRateLabel.adjustsFontSizeToFitWidth = YES;
    [self.infoRootView addSubview:liftRateLabel];
    
    ///是否有电梯
    UILabel *liftTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, liftRateLabel.frame.origin.y + liftRateLabel.frame.size.height + 5.0f, widthBest, 15.0f)];
    liftTipsLabel.text = tempModel.lift;
    liftTipsLabel.textAlignment = NSTextAlignmentCenter;
    liftTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    liftTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self.infoRootView addSubview:liftTipsLabel];
    
    ///朝向
    UILabel *faceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, liftTipsLabel.frame.origin.y + liftTipsLabel.frame.size.height + 40.0f, widthBest, 30.0f)];
    faceLabel.text = tempModel.face;
    faceLabel.textAlignment = NSTextAlignmentCenter;
    faceLabel.textColor = COLOR_CHARACTERS_GRAY;
    faceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    faceLabel.adjustsFontSizeToFitWidth = YES;
    [self.infoRootView addSubview:faceLabel];
    
    ///装修
    UILabel *decorationLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, faceLabel.frame.origin.y + faceLabel.frame.size.height, widthBest, 30.0f)];
    decorationLabel.text = tempModel.decoration;
    decorationLabel.textAlignment = NSTextAlignmentCenter;
    decorationLabel.textColor = COLOR_CHARACTERS_BLACK;
    decorationLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    decorationLabel.adjustsFontSizeToFitWidth = YES;
    [self.infoRootView addSubview:decorationLabel];

}

///创建推荐房源标题信息
- (void)createTitleInfo:(UIView *)view
{
    
    ///获取模型
    QSYComparisonDataModel *tempModel = self.houseList[0];
    CGFloat heightMiddel = 40.0f;
    CGFloat heightTitle = 15.0f;
    CGFloat gapTop = (view.frame.size.height - heightMiddel - 2.0f * heightTitle) / 2.0f;

    ///标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, gapTop, view.frame.size.width - 10.0f, heightTitle)];
    titleLabel.text = tempModel.communityName;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_CHARACTERS_BLACK;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [view addSubview:titleLabel];
    
    ///评分
    CGFloat scoreWidth = [tempModel.score calculateStringDisplayWidthByFixedHeight:heightMiddel andFontSize:FONT_BODY_30] + 10.0f;
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f - scoreWidth, titleLabel.frame.origin.y + titleLabel.frame.size.height, scoreWidth, heightMiddel)];
    scoreLabel.text = tempModel.score;
    scoreLabel.textAlignment = NSTextAlignmentRight;
    scoreLabel.adjustsFontSizeToFitWidth = YES;
    scoreLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    [view addSubview:scoreLabel];
    
    ///评分单位
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(scoreLabel.frame.origin.x + scoreLabel.frame.size.width, scoreLabel.frame.origin.y + 15.0f, 15.0f, 15.0f)];
    unitLabel.text  =@"分";
    unitLabel.textAlignment = NSTextAlignmentLeft;
    unitLabel.textColor = COLOR_CHARACTERS_BLACK;
    unitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [view addSubview:unitLabel];
    
    ///星星
    QSImageView *grayStarImageView = [[QSImageView alloc] initWithFrame:CGRectMake((view.frame.size.width - 60.0f) / 2.0f, scoreLabel.frame.origin.y + scoreLabel.frame.size.height, 60.0f, 12.0f)];
    grayStarImageView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_STAR_GRAY];
    [view addSubview:grayStarImageView];
    
    ///黄星底view
    QSImageView *starRootView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (grayStarImageView.frame.size.width * ([tempModel.score floatValue] / 10.0f)), grayStarImageView.frame.size.height)];
    starRootView.clipsToBounds = YES;
    [grayStarImageView addSubview:starRootView];
    
    ///黄色星星
    QSImageView *yellowStarView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, grayStarImageView.frame.size.width, grayStarImageView.frame.size.height)];
    yellowStarView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_STAR_YELLOW];
    [starRootView addSubview:yellowStarView];

}

#pragma mark - 添加收藏
- (void)addHouseCollected:(UIButton *)button
{

    ///判断是否存在数据
    if (!self.houseList[0]) {
        
        return;
        
    }
    
    [self addCollectedHouse:button];

}

///添加收藏
- (void)addCollectedHouse:(UIButton *)button
{
    
    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在添加收藏"];
    
    ///判断是否已登录
    if (lLoginCheckActionTypeUnLogin == [self checkLogin]) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"添加收藏房源成功"];
        [self saveCollectedHouseWithStatus:NO];
        button.selected = YES;
        return;
        
    }
    
    ///封装参数
    id tempMode = self.houseOriginalList[0];
    NSString *houseID = [[tempMode valueForKey:@"house"] valueForKey:@"id_"];
    NSDictionary *params = @{@"obj_id" : houseID,
                             @"type" : [NSString stringWithFormat:@"%d",self.houseType]};
    
    [QSRequestManager requestDataWithType:rRequestTypeSecondHandHouseCollected andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"添加收藏房源成功"];
        
        ///同步服务端成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self saveCollectedHouseWithStatus:YES];
                
            });
            
        } else {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self saveCollectedHouseWithStatus:NO];
                
            });
            
        }
        
        ///修改按钮状态为已收藏状态
        button.selected = YES;
        
    }];
    
}

///将收藏信息保存本地
- (void)saveCollectedHouseWithStatus:(BOOL)isSendServer
{
    
    id tempModel = self.houseOriginalList[0];
    
    ///当前小区是否同步服务端标识
    if (isSendServer) {
        
        if (fFilterMainTypeRentalHouse == self.houseType) {
            
            QSRentHouseDetailDataModel *rentModel = tempModel;
            rentModel.house.is_syserver = @"1";
            
        }
        
        if (fFilterMainTypeSecondHouse == self.houseType) {
            
            [tempModel setValue:@"1" forKey:@"is_syserver"];
            
        }
        
    } else {
        
        if (fFilterMainTypeRentalHouse == self.houseType) {
            
            QSRentHouseDetailDataModel *rentModel = tempModel;
            rentModel.house.is_syserver = @"0";
            
        }
        
        if (fFilterMainTypeSecondHouse == self.houseType) {
            
            [tempModel setValue:@"0" forKey:@"is_syserver"];
            
        }
        
    }
    
    ///保存关注小区到本地
    [QSCoreDataManager saveCollectedDataWithModel:tempModel andCollectedType:self.houseType andCallBack:^(BOOL flag) {
        
        ///显示保存信息
        if (flag) {
            
            APPLICATION_LOG_INFO(@"房源收藏->保存本地", @"成功")
            
        } else {
            
            APPLICATION_LOG_INFO(@"房源收藏->保存本地", @"失败")
            
        }
        
    }];
    
}

#pragma mark - 删除收藏
- (void)deleteHouseCollected:(UIButton *)button
{

    ///判断是否存在数据
    if (!self.houseList[0]) {
        
        return;
        
    }
    
    [self deleteCollectedHouse:button];

}

///删除收藏
- (void)deleteCollectedHouse:(UIButton *)button
{
    
    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在取消收藏"];
    
    id tempModel = self.houseOriginalList[0];
    NSString *houseID = [[tempModel valueForKey:@"house"] valueForKey:@"id_"];
    
    ///判断当前收藏是否已同步服务端，若未同步，不需要联网删除
    NSString *isSyserver;
    if (fFilterMainTypeSecondHouse == self.houseType) {
        
        isSyserver = [tempModel valueForKey:@"is_syserver"];
        
    }
    
    if (fFilterMainTypeRentalHouse == self.houseType) {
        
        isSyserver = [[tempModel valueForKey:@"house"] valueForKey:@"is_syserver"];
        
    }
    
    if (0 == [isSyserver intValue]) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"取消收藏房源成功"];
        [self deleteCollectedHouseWithStatus:YES];
        button.selected = NO;
        return;
        
    }
    
    ///判断是否已登录
    if (lLoginCheckActionTypeUnLogin == [self checkLogin]) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"取消收藏房源成功"];
        [self deleteCollectedHouseWithStatus:NO];
        button.selected = NO;
        return;
        
    }
    
    ///封装参数
    NSDictionary *params = @{@"obj_id" : houseID,
                             @"type" : [NSString stringWithFormat:@"%d",self.houseType]};
    
    [QSRequestManager requestDataWithType:rRequestTypeSecondHandHouseDeleteCollected andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"取消收藏房源成功"];
        
        ///同步服务端成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self deleteCollectedHouseWithStatus:YES];
                
            });
            
        } else {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self deleteCollectedHouseWithStatus:NO];
                
            });
            
        }
        
        ///修改按钮状态为已收藏状态
        button.selected = NO;
        
    }];
    
}

///取消当前小区的关注
- (void)deleteCollectedHouseWithStatus:(BOOL)isSendServer
{
    
    ///保存关注小区到本地
    [QSCoreDataManager deleteCollectedDataWithID:nil isSyServer:isSendServer andCollectedType:self.houseType andCallBack:^(BOOL flag) {
        
        ///显示保存信息
        if (flag) {
            
            APPLICATION_LOG_INFO(@"房源收藏->删除", @"成功")
            
        } else {
            
            APPLICATION_LOG_INFO(@"房源收藏->删除", @"失败")
            
        }

    }];
    
}

#pragma mark - 模型转换
///将出租房数据模型转换为比一比数据模型
- (QSYComparisonDataModel *)comparisonChangeRentHouseModelToPrivaryModel:(QSRentHouseDetailDataModel *)rentModel
{

    QSYComparisonDataModel *comparisonModel = [[QSYComparisonDataModel alloc] init];
    
    comparisonModel.houseID = rentModel.house.id_;
    comparisonModel.communityName = rentModel.house.village_name;
    comparisonModel.score = [NSString stringWithFormat:@"%.1f",[rentModel.house.tj_condition floatValue] + [rentModel.house.tj_environment floatValue]];
    comparisonModel.districe = [QSCoreDataManager getDistrictValWithDistrictKey:rentModel.house.areaid];
    comparisonModel.street = [QSCoreDataManager getStreetValWithStreetKey:rentModel.house.street];
    comparisonModel.address = rentModel.house.address;
    comparisonModel.area = rentModel.house.house_area;
    comparisonModel.house_shi = rentModel.house.house_shi;
    comparisonModel.house_ting = rentModel.house.house_ting;
    comparisonModel.house_wei = rentModel.house.house_wei;
    comparisonModel.lift = [rentModel.house.elevator isEqualToString:@"Y"] ? @"有电梯" : @"无电梯";
    
    ///租金支付方式
    NSString *rentPayType = [QSCoreDataManager getHouseRentTypeWithKey:rentModel.house.payment];
    comparisonModel.rentPayType = [rentPayType length] > 0 ? rentPayType : @"面议";
    comparisonModel.leadTime = [QSCoreDataManager getRentHouseLeadTimeTypeWithKey:rentModel.house.lead_time];
    
    ///0-在租，1-自住，2-吉屋
    int houseStatus = [rentModel.house.house_status intValue];
    comparisonModel.houseStatus = houseStatus == 1 ? @"自住" : (houseStatus == 0 ? @"在租" : @"吉屋");
    comparisonModel.price = [NSString stringWithFormat:@"%.0f",[rentModel.house.rent_price floatValue]];
    comparisonModel.floor_sum = rentModel.house.floor_num;
    comparisonModel.floor_which = rentModel.house.floor_which;
    comparisonModel.face = [QSCoreDataManager getHouseFaceTypeWithKey:rentModel.house.house_face];
    comparisonModel.decoration = [QSCoreDataManager getHouseDecorationTypeWithKey:rentModel.house.decoration_type];
    
    return comparisonModel;

}

///将二手房数据模型转换为比一比数据模型
- (QSYComparisonDataModel *)comparisonChangeSecondHandHouseModelToPrivaryModel:(QSSecondHouseDetailDataModel *)rentModel
{

    QSYComparisonDataModel *comparisonModel = [[QSYComparisonDataModel alloc] init];
    
    comparisonModel.houseID = rentModel.house.id_;
    comparisonModel.communityName = rentModel.house.village_name;
    comparisonModel.score = [NSString stringWithFormat:@"%.1f",[rentModel.house.tj_condition floatValue] + [rentModel.house.tj_environment floatValue]];
    comparisonModel.districe = [QSCoreDataManager getDistrictValWithDistrictKey:rentModel.house.areaid];
    comparisonModel.street = [QSCoreDataManager getStreetValWithStreetKey:rentModel.house.street];
    comparisonModel.address = rentModel.house.address;
    comparisonModel.area = rentModel.house.house_area;
    comparisonModel.house_shi = rentModel.house.house_shi;
    comparisonModel.house_ting = rentModel.house.house_ting;
    comparisonModel.house_wei = rentModel.house.house_wei;
    comparisonModel.lift = [rentModel.house.elevator isEqualToString:@"Y"] ? @"有电梯" : @"无电梯";
    
    ///总价
    CGFloat totalPrice = [rentModel.house.house_price floatValue];
    
    ///代款利率
    CGFloat monthRate = 0.48;
    
    comparisonModel.price = [NSString stringWithFormat:@"%.0f",totalPrice / 10000.0f];
    comparisonModel.avg_price = [NSString stringWithFormat:@"%.2f",[rentModel.house.price_avg floatValue]];
    comparisonModel.downPayPrice = [NSString stringWithFormat:@"%.0f",totalPrice * 0.3f / 10000.0f];
    
    ///月供
    CGFloat monthPay = [NSString calculateMonthlyMortgatePayment:totalPrice * 0.3f andPaymentType:lLoadRatefeeBusinessLoan andRate:monthRate andTimes:240];
    comparisonModel.monthPrice = [NSString stringWithFormat:@"%.0f",monthPay];
    
    comparisonModel.buildingYear = [[NSDate formatNSTimeToNSDateString:rentModel.house.building_year] substringToIndex:4];
    comparisonModel.rightYear = rentModel.house.used_year;
    comparisonModel.floor_sum = rentModel.house.floor_num;
    comparisonModel.floor_which = rentModel.house.floor_which;
    comparisonModel.face = [QSCoreDataManager getHouseFaceTypeWithKey:rentModel.house.house_face];
    comparisonModel.decoration = [QSCoreDataManager getHouseDecorationTypeWithKey:rentModel.house.decoration_type];
    
    return comparisonModel;

}

#pragma mark - 预约
- (void)bookSecondHandHouse
{
    
    QSSecondHouseDetailDataModel *tempModel = self.houseOriginalList[0];
    
    ///进入预约
    QSPOrderBookTimeViewController *bookTimeVc = [[QSPOrderBookTimeViewController alloc] initWithSubmitCallBack:^(BOOKTIME_RESULT_TYPE resultTag,NSString *orderID) {
        
        if (bBookResultTypeSucess == resultTag) {
            
            ///预约成功，刷新详情数据
            tempModel.expandInfo.is_book = APPLICATION_NSSTRING_SETTING_NIL(orderID);
            
        }
        
    }];
    [bookTimeVc setHouseType:fFilterMainTypeSecondHouse];
    [bookTimeVc setVcType:bBookTypeViewControllerBook];
    [bookTimeVc setHouseInfo:tempModel.house];
    [self.navigationController pushViewController:bookTimeVc animated:YES];

}

- (void)bookRentHouse
{
    
    QSRentHouseDetailDataModel *tempModel = self.houseOriginalList[0];

    ///已登录进入预约
    QSPOrderBookTimeViewController *bookTimeVc = [[QSPOrderBookTimeViewController alloc] initWithSubmitCallBack:^(BOOKTIME_RESULT_TYPE resultTag,NSString *orderID) {
        
        if (bBookResultTypeSucess == resultTag) {
            
            ///预约成功，刷新详情数据
            tempModel.expandInfo.is_book = APPLICATION_NSSTRING_SETTING_NIL(orderID);
            
        }
        
    }];
    [bookTimeVc setHouseType:fFilterMainTypeRentalHouse];
    [bookTimeVc setVcType:bBookTypeViewControllerBook];
    [bookTimeVc setHouseInfo:tempModel.house];
    [self.navigationController pushViewController:bookTimeVc animated:YES];

}

#pragma mark - 查看预约信息
- (void)gotoSecondHandHouseBookOrderInfo
{
    
    QSSecondHouseDetailDataModel *tempModel = self.houseOriginalList[0];

    ///已登录进入预约
    QSPOrderDetailBookedViewController *orderDetailPage = [[QSPOrderDetailBookedViewController alloc] init];
    orderDetailPage.orderID = tempModel.expandInfo.is_book;
    [orderDetailPage setOrderType:mOrderWithUserTypeAppointment];
    [self.navigationController pushViewController:orderDetailPage animated:YES];

}

- (void)gotoRentHouseBookOrderInfo
{
    
    QSRentHouseDetailDataModel *tempModel = self.houseOriginalList[0];

    ///已登录进入预约
    QSPOrderDetailBookedViewController *orderDetailPage = [[QSPOrderDetailBookedViewController alloc] init];
    orderDetailPage.orderID = tempModel.expandInfo.is_book;
    [orderDetailPage setOrderType:mOrderWithUserTypeAppointment];
    [self.navigationController pushViewController:orderDetailPage animated:YES];

}

#pragma mark - 重写返回事件
- (void)gotoTurnBackAction
{

    ///返回列表
    APPLICATION_JUMP_BACK_STEPVC(3)

}

@end

@implementation QSYComparisonDataModel



@end