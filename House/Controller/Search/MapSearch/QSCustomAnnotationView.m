//
//  QSCustomAnnotationView.m
//  House
//
//  Created by 王树朋 on 15/3/18.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomAnnotationView.h"

#import <objc/runtime.h>

#define kPortraitMargin     5
#define kPortraitWidth      70
#define kPortraitHeight     50
#define kTitleWidth         120
#define kTitleHeight        20
#define kArrorHeight        10


@interface QSCustomAnnotationView()

///地图房源单击回调
@property (nonatomic,copy) void(^mapHouseListSingTapCallBack)(NSString *detailID,NSString *title,FILTER_MAIN_TYPE houseType,NSString *buildingID);

@property (nonatomic,strong) UIView *annoView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;

@end

@implementation QSCustomAnnotationView

- (instancetype)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        ///信息展示view
        self.annoView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 70.0f)];
        self.annoView.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
        self.annoView.layer.cornerRadius = 6.0f;
        [self initSubViews];
        
        ///大头针大小
        self.frame = CGRectMake(0.0f, 0.0, self.annoView.frame.size.width, self.annoView.frame.size.height);
        
        ///添加手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapHouseSingTapAction)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [self.annoView addGestureRecognizer:singleTap];
        
        [self addSubview:self.annoView];
        
    }
    
    return self;
    
}


#pragma mark - 单击当前大头针时回调
- (void)mapHouseSingTapAction
{
    
    if (self.mapHouseListSingTapCallBack) {
        
        self.mapHouseListSingTapCallBack(self.deteilID,self.title,self.houseType,self.buildingID);
        
    }
    
}

#pragma mark - 添加大头针子控件
- (void)initSubViews
{
    
    /// 添加标题label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, kPortraitMargin, kTitleWidth, kTitleHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = self.title ? self.title : @"测试地址";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_annoView addSubview:self.titleLabel];
    
    if (fFilterMainTypeNewHouse == self.houseType) {
        
        ///均价label
        UILabel *avgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+8.0f, 35.0f, 15.0f)];
        avgLabel.text = @"均价:";
        avgLabel.font = [UIFont systemFontOfSize:14];
        avgLabel.textAlignment = NSTextAlignmentRight;
        [_annoView addSubview:avgLabel];
        
        
        /// 添加价钱label
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(avgLabel.frame.origin.x+avgLabel.frame.size.width,_titleLabel.frame.origin.y+_titleLabel.frame.size.height+4.0f, 35.0f, 20.0f)];
        priceLabel.font = [UIFont systemFontOfSize:18];
        priceLabel.textColor = [UIColor blackColor];
        priceLabel.text = self.subtitle ? self.subtitle : @"999";
        priceLabel.textAlignment = NSTextAlignmentRight;
        [_annoView addSubview:priceLabel];
        
        ///单位
        UILabel *priceUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x+priceLabel.frame.size.width, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+8.0f, 15.0f, 15.0f)];
        priceUnitLabel.font = [UIFont systemFontOfSize:14.0f];
        priceUnitLabel.text = @"万";
        [_annoView addSubview:priceUnitLabel];
        return;
        
    }
    
    /// 添加价钱label
    self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,_titleLabel.frame.origin.y+_titleLabel.frame.size.height+4.0f, 60.0f, 20.0f)];
    self.subTitleLabel.font = [UIFont systemFontOfSize:18];
    self.subTitleLabel.textColor = [UIColor blackColor];
    self.subTitleLabel.text = self.subtitle ? self.subtitle : @"999";
    self.subTitleLabel.textAlignment = NSTextAlignmentRight;
    [_annoView addSubview:self.subTitleLabel];
    
    ///单位
    UILabel *priceUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.subTitleLabel.frame.origin.x+self.subTitleLabel.frame.size.width, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+8.0f, 15.0f, 15.0f)];
    priceUnitLabel.font = [UIFont systemFontOfSize:14.0f];
    priceUnitLabel.text = @"套";
    [_annoView addSubview:priceUnitLabel];
    
}


#pragma mark - 刷新UI
-(void)updateAnnotation:(id <MAAnnotation>)annotation andHouseType:(FILTER_MAIN_TYPE)houseType andCallBack:(void(^)(NSString *detailID,NSString *title,FILTER_MAIN_TYPE houseType,NSString *buildingID))callBack
{
    
    ///保存回调
    if (callBack) {
        
        self.mapHouseListSingTapCallBack = callBack;
        
    }
    
    self.houseType = houseType;
    NSString *title = annotation.title;
    NSArray *tempArray = [title componentsSeparatedByString:@"#"];
    _titleLabel.text = tempArray[0];
    self.deteilID = tempArray[1];
    self.title = tempArray[0];
    _subTitleLabel.text=annotation.subtitle;
    
}

@end
