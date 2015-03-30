//
//  QSYComparisonViewController.m
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYComparisonViewController.h"

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
    [self.infoRootView addHeaderWithTarget:self action:@selector(createComparisonUI)];
    
    ///一开始就请求数据
    [self.infoRootView headerBeginRefreshing];

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
        
        [self.infoRootView headerEndRefreshing];
        
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
        
        ///登录登录
        [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
           
            ///已登录
            if (lLoginCheckActionTypeLogined == flag) {
                
                
                
            }
            
            ///重新登录
            if (lLoginCheckActionTypeLogined == flag) {
                
                
                
            }
            
        }];
        
    }];
    [self.infoRootView addSubview:appointButton];
    
    ///获取模型
    QSYComparisonDataModel *tempModel = self.houseList[0];
    
    ///收藏按钮
    QSBlockButtonStyleModel *shareButtonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeCollected];
    
    UIButton *shareButton = [UIButton createBlockButtonWithFrame:CGRectMake(appointButton.frame.origin.x + appointButton.frame.size.width + 10.0f, appointButton.frame.origin.y, 44.0f, appointButton.frame.size.height) andButtonStyle:shareButtonStyle andCallBack:^(UIButton *button) {
        
        ///判断是收藏还是删除收藏
        if (button.selected) {
            
            [self deleteHouseCollected];
            
        } else {
            
            [self addHouseCollected];
            
        }
        
    }];
    shareButton.selected = [QSCoreDataManager checkCollectedDataWithID:tempModel.houseID andCollectedType:self.houseType];
    [self.infoRootView addSubview:shareButton];
    
    ///地址信息
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, appointButton.frame.origin.y + appointButton.frame.size.height + 20.0f, widthBest, 15.0f)];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.textColor = COLOR_CHARACTERS_BLACK;
    addressLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    addressLabel.text = [NSString stringWithFormat:@"%@|%@",tempModel.districe,tempModel.street];
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
    [self.infoRootView addSubview:houseTypeLabel];
    
    ///分隔线
    UILabel *houseTypeSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpiontSepLabel, houseTypeLabel.frame.origin.y + houseTypeLabel.frame.size.height + 20.0f - 0.25f, self.infoRootView.frame.size.width - 2.0f * xpiontSepLabel, 0.25f)];
    houseTypeSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.infoRootView addSubview:houseTypeSepLabel];
    
    ///总价
    caclWith = [tempModel.price calculateStringDisplayWidthByFixedHeight:30.0f andFontSize:FONT_BODY_20] + 5.0f;
    widthResult = caclWith > (widthBest * 3.0f / 4.0f) ? (widthBest * 3.0f / 4.0f) : (caclWith < widthBest / 2.0f ? widthBest / 2.0f : caclWith);
    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - widthResult - 15.0f) / 2.0f, houseTypeLabel.frame.origin.y + houseTypeLabel.frame.size.height + 40.0f, widthResult, 30.0f)];
    totalPriceLabel.text = tempModel.price;
    totalPriceLabel.textAlignment = NSTextAlignmentRight;
    totalPriceLabel.textColor = COLOR_CHARACTERS_YELLOW;
    totalPriceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
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
    [self.infoRootView addSubview:rightYearLabel];
    
    ///分隔线
    UILabel *rightYearSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpiontSepLabel, rightYearLabel.frame.origin.y + rightYearLabel.frame.size.height + 20.0f - 0.25f, self.infoRootView.frame.size.width - 2.0f * xpiontSepLabel, 0.25f)];
    rightYearSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.infoRootView addSubview:rightYearSepLabel];
    
    ///电梯比率
    UILabel *liftRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, rightYearLabel.frame.origin.y + rightYearLabel.frame.size.height + 40.0f, widthBest, 15.0f)];
    liftRateLabel.text = [NSString stringWithFormat:@"%@/%@",tempModel.liftNum,tempModel.liftServerNum];
    liftRateLabel.textAlignment = NSTextAlignmentCenter;
    liftRateLabel.textColor = COLOR_CHARACTERS_GRAY;
    liftRateLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [self.infoRootView addSubview:liftRateLabel];
    
    ///电梯提示信息
    UILabel *liftTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, liftRateLabel.frame.origin.y + liftRateLabel.frame.size.height + 5.0f, widthBest, 15.0f)];
    liftTipsLabel.text = @"有电梯";
    liftTipsLabel.textAlignment = NSTextAlignmentCenter;
    liftTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    liftTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self.infoRootView addSubview:liftTipsLabel];
    
    ///分隔线
    UILabel *liftSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpiontSepLabel, liftTipsLabel.frame.origin.y + liftTipsLabel.frame.size.height + 20.0f - 0.25f, self.infoRootView.frame.size.width - 2.0f * xpiontSepLabel, 0.25f)];
    liftSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.infoRootView addSubview:liftSepLabel];
    
    ///朝向
    UILabel *faceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, liftTipsLabel.frame.origin.y + liftTipsLabel.frame.size.height + 40.0f, widthBest, 15.0f)];
    faceLabel.text = tempModel.face;
    faceLabel.textAlignment = NSTextAlignmentCenter;
    faceLabel.textColor = COLOR_CHARACTERS_GRAY;
    faceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [self.infoRootView addSubview:faceLabel];
    
    ///装修
    UILabel *decorationLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, faceLabel.frame.origin.y + faceLabel.frame.size.height + 5.0f, widthBest, 15.0f)];
    decorationLabel.text = tempModel.decoration;
    decorationLabel.textAlignment = NSTextAlignmentCenter;
    decorationLabel.textColor = COLOR_CHARACTERS_BLACK;
    decorationLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
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
    
    ///总价
    caclWith = [tempModel.price calculateStringDisplayWidthByFixedHeight:30.0f andFontSize:FONT_BODY_20] + 5.0f;
    widthResult = caclWith > (widthBest * 3.0f / 4.0f) ? (widthBest * 3.0f / 4.0f) : (caclWith < widthBest / 2.0f ? widthBest / 2.0f : caclWith);
    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - widthResult - 15.0f) / 2.0f, houseTypeLabel.frame.origin.y + houseTypeLabel.frame.size.height + 40.0f, widthResult, 30.0f)];
    totalPriceLabel.text = tempModel.price;
    totalPriceLabel.textAlignment = NSTextAlignmentRight;
    totalPriceLabel.textColor = COLOR_CHARACTERS_GRAY;
    totalPriceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
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
    [self.infoRootView addSubview:avgPriceLabel];
    
    ///首付信息
    caclWith = [tempModel.downPayPrice calculateStringDisplayWidthByFixedHeight:30.0f andFontSize:FONT_BODY_20] + 5.0f;
    widthResult = caclWith > (widthBest - 60.0f) ? (widthBest - 60.0f) : (caclWith < widthBest / 2.0f ? widthBest / 2.0f : caclWith);
    UILabel *downPaymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - widthResult - 60.0f) / 2.0f, avgPriceLabel.frame.origin.y + avgPriceLabel.frame.size.height + 40.0f, widthResult, 30.0f)];
    downPaymentLabel.text = tempModel.downPayPrice;
    downPaymentLabel.textAlignment = NSTextAlignmentRight;
    downPaymentLabel.textColor = COLOR_CHARACTERS_GRAY;
    downPaymentLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
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
    [self.infoRootView addSubview:monthPriceLabel];
    
    ///建筑时间
    UILabel *buildYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint + (widthBest - 60.0f) / 2.0f, monthPriceLabel.frame.origin.y + monthPriceLabel.frame.size.height + 40.0f, 60.0f, 30.0f)];
    buildYearLabel.text = tempModel.buildingYear;
    buildYearLabel.textAlignment = NSTextAlignmentRight;
    buildYearLabel.textColor = COLOR_CHARACTERS_GRAY;
    buildYearLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
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
    [self.infoRootView addSubview:rightYearLabel];
    
    ///电梯比率
    UILabel *liftRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, rightYearLabel.frame.origin.y + rightYearLabel.frame.size.height + 40.0f, widthBest, 15.0f)];
    liftRateLabel.text = [NSString stringWithFormat:@"%@/%@",tempModel.liftNum,tempModel.liftServerNum];
    liftRateLabel.textAlignment = NSTextAlignmentCenter;
    liftRateLabel.textColor = COLOR_CHARACTERS_GRAY;
    liftRateLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [self.infoRootView addSubview:liftRateLabel];
    
    ///电梯提示信息
    UILabel *liftTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, liftRateLabel.frame.origin.y + liftRateLabel.frame.size.height + 5.0f, widthBest, 15.0f)];
    liftTipsLabel.text = @"有电梯";
    liftTipsLabel.textAlignment = NSTextAlignmentCenter;
    liftTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    liftTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self.infoRootView addSubview:liftTipsLabel];
    
    ///朝向
    UILabel *faceLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, liftTipsLabel.frame.origin.y + liftTipsLabel.frame.size.height + 40.0f, widthBest, 15.0f)];
    faceLabel.text = tempModel.face;
    faceLabel.textAlignment = NSTextAlignmentCenter;
    faceLabel.textColor = COLOR_CHARACTERS_GRAY;
    faceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [self.infoRootView addSubview:faceLabel];
    
    ///装修
    UILabel *decorationLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, faceLabel.frame.origin.y + faceLabel.frame.size.height + 5.0f, widthBest, 15.0f)];
    decorationLabel.text = tempModel.decoration;
    decorationLabel.textAlignment = NSTextAlignmentCenter;
    decorationLabel.textColor = COLOR_CHARACTERS_BLACK;
    decorationLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
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
    titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [view addSubview:titleLabel];
    
    ///评分
    CGFloat scoreWidth = [tempModel.score calculateStringDisplayWidthByFixedHeight:heightMiddel andFontSize:FONT_BODY_30] + 10.0f;
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f - scoreWidth, titleLabel.frame.origin.y + titleLabel.frame.size.height, scoreWidth, heightMiddel)];
    scoreLabel.text = tempModel.score;
    scoreLabel.textAlignment = NSTextAlignmentRight;
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
- (void)addHouseCollected
{

    ///判断是否存在数据
    if (!self.houseList[1]) {
        
        return;
        
    }

}

