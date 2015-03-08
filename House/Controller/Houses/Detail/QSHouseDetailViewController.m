//
//  QSHouseDetailViewController.m
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHouseDetailViewController.h"
#import "QSAutoScrollView.h"

#import "QSImageView+Block.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "NSDate+Formatter.h"

#import "QSNewHouseDetailDataModel.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+App.h"

#import "MJRefresh.h"


#import <objc/runtime.h>

///关联
static char RootscrollViewKey;//!<底view的关联key
static char DetailRootViewKey;      //!<所有信息的view
static char BottomButtonRootViewKey;//!<底部按钮的底view关联
static char MainInfoRootViewKey;    //!<主信息的底view关联

static char SecondInfoRootViewKey;  //!<详情信息以下所有信息的底view关联Key

static char RightScoreKey;          //!<右侧评分
static char RightStarKey;           //!<右侧星级
static char LeftScoreKey;           //!<左侧评分
static char LeftStarKey;            //!<左侧星级

@interface QSHouseDetailViewController () <UIScrollViewDelegate>

@property (nonatomic,copy) NSString *title;                 //!<标题
@property (nonatomic,copy) NSString *detailID;              //!<详情的ID
@property (nonatomic,assign) FILTER_MAIN_TYPE detailType;   //!<详情的类型

@end

@implementation QSHouseDetailViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-02-12 12:02:39
 *
 *  @brief              根据标题、ID创建详情页面，可以是房子详情，或者小区详情
 *
 *  @param title        标题
 *  @param detailID     详情的ID
 *  @param detailType   详情的类型：房子/小区等
 *
 *  @return             返回当前创建的详情页指针
 *
 *  @since              1.0.0
 */
- (instancetype)initWithTitle:(NSString *)title andDetailID:(NSString *)detailID andDetailType:(FILTER_MAIN_TYPE)detailType
{

    if (self = [super init]) {
        
        ///保存相关参数
        self.title = title;
        self.detailID = detailID;
        self.detailType = detailType;
        
    }
    
    return self;

}

#pragma mark - UI搭建
///重写导航栏，添加标题信息
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:(self.title ? self.title : @"详情")];

}

