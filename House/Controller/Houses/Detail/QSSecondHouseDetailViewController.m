//
//  QSSecondHouseDetailViewController.m
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSSecondHouseDetailViewController.h"
#import "QSAutoScrollView.h"

#import "QSImageView+Block.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "NSDate+Formatter.h"

#import "QSHousePriceChangesDataModel.h"
#import "QSHouseCommentDataModel.h"
#import "QSWRentHouseInfoDataModel.h"
#import "QSPhotoDataModel.h"
#import "QSSecondHousesDetailReturnData.h"
#import "QSSecondHouseDetailDataModel.h"
#import "QSUserSimpleDataModel.h"
#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+User.h"

#import "MJRefresh.h"


#import <objc/runtime.h>

///关联
static char DetailRootViewKey;      //!<所有信息的view
static char BottomButtonRootViewKey;//!<底部按钮的底view关联
static char MainInfoRootViewKey;    //!<主信息的底view关联

static char RightScoreKey;          //!<右侧评分
static char RightStarKey;           //!<右侧星级
static char LeftScoreKey;           //!<左侧评分
static char LeftStarKey;            //!<左侧星级

@interface QSSecondHouseDetailViewController () <UIScrollViewDelegate>

@property (nonatomic,copy) NSString *title;                 //!<标题
@property (nonatomic,copy) NSString *detailID;              //!<详情的ID
@property (nonatomic,assign) FILTER_MAIN_TYPE detailType;   //!<详情的类型

///详情信息的数据模型
@property (nonatomic,retain) QSSecondHouseDetailDataModel *detailInfo;        //!<返回的基本数据模型，模型下带有4个基本模型，一个数组模型
@property (nonatomic,retain) QSWRentHouseInfoDataModel *houseInfo;          //!<基本列表数据模型
@property (nonatomic,retain) QSUserSimpleDataModel *userInfo;               //!<用户信息模型
@property (nonatomic,retain) QSHousePriceChangesDataModel *priceChangesInfo;//!<价格变化数据模型
@property (nonatomic,retain) QSHouseCommentDataModel *commentInfo;          //!<评论信息
@property (nonatomic,retain) NSArray *photoArray;                           //!<图集数组
@property (nonatomic,retain) QSPhotoDataModel *photoInfo;                   //!<图片模型

@end

@implementation QSSecondHouseDetailViewController

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
    [rootView addHeaderWithTarget:self action:@selector(getSecondHouseDetailInfo)];
    
    ///其他信息底view
    QSScrollView *infoRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, rootView.frame.size.height - 60.0f)];
    [rootView addSubview:infoRootView];
    infoRootView.hidden = YES;
    objc_setAssociatedObject(self, &MainInfoRootViewKey, infoRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///底部按钮
    UIView *bottomRootView = [[UIView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT-60.0f, SIZE_DEFAULT_MAX_WIDTH, 60.0f)];
    [self.view addSubview:bottomRootView];
    bottomRootView.hidden = YES;
    objc_setAssociatedObject(self, &BottomButtonRootViewKey, bottomRootView, OBJC_ASSOCIATION_ASSIGN);
    
    [rootView headerBeginRefreshing];

}