#pragma mark - 删除收藏
- (void)deleteHouseCollected
{

    ///判断是否存在数据
    if (!self.houseList[1]) {
        
        return;
        
    }

}

#pragma mark - 模型转换
///将出租房数据模型转换为比一比数据模型
- (QSYComparisonDataModel *)comparisonChangeRentHouseModelToPrivaryModel:(QSRentHouseDetailDataModel *)rentModel
{

    return nil;

}

///将二手房数据模型转换为比一比数据模型
- (QSYComparisonDataModel *)comparisonChangeSecondHandHouseModelToPrivaryModel:(QSSecondHouseDetailDataModel *)rentModel
{

    QSYComparisonDataModel *comparisonModel = [[QSYComparisonDataModel alloc] init];
    
    comparisonModel.houseID = rentModel.house.id_;
    comparisonModel.communityName = rentModel.house.village_name;
    comparisonModel.score = @"7";
    comparisonModel.districe = [QSCoreDataManager getDistrictValWithDistrictKey:rentModel.house.areaid];
    comparisonModel.street = [QSCoreDataManager getStreetValWithStreetKey:rentModel.house.street];
    comparisonModel.address = rentModel.house.address;
    comparisonModel.area = rentModel.house.house_area;
    comparisonModel.house_shi = rentModel.house.house_shi;
    comparisonModel.house_ting = rentModel.house.house_ting;
    comparisonModel.house_wei = rentModel.house.house_wei;
    
    ///总价
    CGFloat totalPrice = [rentModel.house.house_area floatValue] * [rentModel.house.price_avg floatValue];
    
    ///代款利率
    CGFloat monthRate = 0.46;
    
    comparisonModel.price = [NSString stringWithFormat:@"%.0f",totalPrice / 10000.0f];
    comparisonModel.avg_price = [NSString stringWithFormat:@"%.2f",[rentModel.house.price_avg floatValue]];
    comparisonModel.downPayPrice = [NSString stringWithFormat:@"%.0f",totalPrice * 0.3f / 10000.0f];
    
    ///月供
    CGFloat monthPay = [NSString calculateMonthlyMortgatePayment:totalPrice * 0.3f andPaymentType:lLoadRatefeeBusinessLoan andRate:monthRate andTimes:240];
    comparisonModel.monthPrice = [NSString stringWithFormat:@"%.0f",monthPay];
    
    comparisonModel.buildingYear = [[NSDate formatNSTimeToNSDateString:rentModel.house.building_year] substringToIndex:4];
    comparisonModel.rightYear = rentModel.house.used_year;
    comparisonModel.liftNum = @"26";
    comparisonModel.liftServerNum = @"1023";
    comparisonModel.face = [QSCoreDataManager getHouseFaceTypeWithKey:rentModel.house.house_face];
    comparisonModel.decoration = [QSCoreDataManager getHouseDecorationTypeWithKey:rentModel.house.decoration_type];
    
    return comparisonModel;

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