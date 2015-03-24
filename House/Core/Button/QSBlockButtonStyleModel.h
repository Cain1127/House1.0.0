//
//  QSBlockButtonStyleModel.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSBlockButtonStyleModel : NSObject

@property (nonatomic,copy) NSString *title;                 //!<按钮标题
@property (nonatomic,copy) NSString *titleSelected;         //!<按钮选择状态时的标题
@property (nonatomic,retain) UIColor *bgColor;              //!<按钮背景颜色
@property (nonatomic,retain) UIColor *bgColorHighlighted;   //!<按钮高亮时的背景颜色
@property (nonatomic,retain) UIColor *bgColorSelected;      //!<按钮选择状态时的背景颜色
@property (nonatomic,retain) UIColor *titleNormalColor;     //!<标题普通状态的颜色
@property (nonatomic,retain) UIColor *titleHightedColor;    //!<标题高亮状态时的颜色
@property (nonatomic,retain) UIColor *titleSelectedColor;   //!<标题选择状态时的颜色
@property (nonatomic,retain) UIColor *borderColor;          //!<按钮边框颜色
@property (nonatomic,assign)  float borderWith;             //!<按钮边框大小
@property (nonatomic,assign) float cornerRadio;             //!<按钮的圆角弧度
@property (nonatomic,copy) NSString *imagesNormal;          //!<普通状态时的图片
@property (nonatomic,copy) NSString *imagesHighted;         //!<高亮状态时的图片
@property (nonatomic,copy) NSString *imagesSelected;        //!<选择状态时的图片
@property (nonatomic,copy) UIFont *titleFont;               //!<按钮的标题字体大小

/**
 *  @author yangshengmeng, 15-01-17 18:01:06
 *
 *  @brief  清空按钮当前所有风格
 *
 *  @since  1.0.0
 */
- (void)clearButtonStyle;

@end
