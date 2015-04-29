//
//  QSMyZoneOwnerView.m
//  House
//
//  Created by ysmeng on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMyZoneOwnerView.h"

#import "UIButton+Factory.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSYMyzoneStatisticsOwnerModel.h"

#import <objc/runtime.h>

///关联
static char MainInfoButtonRootViewKey;//!<功能按钮区的底view

@interface QSMyZoneOwnerView ()

@property (nonatomic,assign) USER_COUNT_TYPE userType;              //!<用户类型
@property (nonatomic,copy) BLOCK_OWNER_ZONE_CALLBACK ownerCallBack; //!<业主回调

@end

///关联
static char StayAroundKey;  //!<待看房任务数量关联key
static char HavedAroundKey; //!<已看房任务数量关联key
static char WaitCommitKey;  //!<待成交任务数量关联key
static char CommitedKey;    //!<已成交任务数量关联key

static char AppointedKey;   //!<预约订单关联key
static char DealKey;        //!<成交订单关联key
static char PropertyKey;    //!<物业管理关联key
static char RecommendKey;   //!<推荐房源关联key

@implementation QSMyZoneOwnerView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-02-11 17:02:00
 *
 *  @brief          创建一个给定用户类型的业主页面UI
 *
 *  @param frame    大小的位置
 *  @param userType 用户类型
 *  @param callBack 业主页面功能回调
 *
 *  @return         返回当前创建的业主功能UI
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andUserType:(USER_COUNT_TYPE)userType andCallBack:(BLOCK_OWNER_ZONE_CALLBACK)callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///保存用户类型
        self.userType = userType;
        
        ///保存回调
        if (callBack) {
            
            self.ownerCallBack = callBack;
            
        }
        
        ///创建UI
        [self createOwnerFunctionUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createOwnerFunctionUI
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
    [self addSubview:mainRootView];
    objc_setAssociatedObject(self, &MainInfoButtonRootViewKey, mainRootView, OBJC_ASSOCIATION_ASSIGN);

    ///根据用户类型创建不同的UI
    if (uUserCountTypeTenant == self.userType) {
        
        ///创建房客的业主页面
        [self createRenantOwnerFunctionUI:mainRootView];
        
    } else {
    
        ///正常业主功能页面
        [self createOwnerNormalFunctionUI:mainRootView];
    
    }

}

///频道按钮
- (void)createChannelBarButton:(UIView *)view
{
    
    ///每个控制的宽
    CGFloat width = (view.frame.size.width - 1.5f) / 4.0f;
    
    ///待看房信息
    UIView *stayAroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, view.frame.size.height)];
    stayAroundView.tag = oOwnerZoneActionTypeStayAround;
    [self createChannelButtonUI:stayAroundView andTitle:@"待看房" andKey:&StayAroundKey];
    [view addSubview:stayAroundView];
    [self addSingleTagForChannelRootView:stayAroundView];
    
    ///第一个分隔线
    UILabel *firstSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 4.0f - 0.25f, 0.0f, 0.5f, view.frame.size.height)];
    firstSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:firstSepLabel];
    
    ///已看房
    UIView *havedAroundView = [[UIView alloc] initWithFrame:CGRectMake(stayAroundView.frame.size.width + 0.5f, 0.0f, width, view.frame.size.height)];
    havedAroundView.tag = oOwnerZoneActionTypeHavedAround;
    [self createChannelButtonUI:havedAroundView andTitle:@"已看房" andKey:&HavedAroundKey];
    [view addSubview:havedAroundView];
    [self addSingleTagForChannelRootView:havedAroundView];
    
    ///第二个分隔线
    UILabel *secondSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f - 0.25f, 0.0f, 0.5f, view.frame.size.height)];
    secondSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:secondSepLabel];
    
    ///待成交
    UIView *waitCommitView = [[UIView alloc] initWithFrame:CGRectMake(havedAroundView.frame.origin.x + havedAroundView.frame.size.width + 0.5f, 0.0f, width, view.frame.size.height)];
    waitCommitView.tag = oOwnerZoneActionTypeWaitCommit;
    [self createChannelButtonUI:waitCommitView andTitle:@"待成交" andKey:&WaitCommitKey];
    [view addSubview:waitCommitView];
    [self addSingleTagForChannelRootView:waitCommitView];
    
    ///第三个分隔线
    UILabel *thirdSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width * 3.0f / 4.0f - 0.25f, 0.0f, 0.5f, view.frame.size.height)];
    thirdSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:thirdSepLabel];
    
    ///待成交
    UIView *commitedView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width - width, 0.0f, width, view.frame.size.height)];
    commitedView.tag = oOwnerZoneActionTypeCommited;
    [self createChannelButtonUI:commitedView andTitle:@"已成交" andKey:&CommitedKey];
    [view addSubview:commitedView];
    [self addSingleTagForChannelRootView:commitedView];
    
}

