//
//  QSRentHouseDetailViewController.m
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSRentHouseDetailViewController.h"
#import "QSNearInfoViewController.h"
#import "QSYTalkPTPViewController.h"
#import "QSUserAssessViewController.h"
#import "QSPOrderDetailBookedViewController.h"
#import "QSYOwnerInfoViewController.h"
#import "QSCommunityDetailViewController.h"
#import "QSSearchMapViewController.h"

#import "QSAutoScrollView.h"
#import "QSYPopCustomView.h"
#import "QSYShareChoicesView.h"
#import "QSCustomHUDView.h"
#import "QSYCallTipsPopView.h"

#import "QSImageView+Block.h"
#import "UIImageView+CacheImage.h"
#import "NSString+Calculation.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "NSDate+Formatter.h"

#import "QSRentHousesDetailReturnData.h"
#import "QSRentHouseDetailDataModel.h"

#import "QSHousePriceChangesDataModel.h"
#import "QSHouseCommentDataModel.h"
#import "QSWRentHouseInfoDataModel.h"
#import "QSUserSimpleDataModel.h"
#import "QSPhotoDataModel.h"
#import "QSHouseTypeDataModel.h"

#import "QSCoreDataManager+House.h"
#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+Collected.h"
#import "QSCoreDataManager+History.h"
#import "QSCoreDataManager+User.h"

#import "MJRefresh.h"

#import "QSPOrderBookTimeViewController.h"

#import <objc/runtime.h>

#define kCallAlertViewTag 111


///关联
static char DetailRootViewKey;      //!<所有信息的view
static char BottomButtonRootViewKey;//!<底部按钮的底view关联
static char MainInfoRootViewKey;    //!<主信息的底view关联

static char RightScoreKey;          //!<右侧评分
static char RightStarKey;           //!<右侧星级
static char LeftScoreKey;           //!<左侧评分
static char LeftStarKey;            //!<左侧星级

@interface QSRentHouseDetailViewController () <UIScrollViewDelegate>

@property (nonatomic,copy) NSString *title;                 //!<标题
@property (nonatomic,copy) NSString *detailID;              //!<详情的ID
@property (nonatomic,assign) FILTER_MAIN_TYPE detailType;   //!<详情的类型

///详情信息的数据模型
@property (nonatomic,retain) QSRentHouseDetailDataModel *detailInfo;        //!<返回的基本数据模型，模型下带有4个基本模型，一个数组模型
@property (nonatomic,retain) QSWRentHouseInfoDataModel *houseInfo;          //!<基本列表数据模型
@property (nonatomic,retain) QSUserSimpleDataModel *userInfo;               //!<用户信息模型
@property (nonatomic,retain) QSHousePriceChangesDataModel *priceChangesInfo;//!<价格变化数据模型
@property (nonatomic,retain) QSHouseCommentDataModel *commentInfo;          //!<评论信息

@property (nonatomic,retain) NSArray *photoArray;                           //!<图集数组
@property (nonatomic,retain) QSPhotoDataModel *photoInfo;                   //!<图片模型

@property (nonatomic, copy) NSString *phoneNumber;                          //!<电话号码

@end

@implementation QSRentHouseDetailViewController

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

///由小区进入的接口
- (instancetype)initWithTitle:(NSString *)title andDetailID:(NSString *)detailID
{
    
    if (self = [super init]) {
        
        ///保存相关参数
        self.title = title;
        self.detailID = detailID;
        
    }
    
    return self;
    
}
#pragma mark - UI搭建
///重写导航栏，添加标题信息
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:(self.title ? self.title : @"详情")];
    
    ///收藏按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeCollected];
    
    UIButton *intentionButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 44.0f - 30.0f, 20.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///收藏出租房
        [self collectRentHouse:button];
        
    }];
    intentionButton.selected = [QSCoreDataManager checkCollectedDataWithID:self.detailID andCollectedType:fFilterMainTypeRentalHouse];
    [self.view addSubview:intentionButton];
    
    ///分享按钮
    QSBlockButtonStyleModel *buttonStyleShare = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeShare];
    
    UIButton *shareButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 44.0f, 20.0f, 44.0f, 44.0f) andButtonStyle:buttonStyleShare andCallBack:^(UIButton *button) {
        
        ///分享
        [self shareRentHouse:button];
        
    }];
    [self.view addSubview:shareButton];
    
}

///主展示信息
- (void)createMainShowUI
{
    [super createMainShowUI];
    
    ///所有信息的底view
    QSScrollView *rootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    [self.view addSubview:rootView];
    objc_setAssociatedObject(self, &DetailRootViewKey, rootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///添加头部刷新
    [rootView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getRentHouseDetailInfo)];
    
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
    
    ///一开始就刷新数据
    [rootView.header beginRefreshing];
    
}

