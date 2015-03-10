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

#import "QSImageView+Block.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "NSDate+Formatter.h"

#import "QSNewHouseDetailDataModel.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+App.h"

#import "MJRefresh.h"

///左右限隙宏
#define SIZE_DEFAULT_HEIGHTTAP (SIZE_DEVICE_WIDTH >= 375.0f ? 20.0f : 15.0f)

#import <objc/runtime.h>

///关联
static char DetailRootViewKey;      //!<所有信息的view
static char BottomButtonRootViewKey;//!<底部按钮的底view关联
static char MainInfoRootViewKey;    //!<主信息的底view关联

@interface QSCommunityDetailViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSString *title;                 //!<标题
@property (nonatomic,copy) NSString *detailID;              //!<详情的ID
@property (nonatomic,assign) FILTER_MAIN_TYPE detailType;   //!<详情的类型

@property (nonatomic, strong) UITableView *tabbleView;              //!<小区信息view
@property (nonatomic, retain) NSMutableArray *communityDataSource; //!<小区信息数据源

@end

@implementation QSCommunityDetailViewController

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
    
    ///添加头部刷新
    [rootView addHeaderWithTarget:self action:@selector(getDetailInfo)];
    
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
- (void)createNewDetailInfoViewUI:(QSNewHouseDetailDataModel *)dataModel
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
    headerImageView.image=[UIImage imageNamed:@"houses_detail_header_load_fail750x562"];
    
    UIView *houseDetailView = [[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, headerImageView.frame.origin.y+headerImageView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*4.0f+3.0f*5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createHouseDetailViewUI:houseDetailView];
    
    QSBlockView *priceChangeView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseDetailView.frame.origin.y+houseDetailView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f+2.0f*SIZE_DEFAULT_HEIGHTTAP) andSingleTapCallBack:^(BOOL flag) {
        
        ///进入地图：需要传经纬度
        NSLog(@"点击进入小区二手房");
        
    }];
    
    [self createPriceChangeViewUI:priceChangeView];
    
    QSBlockView *districtAveragePriceView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, priceChangeView.frame.origin.y+priceChangeView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f+2*SIZE_DEFAULT_HEIGHTTAP) andSingleTapCallBack:^(BOOL flag) {
        
        ///进入地图：需要传经纬度
        NSLog(@"点击进入小区出租房");
        
    }];
    [self createDistrictAveragePriceViewUI:districtAveragePriceView];
    
    ///小区房价走势view
    UIView *houseTotalView = [[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, districtAveragePriceView.frame.origin.y+districtAveragePriceView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*3.0f+44.0f+3.0f*10.0f+2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createHouseTotalUI:houseTotalView];
    
    ///交通路线与统计view
    UIView *houseServiceView=[[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseTotalView.frame.origin.y+houseTotalView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, (SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)/5.0f)];
    [self createHouseServiceViewUI:houseServiceView];
    
    QSBlockView *houseAttentionView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseServiceView.frame.origin.y+houseServiceView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 25.0f+15.0f+5.0f+2*SIZE_DEFAULT_HEIGHTTAP) andSingleTapCallBack:^(BOOL flag) {
        
        ///进入地图：需要传经纬度
        NSLog(@"点击进入关注");
        
    }];

    
    [self createHouseAttentionViewUI:houseAttentionView];
    
    QSBlockView *commentView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseAttentionView.frame.origin.y+houseAttentionView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f+2*SIZE_DEFAULT_HEIGHTTAP)andSingleTapCallBack:^(BOOL flag) {
        
        ///进入地图：需要传经纬度
        NSLog(@"点击进入评论");
        
    }];
    [self createCommentViewUI:commentView];
    
    self.tabbleView=[[UITableView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, commentView.frame.origin.y+commentView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 5.0f*100.0f)];
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
    infoRootView.contentSize=CGSizeMake(SIZE_DEVICE_WIDTH,_tabbleView.frame.origin.y+_tabbleView.frame.size.height+130.0f);
    
    //[self.view addSubview:scrollView];
    //    objc_setAssociatedObject(self, &RootscrollViewKey, scrollView, OBJC_ASSOCIATION_ASSIGN);
    
    
    ///判断滚动尺寸
    //    if ((secondRootView.frame.origin.y + secondViewHeight + 10.0f) > infoRootView.frame.size.height) {
    //
    //        infoRootView.contentSize = CGSizeMake(infoRootView.frame.size.width, (secondRootView.frame.origin.y + secondViewHeight + 10.0f));
    //
    //    }
    
    ///修改滚动尺寸
    //    infoRootView.contentSize = CGSizeMake(infoRootView.frame.size.width, infoRootView.contentSize.height + 130.0f);
    
}