///主展示信息
- (void)createMainShowUI
{
    
    ///所有信息的底view
    QSScrollView *rootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    [self.view addSubview:rootView];
    objc_setAssociatedObject(self, &DetailRootViewKey, rootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///添加刷新
    [rootView addHeaderWithTarget:self action:@selector(getNewHouseDetailInfo)];
    
    ///主题图片
    UIImageView *headerImageView=[[UIImageView alloc] init];
    headerImageView.frame = CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT*560/1334);
    headerImageView.image=[UIImage imageNamed:@"houses_list_load_fail690x350"];
    
    ///分数view
    UIView *scoreView = [[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, headerImageView.frame.origin.y+headerImageView.frame.size.height-(SIZE_DEVICE_WIDTH*160.0f/750.0f+9.0f)/2.0f, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_WIDTH*160.0f/750.0f+9.0f)];
    [self createScoreUI:scoreView];
    
    ///房子统计view
    UIView *houseTotalView = [[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, scoreView.frame.origin.y+scoreView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*3.0f+44.0f+3.0f*10.0f+2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createHouseTotalUI:houseTotalView];
    
    UIView *houseDetailView = [[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseTotalView.frame.origin.y+houseTotalView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*4.0f+3.0f*5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createHouseDetailViewUI:houseDetailView];
    //houseDetailView.backgroundColor = [UIColor blueColor];
    
     UIView *houseServiceView=[[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseDetailView.frame.origin.y+houseDetailView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, (SIZE_DEFAULT_MAX_WIDTH-6.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)/5.0f+20.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT+8.0f+5.0f)];
    [self createHouseServiceViewUI:houseServiceView];
    
     UIView *priceChangeView=[[UIView alloc] initWithFrame:CGRectMake(2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseServiceView.frame.origin.y+houseServiceView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*2.0f+5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createPriceChangeViewUI:priceChangeView];
    
     UIView *districtAveragePriceView=[[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, priceChangeView.frame.origin.y+priceChangeView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*2.0f+5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createDistrictAveragePriceViewUI:districtAveragePriceView];
    
     UIView *houseAttentionView=[[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, districtAveragePriceView.frame.origin.y+districtAveragePriceView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*2.0f+5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createHouseAttentionViewUI:houseAttentionView];
    
     UIView *commentView=[[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseAttentionView.frame.origin.y+houseAttentionView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*2.0f+5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createCommentViewUI:commentView];

    UIView *operateView=[[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, commentView.frame.origin.y+commentView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*2.0f+5.0f+35.0f+3*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createOperateViewUI:operateView];
    
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, headerImageView.frame.size.height+scoreView.frame.size.height+houseTotalView.frame.size.height+houseDetailView.frame.size.height+houseServiceView.frame.size.height+priceChangeView.frame.size.height+districtAveragePriceView.frame.size.height+houseAttentionView.frame.size.height+commentView.frame.size.height+ operateView.frame.size.height)];
    
    [scrollView addSubview:headerImageView];
    [scrollView addSubview:scoreView];
    [scrollView addSubview:houseTotalView];
    [scrollView addSubview:houseDetailView];
    [scrollView addSubview:houseServiceView];
    [scrollView addSubview:priceChangeView];
    [scrollView addSubview:districtAveragePriceView];
    [scrollView addSubview:houseAttentionView];
    [scrollView addSubview:commentView];
    [scrollView addSubview:operateView];
    
    
    ///取消滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    ///透明背影
    scrollView.backgroundColor=[UIColor clearColor];
    
    ///设置数据源和代理
    scrollView.delegate = self;
    scrollView.scrollEnabled=YES;
    scrollView.contentSize=CGSizeMake(SIZE_DEVICE_WIDTH,2000.0f);
    
    [self.view addSubview:scrollView];
    objc_setAssociatedObject(self, &RootscrollViewKey, scrollView, OBJC_ASSOCIATION_ASSIGN);
    
    ///底部按钮
    UIView *bottomRootView = [[UIView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT-64.0f-60.0f, SIZE_DEFAULT_MAX_WIDTH, 60.0f)];
    [self.view addSubview:bottomRootView];
    bottomRootView.hidden = YES;
    objc_setAssociatedObject(self, &BottomButtonRootViewKey, bottomRootView, OBJC_ASSOCIATION_ASSIGN);
    [self createBottomButtonViewUI:YES];
    
    ///添加头部刷新
    [scrollView addHeaderWithTarget:self action:@selector(getDetailInfo)];
    [scrollView headerBeginRefreshing];

    

}

#pragma mark - 显示信息UI:网络请求成功后才显示UI
///显示信息UI:网络请求成功后才显示UI
- (void)showInfoUI:(BOOL)flag
{
    
    UIView *mainInfoView = objc_getAssociatedObject(self, &MainInfoRootViewKey);
    UIView *bottomView = objc_getAssociatedObject(self, &BottomButtonRootViewKey);
    
    if (flag) {
        
        mainInfoView.hidden = NO;
        bottomView.hidden = NO;
        
    } else {
        
        mainInfoView.hidden = YES;
        bottomView.hidden = YES;
        
    }
    
}

#pragma mark -添加头部图片
///添加头部图片
- (void)createHeaderImageUI:(UIView *)view
{
    

   

}

#pragma mark -添加评分view
///添加评分view
-(void)createScoreUI:(UIView *)view
{
    
    ///左边六角形图标
//    QSImageView *leftImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH*120.0f/750.0f, SIZE_DEVICE_WIDTH*120.0f/750.0f+7.0f)];
//    leftImageView.image = [UIImage imageNamed:IMAGE_HOUSES_LIST_SIXFORM];
//    leftImageView.center = CGPointMake(SIZE_DEVICE_WIDTH*120.0f/750.0f/ 2.0f, view.frame.size.height/2.0f);
//    [view addSubview:leftImageView];
    
    ///中间六角形图标
    QSImageView *middleImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH*160.0f/750.0f, SIZE_DEVICE_WIDTH*160.0f/750.0f+9.0f)];
    middleImageView.image = [UIImage imageNamed:IMAGE_HOUSES_LIST_SIXFORM];
    middleImageView.center = CGPointMake(view.frame.size.width / 2.0f, view.frame.size.height/2.0f);
    [view addSubview:middleImageView];
    
    ///右边六角形图标
//    QSImageView *rightImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH*120.0f/750.0f, SIZE_DEVICE_WIDTH*120.0f/750.0f+7.0f)];
//    rightImageView.image = [UIImage imageNamed:IMAGE_HOUSES_LIST_SIXFORM];
//    rightImageView.center = CGPointMake(view.frame.size.width-SIZE_DEVICE_WIDTH*120.0f/750.0f/ 2.0f, view.frame.size.height/2.0f);
//    [view addSubview:rightImageView];
    
    ///右侧评分底view
    QSImageView *rightScoreRootView = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 60.0f, (view.frame.size.height - 64.0f) / 2.0f, 60.0f, 64.0f)];
    [self createDetailScoreInfoUI:rightScoreRootView andDetailTitle:@"周边条件" andScoreKey:RightScoreKey andStarKey:RightStarKey];
    [view addSubview:rightScoreRootView];
    
    ///左侧评分底view
    QSImageView *leftScoreRootView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, (view.frame.size.height - 64.0f) / 2.0f, 60.0f, 64.0f)];
    [self createDetailScoreInfoUI:leftScoreRootView andDetailTitle:@"内部条件" andScoreKey:LeftScoreKey andStarKey:LeftStarKey];
    [view addSubview:leftScoreRootView];
    
}

