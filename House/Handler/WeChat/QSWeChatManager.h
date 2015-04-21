//
//  QSWeChatManager.h
//  House
//
//  Created by 王树朋 on 15/4/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "QSSecondHouseDetailViewController.h"

@interface QSWeChatManager : NSObject<sendMsgToWeChatViewDelegate,
UIAlertViewDelegate, WXApiDelegate>
{
    enum WXScene _scene;
}

@property(nonatomic,strong) QSSecondHouseDetailViewController *viewController;
@end
