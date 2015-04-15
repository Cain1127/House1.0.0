//
//  QSPOrderCommentSelectedButtonView.m
//  House
//
//  Created by CoolTea on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderCommentSelectedButtonView.h"
#import "NSString+Calculation.h"

@interface QSPOrderCommentSelectedButtonView ()

@property (nonatomic, strong) UIButton *selectBt;
@property (nonatomic,copy) void(^blockButtonCallBack)(UIButton *button);

@end

@implementation QSPOrderCommentSelectedButtonView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withTitleTip:(NSString*)titleStr andCallBack:(void(^)(UIButton *button))callBack{
    
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f) withTitleTip:titleStr andCallBack:callBack];
    
}

- (instancetype)initWithFrame:(CGRect)frame withTitleTip:(NSString*)titleStr andCallBack:(void(^)(UIButton *button))callBack
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        QSBlockButtonStyleModel *selectBtStyle = [[QSBlockButtonStyleModel alloc] init];
        selectBtStyle.imagesNormal = IMAGE_ZONE_ORDER_COMMENT_SELECTED_NORMAL_BT ;
        selectBtStyle.imagesSelected = IMAGE_ZONE_ORDER_COMMENT_SELECTED_PRESSED_BT;
        selectBtStyle.imagesHighted = IMAGE_ZONE_ORDER_COMMENT_SELECTED_PRESSED_BT;
        
        self.selectBt = [QSBlockButton createBlockButtonWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, 25, 25) andButtonStyle:selectBtStyle andCallBack:^(UIButton *button) {
            
        }];
        [self addSubview:self.selectBt];
        
        CGFloat labelHeight = 28;
        CGFloat labelWidth = SIZE_DEVICE_WIDTH-2*CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-self.selectBt.frame.origin.x-self.selectBt.frame.size.width;
        
        UILabel *markTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.selectBt.frame.origin.x+self.selectBt.frame.size.width+12, self.selectBt.frame.origin.y+(self.selectBt.frame.size.height-labelHeight)/2, labelWidth, labelHeight)];
        [markTipLabel setFont:[UIFont systemFontOfSize:FONT_BODY_18]];
        [markTipLabel setTextColor:[UIColor blackColor]];
        [markTipLabel setText:titleStr];
        [markTipLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:markTipLabel];
        
        ///最下方边界区域
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, markTipLabel.frame.origin.y+markTipLabel.frame.size.height, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), CONTENT_TOP_BOTTOM_OFFSETY)];
        [bottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bottomView];
        
        ///分隔线
        UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CONTENT_TOP_BOTTOM_OFFSETY-0.5f, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), 0.5f)];
        [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_BLACKH];
        [bottomView addSubview:bottomLineLablel];
        
        UIButton *clickBt = [QSBlockButton createBlockButtonWithFrame:CGRectMake(self.selectBt.frame.origin.x, self.selectBt.frame.origin.y+(self.selectBt.frame.size.height-44)/2, self.selectBt.frame.size.width+labelWidth, 44) andButtonStyle:[[QSBlockButtonStyleModel alloc] init] andCallBack:^(UIButton *button) {
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(button);
            }
            
        }];
        [self addSubview:clickBt];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bottomView.frame.origin.y+bottomView.frame.size.height)];
        
        self.blockButtonCallBack = callBack;
        
    }
    
    return self;
    
}

- (BOOL)getSelectedState
{
    
    BOOL flag = NO;
    if (self.selectBt) {
        flag = self.selectBt.selected;
    }
    return flag;
    
}

- (void)setSelectState:(BOOL)flag
{
    
    if (self.selectBt) {
        [self.selectBt setSelected:flag];
    }
    
}

@end