#pragma mark - 导航栏按钮的基本UI创建
///导航栏按钮的基本UI创建
- (void)createChannelButtonUI:(UIView *)view andTitle:(NSString *)title andKey:(const void *)key
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
    objc_setAssociatedObject(self, key, countLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, countLabel.frame.origin.y + countLabel.frame.size.height, view.frame.size.width, 15.0f)];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:titleLabel];
    
}

#pragma mark - 主体功能UI搭建
///业主的正常功能UI
- (void)createOwnerNormalFunctionUI:(UIScrollView *)view
{
    
    ///清空
    for (UIView *obj in [view subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
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
    
    ///获取配置信息
    NSArray *infoList = [self getMyZoneOwnerInfoList];
    
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
        OWNER_ZONE_ACTION_TYPE buttonActionType = [[infoModel valueForKey:@"subtitle_tag"] intValue];
        const void *tipsLabelKey = [self getAssociationKeyWithButtonType:buttonActionType];
        objc_setAssociatedObject(self, tipsLabelKey, tipsLabel, OBJC_ASSOCIATION_ASSIGN);
        
        [view addSubview:button];
        [view addSubview:tipsLabel];
        
    }

}

///房客的用户时，显示如何成为业主
- (void)createRenantOwnerFunctionUI:(UIView *)mainRootView
{
    
    ///清空
    for (UIView *obj in [mainRootView subviews]) {
        
        [obj removeFromSuperview];
        
    }

    ///开始的y坐标
    CGFloat ypoint = (mainRootView.frame.size.height - 139.0f) / 2.0f;
    
    ///按钮的宽度
    CGFloat width = (mainRootView.frame.size.width - 35.0f * 2.0f - 8.0f) / 2.0f;
    
    ///提示信息
    UILabel *tipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(50.0f, ypoint, mainRootView.frame.size.width - 35.0f * 2.0f - 30.0f, 60.0f)];
    tipsLabel.text = @"想成为业主用户，\n马上发布出售或出租物业吧！";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    tipsLabel.numberOfLines = 2;
    tipsLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [mainRootView addSubview:tipsLabel];
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_18];
    buttonStyle.title = @"发布出售物业";
    
    ///出售物业按钮
    UIButton *saleHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake(35.0f, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + 35.0f, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        [self functionButtonAction:oOwnerZoneActionTypeSaleHouse];
        
    }];
    [mainRootView addSubview:saleHouseButton];
    
    ///出租物业
    buttonStyle.title = @"发布出租物业";
    UIButton *renantHouseButton = [UIButton createBlockButtonWithFrame:CGRectMake(saleHouseButton.frame.origin.x + saleHouseButton.frame.size.width + 8.0f, saleHouseButton.frame.origin.y, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        [self functionButtonAction:oOwnerZoneActionTypeRenantHouse];
        
    }];
    [mainRootView addSubview:renantHouseButton];

}

#pragma mark - 根据不同的按钮返回不同的关联key
///根据不同的按钮返回不同的关联key
- (const void *)getAssociationKeyWithButtonType:(OWNER_ZONE_ACTION_TYPE)buttonType
{
    
    switch (buttonType) {
            ///预约我的订单
        case oOwnerZoneActionTypeAppointed:
            
            return &AppointedKey;
            
            break;
            
            ///已完成订单
        case oOwnerZoneActionTypeDeal:
            
            return &DealKey;
            
            break;
            
            ///物业管理
        case oOwnerZoneActionTypeProprerty:
            
            return &PropertyKey;
            
            break;
            
            ///推荐房客
        case oOwnerZoneActionTypeRecommend:
            
            return &RecommendKey;
            
            break;
            
        default:
            break;
    }
    
    return &StayAroundKey;
    
}

