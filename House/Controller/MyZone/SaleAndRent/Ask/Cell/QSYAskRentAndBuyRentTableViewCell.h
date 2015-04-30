//
//  QSYAskRentAndBuyRentTableViewCell.h
//  House
//
//  Created by ysmeng on 15/4/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///求租求购的事件回调
typedef enum
{
    
    aAskRentAndBuyRentCellActionTypeSetting = 0,    //!<设置
    aAskRentAndBuyRentCellActionTypeSettingClose,   //!<关闭设置
    aAskRentAndBuyRentCellActionTypeRecommend,      //!<推荐房源
    aAskRentAndBuyRentCellActionTypeEdit,           //!<编辑
    aAskRentAndBuyRentCellActionTypeDelete,         //!<删除
    
}ASK_RENTANDBUY_RENT_CELL_ACTION_TYPE;

@class QSYAskRentAndBuyDataModel;
@interface QSYAskRentAndBuyRentTableViewCell : UITableViewCell

/**
 *  @author         yangshengmeng, 15-03-31 18:03:40
 *
 *  @brief          根据数据模型刷新UI
 *
 *  @param model    求租求购的数据模型
 *  @param callBack cell上的事件回调
 *
 *  @since          1.0.0
 */
- (void)updateAskRentAndBuyInfoCellUI:(QSYAskRentAndBuyDataModel *)model andSettingButtonStatus:(BOOL)isShowSettingButton andCallBack:(void(^)(ASK_RENTANDBUY_RENT_CELL_ACTION_TYPE actionType))callBack;

/**
 *  @author         yangshengmeng, 15-04-05 18:04:13
 *
 *  @brief          更新底部功能按钮的状态
 *
 *  @param isShow   YES-显示
 *
 *  @since          1.0.0
 */
- (void)updateButtonActionStatus:(BOOL)isShow;

@end