#pragma mark - 搭建底部按钮
///创建底部按钮
- (void)createBottomButtonViewUI:(NSString *)userID
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
    
    NSString *localUserID=[QSCoreDataManager getUserID];
    ///根据是房客还是业主，创建不同的功能按钮（等则是业主）
    if ([localUserID isEqualToString:userID]) {
        
        ///按钮风格
        QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhiteGray];
        
        ///停止出售按钮
        buttonStyle.title = TITLE_HOUSES_DETAIL_SECOND_STOPSALE;
        UIButton *stopSaleButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 8.0f, 88.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
                NSLog(@"点击停止出售按钮事件");
            ///判断是否已登录
            
            
            ///已登录重新刷新数据
            
            
        }];
        stopSaleButton.backgroundColor=[UIColor grayColor];
        [view addSubview:stopSaleButton];
        
        ///按钮风格
        QSBlockButtonStyleModel *editButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
        ///编辑按钮
        editButtonStyle.title = TITLE_HOUSES_DETAIL_SECOND_EDIT;
        UIButton *editButton = [UIButton createBlockButtonWithFrame:CGRectMake(stopSaleButton.frame.origin.x + stopSaleButton.frame.size.width + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, stopSaleButton.frame.origin.y, view.frame.size.width-stopSaleButton.frame.size.width-30.0f-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, stopSaleButton.frame.size.height) andButtonStyle:editButtonStyle andCallBack:^(UIButton *button) {
            
                NSLog(@"点击编辑按钮事件");
            
            
        }];
        [view addSubview:editButton];
        
        ///按钮风格
        QSBlockButtonStyleModel *refreshButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClear];
        ///刷新按钮
       refreshButtonStyle.imagesNormal=@"houses_detail_refresh_normal";
        refreshButtonStyle.imagesHighted=@"houses_detail_refresh_highlighted";
        UIButton *refreshButton = [UIButton createBlockButtonWithFrame:CGRectMake(view.frame.size.width-30.0f, editButton.frame.origin.y+7.0f, 30.0f, 30.0f) andButtonStyle:refreshButtonStyle andCallBack:^(UIButton *button) {
            
            NSLog(@"点击刷新按钮事件");
            
        }];
        [view addSubview:refreshButton];
        
    } else {
        
        ///按钮风格
        QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
        
        ///停止出售按钮
        buttonStyle.title = TITLE_HOUSES_DETAIL_RENT_ORDER;
        UIButton *stopSaleButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 8.0f, 88.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            NSLog(@"点击预约按钮事件");
            ///判断是否已登录
            
            
            ///已登录重新刷新数据
            
            
        }];
        [view addSubview:stopSaleButton];
        
        ///按钮风格
        QSBlockButtonStyleModel *editButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
        ///编辑按钮
        editButtonStyle.title = TITLE_HOUSES_DETAIL_RENT_CONSULT;
        UIButton *editButton = [UIButton createBlockButtonWithFrame:CGRectMake(stopSaleButton.frame.origin.x + stopSaleButton.frame.size.width + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, stopSaleButton.frame.origin.y, view.frame.size.width-stopSaleButton.frame.size.width-SIZE_DEFAULT_MARGIN_LEFT_RIGHT, stopSaleButton.frame.size.height) andButtonStyle:editButtonStyle andCallBack:^(UIButton *button) {
            
            NSLog(@"点击立即咨询按钮事件");
            
            
        }];
        [view addSubview:editButton];
    }
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
- (void)createNewDetailInfoViewUI:(QSSecondHouseDetailDataModel *)dataModel
{
    
    ///信息底view
    UIScrollView *infoRootView = objc_getAssociatedObject(self, &MainInfoRootViewKey);
    
    ///清空原UI
    for (UIView *obj in [infoRootView subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
    ///保存房子基本数据
    self.houseInfo=dataModel.house;
    ///保存用户信息
    self.userInfo=dataModel.user;
    ///保存价钱变动信息
    self.priceChangesInfo=dataModel.price_changes;
    ///保存评论信息
    self.commentInfo=dataModel.comment;
    ///保存图片信息
    self.photoArray=dataModel.secondHouse_photo;
    
    ///主题图片
    UIImageView *headerImageView=[[UIImageView alloc] init];
    headerImageView.frame = CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT*560/1334);
    headerImageView.image=[UIImage imageNamed:@"houses_detail_header_load_fail750x562"];
    
    ///分数view
    QSBlockView *scoreView = [[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, headerImageView.frame.origin.y+headerImageView.frame.size.height-(SIZE_DEVICE_WIDTH*160.0f/750.0f+9.0f)/2.0f, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_WIDTH*160.0f/750.0f+9.0f) andSingleTapCallBack:^(BOOL flag) {
        
        ///进入地图：需要传经纬度
        NSLog(@"");
        
    }];
    [self createScoreUI:scoreView];
    
    ///房子统计view
    UIView *houseTotalView = [[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, scoreView.frame.origin.y+scoreView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*3.0f+44.0f+3.0f*10.0f+2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createHouseTotalUI:houseTotalView];
    
    UIView *houseDetailView = [[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseTotalView.frame.origin.y+houseTotalView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*4.0f+3.0f*5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createHouseDetailViewUI:houseDetailView];
    
    UIView *houseServiceView=[[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseDetailView.frame.origin.y+houseDetailView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, (SIZE_DEFAULT_MAX_WIDTH-6.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)/5.0f+20.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT+8.0f+5.0f)];
    [self createHouseServiceViewUI:houseServiceView];
    
    QSBlockView *priceChangeView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseServiceView.frame.origin.y+houseServiceView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*2.0f+5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT) andSingleTapCallBack:^(BOOL flag) {
        
        ///进入地图：需要传经纬度
        NSLog(@"点击进入价格变动");
        
    }];
    
    [self createPriceChangeViewUI:priceChangeView];
    
    QSBlockView *districtAveragePriceView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, priceChangeView.frame.origin.y+priceChangeView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*2.0f+5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT) andSingleTapCallBack:^(BOOL flag) {
        
        ///进入地图：需要传经纬度
        NSLog(@"点击进入均价详情");
        
    }];
    [self createDistrictAveragePriceViewUI:districtAveragePriceView];
    
    QSBlockView *houseAttentionView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, districtAveragePriceView.frame.origin.y+districtAveragePriceView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 25.0f+15.0f+5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT) andSingleTapCallBack:^(BOOL flag) {
        
        ///进入地图：需要传经纬度
        NSLog(@"点击进入关注");
        
    }];
    
    [self createHouseAttentionViewUI:houseAttentionView];
    
    QSBlockView *commentView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseAttentionView.frame.origin.y+houseAttentionView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*2.0f+5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)andSingleTapCallBack:^(BOOL flag) {
        
        ///进入地图：需要传经纬度
        NSLog(@"点击进入评论");
        
    }];
    
    [self createCommentViewUI:commentView];
    
    ///判断是进业主界面还是房客界面
    NSString *localUserID=[QSCoreDataManager getUserID];
    if([localUserID isEqualToString:self.userInfo.id_]){
    QSBlockView *ownerView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, commentView.frame.origin.y+commentView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*2.0f+5.0f+30.0f+3*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)andSingleTapCallBack:^(BOOL flag) {
        
        ///进入地图：需要传经纬度
        NSLog(@"点击业主");
        
    }];
    
    [self createOwnerViewUI:ownerView andUserInfo:self.userInfo];
        [infoRootView addSubview:ownerView];
    }
    
    [infoRootView addSubview:headerImageView];
    [infoRootView addSubview:scoreView];
    [infoRootView addSubview:houseTotalView];
    [infoRootView addSubview:houseDetailView];
    [infoRootView addSubview:houseServiceView];
    [infoRootView addSubview:priceChangeView];
    [infoRootView addSubview:districtAveragePriceView];
    [infoRootView addSubview:houseAttentionView];
    [infoRootView addSubview:commentView];
    
    ///透明背影
    infoRootView.backgroundColor=[UIColor clearColor];
    
    ///设置数据源和代理
    infoRootView.delegate = self;
    infoRootView.scrollEnabled=YES;
    infoRootView.contentSize=CGSizeMake(SIZE_DEVICE_WIDTH,commentView.frame.origin.y+commentView.frame.size.height+130.0f);
    
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