#pragma mark - 返回房客的基本功能配置信息
///返回房客的基本功能配置信息
- (NSArray *)getMyZoneOwnerInfoList
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MyZoneInfo" ofType:@"plist"];
    NSDictionary *tempDict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return [tempDict valueForKey:@"owner"];
    
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
    
    [self functionButtonAction:(OWNER_ZONE_ACTION_TYPE)tap.view.tag];
    
}

#pragma mark - 点击不同功能按钮时的事件过滤
///点击不同功能按钮时的事件过滤
- (void)functionButtonAction:(OWNER_ZONE_ACTION_TYPE)actionTag
{
    
    switch (actionTag) {
            ///发售物业
        case oOwnerZoneActionTypeSaleHouse:
            
            if (self.ownerCallBack) {
                
                self.ownerCallBack(oOwnerZoneActionTypeSaleHouse,nil);
                
            }
            
            break;
            
            ///发布出租物业
        case oOwnerZoneActionTypeRenantHouse:
            
            if (self.ownerCallBack) {
                
                self.ownerCallBack(oOwnerZoneActionTypeRenantHouse,nil);
                
            }
            
            break;
            
            ///待看房
        case oOwnerZoneActionTypeStayAround:
            
            if (self.ownerCallBack) {
                
                self.ownerCallBack(oOwnerZoneActionTypeStayAround,nil);
                
            }
            
            break;
            
            ///已看房
        case oOwnerZoneActionTypeHavedAround:
            
            if (self.ownerCallBack) {
                
                self.ownerCallBack(oOwnerZoneActionTypeHavedAround,nil);
                
            }
            
            break;
            
            ///待成交
        case oOwnerZoneActionTypeWaitCommit:
            
            if (self.ownerCallBack) {
                
                self.ownerCallBack(oOwnerZoneActionTypeWaitCommit,nil);
                
            }
            
            break;
            
            ///已成交
        case oOwnerZoneActionTypeCommited:
            
            if (self.ownerCallBack) {
                
                self.ownerCallBack(oOwnerZoneActionTypeCommited,nil);
                
            }
            
            break;
            
            ///预约我的订单
        case oOwnerZoneActionTypeAppointed:
            
            if (self.ownerCallBack) {
                
                self.ownerCallBack(oOwnerZoneActionTypeAppointed,nil);
                
            }
            
            break;
            
            ///已成交订单
        case oOwnerZoneActionTypeDeal:
            
            if (self.ownerCallBack) {
                
                self.ownerCallBack(oOwnerZoneActionTypeDeal,nil);
                
            }
            
            break;
            
            ///物业管理
        case oOwnerZoneActionTypeProprerty:
            
            if (self.ownerCallBack) {
                
                self.ownerCallBack(oOwnerZoneActionTypeProprerty,nil);
                
            }
            
            break;
            
            ///推荐房客
        case oOwnerZoneActionTypeRecommend:
            
            if (self.ownerCallBack) {
                
                self.ownerCallBack(oOwnerZoneActionTypeRecommend,nil);
                
            }
            
            break;
            
        default:
            break;
            
    }
    
}

#pragma mark - 刷新UI
/**
 *  @author         yangshengmeng, 15-04-08 19:04:08
 *
 *  @brief          根据业主的统计信息，更新业主页面的数据
 *
 *  @param model    业主的数据模型
 *
 *  @since          1.0.0
 */
- (void)updateOwnerCountInfo:(QSYMyzoneStatisticsOwnerModel *)model
{

    [self updateStayAroundCount:model.book_wait];
    [self updateHavedAroundCount:model.book_ok];
    [self updateWaitCommitAroundCount:model.transaction_wait];
    [self updateCommitedCount:model.transaction_ok];
    [self updateRecommendTenantCount:model.referrals_tenant];
    [self updatePropertyCount:[NSString stringWithFormat:@"%d",[model.tenement_apartment intValue] + [model.tenement_rent intValue]]];
    [self updateAppointedOrderCount:model.book_all];
    [self updateDealOrderCount:model.transaction_all];

}

