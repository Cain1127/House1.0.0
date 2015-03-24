//
//  URLHeader.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#ifndef House_URLHeader_h
#define House_URLHeader_h

/**
 *  @author yangshengmeng, 15-01-20 20:01:11
 *
 *  @brief  所有网络请求相关的URL地址
 *
 *  @since  1.0.0
 */

//
//房当家IP根地址
//
static NSString *const URLFDangJiaIPHome = @"http://117.41.235.110:9527/";

//
//房当家域名根地址
//
static NSString *const URLFDangJiaDomainHome = @"http://api.fdangjia.com/";

//
//房当家域名测试地址
//
static NSString *const URLFDangJiaDomainHomeTest = @"site/test";

//
//图片IP根地址
//
static NSString *const URLFDangJiaImageIPHome = @"http://117.41.235.102:6300/";

//
//图片域名根地址
//
static NSString *const URLFDangJiaImageDomainHome = @"http://img.fdangjia.com/";

//
//小区与新房详情页最新均价根地址
//
static NSString *const URLFDangJiaAvgPriceTotal = @"http://117.41.235.110:9527/total/resoldApartment/";
#endif