#pragma mark - 搭建底部按钮
///创建底部按钮
- (void)createBottomButtonViewUI
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
    
    ///发布当前房源的业主
    NSString *ownerID = self.detailInfo.user.id_;
    NSString *localUserID = [QSCoreDataManager getUserID];
    
    ///根据是房客还是业主，创建不同的功能按钮（等则是业主）
    if ([localUserID isEqualToString:ownerID]) {
        
        ///按钮风格
        QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhiteGray];
        
        ///停止出售按钮
        buttonStyle.title = @"停止出租";
        UIButton *stopSaleButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 8.0f, 88.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            ///发送停售状态
            
            
        }];
        stopSaleButton.backgroundColor=[UIColor grayColor];
        stopSaleButton.titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_20];
        [view addSubview:stopSaleButton];
        
        ///按钮风格
        QSBlockButtonStyleModel *editButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
        
        ///编辑按钮
        editButtonStyle.title = TITLE_HOUSES_DETAIL_SECOND_EDIT;
        UIButton *editButton = [UIButton createBlockButtonWithFrame:CGRectMake(stopSaleButton.frame.origin.x + stopSaleButton.frame.size.width + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, stopSaleButton.frame.origin.y, view.frame.size.width-stopSaleButton.frame.size.width-30.0f-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, stopSaleButton.frame.size.height) andButtonStyle:editButtonStyle andCallBack:^(UIButton *button) {
            
            NSLog(@"点击编辑按钮事件");
            
        }];
        editButton.titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_20];
        [view addSubview:editButton];
        
        ///按钮风格
        QSBlockButtonStyleModel *refreshButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClear];
        
        ///刷新按钮
        refreshButtonStyle.imagesNormal = @"houses_detail_refresh_normal";
        refreshButtonStyle.imagesHighted = @"houses_detail_refresh_highlighted";
        UIButton *refreshButton = [UIButton createBlockButtonWithFrame:CGRectMake(view.frame.size.width-30.0f, editButton.frame.origin.y+7.0f, 30.0f, 30.0f) andButtonStyle:refreshButtonStyle andCallBack:^(UIButton *button) {
            
            NSLog(@"点击刷新按钮事件");
            
        }];
        [view addSubview:refreshButton];
        
    } else if (uUserCountTypeAgency != [QSCoreDataManager getUserType]) {
        
        ///按钮风格
        QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
        
        ///预约按钮
        buttonStyle.title = TITLE_HOUSES_DETAIL_RENT_ORDER;
        UIButton *stopSaleButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 8.0f, 88.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            ///判断是否已登录
            [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                
                ///已登录
                if (lLoginCheckActionTypeLogined == flag) {
                    
                    ///判断是否已预约
                    if (0 >= [self.detailInfo.expandInfo.is_book length]) {
                        
                        ///已登录进入预约
                        QSPOrderBookTimeViewController *bookTimeVc = [[QSPOrderBookTimeViewController alloc] initWithSubmitCallBack:^(BOOKTIME_RESULT_TYPE resultTag) {
                            
                            if (bBookResultTypeSucess == resultTag) {
                                
                                ///预约成功，刷新详情数据
                                UIScrollView *rootView = objc_getAssociatedObject(self, &DetailRootViewKey);
                                [rootView.header beginRefreshing];
                                
                            }
                            
                        }];
                        [bookTimeVc setVcType:bBookTypeViewControllerBook];
                        [bookTimeVc setHouseInfo:self.houseInfo];
                        [self.navigationController pushViewController:bookTimeVc animated:YES];
                        
                    }
                    
                    if (1 <= [self.detailInfo.expandInfo.is_book length]) {
                        
                        ///已登录进入预约
                        QSPOrderDetailBookedViewController *orderDetailPage = [[QSPOrderDetailBookedViewController alloc] init];
                        orderDetailPage.orderID = self.detailInfo.expandInfo.is_book;
                        [self.navigationController pushViewController:orderDetailPage animated:YES];
                        
                    }
                    
                }
                
                ///新登录时刷新数据
                if (lLoginCheckActionTypeReLogin == flag) {
                    
                    UIScrollView *rootView = objc_getAssociatedObject(self, &DetailRootViewKey);
                    [rootView.header beginRefreshing];
                    
                }
                
            }];
            
        }];
        [view addSubview:stopSaleButton];
        
        ///按钮风格
        QSBlockButtonStyleModel *editButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
        
        ///咨询按钮
        editButtonStyle.title = TITLE_HOUSES_DETAIL_RENT_CONSULT;
        UIButton *editButton = [UIButton createBlockButtonWithFrame:CGRectMake(stopSaleButton.frame.origin.x + stopSaleButton.frame.size.width + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, stopSaleButton.frame.origin.y, view.frame.size.width-stopSaleButton.frame.size.width-SIZE_DEFAULT_MARGIN_LEFT_RIGHT, stopSaleButton.frame.size.height) andButtonStyle:editButtonStyle andCallBack:^(UIButton *button) {
            
            [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                
                ///已登录
                if (lLoginCheckActionTypeLogined == flag) {
                    
                    QSYTalkPTPViewController *talkVC = [[QSYTalkPTPViewController alloc] initWithUserModel:self.detailInfo.user];
                    [self.navigationController pushViewController:talkVC animated:YES];
                    
                }
                
                ///新登录
                if (lLoginCheckActionTypeReLogin == flag) {
                    
                    ///刷新数据
                    UIScrollView *rootView = objc_getAssociatedObject(self, &DetailRootViewKey);
                    [rootView.header beginRefreshing];
                    
                }
                
            }];
            
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
- (void)createNewDetailInfoViewUI:(QSRentHouseDetailDataModel *)dataModel
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
    self.photoArray=dataModel.rentHouse_photo;
    
    ///主题图片
    UIImageView *headerImageView=[[UIImageView alloc] init];
    headerImageView.frame = CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT*560/1334);
    headerImageView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_HEADER_DEFAULT_BG];
    if ([dataModel.house.attach_file length] > 0) {
        
        [headerImageView loadImageWithURL:[dataModel.house.attach_file getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_HOUSES_DETAIL_HEADER_DEFAULT_BG]];
        
    }
    
    ///分数view
    QSBlockView *scoreView = [[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, headerImageView.frame.origin.y+headerImageView.frame.size.height-(SIZE_DEVICE_WIDTH*160.0f/750.0f+9.0f)/2.0f, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_WIDTH*160.0f/750.0f+9.0f) andSingleTapCallBack:^(BOOL flag) {
        
        NSLog(@"");
        
    }];
    [self createScoreUI:scoreView andInsideScore:@"4.2" andOverflowScore:@"8.7" andAroundScore:@"1.9"];
    
    ///房子统计view
    UIView *houseTotalView = [[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, scoreView.frame.origin.y+scoreView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*3.0f+44.0f+3.0f*10.0f+2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createHouseTotalUI:houseTotalView andTotalModel:dataModel.house];
    
    ///房子详情
    UIView *houseDetailView = [[UIView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseTotalView.frame.origin.y+houseTotalView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*5.0f+4.0f*5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    [self createHouseDetailViewUI:houseDetailView andHousesInfo:self.houseInfo];
    
    ///房子服务
    QSScrollView *houseServiceView=[[QSScrollView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseDetailView.frame.origin.y+houseDetailView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT+52.0f+8.0f+20.0f)];
    [self createHouseServiceViewUI:houseServiceView];
    
    ///价格变动
    QSBlockView *priceChangeView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseServiceView.frame.origin.y+houseServiceView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*2.0f+5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT) andSingleTapCallBack:^(BOOL flag) {
        
        NSLog(@"点击进入价格变动");
        
    }];
    
    [self createPriceChangeViewUI:priceChangeView andPriceChanges:self.priceChangesInfo];
    
    ///均价详情
    QSBlockView *districtAveragePriceView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, priceChangeView.frame.origin.y+priceChangeView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*2.0f+5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT) andSingleTapCallBack:^(BOOL flag) {
        
        NSLog(@"点击进入小区详情");
        ///进入详情页面
        QSCommunityDetailViewController *detailVC = [[QSCommunityDetailViewController alloc] initWithTitle:dataModel.house.title andCommunityID:dataModel.house.village_id andCommendNum:@"10" andHouseType:@"rent"];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }];
    [self createDistrictAveragePriceViewUI:districtAveragePriceView andTitle:self.houseInfo.village_name andAveragePrice:self.houseInfo.price_avg];
    
    ///房源浏览量
    QSBlockView *houseAttentionView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, districtAveragePriceView.frame.origin.y+districtAveragePriceView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 25.0f+15.0f+5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)];
    
    [self createHouseAttentionViewUI:houseAttentionView andHouseInfo:dataModel.house];
    
    ///房源评论
    QSBlockView *commentView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, houseAttentionView.frame.origin.y+houseAttentionView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f*2.0f+5.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)andSingleTapCallBack:^(BOOL flag) {
        
        NSLog(@"点击进入评论");
            QSUserAssessViewController *assessVC = [[QSUserAssessViewController alloc] initWithType:@"990106" andID:[self.detailID intValue]];
        [self.navigationController pushViewController:assessVC animated:YES];
        
        
    }];
    
    [self createCommentViewUI:commentView andCommentInfo:self.commentInfo];
    
    ///判断是房客并且不是经纪人则加载该界面
    NSString *localUserID=[QSCoreDataManager getUserID];
    if(![localUserID isEqualToString:self.userInfo.id_] &&
       (uUserCountTypeAgency != [QSCoreDataManager getUserType])) {
        
        QSBlockView *ownerView=[[QSBlockView alloc] initWithFrame:CGRectMake(2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, commentView.frame.origin.y+commentView.frame.size.height, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 40.0f+5.0f+35.0f+3*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)andSingleTapCallBack:^(BOOL flag) {
            
            ///检测登录
            [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
                
                if (lLoginCheckActionTypeLogined == flag) {
                    
                    QSYOwnerInfoViewController *ownerInfoVC = [[QSYOwnerInfoViewController alloc] initWithName:self.detailInfo.user.username andOwnerID:self.detailInfo.user.id_ andDefaultHouseType:fFilterMainTypeRentalHouse];
                    [self.navigationController pushViewController:ownerInfoVC animated:YES];
                    
                }
                
                if (lLoginCheckActionTypeReLogin == flag) {
                    
                    ///刷新数据
                    UIScrollView *rootView = objc_getAssociatedObject(self, &DetailRootViewKey);
                    [rootView.header beginRefreshing];
                    
                }
                
            }];
            
        }];
        
        ///搭建业主信息栏
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
    infoRootView.scrollEnabled = YES;
    infoRootView.contentSize = CGSizeMake(SIZE_DEVICE_WIDTH,commentView.frame.origin.y+commentView.frame.size.height+130.0f);
    
}

