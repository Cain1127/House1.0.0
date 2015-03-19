//
//  QSYShareChoicesView.h
//  House
//
//  Created by ysmeng on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///分享的类型
typedef enum
{

    sShareChoicesTypeWeChat = 10,   //!<微信好友
    sShareChoicesTypeFriends,       //!<朋友圈
    sShareChoicesTypeXinLang,       //!<新浪微博

}SHARE_CHOICES_TYPE;

@interface QSYShareChoicesView : UIView

/**
 *  @author         yangshengmeng, 15-03-19 23:03:35
 *
 *  @brief          创建分享选择视图
 *
 *  @param frame    大小和位置
 *  @param callBack 点击选择后的回调
 *
 *  @return         返回当前创建的分享选择窗口
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andShareCallBack:(void(^)(SHARE_CHOICES_TYPE shareType))callBack;

@end
