//
//  QSCustomCalloutView.m
//  House
//
//  Created by 王树朋 on 15/3/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomCalloutView.h"
#import "ColorHeader.h"

#include <objc/runtime.h>

#define kPortraitMargin     5
#define kPortraitWidth      70
#define kPortraitHeight     50

#define kTitleWidth         120
#define kTitleHeight        20

#define kArrorHeight        10

///关联
static char TitleLabelKey;  //!<小区名
static char PriceLabelKey;  //!<价钱
static char AvgLabelKey;    //!<均价
static char PriceUnitKey;   //!<价钱单位

@interface QSCustomCalloutView()

@end

@implementation QSCustomCalloutView


- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [COLOR_CHARACTERS_LIGHTYELLOW CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [COLOR_CHARACTERS_YELLOW CGColor]);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    
    /// 添加标题label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, kPortraitMargin, kTitleWidth, kTitleHeight)];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = self.title ? self.title : @"测试地址";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    objc_setAssociatedObject(self, &TitleLabelKey,titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///均价label
    UILabel *avgLabel=[[UILabel alloc] initWithFrame:CGRectMake(15.0f, titleLabel.frame.origin.y+titleLabel.frame.size.height+8.0f, 35.0f, 15.0f)];
    avgLabel.text=@"均价:";
    avgLabel.font=[UIFont systemFontOfSize:14];
    avgLabel.textAlignment=NSTextAlignmentRight;
    [self addSubview:avgLabel];
    objc_setAssociatedObject(self, &AvgLabelKey, avgLabel, OBJC_ASSOCIATION_ASSIGN);

    
    /// 添加价钱label
     UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(avgLabel.frame.origin.x+avgLabel.frame.size.width,titleLabel.frame.origin.y+titleLabel.frame.size.height+4.0f, 35.0f, 20.0f)];
    priceLabel.font = [UIFont systemFontOfSize:18];
    priceLabel.textColor = [UIColor blackColor];
    priceLabel.text = self.subtitle ? self.subtitle : @"999";
    priceLabel.textAlignment=NSTextAlignmentRight;
    [self addSubview:priceLabel];
    objc_setAssociatedObject(self, &PriceLabelKey, priceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///单位
    UILabel *priceUnitLabel=[[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x+priceLabel.frame.size.width, titleLabel.frame.origin.y+titleLabel.frame.size.height+8.0f, 15.0f, 15.0f)];
    priceUnitLabel.font=[UIFont systemFontOfSize:14.0f];
    priceUnitLabel.text=@"万";
    [self addSubview:priceUnitLabel];
    objc_setAssociatedObject(self, &PriceUnitKey, priceUnitLabel, OBJC_ASSOCIATION_ASSIGN);
    
}

#pragma mark - Override

- (void)setTitle:(NSString *)title
{
    UILabel *titleLabel=objc_getAssociatedObject(self, &TitleLabelKey);
    titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)price
{
    UILabel *priceLabel=objc_getAssociatedObject(self, &PriceLabelKey);
    priceLabel.text = price;
}


@end