#pragma mark - 添加评分view
///添加评分view
-(void)createScoreUI:(UIView *)view andInsideScore:(NSString *)insideScore  andOverflowScore:(NSString *)overflowScore  andAroundScore:(NSString *)aroundScore
{
    
    ///中间六角形图标
    QSImageView *middleImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH*160.0f/750.0f, SIZE_DEVICE_WIDTH*160.0f/750.0f+9.0f)];
    middleImageView.image = [UIImage imageNamed:IMAGE_HOUSES_LIST_SIXFORM];
    middleImageView.center = CGPointMake(view.frame.size.width / 2.0f, view.frame.size.height/2.0f);
    [self createOverflowScoreInfoUI:middleImageView andScore:overflowScore];
    [view addSubview:middleImageView];
    
    ///右侧评分底view
    QSImageView *rightScoreRootView = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 60.0f, (view.frame.size.height - 64.0f) / 2.0f, 60.0f, 64.0f)];
    [self createDetailScoreInfoUI:rightScoreRootView andDetailTitle:@"周边条件" andScoreKey:RightScoreKey andStarKey:RightStarKey andScore:aroundScore];
    [view addSubview:rightScoreRootView];
    
    ///左侧评分底view
    QSImageView *leftScoreRootView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, (view.frame.size.height - 64.0f) / 2.0f, 60.0f, 64.0f)];
    [self createDetailScoreInfoUI:leftScoreRootView andDetailTitle:@"内部条件" andScoreKey:LeftScoreKey andStarKey:LeftStarKey andScore:insideScore];
    [view addSubview:leftScoreRootView];
    
}

///创建详情超值评分UI
- (void)createOverflowScoreInfoUI:(UIView *)view andScore:(NSString *)score
{
    
    ///超值盘评分
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f,10.0f, view.frame.size.width - 10.0f - 20.0f, view.frame.size.height/2.0f-10.f)];
    scoreLabel.text = score;
    scoreLabel.textAlignment = NSTextAlignmentRight;
    scoreLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_25];
    scoreLabel.textColor = COLOR_CHARACTERS_BLACK;
    [view addSubview:scoreLabel];
    
    ///超值盘单位
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(scoreLabel.frame.origin.x + scoreLabel.frame.size.width, scoreLabel.frame.origin.y + scoreLabel.frame.size.height - 20.0f, 20.0f, 20.0f)];
    unitLabel.text = @"分";
    unitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    unitLabel.textColor = COLOR_CHARACTERS_BLACK;
    [view addSubview:unitLabel];
    
    ///说明文字
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f, 60.0f, 20.0f)];
    titleLabel.text = @"超值盘";
    titleLabel.center=CGPointMake(view.frame.size.width / 2.0f, view.frame.size.height/2.0f+10.0f);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_CHARACTERS_BLACK;
    titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [view addSubview:titleLabel];
    [view addSubview:unitLabel];
    
}

///创建详情评分UI
- (void)createDetailScoreInfoUI:(UIView *)view andDetailTitle:(NSString *)detailTitle andScoreKey:(char)scoreKey andStarKey:(char)starKey andScore:(NSString *)score
{
    
    ///头图片
    QSImageView *imageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 32.0f)];
    imageView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_DETAIL_SCORE];
    [view addSubview:imageView];
    
    ///评分
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.0f, 5.0f, view.frame.size.width - 8.0f - 15.0f, 25.0f)];
    scoreLabel.text = score;
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


