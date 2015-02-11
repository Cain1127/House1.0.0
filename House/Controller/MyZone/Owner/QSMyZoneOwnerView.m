//
//  QSMyZoneOwnerView.m
//  House
//
//  Created by ysmeng on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMyZoneOwnerView.h"

@interface QSMyZoneOwnerView ()

@property (nonatomic,assign) USER_COUNT_TYPE userType;              //!<用户类型
@property (nonatomic,copy) BLOCK_OWNER_ZONE_CALLBACK ownerCallBack; //!<业主回调

@end

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

    ///根据用户类型创建不同的UI
    if (uUserCountTypeTenant == self.userType) {
        
        ///创建房客的业主页面
        [self createRenantOwnerFunctionUI];
        
    } else {
    
        ///正常业主功能页面
        [self createOwnerNormalFunctionUI];
    
    }

}

///业主的正常功能UI
- (void)createOwnerNormalFunctionUI
{

    

}

///房客的用户时，显示如何成为业主
- (void)createRenantOwnerFunctionUI
{

    

}

@end