#pragma mark -添加房子详情view
///添加房子详情view
-(void)createHouseDetailViewUI:(UIView *)view
{
    
    UILabel *houseTypeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    houseTypeLabel.text=@"物业费:1.6元/m/月";
    houseTypeLabel.textAlignment=NSTextAlignmentLeft;
    houseTypeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:houseTypeLabel];
    
    UILabel *typeLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    typeLabel.text=@"房屋总数:208";
    typeLabel.textAlignment=NSTextAlignmentLeft;
    typeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:typeLabel];
    
    UILabel *orientationsLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, houseTypeLabel.frame.origin.y+houseTypeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    orientationsLabel.textAlignment=NSTextAlignmentLeft;
    orientationsLabel.font=[UIFont systemFontOfSize:14.0f];
    orientationsLabel.text=@"楼栋总数:2";
    [view addSubview:orientationsLabel];
    
    UILabel *layerCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, houseTypeLabel.frame.origin.y+houseTypeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    layerCountLabel.text=@"绿化率:30.00%";
    layerCountLabel.textAlignment=NSTextAlignmentLeft;
    layerCountLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:layerCountLabel];
    
    UILabel *decoreteLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, layerCountLabel.frame.origin.y+layerCountLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    decoreteLabel.textAlignment=NSTextAlignmentLeft;
    decoreteLabel.font=[UIFont systemFontOfSize:14.0f];
    decoreteLabel.text=@"容积率:3.3";
    [view addSubview:decoreteLabel];
    
    UILabel *timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, layerCountLabel.frame.origin.y+layerCountLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    timeLabel.text=@"建筑年代:2014";
    timeLabel.textAlignment=NSTextAlignmentLeft;
    timeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:timeLabel];
    
    UILabel *structureLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, timeLabel.frame.origin.y+timeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    structureLabel.textAlignment=NSTextAlignmentLeft;
    structureLabel.font=[UIFont systemFontOfSize:14.0f];
    structureLabel.text=@"房屋类型:公寓";
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

#pragma mark -小区二手房view
///添加房子价钱变动view
-(void)createPriceChangeViewUI:(UIView *)view
{
    
    ///更多配套
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_HEIGHTTAP, 150.0f, 20.0f)];
    userLabel.text = @"小区二手房(28)";
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

#pragma mark -添加小区出租房view
///添加小区均价view
-(void)createDistrictAveragePriceViewUI:(UIView *)view
{
    
    ///更多配套
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_HEIGHTTAP, 150.0f, 20.0f)];
    userLabel.text = @"小区出租房(99)";
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

#pragma mark -小区房价走势view
///添加物业总价
- (void)createHouseTotalUI:(UIView *)view
{
    
    UILabel *hoeseTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_HEIGHTTAP, 100.0f, 20.0f)];
    hoeseTotalLabel.text=@"小区房价走势";
    hoeseTotalLabel.textAlignment=NSTextAlignmentLeft;
    [view addSubview:hoeseTotalLabel];
    
    UILabel *areaSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-100.0f, SIZE_DEFAULT_HEIGHTTAP, 100.0f, 20.0f)];
    areaSizeLabel.text=@"最新均价";
    areaSizeLabel.textAlignment=NSTextAlignmentRight;
    [view addSubview:areaSizeLabel];
    
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
//    buttonStyle.bgColor=[UIColor clearColor];
//    buttonStyle.titleNormalColor=[UIColor grayColor];
//    buttonStyle.titleSelectedColor=[UIColor blackColor];
//    buttonStyle.bgColorSelected=[UIColor yellowColor];
//    buttonStyle.bgColorHighlighted=[UIColor yellowColor];
    
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
    //QSStoredCardDataModel *tempModel = self.storedCardDataSource[indexPath.row];
    
    
    //cell.cBalanceLabel.text=tempModel.historybalance;
    
    ///取消选择样式
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 100.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3.0f;

}


#pragma mark -tableview代理方法


//#pragma mark - 结束刷新动画
/////结束刷新动画
//- (void)endRefreshAnimination
//{
//
//    UIScrollView *scrollView = objc_getAssociatedObject(self, &RootscrollViewKey);
//    [scrollView headerEndRefreshing];
//
//}

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
    
    ///封装参数
    //    NSDictionary *params = @{@"loupan_id" : self.loupanID ? self.loupanID : @"",
    //                             @"loupan_building_id" : self.loupanBuildingID ? self.loupanBuildingID : @""};
    //
    //    ///进行请求
    //    [QSRequestManager requestDataWithType:rRequestTypeNewHouseDetail andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
    //
    //        ///请求成功
    //        if (<#condition#>) {
    //            <#statements#>
    //        }
    //
    //    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIScrollView *rootView = objc_getAssociatedObject(self, &DetailRootViewKey);
        [rootView headerEndRefreshing];
        [self showInfoUI:YES];
        
        ///创建详情UI
        [self createNewDetailInfoViewUI:nil];
        
    });
    
}

@end