#pragma mark - 添加物业总价view
///添加物业总价
- (void)createHouseTotalUI:(UIView *)view andTotalModel:(QSWRentHouseInfoDataModel *)houseInfo
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
    UILabel *priceLabel=[[UILabel alloc] init];
    priceLabel.translatesAutoresizingMaskIntoConstraints=NO;
    priceLabel.textAlignment=NSTextAlignmentRight;
    priceLabel.text = houseInfo.rent_price;
    priceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    priceLabel.textColor = COLOR_CHARACTERS_BLACK;
    [rootView addSubview:priceLabel];
    
    ///单位
    UILabel *unitPriceLabel=[[UILabel alloc] init];
    unitPriceLabel.translatesAutoresizingMaskIntoConstraints=NO;
    unitPriceLabel.text = @"元/月";
    unitPriceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    unitPriceLabel.textColor = COLOR_CHARACTERS_BLACK;
    [rootView addSubview:unitPriceLabel];
    
    ///约束参数
    NSDictionary *___viewsVFL = NSDictionaryOfVariableBindings(priceLabel,unitPriceLabel);
    
    ///约束
    NSString *___hVFL_all = @"H:|-(>=2)-[priceLabel(>=80)]-2-[unitPriceLabel(50)]-(>=2)-|";
    NSString *___vVFL_priceLabel = @"V:|-0-[priceLabel(44)]";
    NSString *___vVFL_unitPriceLabel = @"V:|-13-[unitPriceLabel(20)]";
    
    ///添加约束
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_all options:0 metrics:nil views:___viewsVFL]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_priceLabel options:0 metrics:nil views:___viewsVFL]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_unitPriceLabel options:0 metrics:nil views:___viewsVFL]];
    
    ///面积底view
    UIView *rootView1 = [[UIView alloc] initWithFrame:CGRectMake(rootView.frame.size.width+6.0f, hoeseTotalLabel.frame.origin.y+hoeseTotalLabel.frame.size.height+5.0f, view.frame.size.width/2.0f-3.0f, 44.0f)];
    rootView1.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    rootView1.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    [view addSubview:rootView1];
    
    ///面积信息
    UILabel *areaLabel = [[UILabel alloc] init];
    areaLabel.translatesAutoresizingMaskIntoConstraints=NO;
    areaLabel.textAlignment=NSTextAlignmentRight;
    areaLabel.text = houseInfo.house_area;
    areaLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_30];
    areaLabel.textColor = COLOR_CHARACTERS_BLACK;
    [rootView1 addSubview:areaLabel];
    
    ///单位
    UILabel *unitPriceLabel1 = [[UILabel alloc] init];
    unitPriceLabel1.translatesAutoresizingMaskIntoConstraints=NO;
    unitPriceLabel1.text = [NSString stringWithFormat:@"/%@",APPLICATION_AREAUNIT];
    unitPriceLabel1.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    unitPriceLabel1.textColor = COLOR_CHARACTERS_BLACK;
    [rootView1 addSubview:unitPriceLabel1];
    
    ///约束参数
    NSDictionary *___viewsVFL1 = NSDictionaryOfVariableBindings(areaLabel,unitPriceLabel1);
    
    ///约束
    NSString *___hVFL_all1 = @"H:|-(>=2)-[areaLabel(>=80)]-2-[unitPriceLabel1(30)]-(>=2)-|";
    NSString *___vVFL_areaLabel = @"V:|-0-[areaLabel(44)]";
    NSString *___vVFL_unitPriceLabel1 = @"V:|-13-[unitPriceLabel1(20)]";
    
    ///添加约束
    [rootView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_all1 options:0 metrics:nil views:___viewsVFL1]];
    [rootView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_areaLabel options:0 metrics:nil views:___viewsVFL1]];
    [rootView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_unitPriceLabel1 options:0 metrics:nil views:___viewsVFL1]];
    
    ///特色标签
    UIView *featuresRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, rootView.frame.origin.y+rootView.frame.size.height, view.frame.size.width, 30.0f)];
    [view addSubview:featuresRootView];
    [self createFeaturesSubviews:featuresRootView andDataSource:houseInfo.features];
    
    NSString *coordinate_x=houseInfo.coordinate_x;
    NSString *coordinate_y=houseInfo.coordinate_y;
    QSBlockView *mapView=[[QSBlockView alloc] initWithFrame:CGRectMake(0.0f, featuresRootView.frame.origin.y+featuresRootView.frame.size.height, view.frame.size.width, 40.0f) andSingleTapCallBack:^(BOOL flag) {
        NSLog(@"点击定位");
        
        QSSearchMapViewController *smVC = [[QSSearchMapViewController alloc]initWithTitle:self.title andCoordinate_x:coordinate_x andCoordinate_y:coordinate_y];
        
        [self.navigationController pushViewController:smVC animated:YES];
        
    }];
    
    UILabel *addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, view.frame.size.width-100.0f, 20.0f)];
    addressLabel.textAlignment=NSTextAlignmentLeft;
    addressLabel.text=houseInfo.address;
    addressLabel.font=[UIFont systemFontOfSize:14.0f];
    [mapView addSubview:addressLabel];
    
    ///查看地图信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-30.0f-70.0f, addressLabel.frame.origin.y, 70.0f, 20.0f)];
    tipsLabel.text = @"(查看地图)";
    tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    tipsLabel.textAlignment=NSTextAlignmentCenter;
    tipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    [mapView addSubview:tipsLabel];
    
    ///定位按钮
    QSImageView *localImageView = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT-30.0f, tipsLabel.frame.origin.y-5.0f, 30.0f, 30.0f)];
    localImageView.image = [UIImage imageNamed:IMAGE_PUBLIC_LOCAL_LIGHYELLOW];
    [mapView addSubview:localImageView];
    
    [view addSubview:mapView];
    

    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark - 创建特色标签
///创建特色标签
- (void)createFeaturesSubviews:(UIView *)view andDataSource:(NSString *)featuresString
{
    
    if (featuresString && ([featuresString length] > 0)) {
        
        ///清空原标签
        for (UIView *obj in [view subviews]) {
            
            [obj removeFromSuperview];
            
        }
        
        ///将标签信息转为数组
        NSArray *featuresList = [featuresString componentsSeparatedByString:@","];
        
        ///标签宽度
        CGFloat width = 55.0f;
        
        ///循环创建特色标签
        for (int i = 0; i < [featuresList count];i++) {
            
            ///标签项
            UILabel *tempLabel = [[QSLabel alloc] initWithFrame:CGRectMake(i * (width + 3.0f), 10.0f, width, 20.0f)];
            
            ///根据特色标签，查询标签内容
            NSString *featureVal = [QSCoreDataManager getHouseFeatureWithKey:featuresList[i] andFilterType:fFilterMainTypeRentalHouse];
            
            tempLabel.text = featureVal;
            tempLabel.font = [UIFont systemFontOfSize:FONT_BODY_12];
            tempLabel.textAlignment = NSTextAlignmentCenter;
            tempLabel.backgroundColor = COLOR_CHARACTERS_BLACK;
            tempLabel.textColor = [UIColor whiteColor];
            tempLabel.layer.cornerRadius = 4.0f;
            tempLabel.layer.masksToBounds = YES;
            tempLabel.adjustsFontSizeToFitWidth = YES;
            [view addSubview:tempLabel];
            
        }
        
    }
    
}


#pragma mark - 添加房子详情view
///添加房子详情view
-(void)createHouseDetailViewUI:(UIView *)view andHousesInfo:(QSWRentHouseInfoDataModel *)houseInfoModel
{
    
    UILabel *houseTypeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
     houseTypeLabel.text=[NSString stringWithFormat:@"户型:%@室%@厅%@卫",houseInfoModel.house_shi,houseInfoModel.house_ting ? houseInfoModel.house_ting : @"0",houseInfoModel.house_wei ? houseInfoModel.house_wei : @"0"];
    houseTypeLabel.textAlignment=NSTextAlignmentLeft;
    houseTypeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:houseTypeLabel];
    
    UILabel *typeLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    typeLabel.text = [NSString stringWithFormat:@"类型:%@",[QSCoreDataManager getHouseTradeTypeWithKey:houseInfoModel.property_type]];
    typeLabel.textAlignment=NSTextAlignmentLeft;
    typeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:typeLabel];
    
    UILabel *orientationsLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, houseTypeLabel.frame.origin.y+houseTypeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    orientationsLabel.textAlignment=NSTextAlignmentLeft;
    orientationsLabel.font=[UIFont systemFontOfSize:14.0f];
    orientationsLabel.text=[NSString stringWithFormat:@"朝向:%@",[QSCoreDataManager getHouseFaceTypeWithKey:houseInfoModel.house_face]];
    [view addSubview:orientationsLabel];
    
    UILabel *layerCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, houseTypeLabel.frame.origin.y+houseTypeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    layerCountLabel.text=[NSString stringWithFormat:@"层数:%@/%@",houseInfoModel.floor_which,houseInfoModel.floor_num];
    layerCountLabel.textAlignment=NSTextAlignmentLeft;
    layerCountLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:layerCountLabel];
    
    UILabel *decoreteLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, layerCountLabel.frame.origin.y+layerCountLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    decoreteLabel.textAlignment=NSTextAlignmentLeft;
    decoreteLabel.font=[UIFont systemFontOfSize:14.0f];
    decoreteLabel.text=[NSString stringWithFormat:@"装修:%@",[QSCoreDataManager getHouseDecorationTypeWithKey:houseInfoModel.decoration_type]];
    [view addSubview:decoreteLabel];
    
    UILabel *timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, layerCountLabel.frame.origin.y+layerCountLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    timeLabel.text=[NSString stringWithFormat:@"建筑时间:%@",@"需要问接口"];
    timeLabel.textAlignment=NSTextAlignmentLeft;
    timeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:timeLabel];
    
    UILabel *structureLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, timeLabel.frame.origin.y+timeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    structureLabel.textAlignment=NSTextAlignmentLeft;
    structureLabel.font=[UIFont systemFontOfSize:14.0f];
    structureLabel.text=[NSString stringWithFormat:@"结构:%@",@"接口暂无字段"];
    [view addSubview:structureLabel];
    
    UILabel *propertyLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, timeLabel.frame.origin.y+timeLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    propertyLabel.text=[NSString stringWithFormat:@"使用年限:%@年",houseInfoModel.used_year];
    propertyLabel.font=[UIFont systemFontOfSize:14.0f];
    propertyLabel.textAlignment=NSTextAlignmentLeft;
    [view addSubview:propertyLabel];
    
    UILabel *stateLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, structureLabel.frame.origin.y+structureLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    stateLabel.textAlignment=NSTextAlignmentLeft;
    stateLabel.font=[UIFont systemFontOfSize:14.0f];
    stateLabel.text=[NSString stringWithFormat:@"状态:%@",houseInfoModel.house_status];
    [view addSubview:stateLabel];
    
    UILabel *intakeLabel=[[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MAX_WIDTH/2.0f, structureLabel.frame.origin.y+structureLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH/2.0f, 20.0f)];
    intakeLabel.text=[NSString stringWithFormat:@"交付时间:%@",houseInfoModel.lead_time];
    intakeLabel.font=[UIFont systemFontOfSize:14.0f];
    intakeLabel.textAlignment=NSTextAlignmentLeft;
    [view addSubview:intakeLabel];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark - 添加房子服务按钮view