///创建详情评分UI
- (void)createDetailScoreInfoUI:(UIView *)view andDetailTitle:(NSString *)detailTitle andScoreKey:(char)scoreKey andStarKey:(char)starKey
{
    
    ///头图片
    QSImageView *imageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 32.0f)];
    imageView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_DETAIL_SCORE];
    [view addSubview:imageView];
    
    ///评分
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.0f, 5.0f, view.frame.size.width - 8.0f - 15.0f, 25.0f)];
    scoreLabel.text = @"4.5";
    scoreLabel.textAlignment = NSTextAlignmentRight;
    scoreLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    scoreLabel.textColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:scoreLabel];
    objc_setAssociatedObject(self, &scoreKey, scoreLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///单位
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(scoreLabel.frame.origin.x + scoreLabel.frame.size.width, scoreLabel.frame.origin.y + scoreLabel.frame.size.height - 20.0f, 20.0f, 20.0f)];
    unitLabel.text = @"分";
    unitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    unitLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:unitLabel];
    
    ///说明文字
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.0f, scoreLabel.frame.origin.y + scoreLabel.frame.size.height, view.frame.size.width - 6.0f, 15.0f)];
    titleLabel.text = detailTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_12];
    [view addSubview:titleLabel];
    
    ///星级
    QSImageView *starRootImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, view.frame.size.height - 12.0f, view.frame.size.width, 12.0f)];
    starRootImageView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_STAR_GRAY];
    [view addSubview:starRootImageView];
    
    UIView *starRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, starRootImageView.frame.size.height)];
    starRootView.clipsToBounds = YES;
    [starRootImageView addSubview:starRootView];
    
    QSImageView *yellowStarView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, starRootImageView.frame.size.width, starRootImageView.frame.size.height)];
    yellowStarView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_STAR_YELLOW];
    [starRootView addSubview:yellowStarView];
    
}


