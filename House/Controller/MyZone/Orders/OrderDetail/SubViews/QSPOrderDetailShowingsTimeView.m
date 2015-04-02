//
//  QSPOrderDetailShowingsTimeView.m
//  House
//
//  Created by CoolTea on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailShowingsTimeView.h"

#include <objc/runtime.h>

#import "QSOrderDetailInfoDataModel.h"

//上下间隙
#define     CONTENT_TOP_BOTTOM_OFFSETY     14.0f

//关联
static char downButtonKey;      //!<下箭头按钮关联key
static char upButtonKey;        //!<上箭头按钮关联key
static char bottomViewKey;      //!<分割线关联key

@interface QSPOrderDetailShowingsTimeView ()

@property (nonatomic, strong) NSMutableArray *afterViewList;    //保存同级界面后面的UIView元素,必须按照展示先后顺序加入

@end

@implementation QSPOrderDetailShowingsTimeView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withTimeData:(NSArray*)timeArray
{
    
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f) withTimeData:timeArray];
    
}

- (instancetype)initWithFrame:(CGRect)frame withTimeData:(NSArray*)timeArray
{

    if (self = [super initWithFrame:frame]) {
        
        self.afterViewList = [NSMutableArray arrayWithCapacity:0];
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        UILabel *timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), 22)];
        [timeTitleLabel setFont:[UIFont systemFontOfSize:FONT_BODY_12]];
        [timeTitleLabel setTextColor:COLOR_CHARACTERS_GRAY];
        [timeTitleLabel setText:TITLE_MYZONE_ORDER_DETAIL_SHOWINGS_TITLE_TIP];
        [self addSubview:timeTitleLabel];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, timeTitleLabel.frame.origin.y+timeTitleLabel.frame.size.height, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), CONTENT_TOP_BOTTOM_OFFSETY)];
        [bottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bottomView];
        
        objc_setAssociatedObject(self, &bottomViewKey, bottomView, OBJC_ASSOCIATION_ASSIGN);
        
        ///分隔线
        UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CONTENT_TOP_BOTTOM_OFFSETY-0.5f, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), 0.5f)];
        [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_BLACKH];
        [bottomView addSubview:bottomLineLablel];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bottomLineLablel.frame.origin.y+bottomLineLablel.frame.size.height)];
        
        [self setTimeData:timeArray];
        
    }
    
    return self;
    
}

- (void)setTimeData:(NSArray*)timeArray
{
    if (timeArray&&[timeArray isKindOfClass:[NSArray class]]&&[timeArray count]>0) {
        
        CGFloat contentHeight = 0.0;
        
        for (int i=0; i<[timeArray count]; i++) {
            
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, 36.0f+10+i*(22+10), 22.0f, 22.0f)];
            [countLabel setTextColor:[UIColor blackColor]];
            [countLabel setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
            [[countLabel layer] setCornerRadius:countLabel.frame.size.height/2.];
            [[countLabel layer] setMasksToBounds:YES];
            [countLabel setTextAlignment:NSTextAlignmentCenter];
            [countLabel setBackgroundColor:COLOR_CHARACTERS_LIGHTYELLOW];
            [countLabel setText:[NSString stringWithFormat:@"%lu",([timeArray count]-i)]];
            [self addSubview:countLabel];
            
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(countLabel.frame.origin.x+countLabel.frame.size.width+4, countLabel.frame.origin.y, ((SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP)-countLabel.frame.origin.x+countLabel.frame.size.width - 44.0f), countLabel.frame.size.height)];
            [timeLabel setTextColor:[UIColor blackColor]];
            [timeLabel setFont:[UIFont boldSystemFontOfSize:FONT_BODY_16]];
            [self addSubview:timeLabel];
            
            id item = [timeArray objectAtIndex:i];
            
            if ([item isKindOfClass:[NSString class]]) {
//                [timeLabel setText:@"2015-03-13(星期五)10:00-11:00"];
                [timeLabel setText:item];
            }else if ([item isKindOfClass:[QSOrderDetailAppointTimeDataModel class]]) {
                [timeLabel setText:((QSOrderDetailAppointTimeDataModel*)item).time];
            }
            
            contentHeight = timeLabel.frame.origin.y +timeLabel.frame.size.height;
            
            if (i==0&&[timeArray count]>1) {
                
                QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
                buttonStyle.imagesNormal = IMAGE_ZONE_ORDER_DETAIL_DOWN_ARROW_BT;
                UIButton *downButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-44, countLabel.frame.origin.y+(countLabel.frame.size.height-44)/2, 44, 44) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
                    
                    NSLog(@"downButton");
                    
                    [button setHidden:YES];
                    
                    [UIView animateWithDuration:0.3f animations:^{
                        
                        [self  setOffsetYAtItemIndex:[timeArray count]-1];
                        
                    } completion:^(BOOL finished) {
                        
                        
                    }];
                    
                }];
                [self addSubview:downButton];
                
                objc_setAssociatedObject(self, &downButtonKey, downButton, OBJC_ASSOCIATION_ASSIGN);
                
            }else if ( i!=0 && i==[timeArray count]-1){
                
                QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
                buttonStyle.imagesNormal = IMAGE_ZONE_ORDER_DETAIL_UP_ARROW_BT;
                UIButton *upButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-44, countLabel.frame.origin.y+(countLabel.frame.size.height-44)/2, 44, 44) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
                    
                    NSLog(@"upButton");
                    
                    [UIView animateWithDuration:0.3f animations:^{
                        
                        [self  setOffsetYAtItemIndex:0];
                        
                    } completion:^(BOOL finished) {
                        
                        UIButton *downButton = objc_getAssociatedObject(self, &downButtonKey);
                        [downButton setHidden:NO];
                        
                    }];
                    
                }];
                [self addSubview:upButton];
                
                objc_setAssociatedObject(self, &upButtonKey, upButton, OBJC_ASSOCIATION_ASSIGN);
                
            }
            
        }
        
        [self  setOffsetYAtItemIndex:0];
        
    }else{
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0.0f)];
        [self ResetOtherViewOffsetY];
        
    }
    
}

- (void)addAfterView:(UIView* __strong *)view
{
    
    [self.afterViewList addObject:*view];
    
}

- (void)setOffsetYAtItemIndex:(NSInteger)index
{
    
    if (index<0) {
        return;
    }
    
    UIView *bottomView = objc_getAssociatedObject(self, &bottomViewKey);
    if (bottomView) {
        
        [self bringSubviewToFront:bottomView];
        [bottomView setFrame:CGRectMake(bottomView.frame.origin.x, 36.0f+10+(index+1)*(22+10), bottomView.frame.size.width, bottomView.frame.size.height)];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bottomView.frame.origin.y+bottomView.frame.size.height)];
        
    }else{
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 36.0f+10+(index+1)*(22+10)+CONTENT_TOP_BOTTOM_OFFSETY)];
        
    }
    
    [self ResetOtherViewOffsetY];
    
}

- (void)ResetOtherViewOffsetY
{
    CGFloat offsetY = self.frame.origin.y+self.frame.size.height;
    
    if ([self.afterViewList count]>0) {
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


@end