///添加房子服务按钮view
-(void)createHouseServiceViewUI:(QSScrollView *)view
{
    
    CGFloat imageW = 48.0f;
    CGFloat imageH = 52.0f;
    CGFloat imageY = SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat gap = 20.0f;
    
    CGFloat labelW = 60.0f;
    CGFloat labelY = imageY+imageH+8.0f;
    
    QSImageView *bagStay=[[QSImageView alloc] initWithFrame:CGRectMake(0.0f, imageY, imageW,imageH )];
    bagStay.image=[UIImage imageNamed:@"houses_bag"];
    [view addSubview:bagStay];
    
    QSLabel *bagStayLabel=[[QSLabel alloc] initWithFrame:CGRectMake(0.0f, labelY, labelW,20.0f)];
    bagStayLabel.text=@"拎包入住";
    bagStayLabel.textAlignment=NSTextAlignmentLeft;
    bagStayLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:bagStayLabel];
    
    
    QSImageView *appliance=[[QSImageView alloc] initWithFrame:CGRectMake(bagStay.frame.size.width+gap, imageY, imageW, imageH)];
    appliance.image=[UIImage imageNamed:@"houses_appliance"];
    [view addSubview:appliance];
    
    QSLabel *applianceLabel=[[QSLabel alloc] initWithFrame:CGRectMake(appliance.frame.origin.x, labelY, labelW,20.0f)];
    applianceLabel.text=@"家电齐全";
    applianceLabel.textAlignment=NSTextAlignmentLeft;
    applianceLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:applianceLabel];
    
    
    QSImageView *broadband=[[QSImageView alloc] initWithFrame:CGRectMake(appliance.frame.origin.x+appliance.frame.size.width+gap, imageY, imageW, imageH)];
    broadband.image=[UIImage imageNamed:@"houses_broadband"];
    [view addSubview:broadband];
    
    QSLabel *broadbandLabel=[[QSLabel alloc] initWithFrame:CGRectMake(broadband.frame.origin.x, labelY, labelW,20.0f)];
    broadbandLabel.text=@"宽带网络";
    broadbandLabel.textAlignment=NSTextAlignmentLeft;
    broadbandLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:broadbandLabel];
    
    
    QSImageView *linegas=[[QSImageView alloc] initWithFrame:CGRectMake(broadband.frame.origin.x+broadband.frame.size.width+gap, imageY, imageW, imageH)];
    linegas.image=[UIImage imageNamed:@"houses_linegas"];
    [view addSubview:linegas];
    
    QSLabel *linegasLabel=[[QSLabel alloc] initWithFrame:CGRectMake(linegas.frame.origin.x, labelY, labelW,20.0f)];
    linegasLabel.text=@"管道煤气";
    linegasLabel.textAlignment=NSTextAlignmentLeft;
    linegasLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:linegasLabel];
    
    
    QSImageView *mud=[[QSImageView alloc] initWithFrame:CGRectMake(linegas.frame.origin.x+linegas.frame.size.width+gap, imageY, imageW, imageH)];
    mud.image=[UIImage imageNamed:@"houses_mud"];
    [view addSubview:mud];
    
    QSLabel *mudLabel=[[QSLabel alloc] initWithFrame:CGRectMake(mud.frame.origin.x, labelY, labelW,20.0f)];
    mudLabel.text=@"硅藻泥墙";
    mudLabel.textAlignment=NSTextAlignmentLeft;
    mudLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:mudLabel];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
    view.contentSize = CGSizeMake(mud.frame.origin.x+mud.frame.size.width, view.frame.size.height);
    
}

#pragma mark - 添加房子价钱变动view
///添加房子价钱变动view
-(void)createPriceChangeViewUI:(UIView *)view andPriceChanges:(QSHousePriceChangesDataModel *)priceChangesModel
{
    
    ///最近变价
    UILabel *newlyChangeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH/2.0f, 15.0f)];
    newlyChangeLabel.text=[NSString stringWithFormat:@"最近变价:%@",priceChangesModel.update_time];
    newlyChangeLabel.font=[UIFont systemFontOfSize:14.0f];
    newlyChangeLabel.textAlignment=NSTextAlignmentLeft;
    [view addSubview:newlyChangeLabel];
    
    ///价格变动label
    UILabel *consultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, newlyChangeLabel.frame.origin.y+newlyChangeLabel.frame.size.height+5.0f, 70.0f, 15.0f)];
    consultLabel.text = @"价格变动:";

    consultLabel.textColor = COLOR_CHARACTERS_BLACK;
    consultLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:consultLabel];
    
    ///变动次数label
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(consultLabel.frame.size.width, consultLabel.frame.origin.y-5.0f, 44.0f, 25.0f)];
    priceLabel.text = [NSString stringWithFormat:@"%@",priceChangesModel.price_changes_num];
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
    
    ///变动图标
    UIImageView *unitLabel2 = [[UIImageView alloc] initWithFrame:CGRectMake(arrowView.frame.origin.x -10.0f-2.0f,arrowView.frame.origin.y+4.0f , 10.0f, 15.0f)];
    unitLabel2.image=[UIImage imageNamed:IMAGE_HOUSES_DETAIL_PRICEDOWN];
    [view addSubview:unitLabel2];
    
    ///单位
    UILabel *unitLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(unitLabel2.frame.origin.x  -20.0f- 2.0f,arrowView.frame.origin.y+4.0f , 20.0f, 15.0f)];
    unitLabel1.text = @"元";
    unitLabel1.textAlignment = NSTextAlignmentLeft;
    unitLabel1.textColor = COLOR_CHARACTERS_BLACK;
    unitLabel1.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    [view addSubview:unitLabel1];
    
    ///金额
    UILabel *changeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(unitLabel1.frame.origin.x -70.0f- 2.0f, arrowView.frame.origin.y+1.5f, 70.0f, 20.0f)];
    changeCountLabel.text = @"800";
    changeCountLabel.textColor = COLOR_CHARACTERS_YELLOW;
    changeCountLabel.textAlignment = NSTextAlignmentRight;
    changeCountLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [view addSubview:changeCountLabel];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark - 添加小区均价view