#pragma mark -添加物业总价view
///添加物业总价
- (void)createHouseTotalUI:(UIView *)view
{
    
    UILabel *hoeseTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 100.0f, 20.0f)];
    hoeseTotalLabel.text=@"物业总价";
    hoeseTotalLabel.textAlignment=NSTextAlignmentLeft;
    [view addSubview:hoeseTotalLabel];
    
    UILabel *areaSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-100.0f, 10.0f, 100.0f, 20.0f)];
    areaSizeLabel.text=@"面积大小";
    areaSizeLabel.textAlignment=NSTextAlignmentRight;
    [view addSubview:areaSizeLabel];
    
    UILabel *priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, hoeseTotalLabel.frame.origin.y+hoeseTotalLabel.frame.size.height+10.0f, view.frame.size.width/2.0f-3.0f, 44.0f)];
    priceLabel.textAlignment=NSTextAlignmentCenter;
    priceLabel.text=@"340万";
    priceLabel.font=[UIFont systemFontOfSize:25.0f];
    priceLabel.layer.cornerRadius=6.0f;
    priceLabel.backgroundColor=COLOR_CHARACTERS_YELLOW;
    [view addSubview:priceLabel];
    
    UILabel *areaLabel=[[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.size.width+6.0f, hoeseTotalLabel.frame.origin.y+hoeseTotalLabel.frame.size.height+10.0f, priceLabel.frame.size.width, 44.0f)];
    areaLabel.textAlignment=NSTextAlignmentCenter;
    areaLabel.text=@"124/m";
    areaLabel.font=[UIFont systemFontOfSize:25.0f];
    areaLabel.layer.cornerRadius=6.0f;
    areaLabel.backgroundColor=COLOR_CHARACTERS_YELLOW;
    [view addSubview:areaLabel];
    
    UILabel *onlyHouseLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, priceLabel.frame.origin.y+priceLabel.frame.size.height+10.0f, 65.0f, 20.0f)];
    onlyHouseLabel.textAlignment=NSTextAlignmentCenter;
    onlyHouseLabel.text=@"唯一房产";
    onlyHouseLabel.font=[UIFont systemFontOfSize:14.0f];
    onlyHouseLabel.backgroundColor=COLOR_CHARACTERS_BLACK;
    onlyHouseLabel.textColor=[UIColor whiteColor];
    [view addSubview:onlyHouseLabel];
    
    UILabel *fiveYearLabel=[[UILabel alloc] initWithFrame:CGRectMake(onlyHouseLabel.frame.origin.x+onlyHouseLabel.frame.size.width+5.0f, priceLabel.frame.origin.y+priceLabel.frame.size.height+10.0f, 65.0f, 20.0f)];
    fiveYearLabel.textAlignment=NSTextAlignmentCenter;
    fiveYearLabel.text=@"满五年";
    fiveYearLabel.font=[UIFont systemFontOfSize:14.0f];
    fiveYearLabel.backgroundColor=COLOR_CHARACTERS_BLACK;
    fiveYearLabel.textColor=[UIColor whiteColor];
    [view addSubview:fiveYearLabel];
    
    UILabel *degreeHouseLabel=[[UILabel alloc] initWithFrame:CGRectMake(fiveYearLabel.frame.origin.x+fiveYearLabel.frame.size.width+5.0f, priceLabel.frame.origin.y+priceLabel.frame.size.height+10.0f, 65.0f, 20.0f)];
    degreeHouseLabel.textAlignment=NSTextAlignmentCenter;
    degreeHouseLabel.font=[UIFont systemFontOfSize:14.0f];
    degreeHouseLabel.backgroundColor=COLOR_CHARACTERS_BLACK;
    degreeHouseLabel.textColor=[UIColor whiteColor];
    degreeHouseLabel.text=@"学位房";
    
    [view addSubview:degreeHouseLabel];
    
    UILabel *downPaymentLabel=[[UILabel alloc] initWithFrame:CGRectMake(degreeHouseLabel.frame.origin.x+degreeHouseLabel.frame.size.width+5.0f, priceLabel.frame.origin.y+priceLabel.frame.size.height+10.0f, 65.0f, 20.0f)];
    downPaymentLabel.textAlignment=NSTextAlignmentCenter;
    downPaymentLabel.text=@"低首付";
    downPaymentLabel.font=[UIFont systemFontOfSize:14.0f];
    downPaymentLabel.backgroundColor=COLOR_CHARACTERS_BLACK;
    downPaymentLabel.textColor=[UIColor whiteColor];
    [view addSubview:downPaymentLabel];
    
    UILabel *addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, downPaymentLabel.frame.origin.y+downPaymentLabel.frame.size.height+10.0f, SIZE_DEFAULT_MAX_WIDTH-100.0f, 20.0f)];
    addressLabel.textAlignment=NSTextAlignmentCenter;
    addressLabel.text=@"番禺/大石/大石海滨花园 西槎路粤西南路";
    addressLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:addressLabel];
    
    ///补充信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressLabel.frame.origin.x + addressLabel.frame.size.width, addressLabel.frame.origin.y, 70.0f, 20.0f)];
    tipsLabel.text = @"(查看地图)";
    tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    tipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    [view addSubview:tipsLabel];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -添加房子详情view
