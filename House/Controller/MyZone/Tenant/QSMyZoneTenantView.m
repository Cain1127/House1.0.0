//
//  QSMyZoneTenantView.m
//  House
//
//  Created by ysmeng on 15/2/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMyZoneTenantView.h"

#import "UIButton+Factory.h"

#import <objc/runtime.h>


///功能按钮的起始tag
#define TAG_RENANT_ROOT 99

@interface QSMyZoneTenantView ()

@property (nonatomic,copy) BLOCK_TENANT_ZONE_CALLBACK tenantCallBack;//!<房客页面回调

@end

///关联
static char StayAroundKey;  //!<待看房任务数量关联key
static char HavedAroundKey; //!<已看房任务数量关联key
static char WaitCommitKey;  //!<待成交任务数量关联key
static char CommitedKey;    //!<已成交任务数量关联key

static char AppointedKey;   //!<预约订单
static char DealKey;        //!<成交订单
static char BegKey;         //!<求租求购
static char CollectKey;     //!<收藏房源
static char CommunityKey;   //!<关注小区
static char HistoryKey;     //!<浏览足迹

@implementation QSMyZoneTenantView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-02-10 17:02:02
 *
 *  @brief          根据frame和回调创建房客个人中心UI
 *
 *  @param frame    大小和位四置
 *  @param callBack 事件回调
 *
 *  @return         返回当前创建的房客UI
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(TENANT_ZONE_ACTION_TYPE actionType,id params))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///保存回调
        if (callBack) {
            
            self.tenantCallBack = callBack;
            
        }
        
        ///UI搭建
        [self createTenantZoneUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
/**
 *  @author yangshengmeng, 15-02-10 17:02:14
 *
 *  @brief  UI搭建
 *
 *  @since  1.0.0
 */
- (void)createTenantZoneUI
{

    ///按钮栏
    UIView *channelButtonRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 69.0f)];
    [self createChannelBarButton:channelButtonRootView];
    [self addSubview:channelButtonRootView];
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, channelButtonRootView.frame.size.height - 0.5f, self.frame.size.width, 0.5f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self addSubview:sepLabel];
    
    ///其他信息项底view
    UIScrollView *mainRootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, channelButtonRootView.frame.size.height, self.frame.size.width, self.frame.size.height - channelButtonRootView.frame.size.height)];
    mainRootView.showsHorizontalScrollIndicator = NO;
    mainRootView.showsVerticalScrollIndicator = NO;
    [self createMainFunctionButton:mainRootView];
    [self addSubview:mainRootView];

}

///频道按钮
- (void)createChannelBarButton:(UIView *)view
{
    
    ///每个控制的宽
    CGFloat width = (view.frame.size.width - 1.5f) / 4.0f;
    
    ///待看房信息
    UIView *stayAroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, view.frame.size.height)];
    stayAroundView.tag = tTenantZoneActionTypeStayAround;
    [self createChannelButtonUI:stayAroundView andTitle:@"待看房" andKey:StayAroundKey];
    [view addSubview:stayAroundView];
    [self addSingleTagForChannelRootView:stayAroundView];

    ///第一个分隔线
    UILabel *firstSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 4.0f - 0.25f, 0.0f, 0.5f, view.frame.size.height)];
    firstSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:firstSepLabel];
    
    ///已看房
    UIView *havedAroundView = [[UIView alloc] initWithFrame:CGRectMake(stayAroundView.frame.size.width + 0.5f, 0.0f, width, view.frame.size.height)];
    havedAroundView.tag = tTenantZoneActionTypeHavedAround;
    [self createChannelButtonUI:havedAroundView andTitle:@"已看房" andKey:HavedAroundKey];
    [view addSubview:havedAroundView];
    [self addSingleTagForChannelRootView:havedAroundView];
    
    ///第二个分隔线
    UILabel *secondSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f - 0.25f, 0.0f, 0.5f, view.frame.size.height)];
    secondSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:secondSepLabel];
    
    ///待成交
    UIView *waitCommitView = [[UIView alloc] initWithFrame:CGRectMake(havedAroundView.frame.origin.x + havedAroundView.frame.size.width + 0.5f, 0.0f, width, view.frame.size.height)];
    waitCommitView.tag = tTenantZoneActionTypeWaitCommit;
    [self createChannelButtonUI:waitCommitView andTitle:@"待成交" andKey:WaitCommitKey];
    [view addSubview:waitCommitView];
    [self addSingleTagForChannelRootView:waitCommitView];
    
    ///第三个分隔线
    UILabel *thirdSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width * 3.0f / 4.0f - 0.25f, 0.0f, 0.5f, view.frame.size.height)];
    thirdSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:thirdSepLabel];
    
    ///待成交
    UIView *commitedView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width - width, 0.0f, width, view.frame.size.height)];
    commitedView.tag = tTenantZoneActionTypeCommited;
    [self createChannelButtonUI:commitedView andTitle:@"已成交" andKey:CommitedKey];
    [view addSubview:commitedView];
    [self addSingleTagForChannelRootView:commitedView];

}