#pragma mark -添加评分view
///添加评分view
-(void)createScoreUI:(UIView *)view
{
    
    ///中间六角形图标
    QSImageView *middleImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH*160.0f/750.0f, SIZE_DEVICE_WIDTH*160.0f/750.0f+9.0f)];
    middleImageView.image = [UIImage imageNamed:IMAGE_HOUSES_LIST_SIXFORM];
    middleImageView.center = CGPointMake(view.frame.size.width / 2.0f, view.frame.size.height/2.0f);
    [view addSubview:middleImageView];
    
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
    
    ///总计底view
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, hoeseTotalLabel.frame.origin.y+hoeseTotalLabel.frame.size.height+5.0f, view.frame.size.width/2.0f-3.0f, 44.0f)];
    rootView.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    rootView.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    [view addSubview:rootView];
    
    ///价钱信息
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, rootView.frame.size.width / 2.0f, rootView.frame.size.height)];
    priceLabel.text = @"340";
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    priceLabel.textColor = COLOR_CHARACTERS_BLACK;
    [rootView addSubview:priceLabel];
    
    ///单位
    UILabel *unitPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.size.width+3.0f, priceLabel.frame.origin.y+11.0f, 20.0f, 20.0f)];
    unitPriceLabel.text = [NSString stringWithFormat:@"万/%@",APPLICATION_AREAUNIT];
    unitPriceLabel.textAlignment = NSTextAlignmentLeft;
    unitPriceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    unitPriceLabel.textColor = COLOR_CHARACTERS_BLACK;
    [rootView addSubview:unitPriceLabel];
    
    ///面积底view
    UIView *rootView1 = [[UIView alloc] initWithFrame:CGRectMake(rootView.frame.size.width+6.0f, hoeseTotalLabel.frame.origin.y+hoeseTotalLabel.frame.size.height+5.0f, view.frame.size.width/2.0f-3.0f, 44.0f)];
    rootView1.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    rootView1.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    [view addSubview:rootView1];
    
    ///面积信息
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, rootView1.frame.size.width / 2.0f, rootView1.frame.size.height)];
    areaLabel.text = @"340";
    areaLabel.textAlignment = NSTextAlignmentRight;
    areaLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    areaLabel.textColor = COLOR_CHARACTERS_BLACK;
    [rootView1 addSubview:areaLabel];
    
    ///单位
    UILabel *unitPriceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.size.width+3.0f, priceLabel.frame.origin.y+11.0f, 20.0f, 20.0f)];
    unitPriceLabel1.text = [NSString stringWithFormat:@"万/%@",APPLICATION_AREAUNIT];
    unitPriceLabel1.textAlignment = NSTextAlignmentLeft;
    unitPriceLabel1.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    unitPriceLabel1.textColor = COLOR_CHARACTERS_BLACK;
    [rootView1 addSubview:unitPriceLabel1];
    
    UILabel *onlyHouseLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, rootView.frame.origin.y+rootView.frame.size.height+10.0f, 65.0f, 20.0f)];
    onlyHouseLabel.textAlignment=NSTextAlignmentCenter;
    onlyHouseLabel.text=@"唯一房产";
    onlyHouseLabel.font=[UIFont systemFontOfSize:14.0f];
    onlyHouseLabel.backgroundColor=COLOR_CHARACTERS_BLACK;
    onlyHouseLabel.textColor=[UIColor whiteColor];
    [view addSubview:onlyHouseLabel];
    
    UILabel *fiveYearLabel=[[UILabel alloc] initWithFrame:CGRectMake(onlyHouseLabel.frame.origin.x+onlyHouseLabel.frame.size.width+5.0f, onlyHouseLabel.frame.origin.y, 65.0f, 20.0f)];
    fiveYearLabel.textAlignment=NSTextAlignmentCenter;
    fiveYearLabel.text=@"满五年";
    fiveYearLabel.font=[UIFont systemFontOfSize:14.0f];
    fiveYearLabel.backgroundColor=COLOR_CHARACTERS_BLACK;
    fiveYearLabel.textColor=[UIColor whiteColor];
    [view addSubview:fiveYearLabel];
    
    UILabel *degreeHouseLabel=[[UILabel alloc] initWithFrame:CGRectMake(fiveYearLabel.frame.origin.x+fiveYearLabel.frame.size.width+5.0f, onlyHouseLabel.frame.origin.y, 65.0f, 20.0f)];
    degreeHouseLabel.textAlignment=NSTextAlignmentCenter;
    degreeHouseLabel.font=[UIFont systemFontOfSize:14.0f];
    degreeHouseLabel.backgroundColor=COLOR_CHARACTERS_BLACK;
    degreeHouseLabel.textColor=[UIColor whiteColor];
    degreeHouseLabel.text=@"学位房";
    
    [view addSubview:degreeHouseLabel];
    
    UILabel *downPaymentLabel=[[UILabel alloc] initWithFrame:CGRectMake(degreeHouseLabel.frame.origin.x+degreeHouseLabel.frame.size.width+5.0f, onlyHouseLabel.frame.origin.y, 65.0f, 20.0f)];
    downPaymentLabel.textAlignment=NSTextAlignmentCenter;
    downPaymentLabel.text=@"低首付";
    downPaymentLabel.font=[UIFont systemFontOfSize:14.0f];
    downPaymentLabel.backgroundColor=COLOR_CHARACTERS_BLACK;
    downPaymentLabel.textColor=[UIColor whiteColor];
    [view addSubview:downPaymentLabel];
    
    UILabel *addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, onlyHouseLabel.frame.origin.y+onlyHouseLabel.frame.size.height+10.0f, SIZE_DEFAULT_MAX_WIDTH-100.0f, 20.0f)];
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
    linegasLabel.text=@"管道煤气";
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

