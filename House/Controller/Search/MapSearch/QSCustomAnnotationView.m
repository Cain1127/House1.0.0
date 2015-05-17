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

- (instancetype)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier andHouseType:(FILTER_MAIN_TYPE)houseType
{
    
    if (self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        ///信息展示view
        self.annoView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 70.0f)];
        self.houseType = houseType;
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
    
    UIView *connetView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _annoView.frame.size.width, 55.0f)];
    connetView.backgroundColor = COLOR_CHARACTERS_YELLOW;
    connetView.layer.cornerRadius = 6.0f;
    [self.annoView addSubview:connetView];
    
    /// 添加标题label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, kPortraitMargin, kTitleWidth, kTitleHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = self.title ? self.title : @"测试地址";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [connetView addSubview:self.titleLabel];
    
    if (fFilterMainTypeNewHouse == self.houseType) {
        
        ///均价label
        UILabel *avgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+8.0f, 35.0f, 15.0f)];
        avgLabel.text = @"均价:";
        avgLabel.font = [UIFont systemFontOfSize:14];
        avgLabel.textAlignment = NSTextAlignmentRight;
        [connetView addSubview:avgLabel];
        
        /// 添加价钱label
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(avgLabel.frame.origin.x+avgLabel.frame.size.width,_titleLabel.frame.origin.y+_titleLabel.frame.size.height+4.0f, 40.0f, 20.0f)];
        self.subTitleLabel.font = [UIFont systemFontOfSize:16];
        self.subTitleLabel.textColor = [UIColor blackColor];
        self.subTitleLabel.textAlignment = NSTextAlignmentRight;
        [connetView addSubview:self.subTitleLabel];
        
        ///单位
        UILabel *priceUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.subTitleLabel.frame.origin.x+self.subTitleLabel.frame.size.width, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+8.0f, 15.0f, 15.0f)];
        priceUnitLabel.font = [UIFont systemFontOfSize:14.0f];
        priceUnitLabel.text = @"万";
        [connetView addSubview:priceUnitLabel];
        
        ///向下箭头
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
        arrowImageView.center = CGPointMake(60.0f, 60.0f);
        arrowImageView.image = [UIImage imageNamed:@"houses_detail_map_arrow_up"];
        [self.annoView addSubview:arrowImageView];
        return;
        
    } else {
        
        /// 添加价钱label
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,_titleLabel.frame.origin.y+_titleLabel.frame.size.height+4.0f, 60.0f, 20.0f)];
        self.subTitleLabel.font = [UIFont systemFontOfSize:18];
        self.subTitleLabel.textColor = [UIColor blackColor];
        self.subTitleLabel.text = self.subtitle ? self.subtitle : @"";
        self.subTitleLabel.textAlignment = NSTextAlignmentRight;
        [connetView addSubview:self.subTitleLabel];
        
        ///单位
        UILabel *priceUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.subTitleLabel.frame.origin.x+self.subTitleLabel.frame.size.width, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+8.0f, 15.0f, 15.0f)];
        priceUnitLabel.font = [UIFont systemFontOfSize:14.0f];
        priceUnitLabel.text = @"套";
        [connetView addSubview:priceUnitLabel];
        
        ///向下箭头
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
        arrowImageView.center = CGPointMake(60.0f, 60.0f);
        arrowImageView.image = [UIImage imageNamed:@"houses_detail_map_arrow_up"];
        [self.annoView addSubview:arrowImageView];
        return;
        
    }
    
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
    
    NSString *map_type=[NSString stringWithFormat:@"%ld",(long)self.houseType];
    
    if ([map_type isEqualToString:@"200502" ]) {
        
        _subTitleLabel.text = [NSString stringWithFormat:@"%.2f",[annotation.subtitle floatValue]/10000.0f];
        
    } else {
        
        _subTitleLabel.text = annotation.subtitle;
        
    }
    
}

@end