///添加小区均价view
-(void)createDistrictAveragePriceViewUI:(UIView *)view andTitle:(NSString *)Districttitle andAveragePrice:(NSString *)averagePrice
{
    ///小区名
    UILabel *consultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH-70.0f, 15.0f)];
    consultLabel.text = [NSString stringWithFormat:@"%@小区均价",Districttitle];
    consultLabel.textColor = COLOR_CHARACTERS_BLACK;
    consultLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:consultLabel];
    
    ///均价
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, consultLabel.frame.origin.y+consultLabel.frame.size.height+5.0f, 55.0f, 25.0f)];
    priceLabel.text = [NSString stringWithFormat:@"%@",averagePrice];
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
    unitLabel1.text = [NSString stringWithFormat:@"/%@",APPLICATION_AREAUNIT];
    unitLabel1.textAlignment = NSTextAlignmentLeft;
    unitLabel1.textColor = COLOR_CHARACTERS_BLACK;
    unitLabel1.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:unitLabel1];
    
    ///右侧箭头
    QSImageView *arrowView = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 13.0f, view.frame.size.height / 2.0f - 11.5f, 13.0f, 23.0f)];
    arrowView.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [view addSubview:arrowView];
    
    ///小区
    UILabel *houseCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-arrowView.frame.size.width-3.0f-30.0f, arrowView.frame.origin.y-4.0f, 30.0f, 12.0f)];
    houseCommentLabel.text = @"小区";
    houseCommentLabel.textColor = COLOR_CHARACTERS_BLACK;
    houseCommentLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_12];
    [view addSubview:houseCommentLabel];
    
    ///详情
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

#pragma mark - 添加房源关注view
///添加房源关注view
-(void)createHouseAttentionViewUI:(UIView *)view andHouseInfo:(QSWRentHouseInfoDataModel *)houseInfoModel

{
    
    ///间隙
    CGFloat width = 60.0f;
    CGFloat gap = (view.frame.size.width - width * 4.0f) / 3.0f;
    
    UILabel *busLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT+15.0f+5.0f, width, 15.0f)];
    busLabel.text = @"房源浏览量";
    busLabel.textAlignment = NSTextAlignmentCenter;
    busLabel.textColor = COLOR_CHARACTERS_GRAY;
    busLabel.font = [UIFont systemFontOfSize:FONT_BODY_12];
    [view addSubview:busLabel];
    
    UILabel *busCountLable = [[UILabel alloc] initWithFrame:CGRectMake(busLabel.frame.origin.x, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, width / 2.0f + 5.0f, 25.0f)];
    busCountLable.text = houseInfoModel.view_count ? houseInfoModel.view_count : @"0";
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
    UILabel *busSepLine = [[UILabel alloc] initWithFrame:CGRectMake(busLabel.frame.origin.x + busLabel.frame.size.width + gap / 2.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT+5.0f, 0.25f, 30.0f)];
    busSepLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:busSepLine];
    
    UILabel *techLabel = [[UILabel alloc] initWithFrame:CGRectMake(width + gap, busLabel.frame.origin.y, width, 15.0f)];
    techLabel.text = @"房客关注";
    techLabel.textAlignment = NSTextAlignmentCenter;
    techLabel.textColor = COLOR_CHARACTERS_GRAY;
    techLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [view addSubview:techLabel];
    
    UILabel *techCountLable = [[UILabel alloc] initWithFrame:CGRectMake(techLabel.frame.origin.x, busCountLable.frame.origin.y, width / 2.0f + 5.0f, 25.0f)];
    techCountLable.text = houseInfoModel.attention_count ? houseInfoModel.attention_count : @"0";
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
    UILabel *techSepLine = [[UILabel alloc] initWithFrame:CGRectMake(techLabel.frame.origin.x + techLabel.frame.size.width + gap / 2.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT+5.0f, 0.25f, 30.0f)];
    techSepLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:techSepLine];
    
    UILabel *medicalLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * (width + gap), busLabel.frame.origin.y, width, 15.0f)];
    medicalLabel.text = @"待看房预约";
    medicalLabel.textAlignment = NSTextAlignmentCenter;
    medicalLabel.textColor = COLOR_CHARACTERS_GRAY;
    medicalLabel.font = [UIFont systemFontOfSize:FONT_BODY_12];
    [view addSubview:medicalLabel];
    
    UILabel *medicalCountLable = [[UILabel alloc] initWithFrame:CGRectMake(medicalLabel.frame.origin.x, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, width / 2.0f + 5.0f, 25.0f)];
    medicalCountLable.text = houseInfoModel.tj_wait_look_house_people ? houseInfoModel.tj_wait_look_house_people : @"0";
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
    UILabel *medicalSepLine = [[UILabel alloc] initWithFrame:CGRectMake(medicalLabel.frame.origin.x + medicalLabel.frame.size.width + gap / 2.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT+5.0f, 0.25f, 30.0f)];
    medicalSepLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:medicalSepLine];
    
    UILabel *foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.0f * (width + gap), busLabel.frame.origin.y, width, 15.0f)];
    foodLabel.text = @"看房预约";
    foodLabel.textAlignment = NSTextAlignmentCenter;
    foodLabel.textColor = COLOR_CHARACTERS_GRAY;
    foodLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [view addSubview:foodLabel];
    
    UILabel *foodCountLable = [[UILabel alloc] initWithFrame:CGRectMake(foodLabel.frame.origin.x, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, width / 2.0f + 5.0f, 25.0f)];
    foodCountLable.text = houseInfoModel.reservation_num ? houseInfoModel.reservation_num : @"0";
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
    
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark - 添加评论view
///添加评论view
-(void)createCommentViewUI:(UIView *)view andCommentInfo:(QSHouseCommentDataModel *) commentModel
{
    
    ///用户头像
    QSImageView *userImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 40.0f, 40.0f)];
    userImageView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_80];
    if ([commentModel.avatar length] > 0) {
        
        [userImageView loadImageWithURL:[commentModel.avatar getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_DEFAULT_80]];
        
    }
    [view addSubview:userImageView];
    
    ///头像六角
    QSImageView *userIconSixForm = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, userImageView.frame.size.width, userImageView.frame.size.height)];
    userIconSixForm.image = [UIImage imageNamed:IMAGE_CHAT_SIXFORM_HOLLOW];
    [userImageView addSubview:userIconSixForm];
    
    ///用户名
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(userImageView.frame.origin.x+userImageView.frame.size.width+5.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 70.0f, 15.0f)];
    userLabel.text = commentModel.title ? commentModel.title : @"暂无";
    userLabel.textColor = COLOR_CHARACTERS_BLACK;
    userLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:userLabel];
    
    UILabel *timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(userLabel.frame.origin.x+userLabel.frame.size.width+5.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 100.0f, 15.0f)];
    timeLabel.text = commentModel.update_time;
    timeLabel.textColor = COLOR_CHARACTERS_BLACK;
    timeLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:timeLabel];
    
    ///评论内容
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(userLabel.frame.origin.x, userLabel.frame.origin.y+userLabel.frame.size.height+3.0f, SIZE_DEFAULT_MAX_WIDTH-70.0f, 15.0f)];
    commentLabel.text = commentModel.content ? commentModel.content : @"暂无";
    commentLabel.textColor = COLOR_CHARACTERS_BLACK;
    commentLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:commentLabel];
    
    ///右侧箭头
    QSImageView *arrowView = [[QSImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 13.0f , view.frame.size.height / 2.0f - 11.5f, 13.0f, 23.0f)];
    arrowView.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [view addSubview:arrowView];
    
    ///评论
    UILabel *houseCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-arrowView.frame.size.width-3.0f-30.0f, arrowView.frame.origin.y-4.0f, 30.0f, 12.0f)];
    houseCommentLabel.text = @"评论";
    houseCommentLabel.textColor = COLOR_CHARACTERS_BLACK;
    houseCommentLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_12];
    [view addSubview:houseCommentLabel];
    
    ///评论数
    UILabel *commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(houseCommentLabel.frame.origin.x, houseCommentLabel.frame.origin.y+houseCommentLabel.frame.size.height+3.0f, 30.0f, 12.0f)];
    commentCountLabel.text = commentModel.num ? commentModel.num : @"暂无";
    commentCountLabel.textColor = COLOR_CHARACTERS_BLACK;
    commentCountLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_12];
    [view addSubview:commentCountLabel];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEFAULT_MAX_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_LEFT_RIGHT,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

