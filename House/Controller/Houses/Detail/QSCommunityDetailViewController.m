//
//  QSCommunityDetailViewController.m
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCommunityDetailViewController.h"
#import "QSCommunityDetailViewCell.h"

#import "QSAutoScrollView.h"
#import "QSCustomHUDView.h"

#import "QSImageView+Block.h"
#import "UIImageView+CacheImage.h"
#import "NSString+Calculation.h"
#import "URLHeader.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "NSDate+Formatter.h"

#import "QSCommunityHousesDetailReturnData.h"
#import "QSCommunityHouseDetailDataModel.h"
#import "QSHouseInfoDataModel.h"

#import "QSWCommunityDataModel.h"
#import "QSPhotoDataModel.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+Collected.h"

#import "MJRefresh.h"



///左右限隙宏
#define SIZE_DEFAULT_HEIGHTTAP (SIZE_DEVICE_WIDTH >= 375.0f ? 20.0f : 15.0f)

#import <objc/runtime.h>

///关联
static char DetailRootViewKey;      //!<所有信息的view
static char BottomButtonRootViewKey;//!<底部按钮的底view关联
static char MainInfoRootViewKey;    //!<主信息的底view关联

@interface QSCommunityDetailViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSString *title;                         //!<标题
@property (nonatomic,copy) NSString *communityID;                   //!<小区的ID
@property (nonatomic,copy) NSString *commendNum;                    //!<推荐房源的个数
@property (nonatomic,copy) NSString *houseType;                     //!<推荐房源的类型：出租/二手

///详情信息的数据模型
@property (nonatomic,retain) QSCommunityHouseDetailDataModel *detailInfo;        //!<返回的基本数据模型，模型下带有2个基本模型，2个数组模型
@property (nonatomic,retain) QSWCommunityDataModel *houseInfo;          //!<基本模型数据

@property (nonatomic,retain) NSArray *photoArray;                      //!<图集数组
@property (nonatomic,retain) QSPhotoDataModel *village_photo;          //!<图片模型

@property (nonatomic,retain) NSArray *houseCommendArray;                   //!<推荐数组
@property (nonatomic,retain) QSHouseInfoDataModel *houseCommendModel;       //!<推荐模型

@property (nonatomic, strong) UITableView *tabbleView;              //!<小区信息view
//@property (nonatomic, retain) NSMutableArray *communityDataSource;  //!<小区推荐数据源

@end

@implementation QSCommunityDetailViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-03-12 16:03:11
 *
 *  @brief              创建小区详情页面
 *
 *  @param title        标题
 *  @param communityID  小区ID
 *  @param commendNum   小区详情中，推荐房源的个数
 *  @param houseType    是推荐二手房/出租房
 *
 *  @return             返回小区详情页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithTitle:(NSString *)title andCommunityID:(NSString *)communityID andCommendNum:(NSString *)commendNum andHouseType:(NSString *)houseType
{
    
    if (self = [super init]) {
        
        ///保存相关参数
        self.title = title;
        self.communityID = communityID;
        self.commendNum = commendNum;
        self.houseType = houseType;
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
///重写导航栏，添加标题信息
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:(self.title ? self.title : @"详情")];
    
    ///关注按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeCollected];
    
    UIButton *intentionButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 44.0f, 20.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///关注小区
        [self intentionCommunity:button];
        
    }];
    intentionButton.selected = [QSCoreDataManager checkCollectedDataWithID:self.communityID andCollectedType:fFilterMainTypeCommunity];
    [self.view addSubview:intentionButton];
    
}

///主展示信息
- (void)createMainShowUI
{
    
    ///所有信息的底view
    QSScrollView *rootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    [self.view addSubview:rootView];
    objc_setAssociatedObject(self, &DetailRootViewKey, rootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///添加头部刷新
    [rootView addHeaderWithTarget:self action:@selector(getCommunityDetailInfo)];
    
    ///其他信息底view
    QSScrollView *infoRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, rootView.frame.size.height)];
    [rootView addSubview:infoRootView];
    infoRootView.hidden = YES;
    objc_setAssociatedObject(self, &MainInfoRootViewKey, infoRootView, OBJC_ASSOCIATION_ASSIGN);
    
    [rootView headerBeginRefreshing];
    
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