///添加房子详情view
-(void)createHouseDetailViewUI:(UIView *)view
{
    
    UILabel *houseTypeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    houseTypeLabel.text=@"户型:一室一厅";
    houseTypeLabel.textAlignment=NSTextAlignmentLeft;
    houseTypeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:houseTypeLabel];
    
    UILabel *typeLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    typeLabel.text=@"类型:公寓";
    typeLabel.textAlignment=NSTextAlignmentLeft;
    typeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:typeLabel];
    
    UILabel *orientationsLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, houseTypeLabel.frame.origin.y+houseTypeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    orientationsLabel.textAlignment=NSTextAlignmentLeft;
      orientationsLabel.font=[UIFont systemFontOfSize:14.0f];
    orientationsLabel.text=@"朝向:东南西北中";
    [view addSubview:orientationsLabel];
    
    UILabel *layerCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, houseTypeLabel.frame.origin.y+houseTypeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    layerCountLabel.text=@"层数:23/38层";
    layerCountLabel.textAlignment=NSTextAlignmentLeft;
      layerCountLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:layerCountLabel];
    
    UILabel *decoreteLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, layerCountLabel.frame.origin.y+layerCountLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    decoreteLabel.textAlignment=NSTextAlignmentLeft;
      decoreteLabel.font=[UIFont systemFontOfSize:14.0f];
    decoreteLabel.text=@"装修:精装修";
    [view addSubview:decoreteLabel];
    
    UILabel *timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, layerCountLabel.frame.origin.y+layerCountLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    timeLabel.text=@"年代:2008年";
    timeLabel.textAlignment=NSTextAlignmentLeft;
    timeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:timeLabel];
    
    UILabel *structureLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, timeLabel.frame.origin.y+timeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    structureLabel.textAlignment=NSTextAlignmentLeft;
    structureLabel.font=[UIFont systemFontOfSize:14.0f];
    structureLabel.text=@"结构:混合";
    [view addSubview:structureLabel];
    
    UILabel *propertyLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, timeLabel.frame.origin.y+timeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    propertyLabel.text=@"产权:50年使用权";
    propertyLabel.font=[UIFont systemFontOfSize:14.0f];
    propertyLabel.textAlignment=NSTextAlignmentLeft;
    [view addSubview:propertyLabel];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -添加房子服务按钮view
