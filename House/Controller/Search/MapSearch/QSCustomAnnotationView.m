//
//  QSCustomAnnotationView.m
//  House
//
//  Created by 王树朋 on 15/3/18.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomAnnotationView.h"

#define kCalloutWidth       120.0
#define kCalloutHeight      70.0

@interface QSCustomAnnotationView()

@end

@implementation QSCustomAnnotationView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:frame];
    if (self) {
        
        if (self.calloutView == nil)
        {
            self.calloutView = [[QSCustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            
            self.frame = CGRectMake(0, 0, _calloutView.frame.size.width, _calloutView.frame.size.height );
            
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0f + self.calloutOffset.x,-CGRectGetHeight(self.calloutView.bounds) / 2.0f + self.calloutOffset.y);
        }
        [self addSubview:self.calloutView];
        

    }
    return self;
    
}

-(void)updateAnnotation:(id <MAAnnotation>)annotation andHouseType:(FILTER_MAIN_TYPE)houseType
{

    self.calloutView.houseType = houseType;
    NSString *title = annotation.title;
    NSArray *tempArray = [title componentsSeparatedByString:@"#"];
    self.calloutView.title = tempArray[0];
    self.deteilID = tempArray[1];
    self.title = tempArray[0];
    self.calloutView.subtitle=annotation.subtitle;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[QSCustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
//            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        
        self.calloutView.title = self.annotation.title;
        self.calloutView.subtitle = self.annotation.subtitle;
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}


/// 重写此函数,用以实现点击calloutView判断为点击该annotationView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point
                                                           toView:self.calloutView] withEvent:event];
    }
    return inside;
}

@end