#pragma mark - 添加业主view
///添加业主view
-(void)createOwnerViewUI:(UIView *)view andUserInfo:(QSUserSimpleDataModel *)userInfoModel
{
    
    ///业主
    QSImageView *userImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 40.0f, 40.0f)];
    userImageView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_80];
    if ([self.detailInfo.user.avatar length] > 0) {
        
        [userImageView loadImageWithURL:[self.detailInfo.user.avatar getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_DEFAULT_80]];
        
    }
    [view addSubview:userImageView];
    
    ///镂空六角形
    QSImageView *userIconSixForm = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, userImageView.frame.size.width, userImageView.frame.size.height)];
    userIconSixForm.image = [UIImage imageNamed:IMAGE_CHAT_SIXFORM_HOLLOW];
    [userImageView addSubview:userIconSixForm];
    
    ///业主名称
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(userImageView.frame.origin.x+userImageView.frame.size.width+5.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MAX_WIDTH-70.0f, 15.0f)];
    userLabel.text = [NSString stringWithFormat:@"业主:%@",userInfoModel.username ? userInfoModel.username : @"未知"];
    userLabel.textColor = COLOR_CHARACTERS_BLACK;
    userLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:userLabel];
    
    ///评论
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(userLabel.frame.origin.x, userLabel.frame.origin.y+userLabel.frame.size.height+3.0f, SIZE_DEFAULT_MAX_WIDTH-70.0f, 15.0f)];
    
    ///如果未预约，则隐藏手机号
    if ([self.detailInfo.expandInfo.is_book intValue] == 0) {
        
        commentLabel.text = [NSString stringWithFormat:@"%@******%@ (%@) | 二手房(%@) | 出租(%@)",[userInfoModel.mobile substringToIndex:3],[userInfoModel.mobile substringFromIndex:9],@"未开放",userInfoModel.tj_secondHouse_num,userInfoModel.tj_rentHouse_num];
        
    }
    
    ///如果已经预约过，则显示电话号码
    if (1 == [self.detailInfo.expandInfo.is_book intValue]) {
        
        commentLabel.text = [NSString stringWithFormat:@"%@ | 二手房(%@) | 出租(%@)",userInfoModel.mobile,userInfoModel.tj_secondHouse_num,userInfoModel.tj_rentHouse_num];
        
    }
    
    commentLabel.textColor = COLOR_CHARACTERS_BLACK;
    commentLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [view addSubview:commentLabel];
    
    ///按钮风格
    QSBlockButtonStyleModel *connectButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    
    ///联系业主按钮
    connectButtonStyle.title = TITLE_HOUSES_DETAIL_RENT_CONNECT;
    UIButton *connectButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, commentLabel.frame.origin.y + commentLabel.frame.size.height+SIZE_DEFAULT_MARGIN_LEFT_RIGHT,view.frame.size.width,35.0f) andButtonStyle:connectButtonStyle andCallBack:^(UIButton *button) {
        
        ///判断是否已登录
        [self checkLoginAndShowLoginWithBlock:^(LOGIN_CHECK_ACTION_TYPE flag) {
            
            ///已登录
            if (lLoginCheckActionTypeLogined == flag) {
                
                ///判断是否已预约：已经预约方可联系业主
                if (0 < [self.detailInfo.expandInfo.is_book intValue]) {
                    
                    [self contactHouseOwner:userInfoModel.mobile andOwer:userInfoModel.nickname];
                    
                }
                
                ///未预约，则弹出提示
                if (0 >= [self.detailInfo.expandInfo.is_book intValue]) {
                    
                    TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请先预约看房，预约成功后方可拨打业主电话", 1.0f, ^(){})
                    
                }
                
            }
            
            ///新登录，刷新数据
            if (lLoginCheckActionTypeReLogin == flag) {
                
                UIScrollView *rootView = objc_getAssociatedObject(self, &DetailRootViewKey);
                [rootView.header beginRefreshing];
                
            }
            
        }];
        
    }];
    [view addSubview:connectButton];
    
}

#pragma mark - 联系业主事件
- (void)contactHouseOwner:(NSString *)number andOwer:(NSString *)ower
{
    
    ///弹出框
    __block QSYPopCustomView *popView;
    
    QSYCallTipsPopView *callTipsView = [[QSYCallTipsPopView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 130.0f, SIZE_DEVICE_WIDTH, 130.0f) andName:ower andPhone:number andCallBack:^(CALL_TIPS_CALLBACK_ACTION_TYPE actionType) {
        
        ///回收弹框
        [popView hiddenCustomPopview];
        
        ///确认打电话
        if (cCallTipsCallBackActionTypeConfirm == actionType) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumber]]];
            
        }
        
    }];
    
    popView = [QSYPopCustomView popCustomViewWithoutChangeFrame:callTipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
        
    }];
    
}