#pragma mark -添加房子价钱变动view
///添加房子价钱变动view
-(void)createPriceChangeViewUI:(UIView *)view
{
    
    UILabel *newlyChangeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH/2.0f, 15.0f)];
    newlyChangeLabel.text=@"最近变价:2014-9-9";
    newlyChangeLabel.font=[UIFont systemFontOfSize:14.0f];
    newlyChangeLabel.textAlignment=NSTextAlignmentLeft;
    [view addSubview:newlyChangeLabel];
    
//    ///税金参考
    UILabel *consultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, newlyChangeLabel.frame.origin.y+newlyChangeLabel.frame.size.height+5.0f, 70.0f, 15.0f)];
    consultLabel.text = @"价格变动：";
    consultLabel.textColor = COLOR_CHARACTERS_BLACK;
    consultLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:consultLabel];

    ///税金
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(consultLabel.frame.size.width, consultLabel.frame.origin.y-5.0f, 25.0f, 25.0f)];
    priceLabel.text = @"9";
    priceLabel.textColor = COLOR_CHARACTERS_YELLOW;
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [view addSubview:priceLabel];
    
    ///单位
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width + 2.0f,priceLabel.frame.origin.y+7.5f , 15.0f, 10.0f)];
    unitLabel.text = @"次";
    unitLabel.textAlignment = NSTextAlignmentLeft;
    unitLabel.textColor = COLOR_CHARACTERS_BLACK;
    unitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:unitLabel];

    
    ///右侧箭头
    QSImageView *arrowView = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 13.0f , view.frame.size.height / 2.0f - 11.5f, 13.0f, 23.0f)];
    arrowView.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [view addSubview:arrowView];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -添加小区均价view