#pragma mark - 创建数据UI：网络请求后，按数据创建不同的UI
///创建数据UI：网络请求后，按数据创建不同的UI
- (void)createNewDetailInfoViewUI:(QSCommunityHouseDetailDataModel *)dataModel
{
    
    ///信息底view
    UIScrollView *infoRootView = objc_getAssociatedObject(self, &MainInfoRootViewKey);
    
    ///清空原UI
    for (UIView *obj in [infoRootView subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
    ///主题图片
    UIImageView *headerImageView=[[UIImageView alloc] init];
    headerImageView.frame = CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT*560/1334);
    [headerImageView loadImageWithURL:[dataModel.village.attach_file getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_HOUSES_DETAIL_HEADER_DEFAULT_BG]];
    
    UIView *houseDetailView = [[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, headerImageView.frame.origin.y+headerImageView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*4.0f+3.0f*5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createHouseDetailViewUI:houseDetailView andHouseInfo:dataModel.village];
    
    QSBlockView *priceChangeView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseDetailView.frame.origin.y+houseDetailView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f+2.0f*SIZE_DEFAULT_HEIGHTTAP) andSingleTapCallBack:^(BOOL flag) {
        
        ///进入地图：需要传经纬度
        NSLog(@"点击进入小区二手房");
        
    }];
    
    [self createPriceChangeViewUI:priceChangeView andSecondHouseNum:dataModel.village.tj_secondHouse_num];
    
    QSBlockView *districtAveragePriceView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, priceChangeView.frame.origin.y+priceChangeView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f+2*SIZE_DEFAULT_HEIGHTTAP) andSingleTapCallBack:^(BOOL flag) {
        
        ///进入地图：需要传经纬度
        NSLog(@"点击进入小区出租房");
        
    }];
    [self createDistrictAveragePriceViewUI:districtAveragePriceView andRentHouseNum:dataModel.village.tj_rentHouse_num];
    
    ///小区房价走势view
    UIView *houseTotalView = [[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, districtAveragePriceView.frame.origin.y+districtAveragePriceView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f+5.0f+200.0f+2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createHouseTotalUI:houseTotalView andPrice:dataModel.village.price_avg];
    
    ///交通路线与统计view
    UIView *houseServiceView=[[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseTotalView.frame.origin.y+houseTotalView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, (SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)/5.0f)];
    [self createHouseServiceViewUI:houseServiceView];
    
    UIView *houseAttentionView=[[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseServiceView.frame.origin.y+houseServiceView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 25.0f+15.0f+5.0f+2*SIZE_DEFAULT_HEIGHTTAP)];
    [self createHouseAttentionViewUI:houseAttentionView];
    
    QSBlockView *commentView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseAttentionView.frame.origin.y+houseAttentionView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f+2*SIZE_DEFAULT_HEIGHTTAP)andSingleTapCallBack:^(BOOL flag) {
        
        ///进入地图：需要传经纬度
        NSLog(@"点击进入更多配套");
        
    }];
    [self createCommentViewUI:commentView];
    
    self.tabbleView=[[UITableView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, commentView.frame.origin.y+commentView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.houseCommendArray.count*100.0f)];
    self.tabbleView.delegate=self;
    self.tabbleView.dataSource=self;
    
    [infoRootView addSubview:headerImageView];
    [infoRootView addSubview:houseDetailView];
    [infoRootView addSubview:houseServiceView];
    [infoRootView addSubview:priceChangeView];
    [infoRootView addSubview:houseTotalView];
    [infoRootView addSubview:districtAveragePriceView];
    [infoRootView addSubview:houseAttentionView];
    [infoRootView addSubview:commentView];
    [infoRootView addSubview:self.tabbleView];
    
    ///透明背影
    infoRootView.backgroundColor=[UIColor clearColor];
    
    ///设置数据源和代理
    infoRootView.delegate = self;
    infoRootView.scrollEnabled=YES;
    infoRootView.contentSize=CGSizeMake(SIZE_DEVICE_WIDTH,_tabbleView.frame.origin.y+_tabbleView.frame.size.height);
    
}