#pragma mark - 导航栏按钮的基本UI创建
///导航栏按钮的基本UI创建
- (void)createChannelButtonUI:(UIView *)view andTitle:(NSString *)title andKey:(char)key
{

    ///数量提示
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake((view.frame.size.width - 34.0f) / 2.0f, 10.0f, 34.0f, 34.0f)];
    countLabel.text = @"0";
    countLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.textColor = COLOR_CHARACTERS_BLACK;
    countLabel.layer.cornerRadius = 17.0f;
    countLabel.layer.masksToBounds = YES;
    [view addSubview:countLabel];
    objc_setAssociatedObject(self, &key, countLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, countLabel.frame.origin.y + countLabel.frame.size.height, view.frame.size.width, 15.0f)];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:titleLabel];

}

///主要功能按钮
- (void)createMainFunctionButton:(UIScrollView *)view
{
    
    ///获取配置信息数据
    NSArray *infoArray = [self getMyZoneRenantInfoList];
    
    ///创建按钮
    [self createMainFunctionButtonUI:infoArray andRootView:view];
    
}

///创建不同的功能按钮
- (void)createMainFunctionButtonUI:(NSArray *)infoList andRootView:(UIScrollView *)view
{
    
    ///布局高度
    CGFloat layoutHeight = view.frame.size.height;
    
    ///判断是否是4s
    if (SIZE_DEVICE_HEIGHT <= 480.0f) {
        
        view.contentSize = CGSizeMake(view.frame.size.width, 245.0f);
        layoutHeight = 245.0f;
        
    }

    ///按钮宽
    CGFloat width = 80.0f;
    
    ///按钮高
    CGFloat height = 85.0f;
    
    ///底部提示信息高
    CGFloat tipsHeight = 15.0f;
    
    ///纵向间隙
    CGFloat gapH = (layoutHeight - 2.0f * (height + tipsHeight)) / 3.0f;
    
    ///横向间隙
    CGFloat gapW = (view.frame.size.width - 3.0f * width) / 4.0f;
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.titleNormalColor = COLOR_CHARACTERS_BLACK;
    buttonStyle.titleHightedColor = COLOR_CHARACTERS_YELLOW;
    buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_16];
    
    ///循环创建功能按钮
    for (int i = 0; i < [infoList count]; i++) {
        
        ///数据模型
        NSDictionary *infoModel = infoList[i];
        
        ///设置按钮的风格
        buttonStyle.title = [infoModel valueForKey:@"title"];
        buttonStyle.imagesNormal = [infoModel valueForKey:@"image_normal"];
        buttonStyle.imagesHighted = [infoModel valueForKey:@"image_highlighted"];
        
        ///功能按钮
        UIButton *button = [UIButton createCustomStyleButtonWithFrame:CGRectMake(gapW + (i % 3) * (gapW + width), gapH + (i / 3) * (gapH + tipsHeight + height), width, height) andButtonStyle:buttonStyle andCustomButtonStyle:cCustomButtonStyleBottomTitle andTitleSize:15.0f andMiddleGap:0.0f andCallBack:^(UIButton *button) {
            
            [self functionButtonAction:[[infoModel valueForKey:@"action_tag"] intValue]];
            
        }];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        ///提示说明信息
        UILabel *tipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y + button.frame.size.height, button.frame.size.width, tipsHeight)];
        tipsLabel.text = @"查看全部";
        tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
        tipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        TENANT_ZONE_ACTION_TYPE buttonType = [[infoModel valueForKey:@"subtitle_tag"] intValue];
        char tipsLabelKey = [self getAssociationKeyWithButtonType:buttonType];
        objc_setAssociatedObject(self, &tipsLabelKey, tipsLabel, OBJC_ASSOCIATION_ASSIGN);
        
        [view addSubview:button];
        [view addSubview:tipsLabel];
        
    }

}