///添加小区均价view
-(void)createDistrictAveragePriceViewUI:(UIView *)view
{
   
    ///税金参考
    UILabel *consultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH-70.0f, 15.0f)];
    consultLabel.text = @"XXX小区均价";
    consultLabel.textColor = COLOR_CHARACTERS_BLACK;
    consultLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:consultLabel];
    
    ///税金
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, consultLabel.frame.origin.y+consultLabel.frame.size.height+5.0f, 55.0f, 25.0f)];
    priceLabel.text = @"99999";
    priceLabel.textColor = COLOR_CHARACTERS_YELLOW;
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [view addSubview:priceLabel];
    
    ///单位
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width + 2.0f,priceLabel.frame.origin.y , 15.0f, 25.0f)];
    unitLabel.text = @"元";
    unitLabel.textAlignment = NSTextAlignmentLeft;
    unitLabel.textColor = COLOR_CHARACTERS_BLACK;
    unitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:unitLabel];
    
    ///单位
    UILabel *unitLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(unitLabel.frame.origin.x + unitLabel.frame.size.width + 2.0f,priceLabel.frame.origin.y+7.5f , 25.0f, 10.0f)];
    unitLabel1.text = @"/m";
    unitLabel1.textAlignment = NSTextAlignmentLeft;
    unitLabel1.textColor = COLOR_CHARACTERS_BLACK;
    unitLabel1.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:unitLabel1];
    
    ///右侧箭头
    QSImageView *arrowView = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 13.0f, view.frame.size.height / 2.0f - 11.5f, 13.0f, 23.0f)];
    arrowView.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [view addSubview:arrowView];
    
    ///税金参考
    UILabel *houseCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-arrowView.frame.size.width-3.0f-30.0f, arrowView.frame.origin.y-4.0f, 30.0f, 12.0f)];
    houseCommentLabel.text = @"小区";
    houseCommentLabel.textColor = COLOR_CHARACTERS_BLACK;
    houseCommentLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_12];
    [view addSubview:houseCommentLabel];
    
    ///税金参考
    UILabel *commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(houseCommentLabel.frame.origin.x, houseCommentLabel.frame.origin.y+houseCommentLabel.frame.size.height+3.0f, 30.0f, 12.0f)];
    commentCountLabel.text = @"详情";
    commentCountLabel.textColor = COLOR_CHARACTERS_BLACK;
    commentCountLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_12];
    [view addSubview:commentCountLabel];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -添加房源关注view
