//
//  QSYSearchCommunityViewController.m
//  House
//
//  Created by ysmeng on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSearchCommunityViewController.h"

@interface QSYSearchCommunityViewController ()

///选择一个小区后的回调
@property (nonatomic,copy) void(^pickedCommunityCallBack)(BOOL flag,QSCommunityDataModel *communityModel);

@end

@implementation QSYSearchCommunityViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-12 17:03:05
 *
 *  @brief          根据回调创建一个小区添加关注的页面
 *
 *  @param callBack 选择一个小区后的回调
 *
 *  @return         返回小区关注选择页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPickedCallBack:(void(^)(BOOL flag,QSCommunityDataModel *communityModel))callBack
{

    if (self = [super init]) {
        
        ///保存回调
        if (callBack) {
            
            self.pickedCommunityCallBack = callBack;
            
        }
        
        ///创建UI
        
        
    }
    
    return self;

}

@end