///更新推荐房客
- (void)updateRecommendTenantCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &RecommendKey);
    if ([newInfo intValue] > 0) {
        
        if ([newInfo intValue] > 99) {
            
            label.text = @"99+条记录";
            
        } else {
            
            label.text = [NSString stringWithFormat:@"%@条记录",newInfo];
            
        }
        
    } else {
        
        label.text = @"查看全部";
        
    }
    
}

///更新物业数量
- (void)updatePropertyCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &PropertyKey);
    if ([newInfo intValue] > 0) {
        
        if ([newInfo intValue] > 99) {
            
            label.text = @"99+条记录";
            
        } else {
            
            label.text = [NSString stringWithFormat:@"%@条记录",newInfo];
            
        }
        
    } else {
        
        label.text = @"查看全部";
        
    }
    
}

///更新成交订单
- (void)updateDealOrderCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &DealKey);
    if ([newInfo intValue] > 0) {
        
        if ([newInfo intValue] > 99) {
            
            label.text = @"99+条记录";
            
        } else {
            
            label.text = [NSString stringWithFormat:@"%@条记录",newInfo];
            
        }
        
    } else {
        
        label.text = @"查看全部";
        
    }
    
}

///更新预约订单
- (void)updateAppointedOrderCount:(NSString *)newInfo
{

    UILabel *label = objc_getAssociatedObject(self, &AppointedKey);
    if ([newInfo intValue] > 0) {
        
        if ([newInfo intValue] > 99) {
            
            label.text = @"99+条记录";
            
        } else {
        
            label.text = [NSString stringWithFormat:@"%@条记录",newInfo];
        
        }
        
    } else {
    
        label.text = @"查看全部";
    
    }

}

///更新待看房数量
- (void)updateStayAroundCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &StayAroundKey);
    if (label && newInfo) {
        
        ///判断数量是0或大于零
        if (100 <= [newInfo intValue]) {
            
            label.text = @"99+";
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else if (0 < [newInfo intValue]) {
            
            label.text = newInfo;
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else {
            
            label.text = @"0";
            label.backgroundColor = [UIColor clearColor];
            
        }
        
    } else {
    
        label.text = @"0";
    
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
            
            label.text = @"99+";
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else if (0 < [newInfo intValue]) {
            
            label.text = newInfo;
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else {
            
            label.backgroundColor = [UIColor clearColor];
            
        }
        
    } else {
    
        label.text = @"0";
    
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
            
            label.text = @"99+";
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else if (0 < [newInfo intValue]) {
            
            label.text = newInfo;
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else {
            
            label.backgroundColor = [UIColor clearColor];
            
        }
        
    } else {
    
        label.text = @"0";
    
    }
    
}

///更新已成交数量
- (void)updateCommitedCount:(NSString *)newInfo
{
    
    UILabel *label = objc_getAssociatedObject(self, &CommitedKey);
    if (label && newInfo) {
        
        ///判断数量是0或大于零
        if (100 <= [newInfo intValue]) {
            
            label.text = @"99+";
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else if (0 < [newInfo intValue]) {
            
            label.text = newInfo;
            label.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            
        } else {
            
            label.backgroundColor = [UIColor clearColor];
            
        }
        
    } else {
    
        label.text = @"0";
    
    }
    
}

#pragma mark - 重建UI
- (void)rebuildOwnerFunctionUI:(USER_COUNT_TYPE)userType
{
    
    ///获取底view
    UIScrollView *rootView = objc_getAssociatedObject(self, &MainInfoButtonRootViewKey);

    ///根据用户类型创建不同的UI
    if (uUserCountTypeTenant == userType) {
        
        ///创建房客的业主页面
        [self createRenantOwnerFunctionUI:rootView];
        
    } else {
        
        ///正常业主功能页面
        [self createOwnerNormalFunctionUI:rootView];
        
    }

}

@end