#pragma mark - 根据不同的按钮返回不同的关联key
///根据不同的按钮返回不同的关联key
- (char)getAssociationKeyWithButtonType:(TENANT_ZONE_ACTION_TYPE)buttonType
{

    switch (buttonType) {
            ///预约订单
        case tTenantZoneActionTypeAppointed:
            
            return AppointedKey;
            
            break;
            
            ///已完成订单
        case tTenantZoneActionTypeDeal:
            
            return DealKey;
            
            break;
            
            ///求租求购
        case tTenantZoneActionTypeBeg:
            
            return BegKey;
            
            break;
            
            ///收藏房源
        case tTenantZoneActionTypeCollected:
            
            return CollectKey;
            
            break;
            
            ///关注小区
        case tTenantZoneActionTypeCommunity:
            
            return CommunityKey;
            
            break;
            
            ///浏览记录
        case tTenantZoneActionTypeHistory:
            
            return HistoryKey;
            
            break;
            
        default:
            break;
    }
    
    return StayAroundKey;

}

#pragma mark - 频道栏的单击手势
///为频道栏的控制添加单击事件
- (void)addSingleTagForChannelRootView:(UIView *)view
{

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(channelBarButtonAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tap];

}

#pragma mark - 频道栏控制点击事件
///频道栏控制点击事件
- (void)channelBarButtonAction:(UITapGestureRecognizer *)tap
{

    [self functionButtonAction:(TENANT_ZONE_ACTION_TYPE)tap.view.tag];

}

#pragma mark - 点击不同功能按钮时的事件过滤
///点击不同功能按钮时的事件过滤
- (void)functionButtonAction:(TENANT_ZONE_ACTION_TYPE)actionTag
{

    switch (actionTag) {
            ///待看房点击
        case tTenantZoneActionTypeStayAround:
            
            NSLog(@"==================待看房======================");
            
            break;
            
            ///已看房点击
        case tTenantZoneActionTypeHavedAround:
            
            NSLog(@"==================已看房======================");
            
            break;
            
            ///待成交点击
        case tTenantZoneActionTypeWaitCommit:
            
            NSLog(@"==================待成交======================");
            
            break;
            
            ///已成交点击
        case tTenantZoneActionTypeCommited:
            
            NSLog(@"==================已成交======================");
            
            break;
            
            ///预约订单击
        case tTenantZoneActionTypeAppointed:
            
            NSLog(@"==================预约订单======================");
            
            break;
            
            ///已成交订单点击
        case tTenantZoneActionTypeDeal:
            
            NSLog(@"==================已成交订单======================");
            
            break;
            
            ///求租求购点击
        case tTenantZoneActionTypeBeg:
            
            NSLog(@"==================求租求购======================");
            
            break;
            
            ///收藏房源
        case tTenantZoneActionTypeCollected:
            
            NSLog(@"==================收藏房源======================");
            
            break;
            
            ///关注小区
        case tTenantZoneActionTypeCommunity:
            
            NSLog(@"==================关注小区======================");
            
            break;
            
            ///浏览记录
        case tTenantZoneActionTypeHistory:
            
            NSLog(@"==================浏览记录======================");
            
            break;
            
        default:
            break;
    }

    if (self.tenantCallBack) {
        self.tenantCallBack(actionTag,nil);
    }
}

#pragma mark - 返回房客的基本功能配置信息
///返回房客的基本功能配置信息
- (NSArray *)getMyZoneRenantInfoList
{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"MyZoneInfo" ofType:@"plist"];
    NSDictionary *tempDict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return [tempDict valueForKey:@"renant"];

}