#pragma mark -添加房子详情view
///添加房子详情view
-(void)createHouseDetailViewUI:(UIView *)view andHouseInfo:(QSWCommunityDataModel *)houseInfo
{
    
    UILabel *houseTypeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    houseTypeLabel.text=[NSString stringWithFormat:@"物业费:%@",houseInfo.fee];
    houseTypeLabel.textAlignment=NSTextAlignmentLeft;
    houseTypeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:houseTypeLabel];
    
    UILabel *typeLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    typeLabel.text=[NSString stringWithFormat:@"房屋总数:%@",houseInfo.households_num];
    typeLabel.textAlignment=NSTextAlignmentLeft;
    typeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:typeLabel];
    
    UILabel *orientationsLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, houseTypeLabel.frame.origin.y+houseTypeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    orientationsLabel.textAlignment=NSTextAlignmentLeft;
    orientationsLabel.font=[UIFont systemFontOfSize:14.0f];
    orientationsLabel.text=[NSString stringWithFormat:@"楼栋总数:%@",houseInfo.buildings_num];
    [view addSubview:orientationsLabel];
    
    UILabel *layerCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, houseTypeLabel.frame.origin.y+houseTypeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    layerCountLabel.text=[NSString stringWithFormat:@"绿化率:%@",houseInfo.green_rate];
    layerCountLabel.textAlignment=NSTextAlignmentLeft;
    layerCountLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:layerCountLabel];
    
    UILabel *decoreteLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, layerCountLabel.frame.origin.y+layerCountLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    decoreteLabel.textAlignment=NSTextAlignmentLeft;
    decoreteLabel.font=[UIFont systemFontOfSize:14.0f];
    decoreteLabel.text=[NSString stringWithFormat:@"容积率:%@",houseInfo.volume_rate];
    [view addSubview:decoreteLabel];
    
    UILabel *timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, layerCountLabel.frame.origin.y+layerCountLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    timeLabel.text=[NSString stringWithFormat:@"建筑时间:%@",houseInfo.building_year];
    timeLabel.textAlignment=NSTextAlignmentLeft;
    timeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:timeLabel];
    
    UILabel *structureLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, timeLabel.frame.origin.y+timeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    structureLabel.textAlignment=NSTextAlignmentLeft;
    structureLabel.font=[UIFont systemFontOfSize:14.0f];
    structureLabel.text=[NSString stringWithFormat:@"房屋类型:%@",[QSCoreDataManager getHouseTradeTypeWithKey:houseInfo.property_type]];
    [view addSubview:structureLabel];
    
    UILabel *propertyLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, timeLabel.frame.origin.y+timeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    propertyLabel.text=[NSString stringWithFormat:@"使用年限:%@",houseInfo.used_year];
    propertyLabel.font=[UIFont systemFontOfSize:14.0f];
    propertyLabel.textAlignment=NSTextAlignmentLeft;
    [view addSubview:propertyLabel];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -小区二手房view
///小区二手房view
-(void)createPriceChangeViewUI:(UIView *)view andSecondHouseNum:(NSString *)secondHouseNum
{
    
    ///二手房label
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_HEIGHTTAP, 80.0f, 15.0f)];
    userLabel.text = @"小区二手房";
    userLabel.textColor = COLOR_CHARACTERS_BLACK;
    userLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [view addSubview:userLabel];
    
    ///括号
    UILabel *unit1=[[UILabel alloc] initWithFrame:CGRectMake(userLabel.frame.origin.x+userLabel.frame.size.width+3.0f, SIZE_DEFAULT_HEIGHTTAP-5.0f, 10.0f, 25.0f)];
    unit1.text=@"(";
    unit1.font=[UIFont systemFontOfSize:20.0f];
    unit1.textAlignment=NSTextAlignmentCenter;
    [view addSubview:unit1];
    
    ///二手房数量
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(unit1.frame.origin.x+unit1.frame.size.width+3.0f, SIZE_DEFAULT_HEIGHTTAP-5.0f, 25.0f, 25.0f)];
    countLabel.text = [NSString stringWithFormat:@"%@",secondHouseNum];
    countLabel.textAlignment=NSTextAlignmentCenter;
    countLabel.textColor = COLOR_CHARACTERS_LIGHTYELLOW;
    countLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [view addSubview:countLabel];
    
    ///括号
    UILabel *unit2=[[UILabel alloc] initWithFrame:CGRectMake(countLabel.frame.origin.x+countLabel.frame.size.width+3.0f, SIZE_DEFAULT_HEIGHTTAP-5.0f, 10.0f, 25.0f)];
    unit2.text=@")";
    unit2.font=[UIFont systemFontOfSize:20.0f];
    unit2.textAlignment=NSTextAlignmentCenter;
    [view addSubview:unit2];
    
    ///右侧箭头
    QSImageView *arrowView = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 13.0f , view.frame.size.height / 2.0f - 11.5f, 13.0f, 23.0f)];
    arrowView.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [view addSubview:arrowView];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -添加小区出租房view
