//
//  QSYComparisonViewController.h
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYComparisonViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-03-19 23:03:35
 *
 *  @brief          创建比一比列表
 *
 *  @return         返回当前创建的比一比页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPickedHouseList:(NSArray *)houseList andHouseType:(FILTER_MAIN_TYPE)houseType;

@end

@interface QSYComparisonDataModel : NSObject

@property (nonatomic,copy) NSString *houseID;       //!<房源ID
@property (nonatomic,copy) NSString *communityName; //!<小区名
@property (nonatomic,copy) NSString *score;         //!<评分
@property (nonatomic,copy) NSString *districe;      //!<区
@property (nonatomic,copy) NSString *street;        //!<街道
@property (nonatomic,copy) NSString *address;       //!<详细地址
@property (nonatomic,copy) NSString *area;          //!<面积
@property (nonatomic,copy) NSString *house_shi;     //!<室的个数
@property (nonatomic,copy) NSString *house_ting;    //!<厅的个数
@property (nonatomic,copy) NSString *house_wei;     //!<卫的个数
@property (nonatomic,copy) NSString *price;         //!<售价/租金
@property (nonatomic,copy) NSString *avg_price;     //!<售价/租金
@property (nonatomic,copy) NSString *downPayPrice;  //!<首付
@property (nonatomic,copy) NSString *monthPrice;    //!<月供
@property (nonatomic,copy) NSString *buildingYear;  //!<建筑时间
@property (nonatomic,copy) NSString *rightYear;     //!<产权年限
@property (nonatomic,copy) NSString *floor_which;   //!<房源所在楼层
@property (nonatomic,copy) NSString *floor_sum;     //!<房源楼栋总层数
@property (nonatomic,copy) NSString *face;          //!<朝向
@property (nonatomic,copy) NSString *decoration;    //!<装修
@property (nonatomic,copy) NSString *lift;          //!<是否有电梯
@property (nonatomic,copy) NSString *rentPayType;   //!<租金支付方式
@property (nonatomic,copy) NSString *leadTime;      //!<入住时间
@property (nonatomic,copy) NSString *houseStatus;   //!<出租房的当前状态

@end