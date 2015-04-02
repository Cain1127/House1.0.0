//
//  QSTabbar.m
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTabbar.h"

@interface QSTabbar ()

@property (nonatomic,copy) void(^tabbarTapCallBack)(int index);
@property (nonatomic,retain) NSMutableArray *tabbarButtonArray;     //!<tabbar按钮数组
@property (nonatomic,retain) NSMutableArray *tabbarButtonTipsArray; //!<tabbar按钮右上角提示数组

@end

@implementation QSTabbar

#pragma mark - 以给定的tabbar信息初始化
/**
 *  @author         yangshengmeng, 15-01-17 17:01:12
 *
 *  @brief          按给定的tabbar信息初始化一个tabbar
 *
 *  @param frame    在父视图中的位置和大小
 *  @param array    tabbar按钮信息
 *
 *  @return         返回一个tabbar
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andTabbarButtonArray:(NSArray *)array andTabbarTapCallBack:(void(^)(int index))callBack
{
    
    if (self = [super initWithFrame:frame]) {
        
        ///默认背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存回调
        if (callBack) {
            
            self.tabbarTapCallBack = callBack;
            
        }
        
        ///初始化按钮数组容器
        self.tabbarButtonArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
        
        ///创建UI
        [self createTabbarInitUI:array];
        
    }
    
    return self;

}

///搭建tabbarUI
- (void)createTabbarInitUI:(NSArray *)array
{

    ///初始判断按钮信息是否有效
    if (nil == array || 0 >= [array count]) {
        
        return;
        
    }
    
    ///间隙
    CGFloat gapFloat = (SIZE_DEVICE_WIDTH - 320.0f) / ([array count] + 1.0f);
    CGFloat width = 320.0f / [array count];
    
    ///循环创建tabbar按钮
    for (int i = 0;i < [array count];i++) {
        
        ///获取按钮的信息
        NSDictionary *tempDict = array[i];
        
        ///创建按钮风格
        QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
        buttonStyle.imagesNormal = [tempDict valueForKey:@"image_normal"];
        buttonStyle.imagesSelected = [tempDict valueForKey:@"image_selected"];
        
        UIButton *tempButton = [UIButton createBlockButtonWithFrame:CGRectMake(gapFloat + i * (width + gapFloat), 0.0f, width, self.frame.size.height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            ///如果按钮当前处于选择状态，不回调
            if (button.selected) {
                
                return;
                
            }
            
            ///回调
            if (self.tabbarTapCallBack) {
                
                self.tabbarTapCallBack(i);
                
            }
            
        }];
        
        ///第一个按钮处于选择状态
        if (i == 0) {
            
            tempButton.selected = YES;
            
        }
        
        ///右上角提示
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempButton.frame.origin.x + tempButton.frame.size.width - 35.0f, tempButton.frame.origin.y, 20.0f, 20.0f)];
        tipsLabel.backgroundColor = [UIColor redColor];
        tipsLabel.layer.cornerRadius = 10.0f;
        tipsLabel.layer.masksToBounds = YES;
        tipsLabel.text = @"0";
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.adjustsFontSizeToFitWidth = YES;
        tipsLabel.hidden = YES;
        
        ///添加单击时的状态更换
        [tempButton addTarget:self action:@selector(tabbarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        ///加载
        [self addSubview:tempButton];
        [self addSubview:tipsLabel];
        
        ///保存
        [self.tabbarButtonArray addObject:tempButton];
        [self.tabbarButtonTipsArray addObject:tipsLabel];
        
    }
    
    ///顶部线条
    UILabel *lineLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 0.5f)];
    lineLabel.backgroundColor = COLOR_CHARACTERS_GRAY;
    lineLabel.alpha = 0.5f;
    [self addSubview:lineLabel];

}

#pragma mark - 选择某一个按钮时修改对应状态
- (void)tabbarButtonAction:(UIButton *)button
{

    ///如果单击的按钮本身都是选择状态，直接返回
    if (button.selected) {
        
        return;
        
    }
    
    ///循环设置按钮的状态
    for (UIButton *tempButton in self.tabbarButtonArray) {
        
        tempButton.selected = NO;
        
    }
    
    ///当前按钮处于选择状态
    button.selected = YES;

}

#pragma mark - 把给定下标的tabbarItem设置为选择状态
/**
 *  @author         yangshengmeng, 15-01-17 17:01:07
 *
 *  @brief          设置给定下标的tabbarItem处于选择状态
 *
 *  @param index    给定下标
 *
 *  @since          1.0.0
 */
- (void)setCurrentSelectedIndex:(int)index
{

    ///遍历数据中的按钮，将对应下标的按钮设置为选择状态，其他按钮为非选择状态
    for (int i = 0;i < [self.tabbarButtonArray count];i++) {
        
        UIButton *tempButton = self.tabbarButtonArray[i];
        
        if (i == index) {
            
            tempButton.selected = YES;
            
        } else {
        
            tempButton.selected = NO;
        
        }
        
    }

}

#pragma mark - 在给定下标的按钮右上角提示相关信息
/**
 *  @author             yangshengmeng, 15-01-17 18:01:11
 *
 *  @brief              在特定下标的按钮右上角显示红色提示信息
 *
 *  @param tipsString   提示信息
 *  @param index        下标
 *
 *  @since              1.0.0
 */
- (void)setUpperRightCornerTipsWithString:(NSString *)tipsString andIndex:(int)index
{

    UILabel *tipsLabel = self.tabbarButtonTipsArray[index];
    if ([tipsString length] > 0) {
        
        tipsLabel.hidden = NO;
        tipsLabel.text = tipsString;
        
    } else {
    
        tipsLabel.text = @"0";
        tipsLabel.hidden = YES;
    
    }

}

@end