///添加小区均价view
-(void)createDistrictAveragePriceViewUI:(UIView *)view andRentHouseNum:(NSString *)rentHouseNum
{
    
    ///小区出租房
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_HEIGHTTAP, 80.0f, 15.0f)];
    userLabel.text = @"小区出租房";
    userLabel.textColor = COLOR_CHARACTERS_BLACK;
    userLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [view addSubview:userLabel];
    
    ///括号
    UILabel *unit1=[[UILabel alloc] initWithFrame:CGRectMake(userLabel.frame.origin.x+userLabel.frame.size.width+3.0f, SIZE_DEFAULT_HEIGHTTAP-5.0f, 10.0f, 25.0f)];
    unit1.text=@"(";
    unit1.font=[UIFont systemFontOfSize:20.0f];
    unit1.textAlignment=NSTextAlignmentCenter;
    [view addSubview:unit1];
    
    ///二手房数量
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(unit1.frame.origin.x+unit1.frame.size.width+3.0f, SIZE_DEFAULT_HEIGHTTAP-5.0f, 25.0f, 25.0f)];
    countLabel.text = [NSString stringWithFormat:@"%@",rentHouseNum];
    countLabel.textAlignment=NSTextAlignmentCenter;
    countLabel.textColor = COLOR_CHARACTERS_LIGHTYELLOW;
    countLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [view addSubview:countLabel];
    
    ///括号
    UILabel *unit2=[[UILabel alloc] initWithFrame:CGRectMake(countLabel.frame.origin.x+countLabel.frame.size.width+3.0f, SIZE_DEFAULT_HEIGHTTAP-5.0f, 10.0f, 25.0f)];
    unit2.text=@")";
    unit2.font=[UIFont systemFontOfSize:20.0f];
    unit2.textAlignment=NSTextAlignmentCenter;
    [view addSubview:unit2];
    
    ///右侧箭头
    QSImageView *arrowView = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 13.0f , view.frame.size.height / 2.0f - 11.5f, 13.0f, 23.0f)];
    arrowView.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [view addSubview:arrowView];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -小区房价走势view
///添加物业总价
- (void)createHouseTotalUI:(UIView *)view andPrice:(NSString *)price
{
    
    UILabel *hoeseTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_HEIGHTTAP+5.0f, 100.0f, 15.0f)];
    hoeseTotalLabel.text=@"小区房价走势";
    hoeseTotalLabel.textAlignment=NSTextAlignmentLeft;
    hoeseTotalLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:hoeseTotalLabel];
    
    UILabel *areaSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-80.0f - 95.0f - 35.0f, SIZE_DEFAULT_HEIGHTTAP+5.0f, 80.0f, 15.0f)];
    areaSizeLabel.text=[NSString stringWithFormat:@"最新均价:"];
    areaSizeLabel.textAlignment=NSTextAlignmentRight;
    areaSizeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:areaSizeLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width - 95.0f - 35.0f, SIZE_DEFAULT_HEIGHTTAP, 95.0f, 20.0f)];
    priceLabel.text = [NSString stringWithFormat:@"%@",price];
    priceLabel.textColor = COLOR_CHARACTERS_YELLOW;
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [view addSubview:priceLabel];
    
    ///单位
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width - 30.0f, SIZE_DEFAULT_HEIGHTTAP+5.0f, 35.0f, 10.0f)];
    unitLabel.text = [NSString stringWithFormat:@"元/%@",APPLICATION_AREAUNIT];
    unitLabel.textAlignment = NSTextAlignmentLeft;
    unitLabel.textColor = COLOR_CHARACTERS_BLACK;
    unitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:unitLabel];
    
    UIWebView *priceWeb=[[UIWebView alloc] initWithFrame:CGRectMake(0.0f, priceLabel.frame.origin.y+priceLabel.frame.size.height+5.0f, view.frame.size.width, 200.0f)];
    
    NSString *url=[NSString stringWithFormat:@"%@%@%@%@",URLFDangJiaAvgPriceTotal,@"?h=200",@"&total_type=990202&",self.communityID];
    [priceWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [view addSubview:priceWeb];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}


