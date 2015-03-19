//
//  QSAnnotationView.m
//  suntry
//
//  Created by 王树朋 on 15/3/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAnnotationView.h"
#import "QSAnnotation.h"

@interface QSAnnotationView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation QSAnnotationView

+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView
{
    static NSString *ID = @"car_desc";
    QSAnnotationView *annoView = (QSAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[QSAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    return annoView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 20.0f)];
        _subtitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 100.0f, 40.0f)];
        
        _iconImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_carpostion0"]];
        
        [self addSubview:_titleLabel];
        [self addSubview:_subtitleLabel];
        [self addSubview:_iconImageView];
        self.frame = CGRectMake(0, 35.0f, 30.0f, _titleLabel.frame.size.height+_subtitleLabel.frame.size.height+_iconImageView.frame.size.height);
    }
    return self;
}

- (void)setAnnotation:(id<MAAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    QSAnnotation *anno = annotation;
    self.titleLabel.text = anno.title;
    self.subtitleLabel.text = anno.subtitle;
    self.subtitleLabel.textColor=[UIColor redColor];
    self.backgroundColor=[UIColor blueColor];
    self.iconImageView.image=[UIImage imageNamed:anno.icon];
}

@end
