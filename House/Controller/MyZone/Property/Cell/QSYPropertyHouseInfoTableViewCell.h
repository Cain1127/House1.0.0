//
//  QSYPropertyHouseInfoTableViewCell.h
//  House
//
//  Created by ysmeng on 15/4/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///物业事件回调
typedef enum
{

    pPropertyInfocellActionTypeSetting = 99,        //!<设置
    pPropertyInfocellActionTypeCloseSetting,        //!<关闭设置
    pPropertyInfocellActionTypeEdit,                //!<编辑
    pPropertyInfocellActionTypeDelete,              //!<暂停发布
    pPropertyInfocellActionTypeRecommendRenant,     //!<推荐房客
    pPropertyInfocellActionTypeRefreshHouse,        //!<刷新房源

}PROPERTY_INFOCELL_ACTION_TYPE;

@interface QSYPropertyHouseInfoTableViewCell : UITableViewCell

/**
 *  @author                 yangshengmeng, 15-04-07 23:04:41
 *
 *  @brief                  根据房源类型，创建物业信息UI
 *
 *  @param style            风格
 *  @param reuseIdentifier  复用标签
 *  @param houseType        房源类型
 *
 *  @return                 返回当前创建的物业cell
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andHouseType:(FILTER_MAIN_TYPE)houseType;

/**
 *  @author             yangshengmeng, 15-04-07 23:04:49
 *
 *  @brief              刷新UI
 *
 *  @param tempModel    房源的数据模型
 *
 *  @since              1.0.0
 */
- (void)updateMyPropertyHouseInfo:(id)tempModel andHouseType:(FILTER_MAIN_TYPE)houseType andCallBack:(void(^)(PROPERTY_INFOCELL_ACTION_TYPE actionType))callBack;

/**
 *  @author         yangshengmeng, 15-04-07 23:04:19
 *
 *  @brief          设置编辑功能是否显示
 *
 *  @param isShow   YES-显示
 *
 *  @since          1.0.0
 */
- (void)updateEditFunctionShowStatus:(BOOL)isShow;

@end