#pragma mark -添加房子服务按钮view
///添加房子服务按钮view
-(void)createHouseServiceViewUI:(UIView *)view
{
    
    CGFloat buttonW = view.frame.size.width / 5.0f;
    CGFloat buttonH = buttonW;
    CGFloat buttonY = 0.0f;
    QSBlockButtonStyleModel *buttonStyle=[QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    
    UIButton *bushButton=[QSBlockButton createBlockButtonWithFrame:CGRectMake(0.0f, buttonY, buttonW, buttonH) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"点击公交按钮事件");
        
    }];
    [bushButton setTitle:@"公交" forState:UIControlStateNormal];
    [bushButton setBackgroundImage:[UIImage imageNamed:@"houses_detail_busbutton_highlighted"] forState:UIControlStateHighlighted];
    [bushButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    [view addSubview:bushButton];
    
    ///分隔线
    UILabel *lineLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(bushButton.frame.origin.x+bushButton.frame.size.width-0.25f,SIZE_DEFAULT_HEIGHTTAP, 0.25,  view.frame.size.height-2.0f*SIZE_DEFAULT_HEIGHTTAP)];
    lineLabel0.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:lineLabel0];
    
    UIButton *subwayButton=[QSBlockButton createBlockButtonWithFrame:CGRectMake(bushButton.frame.origin.x+bushButton.frame.size.width, buttonY, buttonW, buttonH) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"点击地铁按钮事件");
        
    }];
    [subwayButton setTitle:@"地铁" forState:UIControlStateNormal];
     [subwayButton setBackgroundImage:[UIImage imageNamed:@"houses_detail_busbutton_highlighted"] forState:UIControlStateSelected];
    [view addSubview:subwayButton];
    
    ///分隔线
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(subwayButton.frame.origin.x+subwayButton.frame.size.width-0.25f,SIZE_DEFAULT_HEIGHTTAP, 0.25,  view.frame.size.height-2.0f*SIZE_DEFAULT_HEIGHTTAP)];
    lineLabel1.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:lineLabel1];
    
    UIButton *hospitalButton=[QSBlockButton createBlockButtonWithFrame:CGRectMake(subwayButton.frame.origin.x+subwayButton.frame.size.width, buttonY, buttonW, buttonH) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"点击医院按钮事件");
        
    }];
    [hospitalButton setTitle:@"医院" forState:UIControlStateNormal];
    [hospitalButton setBackgroundImage:[UIImage imageNamed:@"houses_detail_busbutton_highlighted"] forState:UIControlStateSelected];

    [view addSubview:hospitalButton];
    
    ///分隔线
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(hospitalButton.frame.origin.x+hospitalButton.frame.size.width-0.25f,SIZE_DEFAULT_HEIGHTTAP, 0.25, view.frame.size.height-2.0f*SIZE_DEFAULT_HEIGHTTAP)];
    lineLabel2.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:lineLabel2];
    
    UIButton *schoolButton=[QSBlockButton createBlockButtonWithFrame:CGRectMake(hospitalButton.frame.origin.x+hospitalButton.frame.size.width, buttonY, buttonW, buttonH) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"点击学校按钮事件");
        
        ///
        
    }];
    [schoolButton setTitle:@"学校" forState:UIControlStateNormal];
    [schoolButton setBackgroundImage:[UIImage imageNamed:@"houses_detail_busbutton_highlighted"] forState:UIControlStateSelected];

    [view addSubview:schoolButton];
    
    ///分隔线
    UILabel *lineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(schoolButton.frame.origin.x+schoolButton.frame.size.width-0.25f,SIZE_DEFAULT_HEIGHTTAP, 0.25,  view.frame.size.height-2.0f*SIZE_DEFAULT_HEIGHTTAP)];
    lineLabel3.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:lineLabel3];
    
    UIButton *cateringButton=[QSBlockButton createBlockButtonWithFrame:CGRectMake(schoolButton.frame.origin.x+schoolButton.frame.size.width, buttonY, buttonW, buttonH) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"点击餐饮按钮事件");
        
    }];
    [cateringButton setTitle:@"餐饮" forState:UIControlStateNormal];
    [cateringButton setBackgroundImage:[UIImage imageNamed:@"houses_detail_busbutton_highlighted"] forState:UIControlStateSelected];

    [view addSubview:cateringButton];
    
}

