//
//  QSShareManager.m
//  House
//
//  Created by 王树朋 on 15/4/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSShareManager.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "WXApi.h"

///友盟分享appkey
static NSString *const shareSDK_Key = @"5535be0d67e58e4e96003357";
///微信appID
static NSString *const Wechat_Key = @"wxc1d288df9337eb74";
///微信appSecret
static NSString *const appSecret_Key = @"0c4264acc43c08c808c1d01181a23387";

@implementation QSShareManager

+ (QSShareManager *)sharedManager
{
    static QSShareManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
    
}

- (id)init
{
    if (self = [super init]) {
        [self setupManager];
    }
    return self;
}

- (void)setupManager
{
    ///设置友盟key
    [UMSocialData setAppKey:shareSDK_Key];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:Wechat_Key appSecret:appSecret_Key url:@"http://www.umeng.com/social"];

}



@end
