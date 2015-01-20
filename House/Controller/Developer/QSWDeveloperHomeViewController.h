//
//  QSWDeveloperHomeViewController.h
//  House
//
//  Created by 王树朋 on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMasterViewController.h"

@interface QSWDeveloperHomeViewController : QSMasterViewController

///在售楼盘数量
@property (weak, nonatomic) IBOutlet UILabel *salingLabel;

///当前活动
@property (weak, nonatomic) IBOutlet UILabel *activeLabel;

///访问量次数
@property (weak, nonatomic) IBOutlet UILabel *pageViewLabel;

///预约量次数
@property (weak, nonatomic) IBOutlet UILabel *bookingCountLabel;

///最受欢迎楼盘
@property (weak, nonatomic) IBOutlet UILabel *topPopularHouseLabel;

///点击在售楼盘按钮事件
- (IBAction)salingButton:(id)sender;

///点击当前活动按钮事件
- (IBAction)activeButton:(id)sender;

///点击设置按钮事件
- (IBAction)settingButton:(id)sender;

///点击消息按钮事件
- (IBAction)messageButton:(id)sender;


@end