#pragma mark -添加房源关注view
///添加房源关注view
-(void)createHouseAttentionViewUI:(UIView *)view
{
    
    ///间隙
    CGFloat width = 1.0f/3.0f*view.frame.size.width-2.0f*10.0f;
    CGFloat gap = (view.frame.size.width - width * 3.0f) / 6.0f;
    
    ///公交路线
    UILabel *busLabel = [[UILabel alloc] initWithFrame:CGRectMake(gap, SIZE_DEFAULT_HEIGHTTAP+25.0f+5.0f, width, 15.0f)];
    busLabel.text = @"地铁";
    busLabel.textAlignment = NSTextAlignmentCenter;
    busLabel.textColor = COLOR_CHARACTERS_GRAY;
    busLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [view addSubview:busLabel];
    
    UILabel *busCountLable = [[UILabel alloc] initWithFrame:CGRectMake(gap, SIZE_DEFAULT_HEIGHTTAP, 25.0f, 25.0f)];
    busCountLable.text = @"2";
    busCountLable.textAlignment = NSTextAlignmentRight;
    busCountLable.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    busCountLable.textColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:busCountLable];
    
    UILabel *busCountUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(busCountLable.frame.origin.x + busCountLable.frame.size.width+2.0f, SIZE_DEFAULT_HEIGHTTAP+5.0f,width-busCountLable.frame.size.width, 15.0f)];
    busCountUnitLabel.text = @"条线路";
    busCountUnitLabel.textAlignment = NSTextAlignmentLeft;
    busCountUnitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    busCountUnitLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:busCountUnitLabel];
    
    ///分隔线
    UILabel *busSepLine = [[UILabel alloc] initWithFrame:CGRectMake(busLabel.frame.origin.x + busLabel.frame.size.width + gap, SIZE_DEFAULT_HEIGHTTAP, 0.25f, view.frame.size.height - 2.0f*SIZE_DEFAULT_HEIGHTTAP)];
    busSepLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:busSepLine];
    
    ///教育机构
    UILabel *techLabel = [[UILabel alloc] initWithFrame:CGRectMake(width+3.0f*gap, SIZE_DEFAULT_HEIGHTTAP+25.0f+5.0f, width, 15.0f)];
    techLabel.text = @"公交";
    techLabel.textAlignment = NSTextAlignmentCenter;
    techLabel.textColor = COLOR_CHARACTERS_GRAY;
    techLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [view addSubview:techLabel];
    
    UILabel *techCountLable = [[UILabel alloc] initWithFrame:CGRectMake(techLabel.frame.origin.x, SIZE_DEFAULT_HEIGHTTAP, 25.0f, 25.0f)];
    techCountLable.text = @"12";
    techCountLable.textAlignment = NSTextAlignmentRight;
    techCountLable.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    techCountLable.textColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:techCountLable];
    
    UILabel *techCountUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(techCountLable.frame.origin.x + techCountLable.frame.size.width, SIZE_DEFAULT_HEIGHTTAP+5.0f, width-techCountLable.frame.size.width, 15.0f)];
    techCountUnitLabel.text = @"条线路";
    techCountUnitLabel.textAlignment = NSTextAlignmentLeft;
    techCountUnitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    techCountUnitLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:techCountUnitLabel];
    
    ///分隔线
    UILabel *techSepLine = [[UILabel alloc] initWithFrame:CGRectMake(techLabel.frame.origin.x + techLabel.frame.size.width + gap, SIZE_DEFAULT_HEIGHTTAP, 0.25f, view.frame.size.height - 2.0*SIZE_DEFAULT_HEIGHTTAP)];
    techSepLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:techSepLine];
    
    ///医疗机构
    UILabel *medicalLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f*width+5.0f*gap, SIZE_DEFAULT_HEIGHTTAP+25.0f+5.0f, width, 15.0f)];
    medicalLabel.text = @"其他";
    medicalLabel.textAlignment = NSTextAlignmentCenter;
    medicalLabel.textColor = COLOR_CHARACTERS_GRAY;
    medicalLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [view addSubview:medicalLabel];
    
    UILabel *medicalCountLable = [[UILabel alloc] initWithFrame:CGRectMake(medicalLabel.frame.origin.x, SIZE_DEFAULT_HEIGHTTAP, 25.0f, 25.0f)];
    medicalCountLable.text = @"28";
    medicalCountLable.textAlignment = NSTextAlignmentRight;
    medicalCountLable.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    medicalCountLable.textColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:medicalCountLable];
    
    UILabel *medicalCountUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(medicalCountLable.frame.origin.x + medicalCountLable.frame.size.width+2.0f, SIZE_DEFAULT_HEIGHTTAP+5.0f, width-medicalCountLable.frame.size.width, 15.0f)];
    medicalCountUnitLabel.text = @"条线路";
    medicalCountUnitLabel.textAlignment = NSTextAlignmentLeft;
    medicalCountUnitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    medicalCountUnitLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:medicalCountUnitLabel];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -添加更多配套view