///添加房源关注view
-(void)createHouseAttentionViewUI:(UIView *)view
{
    
    ///间隙
    CGFloat width = 60.0f;
    CGFloat gap = (view.frame.size.width - width * 4.0f - 26.0f) / 3.0f;
    
    ///公交路线
    UILabel *busLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT+15.0f+5.0f, width, 15.0f)];
    busLabel.text = @"房源浏览量";
    busLabel.textAlignment = NSTextAlignmentCenter;
    busLabel.textColor = COLOR_CHARACTERS_GRAY;
    busLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [view addSubview:busLabel];
    
    UILabel *busCountLable = [[UILabel alloc] initWithFrame:CGRectMake(busLabel.frame.origin.x, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, width / 2.0f + 5.0f, 25.0f)];
    busCountLable.text = @"980";
    busCountLable.textAlignment = NSTextAlignmentRight;
    busCountLable.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    busCountLable.textColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:busCountLable];
    
    UILabel *busCountUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(busCountLable.frame.origin.x + busCountLable.frame.size.width, SIZE_DEFAULT_MARGIN_LEFT_RIGHT+7.5f, 15.0f, 10.0f)];
    busCountUnitLabel.text = @"次";
    busCountUnitLabel.textAlignment = NSTextAlignmentLeft;
    busCountUnitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    busCountUnitLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:busCountUnitLabel];
    
    ///分隔线
    UILabel *busSepLine = [[UILabel alloc] initWithFrame:CGRectMake(busLabel.frame.origin.x + busLabel.frame.size.width + gap / 2.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.25f, view.frame.size.height - 2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    busSepLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:busSepLine];
    
    ///教育机构
    UILabel *techLabel = [[UILabel alloc] initWithFrame:CGRectMake(width + gap, busLabel.frame.origin.y, width, 15.0f)];
    techLabel.text = @"房客关注";
    techLabel.textAlignment = NSTextAlignmentCenter;
    techLabel.textColor = COLOR_CHARACTERS_GRAY;
    techLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [view addSubview:techLabel];
    
    UILabel *techCountLable = [[UILabel alloc] initWithFrame:CGRectMake(techLabel.frame.origin.x, busCountLable.frame.origin.y, width / 2.0f + 5.0f, 25.0f)];
    techCountLable.text = @"120";
    techCountLable.textAlignment = NSTextAlignmentRight;
    techCountLable.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    techCountLable.textColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:techCountLable];
    
    UILabel *techCountUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(techCountLable.frame.origin.x + techCountLable.frame.size.width, SIZE_DEFAULT_MARGIN_LEFT_RIGHT+7.5f, 15.0f, 10.0f)];
    techCountUnitLabel.text = @"次";
    techCountUnitLabel.textAlignment = NSTextAlignmentLeft;
    techCountUnitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    techCountUnitLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:techCountUnitLabel];
    
    ///分隔线
    UILabel *techSepLine = [[UILabel alloc] initWithFrame:CGRectMake(techLabel.frame.origin.x + techLabel.frame.size.width + gap / 2.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.25f, view.frame.size.height - 2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    techSepLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:techSepLine];
    
    ///医疗机构
    UILabel *medicalLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * (width + gap), busLabel.frame.origin.y, width, 15.0f)];
    medicalLabel.text = @"待看房预约";
    medicalLabel.textAlignment = NSTextAlignmentCenter;
    medicalLabel.textColor = COLOR_CHARACTERS_GRAY;
    medicalLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [view addSubview:medicalLabel];
    
    UILabel *medicalCountLable = [[UILabel alloc] initWithFrame:CGRectMake(medicalLabel.frame.origin.x, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, width / 2.0f + 5.0f, 25.0f)];
    medicalCountLable.text = @"28";
    medicalCountLable.textAlignment = NSTextAlignmentRight;
    medicalCountLable.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    medicalCountLable.textColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:medicalCountLable];
    
    UILabel *medicalCountUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(medicalCountLable.frame.origin.x + medicalCountLable.frame.size.width, SIZE_DEFAULT_MARGIN_LEFT_RIGHT+7.5f, 15.0f, 10.0f)];
    medicalCountUnitLabel.text = @"人";
    medicalCountUnitLabel.textAlignment = NSTextAlignmentLeft;
    medicalCountUnitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    medicalCountUnitLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:medicalCountUnitLabel];
    
    ///分隔线
    UILabel *medicalSepLine = [[UILabel alloc] initWithFrame:CGRectMake(medicalLabel.frame.origin.x + medicalLabel.frame.size.width + gap / 2.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.25f, view.frame.size.height - 2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    medicalSepLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:medicalSepLine];
    
    ///餐饮娱乐
    UILabel *foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.0f * (width + gap), busLabel.frame.origin.y, width, 15.0f)];
    foodLabel.text = @"看房预约";
    foodLabel.textAlignment = NSTextAlignmentCenter;
    foodLabel.textColor = COLOR_CHARACTERS_GRAY;
    foodLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [view addSubview:foodLabel];
    
    UILabel *foodCountLable = [[UILabel alloc] initWithFrame:CGRectMake(foodLabel.frame.origin.x, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, width / 2.0f + 5.0f, 25.0f)];
    foodCountLable.text = @"28";
    foodCountLable.textAlignment = NSTextAlignmentRight;
    foodCountLable.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    foodCountLable.textColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:foodCountLable];
    
    UILabel *foodCountUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(foodCountLable.frame.origin.x + foodCountLable.frame.size.width, SIZE_DEFAULT_MARGIN_LEFT_RIGHT+7.5f, 15.0f, 10.0f)];
    foodCountUnitLabel.text = @"次";
    foodCountUnitLabel.textAlignment = NSTextAlignmentLeft;
    foodCountUnitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    foodCountUnitLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:foodCountUnitLabel];
    
    ///右侧箭头
    QSImageView *arrowView = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 13.0f , view.frame.size.height / 2.0f - 11.5f, 13.0f, 23.0f)];
    arrowView.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [view addSubview:arrowView];

    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -添加评论view