#pragma mark - 请求详情信息
- (void)getRentHouseDetailInfo
{
    
    ///封装参数
    NSDictionary *params = @{@"id_" : self.detailID ? self.detailID : @""};
    
    ///进行请求
    [QSRequestManager requestDataWithType:rRequestTypeRentalHouseDetail andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///转换模型
            QSRentHousesDetailReturnData *tempModel = resultData;
            
            ///保存返回的数据模型
            self.detailInfo = tempModel.detailInfo;
            self.houseInfo = tempModel.detailInfo.house;
            
            ///创建详情UI
            [self createNewDetailInfoViewUI:tempModel.detailInfo];
            [self createBottomButtonViewUI];
            
            ///1秒后停止动画，并显示界面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIScrollView *rootView = objc_getAssociatedObject(self, &DetailRootViewKey);
                [self showInfoUI:YES];
                [rootView.header endRefreshing];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    ///添加浏览记录
                    [self addBrowseRecords];
                    
                });
                
            });
            
        } else {
            
            UIScrollView *rootView = objc_getAssociatedObject(self, &DetailRootViewKey);
            [rootView.header endRefreshing];
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"获取出租房详情信息失败，请稍后再试……",1.0f,^(){
                
                ///推回上一页
                [self.navigationController popViewControllerAnimated:YES];
                
            })
            
        }
        
    }];
    
}

#pragma mark - 添加浏览记录
- (void)addBrowseRecords
{

    [QSCoreDataManager saveHistoryDataWithModel:self.detailInfo andCollectedType:fFilterMainTypeRentalHouse andCallBack:^(BOOL flag) {
        
        if (flag) {
            
            APPLICATION_LOG_INFO(@"出租房浏览记录添加", @"成功")
            
        } else {
        
            APPLICATION_LOG_INFO(@"出租房浏览记录添加", @"失败")
        
        }
        
    }];

}

#pragma mark - 分享出租房
///分享出租房
- (void)shareRentHouse:(UIButton *)button
{
    
    ///弹出窗口的指针
    __block QSYPopCustomView *popView = nil;
    
    ///提示选择窗口
    QSYShareChoicesView *saleTipsView = [[QSYShareChoicesView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 150.0f) andShareCallBack:^(SHARE_CHOICES_TYPE actionType) {
        
        ///加收弹出窗口
        [popView hiddenCustomPopview];
        
        ///处理不同的分享事件
        switch (actionType) {
                ///新浪微博
            case sShareChoicesTypeXinLang:
                
                break;
                
                ///朋友圈
            case sShareChoicesTypeFriends:
                
                break;
                
                ///微信朋友圈
            case sShareChoicesTypeWeChat:
                
                break;
                
            default:
                break;
        }
        
    }];
    
    ///弹出窗口
    popView = [QSYPopCustomView popCustomView:saleTipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {}];
    
}

#pragma mark - 收藏当前出租房
///收藏当前出租房
- (void)collectRentHouse:(UIButton *)button
{
    
    ///已收藏，则删除收藏
    if (button.selected) {
        
        [self deleteCollectedRentHouse:button];
        
    } else {
        
        [self addCollectedRentHouse:button];
        
    }
    
}

///删除收藏
- (void)deleteCollectedRentHouse:(UIButton *)button
{
    
    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在取消收藏"];
    
    ///判断当前收藏是否已同步服务端，若未同步，不需要联网删除
    QSRentHouseDetailDataModel *localDataModel = [QSCoreDataManager searchCollectedDataWithID:self.detailInfo.house.id_ andCollectedType:fFilterMainTypeRentalHouse];
    if (0 == [localDataModel.house.is_syserver intValue]) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"取消收藏房源成功"];
        [self deleteCollectedRentWithStatus:YES];
        button.selected = NO;
        return;
        
    }
    
    ///判断是否已登录
    if (lLoginCheckActionTypeUnLogin == [self checkLogin]) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"取消收藏房源成功"];
        [self deleteCollectedRentWithStatus:NO];
        button.selected = NO;
        return;
        
    }
    
    ///封装参数
    NSDictionary *params = @{@"obj_id" : self.detailInfo.house.id_,
                             @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeRentalHouse]};
    
    [QSRequestManager requestDataWithType:rRequestTypeRentalHouseDeleteCollected andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"取消收藏房源成功"];
        
        ///同步服务端成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self deleteCollectedRentWithStatus:YES];
                
            });
            
        } else {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self deleteCollectedRentWithStatus:NO];
                
            });
            
        }
        
        ///修改按钮状态为已收藏状态
        button.selected = NO;
        
    }];
    
}

///添加收藏
- (void)addCollectedRentHouse:(UIButton *)button
{
    
    ///显示HUD
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在添加收藏"];
    
    ///判断是否已登录
    if (lLoginCheckActionTypeUnLogin == [self checkLogin]) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"添加收藏房源成功"];
        [self saveCollectedRentHouseWithStatus:NO];
        button.selected = YES;
        return;
        
    }
    
    ///封装参数
    NSDictionary *params = @{@"obj_id" : self.detailInfo.house.id_,
                             @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeRentalHouse]};
    
    [QSRequestManager requestDataWithType:rRequestTypeRentalHouseCollected andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///隐藏HUD
        [hud hiddenCustomHUDWithFooterTips:@"添加收藏房源成功"];
        
        ///同步服务端成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self saveCollectedRentHouseWithStatus:YES];
                
            });
            
        } else {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self saveCollectedRentHouseWithStatus:NO];
                
            });
            
        }
        
        ///修改按钮状态为已收藏状态
        button.selected = YES;
        
    }];
    
}

#pragma mark - 添加本地收藏
///将收藏信息保存本地
- (void)saveCollectedRentHouseWithStatus:(BOOL)isSendServer
{
    
    ///当前新房收藏是否同步服务端标识
    if (isSendServer) {
        
        self.detailInfo.house.is_syserver = @"1";
        
    } else {
        
        self.detailInfo.house.is_syserver = @"0";
        
    }
    
    ///保存新房信息到本地
    [QSCoreDataManager saveCollectedDataWithModel:self.detailInfo andCollectedType:fFilterMainTypeRentalHouse andCallBack:^(BOOL flag) {
        
        ///显示保存信息
        if (flag) {
            
            APPLICATION_LOG_INFO(@"出租房收藏->保存本地", @"成功")
            
        } else {
            
            APPLICATION_LOG_INFO(@"出租收藏->保存本地", @"失败")
            
        }
        
    }];
    
}

#pragma mark - 取消本地收藏
///取消本地收藏
- (void)deleteCollectedRentWithStatus:(BOOL)isSendServer
{
    
    ///删除本地收藏的新房信息
    [QSCoreDataManager deleteCollectedDataWithID:self.detailInfo.house.id_ isSyServer:isSendServer andCollectedType:fFilterMainTypeRentalHouse andCallBack:^(BOOL flag) {
        
        ///显示保存信息
        if (flag) {
            
            APPLICATION_LOG_INFO(@"出租房收藏->删除", @"成功")
            
        } else {
            
            APPLICATION_LOG_INFO(@"出租房收藏->删除", @"失败")
            
        }
        
    }];
    
}

@end