///添加评论view
-(void)createCommentViewUI:(UIView *)view
{
    
    ///更多配套
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_HEIGHTTAP, 70.0f, 20.0f)];
    userLabel.text = @"更多配套";
    userLabel.textColor = COLOR_CHARACTERS_BLACK;
    userLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [view addSubview:userLabel];
    
    ///右侧箭头
    QSImageView *arrowView = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 13.0f , view.frame.size.height / 2.0f - 11.5f, 13.0f, 23.0f)];
    arrowView.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [view addSubview:arrowView];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -tableview数据源方法
///添加每一行cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * CellIdentifier = @"normalInfoCell";
    
    QSCommunityDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[QSCommunityDetailViewCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f)];
        
    }
    
    ///获取模型
     self.houseCommendModel = self.houseCommendArray[indexPath.row];
    
    [cell updateCommunityInfoCellUIWithDataModel:self.houseCommendModel];
    ///取消选择样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 100.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.houseCommendArray.count;

}

#pragma mark - 请求小区详情信息
///请求新房详情信息
- (void)getCommunityDetailInfo
{
    
    ///封装参数
    NSDictionary *params = @{@"id_" : self.communityID ? self.communityID : @"",
                             @"house_commend_num" : self.commendNum ? self.commendNum : @"",
                             @"house_second_or_rent" : self.houseType ? self.houseType : @""};
    
    ///进行请求
    [QSRequestManager requestDataWithType:rRequestTypeCommunityDetail andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///转换模型
            QSCommunityHousesDetailReturnData *tempModel = resultData;
            
            ///保存数据模型
            self.detailInfo = tempModel.detailInfo;
            
            self.houseInfo=tempModel.detailInfo.village;
            self.houseCommendArray=tempModel.detailInfo.house_commend;
            NSLog(@"出租房详情数据请求成功%@",tempModel.detailInfo.village);
            NSLog(@"参数id%@",params);
            NSLog(@"地址%@",self.houseInfo.address);
            
            ///创建详情UI
            [self createNewDetailInfoViewUI:tempModel.detailInfo];
            
            ///1秒后停止动画，并显示界面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIScrollView *rootView = objc_getAssociatedObject(self, &DetailRootViewKey);
                [rootView headerEndRefreshing];
                [self showInfoUI:YES];
                
            });
            
        } else {
            
            UIScrollView *rootView = objc_getAssociatedObject(self, &DetailRootViewKey);
            [rootView headerEndRefreshing];
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"获取小区详情信息失败，请稍后再试……",1.0f,^(){
                
                ///推回上一页
                [self.navigationController popViewControllerAnimated:YES];
                
            })
            
        }
        
    }];
    
}