///添加评论view
-(void)createCommentViewUI:(UIView *)view
{
    
    ///税金参考
    QSImageView *userImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 33.0f, 33.0f)];
    userImageView.backgroundColor=[UIColor yellowColor];
    [view addSubview:userImageView];
    
    ///税金参考
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(userImageView.frame.origin.x+userImageView.frame.size.width+5.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH-70.0f, 15.0f)];
    userLabel.text = @"长江一号：2014-9-9";
    userLabel.textColor = COLOR_CHARACTERS_BLACK;
    userLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:userLabel];
    
    ///税金参考
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(userLabel.frame.origin.x, userLabel.frame.origin.y+userLabel.frame.size.height+3.0f, SIZE_DEFAULT_MAX_WIDTH-70.0f, 15.0f)];
    commentLabel.text = @"这个小区有小偷";
    commentLabel.textColor = COLOR_CHARACTERS_BLACK;
    commentLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:commentLabel];
    
    ///右侧箭头
    QSImageView *arrowView = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 13.0f , view.frame.size.height / 2.0f - 11.5f, 13.0f, 23.0f)];
    arrowView.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [view addSubview:arrowView];
    
    ///税金参考
    UILabel *houseCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-arrowView.frame.size.width-3.0f-30.0f, arrowView.frame.origin.y-4.0f, 30.0f, 12.0f)];
    houseCommentLabel.text = @"评论";
    houseCommentLabel.textColor = COLOR_CHARACTERS_BLACK;
    houseCommentLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_12];
    [view addSubview:houseCommentLabel];
    
    ///税金参考
    UILabel *commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(houseCommentLabel.frame.origin.x, houseCommentLabel.frame.origin.y+houseCommentLabel.frame.size.height+3.0f, 30.0f, 12.0f)];
    commentCountLabel.text = @"(28)";
    commentCountLabel.textColor = COLOR_CHARACTERS_BLACK;
    commentCountLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_12];
    [view addSubview:commentCountLabel];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark -添加操作view
