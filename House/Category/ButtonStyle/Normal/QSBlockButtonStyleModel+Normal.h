//
//  QSBlockButtonStyleModel+Normal.h
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBlockButtonStyleModel.h"

///普通按钮的类型
typedef enum
{

    nNormalButtonTypeCornerWhite = 400,     //!<普通白色底灰色圆角框按钮
    nNormalButtonTypeCornerYellow,          //!<普通黄色圆角按钮
    nNormalButtonTypeCornerLightYellow,     //!<浅黄色圆角按钮
    nNormalButtonTypeCornerWhiteGray,       //!<白字圆角灰底按钮
    nNormalButtonTypeCornerWhiteLightYellowBorder,       //!<普通白色底浅黄圆角框按钮
    
    nNormalButtonTypeClearGray,             //!<灰字白底按钮
    nNormalButtonTypeClearLightGray,        //!<浅灰字白底按钮
    
    nNormalButtonTypeClear                  //!<黑字白色按钮

}NORMAL_BUTTON_TYPE;

/**
 *  @author yangshengmeng, 15-01-20 11:01:53
 *
 *  @brief  普通按钮风格的工厂创建类型
 *
 *  @since  1.0.0
 */
@interface QSBlockButtonStyleModel (Normal)

/**
 *  @author             yangshengmeng, 15-01-20 11:01:19
 *
 *  @brief              根据按钮的类型，返回
 *
 *  @param buttonType   按钮类型
 *
 *  @return             返回一个指定类型的风格
 *
 *  @since              1.0.0
 */
+ (QSBlockButtonStyleModel *)createNormalButtonWithType:(NORMAL_BUTTON_TYPE)buttonType;

@end
