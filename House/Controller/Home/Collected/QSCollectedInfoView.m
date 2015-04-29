//
//  QSCollectedInfoView.m
//  House
//
//  Created by ysmeng on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCollectedInfoView.h"

#import "TipsHeader.h"

#import "QSCommunityHouseDetailDataModel.h"
#import "QSWCommunityDataModel.h"

#import <objc/runtime.h>

///关联
static char CommunityKey;   //!<小区关联
static char PriceKey;       //!<现价关联
static char TipsImageKey;   //!<指示图片关联
static char IncreaseKey;    //!<涨幅关联
static char IncreaseUnitKey;//!<涨幅单位关联

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

    ///小区信息
    UILabel *titlaLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, 90.0f, self.frame.size.height)];
    titlaLabel.textAlignment = NSTextAlignmentLeft;
    titlaLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    titlaLabel.textColor = COLOR_CHARACTERS_BLACK;
    titlaLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:titlaLabel];
    objc_setAssociatedObject(self, &CommunityKey, titlaLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///现价
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(titlaLabel.frame.origin.x + titlaLabel.frame.size.width + 10.0f, 0.0f, 40.0f, self.frame.size.height)];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.textColor = COLOR_CHARACTERS_YELLOW;
    priceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    priceLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:priceLabel];
    objc_setAssociatedObject(self, &PriceKey, priceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///现价单位
    UILabel *priceUnitLable = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width, 0.0f, 40.0f, self.frame.size.height)];
    priceUnitLable.text = [NSString stringWithFormat:@"万/%@",APPLICATION_AREAUNIT];
    priceUnitLable.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [self addSubview:priceUnitLable];
    
    ///上涨或下调提示
    QSImageView *tipsImage = [[QSImageView alloc] initWithFrame:CGRectMake(priceUnitLable.frame.origin.x + priceUnitLable.frame.size.width + 5.0f, (self.frame.size.height - 22.0f) / 2.0f, 10.0f, 22.0f)];
    tipsImage.hidden = YES;
    [self addSubview:tipsImage];
    objc_setAssociatedObject(self, &TipsImageKey, tipsImage, OBJC_ASSOCIATION_ASSIGN);
    
    ///涨幅
    UILabel *increaseInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipsImage.frame.origin.x + tipsImage.frame.size.width + 5.0f, 0.0f, 40.0f, self.frame.size.height)];
    increaseInfoLabel.textAlignment = NSTextAlignmentLeft;
    increaseInfoLabel.textColor = COLOR_CHARACTERS_YELLOW;
    increaseInfoLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    increaseInfoLabel.hidden = YES;
    increaseInfoLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:increaseInfoLabel];
    objc_setAssociatedObject(self, &IncreaseKey, increaseInfoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///涨幅单位
    UILabel *increaseUnitLable = [[UILabel alloc] initWithFrame:CGRectMake(increaseInfoLabel.frame.origin.x + increaseInfoLabel.frame.size.width, 0.0f, 30.0f, self.frame.size.height)];
    increaseUnitLable.text = @"%";
    increaseUnitLable.font = [UIFont systemFontOfSize:FONT_BODY_14];
    increaseUnitLable.hidden = YES;
    [self addSubview:increaseUnitLable];
    objc_setAssociatedObject(self, &IncreaseUnitKey, increaseUnitLable, OBJC_ASSOCIATION_ASSIGN);
    
    ///右箭头
    QSImageView *arrowView = [[QSImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 13.0f - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.frame.size.height / 2.0f - 11.5f, 13.0f, 23.0f)];
    arrowView.image = [UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW];
    [self addSubview:arrowView];

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
- (void)updateCollectedInfoViewUI:(QSCommunityHouseDetailDataModel *)model
{

    ///更新标题
    UILabel *titleLabel = objc_getAssociatedObject(self, &CommunityKey);
    if (titleLabel && model.village.title) {
        
        titleLabel.text = model.village.title;
        
    }
    
    ///更新现价
    UILabel *priceLabel = objc_getAssociatedObject(self, &PriceKey);
    if (priceLabel && model.village.price_avg) {
        
        priceLabel.text = [NSString stringWithFormat:@"%.2f",[model.village.price_avg floatValue] / 10000];
        
    }
    
    ///判断是否存在涨幅
    CGFloat newPrice = [model.village.price_avg floatValue];
    CGFloat oldPrice = [model.village.tj_last_month_price_avg floatValue];
    CGFloat increasePrice = newPrice - oldPrice;
    CGFloat isChange = newPrice - oldPrice;
    
    if (oldPrice < 1.0f) {
        
        return;
        
    }
    
    if (isChange < 0.0) {
        
        isChange = isChange * (-1.0f);
        
    }
    
    if (isChange < 1.0f) {
        
        return;
        
    }
    
    ///计算涨幅
    CGFloat increase = 0.0f;
    
    ///指示图片
    NSString *tipsImageName = IMAGE_HOME_COLLECTED_INCREASE_UP;
    
    ///转成正数
    if (increasePrice < 0.0f) {
        
        increasePrice = increasePrice * (-1.0f);
        increase = increasePrice / oldPrice;
        tipsImageName = IMAGE_HOME_COLLECTED_INCREASE_DOWN;
        
    } else {
    
        increase = increasePrice / oldPrice;
    
    }
    
    ///更新UI
    UIImageView *imageView = objc_getAssociatedObject(self, &TipsImageKey);
    imageView.image = [UIImage imageNamed:tipsImageName];
    imageView.hidden = NO;
    
    UILabel *increaseLabel = objc_getAssociatedObject(self, &IncreaseKey);
    increaseLabel.text = [NSString stringWithFormat:@"%.2f",increase];
    increaseLabel.hidden = NO;
    
    UILabel *unitLabel = objc_getAssociatedObject(self, &IncreaseUnitKey);
    unitLabel.hidden = NO;

}

@end
