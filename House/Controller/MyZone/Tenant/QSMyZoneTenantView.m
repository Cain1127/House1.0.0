//
//  QSMyZoneTenantView.m
//  House
//
//  Created by ysmeng on 15/2/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMyZoneTenantView.h"

@interface QSMyZoneTenantView ()

@property (nonatomic,copy) BLOCK_TENANT_ZONE_CALLBACK tenantCallBack;//!<房客页面回调

@end

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
    UIView *mainRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height - channelButtonRootView.frame.size.height)];
    [self createMainFunctionButton:mainRootView];
    [self addSubview:mainRootView];

}

///频道按钮
- (void)createChannelBarButton:(UIView *)view
{

    ///第一个分隔线
    UILabel *firstSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 4.0f, 0.0f, 0.5f, view.frame.size.height)];
    firstSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:firstSepLabel];
    
    ///第二个分隔线
    UILabel *secondSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 2.0f, 0.0f, 0.5f, view.frame.size.height)];
    secondSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:secondSepLabel];
    
    ///第三个分隔线
    UILabel *thirdSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width * 3.0f / 4.0f, 0.0f, 0.5f, view.frame.size.height)];
    thirdSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:thirdSepLabel];

}

///主要功能按钮
- (void)createMainFunctionButton:(UIView *)view
{
    
    ///按钮宽
    CGFloat width = 61.0f;
    
    ///按钮高
    CGFloat height = 85.0f;
    
    ///底部提示信息高
    CGFloat tipsHeight = 15.0f;

    ///纵向间隙
    CGFloat gapH = (view.frame.size.height - 2.0f * (height + tipsHeight)) / 3.0f;
    
    ///横向间隙
    CGFloat gapW = (view.frame.size.width - 3.0f * width) / 4.0f;
    
    

}

@end
