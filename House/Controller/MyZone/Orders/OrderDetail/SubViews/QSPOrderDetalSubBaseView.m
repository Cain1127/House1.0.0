//
//  QSPOrderDetalSubBaseView.m
//  House
//
//  Created by CoolTea on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetalSubBaseView.h"


@interface QSPOrderDetalSubBaseView ()

@property (nonatomic, strong) NSMutableArray *afterViewList;    //保存同级界面后面的UIView元素,必须按照展示先后顺序加入

@end

@implementation QSPOrderDetalSubBaseView


- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.afterViewList = [NSMutableArray arrayWithCapacity:0];
        
    }
    return self;
}


- (void)addAfterView:(UIView* __strong *)view
{
    
    if (self.afterViewList) {
        
        [self.afterViewList addObject:*view];
        
    }
    
}

- (void)ResetOtherViewOffsetY
{
    CGFloat offsetY = self.frame.origin.y+self.frame.size.height;
    
    if (self.afterViewList && [self.afterViewList count]>0) {
        for (int i=0; i<[self.afterViewList count]; i++) {
            
            id afterItem = [self.afterViewList objectAtIndex:i];
            if ([afterItem isKindOfClass:[UIView class]]) {
                
                UIView *afterView = (UIView*)afterItem;
                [afterView setFrame:CGRectMake(afterView.frame.origin.x, offsetY, afterView.frame.size.width, afterView.frame.size.height)];
                
                offsetY += afterView.frame.size.height;
                
            }
            
        }
    }
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        
        UIScrollView *scrollView = (UIScrollView*)(self.superview);
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, offsetY)];
        
    }
    
}

- (NSArray*)getAfterViewsList
{
    return self.afterViewList;
}

- (void)setFrameHeightToShowHeight
{
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.showHeight)];
    
}

- (void)setFrameHeightToZero
{
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0)];
    
}

@end
