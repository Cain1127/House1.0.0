//
//  QSCustomAnnotationView.h
//  House
//
//  Created by 王树朋 on 15/3/18.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
//#import "QSCustomCalloutView.h"
@interface QSCustomAnnotationView : MAAnnotationView

@property (nonatomic, copy) NSString *deteilID;                 //!<单据ID
@property (nonatomic,copy) NSString *title;                     //!<标题
@property (nonatomic,copy) NSString *buildingID;                //!<新房中，楼栋ID
@property (nonatomic, copy) NSString *subtitle;                 //!<价钱
@property (nonatomic,assign)FILTER_MAIN_TYPE houseType;         //!<房源类型
/*!
 *  @author wangshupeng, 15-03-27 16:03:57
 *
 *  @brief  更新大头针数据
 *
 *  @since 1.0.0
 */
-(void)updateAnnotation:(id <MAAnnotation>)annotation andHouseType:(FILTER_MAIN_TYPE)houseType andCallBack:(void(^)(NSString *detailID,NSString *title,FILTER_MAIN_TYPE houseType,NSString *buildingID))callBack;

@end