///添加房子服务按钮view
-(void)createHouseServiceViewUI:(UIView *)view
{
    
    CGFloat imageW = (view.frame.size.width - 4.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 5.0f;
    CGFloat imageH = imageW +5.0f;
    CGFloat imageY = SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    
    CGFloat labelW = imageW;
    CGFloat labelY = imageY+imageH+8.0f;
    
    QSImageView *bagStay=[[QSImageView alloc] initWithFrame:CGRectMake(0.0f, imageY, imageW,imageH )];
    bagStay.image=[UIImage imageNamed:@"houses_bag"];
    [view addSubview:bagStay];
    
    QSLabel *bagStayLabel=[[QSLabel alloc] initWithFrame:CGRectMake(0.0f, labelY, labelW,20.0f)];
    bagStayLabel.text=@"拎包入住";
    bagStayLabel.textAlignment=NSTextAlignmentCenter;
    bagStayLabel.font=[UIFont systemFontOfSize:12.0f];
    [view addSubview:bagStayLabel];
    
    
    QSImageView *appliance=[[QSImageView alloc] initWithFrame:CGRectMake(bagStay.frame.size.width+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, imageY, imageW, imageH)];
    appliance.image=[UIImage imageNamed:@"houses_appliance"];
    [view addSubview:appliance];
    
    QSLabel *applianceLabel=[[QSLabel alloc] initWithFrame:CGRectMake(appliance.frame.origin.x, labelY, imageW,20.0f)];
    applianceLabel.text=@"家电齐全";
    applianceLabel.textAlignment=NSTextAlignmentCenter;
    applianceLabel.font=[UIFont systemFontOfSize:12.0f];
    [view addSubview:applianceLabel];
    
    
    QSImageView *broadband=[[QSImageView alloc] initWithFrame:CGRectMake(appliance.frame.origin.x+appliance.frame.size.width+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, imageY, imageW, imageH)];
    broadband.image=[UIImage imageNamed:@"houses_broadband"];
    [view addSubview:broadband];
    
    QSLabel *broadbandLabel=[[QSLabel alloc] initWithFrame:CGRectMake(broadband.frame.origin.x, labelY, imageW,20.0f)];
    broadbandLabel.text=@"宽带网络";
    broadbandLabel.textAlignment=NSTextAlignmentCenter;
    broadbandLabel.font=[UIFont systemFontOfSize:12.0f];
    [view addSubview:broadbandLabel];
    
    
    QSImageView *linegas=[[QSImageView alloc] initWithFrame:CGRectMake(broadband.frame.origin.x+broadband.frame.size.width+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, imageY, imageW, imageH)];
    linegas.image=[UIImage imageNamed:@"houses_linegas"];
    [view addSubview:linegas];
    
    QSLabel *linegasLabel=[[QSLabel alloc] initWithFrame:CGRectMake(linegas.frame.origin.x, labelY, imageW,20.0f)];
    linegasLabel.text=@"管着煤气";
    linegasLabel.textAlignment=NSTextAlignmentCenter;
    linegasLabel.font=[UIFont systemFontOfSize:12.0f];
    [view addSubview:linegasLabel];
    
    
    QSImageView *mud=[[QSImageView alloc] initWithFrame:CGRectMake(linegas.frame.origin.x+linegas.frame.size.width+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, imageY, imageW, imageH)];
    mud.image=[UIImage imageNamed:@"houses_mud"];
    [view addSubview:mud];
    
    QSLabel *mudLabel=[[QSLabel alloc] initWithFrame:CGRectMake(mud.frame.origin.x, labelY, imageW,20.0f)];
    mudLabel.text=@"硅藻泥墙";
    mudLabel.textAlignment=NSTextAlignmentCenter;
    mudLabel.font=[UIFont systemFontOfSize:12.0f];
    [view addSubview:mudLabel];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark - 搭建底部按钮
///创建底部按钮
- (void)createBottomButtonViewUI:(BOOL)isLooked
{
    
    ///获取底view
    UIView *view = objc_getAssociatedObject(self, &BottomButtonRootViewKey);
    
    ///清空原数据
    for (UIView *obj in [view subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, 0.25f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:sepLabel];
    
    ///根据是否已看房，创建不同的功能按钮
    if (isLooked) {
        
        ///按钮风格
        QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
        
        ///免费通话按钮
        buttonStyle.title = TITLE_HOUSES_DETAIL_NEW_FREECALL;
        UIButton *callFreeButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 8.0f, (view.frame.size.width - 3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            ///判断是否已登录
            
            
            ///已登录重新刷新数据
            
            
        }];
        [view addSubview:callFreeButton];
        
        ///我要看房按钮
        buttonStyle.title = TITLE_HOUSES_DETAIL_NEW_LOOKHOUSE;
        UIButton *lookHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake(callFreeButton.frame.origin.x + callFreeButton.frame.size.width + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, callFreeButton.frame.origin.y, callFreeButton.frame.size.width, callFreeButton.frame.size.height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            
            
        }];
        [view addSubview:lookHouseButton];
        
    } else {
        
        ///按钮风格
        QSBlockButtonStyleModel *buttonStyel = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
        
        ///免费通话按钮
        buttonStyel.title = TITLE_HOUSES_DETAIL_NEW_FREECALL;
        UIButton *callFreeButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 8.0f, view.frame.size.width - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f) andButtonStyle:buttonStyel andCallBack:^(UIButton *button) {
            
            ///判断是否已登录
            
            
            ///已登录重新刷新数据
            
            
        }];
        [view addSubview:callFreeButton];
        
    }
    
}


#pragma mark -添加房子价钱变动view
///添加房子价钱变动view
-(void)createPriceChangeViewUI:(UIView *)view
{
    
//    UILabel *changeLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, timeLabel.frame.origin.y+timeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
//    propertyLabel.text=@"产权:50年使用权";
//    propertyLabel.font=[UIFont systemFontOfSize:14.0f];
//    propertyLabel.textAlignment=NSTextAlignmentLeft;
//    [view addSubview:propertyLabel];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -添加小区均价view
///添加小区均价view
-(void)createDistrictAveragePriceViewUI:(UIView *)view
{
   
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -添加房源关注view
///添加房源关注view
-(void)createHouseAttentionViewUI:(UIView *)view
{
    
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -添加评论view
///添加评论view
-(void)createCommentViewUI:(UIView *)view
{
    
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -添加操作view
///添加操作view
-(void)createOperateViewUI:(UIView *)view
{
    
    
}

#pragma mark - 结束刷新动画
///结束刷新动画
- (void)endRefreshAnimination
{

    UIScrollView *scrollView = objc_getAssociatedObject(self, &RootscrollViewKey);
    [scrollView headerEndRefreshing];

}

#pragma mark - 请求详情信息
/**
 *  @author yangshengmeng, 15-02-12 14:02:44
 *
 *  @brief  请求详情信息
 *
 *  @since  1.0.0
 */
- (void)getDetailInfo
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self endRefreshAnimination];
        
    });

}

@end
