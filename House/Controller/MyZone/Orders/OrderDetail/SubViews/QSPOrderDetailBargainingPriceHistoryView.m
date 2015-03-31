//
//  QSPOrderDetailBargainingPriceHistoryView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailBargainingPriceHistoryView.h"
#include <objc/runtime.h>
#import "QSOrderDetailInfoDataModel.h"

//上下间隙
#define     CONTENT_TOP_BOTTOM_OFFSETY     14.0f

//关联
static char hideShowButtonKey;      //!<折叠按钮关联key
static char bottomViewKey;      //!<分割线关联key

@interface QSPOrderDetailBargainingPriceHistoryView ()

@property (nonatomic, strong) UILabel *bargainTitleLabel;               //!<议价标题View
@property (nonatomic, strong) UIButton *hideShowButton;                 //!<折叠按钮
@property (nonatomic, strong) NSMutableArray *afterViewList;            //!<保存同级界面后面的UIView元素,必须按照展示先后顺序加入
@property (nonatomic, strong) NSMutableArray *bargainList;              //!<议价历史数据
@property (nonatomic, assign) BOOL  isShowListFlag;                     //!<是否展示议价历史数据

@end

@implementation QSPOrderDetailBargainingPriceHistoryView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withOrderData:(id)orderData
{
    
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f) withOrderData:orderData];
    
}

- (instancetype)initWithFrame:(CGRect)frame withOrderData:(id)orderData
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.afterViewList = [NSMutableArray arrayWithCapacity:0];
        self.bargainList = [NSMutableArray arrayWithCapacity:0];
        self.isShowListFlag = NO;
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        self.bargainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP)-44, 22)];
        [self.bargainTitleLabel setFont:[UIFont systemFontOfSize:FONT_BODY_12]];
        [self.bargainTitleLabel setTextColor:[UIColor blackColor]];
        [self addSubview:self.bargainTitleLabel];
        
        QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
        buttonStyle.imagesNormal = IMAGE_ZONE_ORDER_DETAIL_DOWN_ARROW_BT;
        self.hideShowButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-44, self.bargainTitleLabel.frame.origin.y+(self.bargainTitleLabel.frame.size.height-44)/2, 44, 44) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            NSLog(@"hideShowButton");
            self.isShowListFlag = !self.isShowListFlag;
            
            if (self.isShowListFlag) {
                
                [self.hideShowButton setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_DETAIL_UP_ARROW_BT] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.3f animations:^{
                    
                    [self  setOffsetYAtItemIndex:[self.bargainList count]-1];
                    
                } completion:^(BOOL finished) {
                    
                    
                }];
                
            }else{
                
                [self.hideShowButton setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_DETAIL_DOWN_ARROW_BT] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.3f animations:^{
                    
                    [self  setOffsetYAtItemIndex:0];
                    
                } completion:^(BOOL finished) {
                    
                    
                }];
                
            }
            
        }];
        [self addSubview:self.hideShowButton];
        
        objc_setAssociatedObject(self, &hideShowButtonKey, _hideShowButton, OBJC_ASSOCIATION_ASSIGN);
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, self.bargainTitleLabel.frame.origin.y+self.bargainTitleLabel.frame.size.height, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), CONTENT_TOP_BOTTOM_OFFSETY)];
        [bottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bottomView];
        
        objc_setAssociatedObject(self, &bottomViewKey, bottomView, OBJC_ASSOCIATION_ASSIGN);
        
        ///分隔线
        UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CONTENT_TOP_BOTTOM_OFFSETY-0.5f, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), 0.5f)];
        [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_BLACKH];
        [bottomView addSubview:bottomLineLablel];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bottomView.frame.origin.y+bottomView.frame.size.height)];
        
        [self setOrderData:orderData];
        
    }
    
    return self;
    
}

- (void)setOrderData:(id)orderData
{
    
    QSOrderDetailInfoDataModel *tempOrderData = nil;
    
    if (orderData) {
        
        if ([orderData isKindOfClass:[QSOrderDetailInfoDataModel class]]) {
            
            tempOrderData = (QSOrderDetailInfoDataModel*)orderData;
            
        }
    }
    
    if (!tempOrderData) {
        NSLog(@"QSPOrderDetailMyPriceView orderdata 格式错误！");
        return;
    }
    
    
    self.bargainList = tempOrderData.bargain_list;
    
    if (self.bargainTitleLabel) {
        [self.bargainTitleLabel setAttributedText:[tempOrderData titleStringOnBargainListView]];
    }
    
    if (self.bargainList && [self.bargainList count]<=1 && self.hideShowButton) {
        [self.hideShowButton setHidden:YES];
    }else{
        [self.hideShowButton setHidden:NO];
        [self.hideShowButton setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_DETAIL_DOWN_ARROW_BT] forState:UIControlStateNormal];
    }
    
    self.isShowListFlag = NO;
    
    if (self.bargainList&&[self.bargainList isKindOfClass:[NSArray class]]&&[self.bargainList count]>0) {
        
        CGFloat contentHeight = 0.0;
        
        for (int i=0; i<[self.bargainList count]; i++) {
            
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, 36.0f+10+i*(22+10), 22.0f, 22.0f)];
            [countLabel setTextColor:[UIColor blackColor]];
            [countLabel setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
            [[countLabel layer] setCornerRadius:countLabel.frame.size.height/2.];
            [[countLabel layer] setMasksToBounds:YES];
            [countLabel setTextAlignment:NSTextAlignmentCenter];
            [countLabel setBackgroundColor:COLOR_CHARACTERS_LIGHTYELLOW];
            [countLabel setText:[NSString stringWithFormat:@"%u",([self.bargainList count]-i)]];
            [self addSubview:countLabel];
            
            UILabel *bargainLabel = [[UILabel alloc] initWithFrame:CGRectMake(countLabel.frame.origin.x+countLabel.frame.size.width+4, countLabel.frame.origin.y, ((SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP)-countLabel.frame.origin.x+countLabel.frame.size.width - 44.0f), countLabel.frame.size.height)];
            [bargainLabel setTextColor:[UIColor blackColor]];
            [bargainLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
            [self addSubview:bargainLabel];
            
            id item = [self.bargainList objectAtIndex:i];
            
            if ([item isKindOfClass:[QSOrderDetailBargainDataModel class]]) {
                [bargainLabel setAttributedText:[tempOrderData infoStringOnBargainListView:(QSOrderDetailBargainDataModel*)item]];
            }
            
            contentHeight = bargainLabel.frame.origin.y +bargainLabel.frame.size.height;
            
        }
        
        [self setOffsetYAtItemIndex:0];
        
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
