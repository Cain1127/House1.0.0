//
//  QSYRegistViewController.m
//  House
//
//  Created by ysmeng on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYRegistViewController.h"

@interface QSYRegistViewController ()

///注册请求完成后的回调
@property (nonatomic,copy) void(^registCallBack)(BOOL flag,NSString *count,NSString *psw);

@end

@implementation QSYRegistViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-13 18:03:27
 *
 *  @brief          根据注册的回调，创建注页面
 *
 *  @param callBack 注册后回调block
 *
 *  @return         返回当前创建的注册页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithRegistCallBack:(void(^)(BOOL flag,NSString *count,NSString *psw))callBack
{

    if (self = [super init]) {
        
        ///保存回调
        if (callBack) {
            
            self.registCallBack = callBack;
            
        }
        
    }
    
    return self;

}

@end