///添加操作view
-(void)createOperateViewUI:(UIView *)view
{
    
    ///按钮风格
    QSBlockButtonStyleModel *Style1 = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    
     UIButton *stopSaleButton=[QSBlockButton createBlockButtonWithFrame:CGRectMake(0.0f, 5.0f, 80.0f, 44.0f) andButtonStyle:Style1 andCallBack:^(UIButton *button) {
        
        NSLog(@"点击停止出售事件");
        
    }];
    stopSaleButton.backgroundColor=[UIColor blackColor];
    stopSaleButton.titleLabel.text=@"停止出售";
    [view addSubview:stopSaleButton];
    
    ///按钮风格
    QSBlockButtonStyleModel *yellowStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    UIButton *editButton=[QSBlockButton createBlockButtonWithFrame:CGRectMake(stopSaleButton.frame.origin.x+stopSaleButton.frame.size.width+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 44.0f) andButtonStyle:yellowStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"点击编辑事件");
        
    }];
    editButton.backgroundColor=[UIColor yellowColor];
    editButton.titleLabel.text=@"编辑";
    [view addSubview:editButton];
    
    UIButton *refreshButton=[QSBlockButton createBlockButtonWithFrame:CGRectMake(view.frame.size.width-44.0f-SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 5.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        NSLog(@"点击编辑事件");
        
    }];
    refreshButton.backgroundColor=[UIColor redColor];
    [view addSubview:refreshButton];
}

#pragma mark -添加业主view
///添加业主view
-(void)createOwnerViewUI:(UIView *)view andUserInfo:(QSUserSimpleDataModel *)userInfoModel
{
    
    ///业主
    QSImageView *userImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 33.0f, 33.0f)];
    userImageView.backgroundColor=[UIColor yellowColor];
    [view addSubview:userImageView];
        
    ///业主名称
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(userImageView.frame.origin.x+userImageView.frame.size.width+5.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH-70.0f, 15.0f)];
    userLabel.text = [NSString stringWithFormat:@"业主:%@",userInfoModel.username ? userInfoModel.username :@"暂无"];
    userLabel.textColor = COLOR_CHARACTERS_BLACK;
    userLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:userLabel];
    
    ///评论
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(userLabel.frame.origin.x, userLabel.frame.origin.y+userLabel.frame.size.height+3.0f, SIZE_DEFAULT_MAX_WIDTH-70.0f, 15.0f)];
    commentLabel.text = @"1380000000(未开放)|二手房(0)|出租(0)";
    commentLabel.textColor = COLOR_CHARACTERS_BLACK;
    commentLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:commentLabel];
    
    ///按钮风格
    QSBlockButtonStyleModel *connectButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    ///编辑按钮
    connectButtonStyle.title = TITLE_HOUSES_DETAIL_RENT_CONNECT;
    UIButton *connectButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, commentLabel.frame.origin.y + commentLabel.frame.size.height+SIZE_DEFAULT_MARGIN_LEFT_RIGHT,view.frame.size.width,35.0f) andButtonStyle:connectButtonStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"点击联系业主按钮事件");
        
        
    }];
    [view addSubview:connectButton];
}
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
- (void)getSecondHouseDetailInfo
{
    
    ///封装参数
    NSDictionary *params = @{@"id_" : self.detailID ? self.detailID : @""};
    ///
    
    ///进行请求
    [QSRequestManager requestDataWithType:rRequestTypeSecondHandHouseDetail andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///转换模型
            QSSecondHousesDetailReturnData *tempModel = resultData;
            
            ///保存返回的数据模型
            self.detailInfo = tempModel.detailInfo;
            self.houseInfo=self.detailInfo.house;
            self.userInfo=tempModel.detailInfo.user;
            NSLog(@"二手房详情数据请求成功%@",tempModel.detailInfo);
            NSLog(@"参数id%@",params);
            NSLog(@"地址%@",self.houseInfo.address);
            
            ///创建详情UI
            [self createNewDetailInfoViewUI:tempModel.detailInfo];
            [self createBottomButtonViewUI:tempModel.detailInfo.user.id_];

            
            
            ///1秒后停止动画，并显示界面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIScrollView *rootView = objc_getAssociatedObject(self, &DetailRootViewKey);
                [rootView headerEndRefreshing];
                [self showInfoUI:YES];
                
            });
            
        } else {
            
            UIScrollView *rootView = objc_getAssociatedObject(self, &DetailRootViewKey);
            [rootView headerEndRefreshing];
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(TIPS_NEWHOUSE_DETAIL_LOADFAIL,1.0f,^(){
                
                ///推回上一页
                [self.navigationController popViewControllerAnimated:YES];
                
            })
            
        }
        
    }];
    
}
@end