#pragma mark - 刷新UI
/**
 *  @author yangshengmeng, 15-02-11 13:02:53
 *
 *  @brief  刷新UI
 *
 *  @since  1.0.0
 */

///更新待看房数量
- (void)updateStayAroundCount:(NSString *)newInfo
{

    UILabel *label = objc_getAssociatedObject(self, &StayAroundKey);
    if (label && newInfo) {
        
        label.text = newInfo;
        
        ///判断数量是0或大于零
        if (100 <= [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@+",newInfo];
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else if (0 < [newInfo intValue]) {
            
            label.text = newInfo;
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else {
            
            label.backgroundColor = [UIColor clearColor];
            
        }
        
    }

}

///更新已看房数量
- (void)updateHavedAroundCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &HavedAroundKey);
    if (label && newInfo) {
        
        label.text = newInfo;
        
        ///判断数量是0或大于零
        if (100 <= [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@+",newInfo];
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else if (0 < [newInfo intValue]) {
            
            label.text = newInfo;
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else {
            
            label.backgroundColor = [UIColor clearColor];
            
        }
        
    }
    
}

///更新待成交数量
- (void)updateWaitCommitAroundCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &WaitCommitKey);
    if (label && newInfo) {
        
        label.text = newInfo;
        
        ///判断数量是0或大于零
        if (100 <= [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@+",newInfo];
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else if (0 < [newInfo intValue]) {
            
            label.text = newInfo;
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else {
            
            label.backgroundColor = [UIColor clearColor];
            
        }
        
    }
    
}

///更新已成交数量
- (void)updateCommitedCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &CommitedKey);
    if (label && newInfo) {
        
        ///判断数量是0或大于零
        if (100 <= [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@+",newInfo];
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else if (0 < [newInfo intValue]) {
            
            label.text = newInfo;
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else {
        
            label.backgroundColor = [UIColor clearColor];
        
        }
        
    }
    
}

///预约订单
- (void)updateAppointedOrderCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &AppointedKey);
    if (label && newInfo) {
        
        ///判断数量是0或大于零
        if (100 <= [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@+",newInfo];
            
        } else if (0 < [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@条记录",newInfo];
            
        } else {
            
            label.text = @"查看全部";
            
        }
        
    }
    
}

///已完成订单
- (void)updateDealOrderCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &DealKey);
    if (label && newInfo) {
        
        ///判断数量是0或大于零
        if (100 <= [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@+",newInfo];
            
        } else if (0 < [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@条记录",newInfo];
            
        } else {
            
            label.text = @"查看全部";
            
        }
        
    }
    
}

///求租求购
- (void)updateBegCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &BegKey);
    if (label && newInfo) {
        
        ///判断数量是0或大于零
        if (100 <= [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@+",newInfo];
            
        } else if (0 < [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@条记录",newInfo];
            
        } else {
            
            label.text = @"查看全部";
            
        }
        
    }
    
}

///收藏房源
- (void)updateCollectCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &CollectKey);
    if (label && newInfo) {
        
        ///判断数量是0或大于零
        if (100 <= [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@+",newInfo];
            
        } else if (0 < [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@个房源",newInfo];
            
        } else {
            
            label.text = @"暂无收藏";
            
        }
        
    }
    
}

///关注小区
- (void)updateCommunityCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &CommunityKey);
    if (label && newInfo) {
        
        ///判断数量是0或大于零
        if (100 <= [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@+",newInfo];
            
        } else if (0 < [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@个小区",newInfo];
            
        } else {
            
            label.text = @"暂无关注";
            
        }
        
    }
    
}

///浏览足迹
- (void)updateHistoryCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &HistoryKey);
    if (label && newInfo) {
        
        ///判断数量是0或大于零
        if (100 <= [newInfo intValue]) {
            
            label.text = [NSString stringWithFormat:@"%@+",newInfo];
            
        } else if (0 < [newInfo intValue]) {
        
            label.text = [NSString stringWithFormat:@"%@条记录",newInfo];
        
        } else {
            
            label.text = @"暂无浏览";
            
        }
        
    }
    
}

@end
