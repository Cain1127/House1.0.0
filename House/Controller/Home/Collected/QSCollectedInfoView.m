//
//  QSCollectedInfoView.m
//  House
//
//  Created by ysmeng on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCollectedInfoView.h"

@implementation QSCollectedInfoView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-12 16:03:53
 *
 *  @brief          创建一个收藏小区滚动的视图
 *
 *  @param frame    大小和位置
 *  @param viewType 视图的类型
 *
 *  @return         返回当前创建的收藏信息展示视图
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andViewType:(COLLECTED_INFOVIEW_TYPE)viewType
{

    if (self = [super initWithFrame:frame]) {
        
        ///根据不同的类型，创建不同的UI
        if (cCollectedInfoViewTypeAcivity == viewType) {
            
            [self createActivityCollectedViewUI];
            
        }
        
        if (cCollectedInfoViewTypeDefault == viewType) {
            
            [self createDefaultCollectedViewUI];
            
        }
        
    }
    
    return self;

}

#pragma mark - UI搭建
///有效信息的UI
- (void)createActivityCollectedViewUI
{

    

}

///默认无信息的UI
- (void)createDefaultCollectedViewUI
{

    ///提示信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, self.frame.size.width - 4.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.frame.size.height)];
    tipsLabel.text = @"+点击添加小区 房价变化实时知";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    tipsLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self addSubview:tipsLabel];
    
    ///右箭头
    QSImageView *arrowView = [[QSImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 13.0f - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.frame.size.height / 2.0f - 11.5f, 13.0f, 23.0f)];
    arrowView.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [self addSubview:arrowView];

}

#pragma mark - 刷新UI
/**
 *  @author         yangshengmeng, 15-03-12 16:03:25
 *
 *  @brief          根据收藏小区的数据模型，刷新收藏页面的UI
 *
 *  @param model    收藏小区的数据模型
 *
 *  @since          1.0.0
 */
- (void)updateCollectedInfoViewUI:(QSCollectedCommunityDataModel *)model
{

    

}

@end