#pragma mark - 关注小区
///点击关注小区
- (void)intentionCommunity:(UIButton *)button
{
    
    ///判断当前是否已收藏：已收藏则进行删除事件
    if (button.selected) {
        
        [self deleteIntentionCommunity:button];
        
    } else {
    
        [self addIntentionCommunity:button];
    
    }

}

///删除关注
- (void)deleteIntentionCommunity:(UIButton *)button
{

    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在取消关注"];
    
    ///判断当前收藏是否已同步服务端，若未同步，不需要联网删除
    QSCommunityHouseDetailDataModel *localDataModel = [QSCoreDataManager searchCollectedDataWithID:self.detailInfo.village.id_ andCollectedType:fFilterMainTypeCommunity];
    if (0 == [localDataModel.is_syserver intValue]) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"取消关注小区成功"];
        [self deleteIntentionCommunityWithStatus:YES];
        button.selected = NO;
        return;
        
    }
    
    ///判断是否已登录
    if (lLoginCheckActionTypeUnLogin == [self checkLogin]) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"取消关注小区成功"];
        [self deleteIntentionCommunityWithStatus:NO];
        button.selected = NO;
        return;
        
    }
    
    ///封装参数
    NSDictionary *params = @{@"obj_id" : self.detailInfo.village.id_,
                             @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeCommunity]};
    
    [QSRequestManager requestDataWithType:rRequestTypeCommunityDeleteIntention andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"取消关注小区成功"];
        
        ///同步服务端成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self deleteIntentionCommunityWithStatus:YES];
                
            });
            
        } else {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self deleteIntentionCommunityWithStatus:NO];
                
            });
            
        }
        
        ///修改按钮状态为已收藏状态
        button.selected = NO;
        
    }];

}

///添加关注
- (void)addIntentionCommunity:(UIButton *)button
{

    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在添加关注"];
    
    ///封装参数
    NSDictionary *params = @{@"obj_id" : self.detailInfo.village.id_,
                             @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeCommunity]};
    
    ///判断是否已登录
    if (lLoginCheckActionTypeUnLogin == [self checkLogin]) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"关注小区成功"];
        [self saveIntentionCommunityWithStatus:NO];
        params = nil;
        button.selected = YES;
        return;
        
    }
    
    [QSRequestManager requestDataWithType:rRequestTypeCommunityIntention andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"关注小区成功"];
        
        ///同步服务端成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self saveIntentionCommunityWithStatus:YES];
                
            });
            
        } else {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self saveIntentionCommunityWithStatus:NO];
                
            });
            
        }
        
        ///修改按钮状态为已收藏状态
        button.selected = YES;
        
    }];

}

#pragma mark - 将关注信息保存本地
///将收藏信息保存本地
- (void)saveIntentionCommunityWithStatus:(BOOL)isSendServer
{

    ///当前小区是否同步服务端标识
    if (isSendServer) {
        
        self.detailInfo.is_syserver = @"1";
        
    } else {
    
        self.detailInfo.is_syserver = @"0";
        
    }
    
    ///保存关注小区到本地
    [QSCoreDataManager saveCollectedDataWithModel:self.detailInfo andCollectedType:fFilterMainTypeCommunity andCallBack:^(BOOL flag) {
        
        ///显示保存信息
        if (flag) {
            
            APPLICATION_LOG_INFO(@"小区关注->保存本地", @"成功")
            
        } else {
        
            APPLICATION_LOG_INFO(@"小区关注->保存本地", @"失败")
        
        }
        
    }];

}

#pragma mark - 取消关注
///取消当前小区的关注
- (void)deleteIntentionCommunityWithStatus:(BOOL)isSendServer
{
    
    ///保存关注小区到本地
    [QSCoreDataManager deleteCollectedDataWithID:self.detailInfo.village.id_ isSyServer:isSendServer andCollectedType:fFilterMainTypeCommunity andCallBack:^(BOOL flag) {
        
        ///显示保存信息
        if (flag) {
            
            APPLICATION_LOG_INFO(@"小区关注->删除", @"成功")
            
        } else {
            
            APPLICATION_LOG_INFO(@"小区关注->删除", @"失败")
            
        }
        
    }];

}

@end
