//
//  QSHomeViewController.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMasterViewController.h"

@interface QSHomeViewController : QSMasterViewController

@property (weak, nonatomic) IBOutlet UILabel *houseTypeCountOneLabel; //!<一房房源统计

@property (weak, nonatomic) IBOutlet UILabel *houseTypeCountTwoLabel; //!<二房房源统计

@property (weak, nonatomic) IBOutlet UILabel *houseTypeCountThreeLabel; //!<三房房源统计

@property (weak, nonatomic) IBOutlet UILabel *houseTypeCountFourLabel;  //!<四房房源统计

@property (weak, nonatomic) IBOutlet UILabel *houseTypeCountOtherLabel; //!<其他房源统计

- (IBAction)newHouseButton:(id)sender; //!<新房按钮点击

- (IBAction)secondHandHouseButton:(id)sender; //!<二手房按钮点击

- (IBAction)rentingHouseButton:(id)sender;//!<租房按钮点击

- (IBAction)saleHouseButton:(id)sender;//!< 我要放盘按钮点击

- (IBAction)bambooplateHouseButton:(id)sender;//!<笋盘推荐按钮点击


@end
