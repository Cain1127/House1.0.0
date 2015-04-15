//
//  QSPOrderCommentStarsView.m
//  House
//
//  Created by CoolTea on 15/4/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderCommentStarsView.h"
#import "NSString+Calculation.h"
#import "QSBlockButton.h"

#define StarsMaxCount   5

#define DefaultIndex    StarsMaxCount/2+(StarsMaxCount%2!=0?1:0)-1

@interface QSPOrderCommentStarsView ()

@property (nonatomic, assign)   NSInteger currentSelectedIndex;

@end

@implementation QSPOrderCommentStarsView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withTitleTip:(NSString*)titleStr{
    
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f) withTitleTip:titleStr];
    
}

- (instancetype)initWithFrame:(CGRect)frame withTitleTip:(NSString*)titleStr
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        _currentSelectedIndex = DefaultIndex;
        
        CGFloat labelHeight = 32;
        CGFloat labelWidth = [titleStr calculateStringDisplayWidthByFixedHeight:labelHeight andFontSize:FONT_BODY_14];
        
        UILabel *markTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, labelWidth, labelHeight)];
        [markTipLabel setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
        [markTipLabel setTextColor:[UIColor blackColor]];
        [markTipLabel setText:titleStr];
        [markTipLabel setBackgroundColor:[UIColor clearColor]];
        [markTipLabel setNumberOfLines:0];
        [self addSubview:markTipLabel];
        
        for (int i=0; i<StarsMaxCount; i++) {
            
            QSBlockButtonStyleModel *starBtStyle = [[QSBlockButtonStyleModel alloc] init];
            if (i<=_currentSelectedIndex) {
                
                starBtStyle.imagesNormal = IMAGE_ZONE_ORDER_COMMENT_START_PRESSED_BT;
                
            }else{
                
                starBtStyle.imagesNormal = IMAGE_ZONE_ORDER_COMMENT_START_NORMAL_BT;
                
            }
            starBtStyle.imagesSelected = IMAGE_ZONE_ORDER_COMMENT_START_PRESSED_BT;
            starBtStyle.imagesHighted = IMAGE_ZONE_ORDER_COMMENT_START_PRESSED_BT;
            
            UIButton *starBt = [QSBlockButton createBlockButtonWithFrame:CGRectMake(markTipLabel.frame.origin.x + markTipLabel.frame.size.width + 10 + i*(30+4), markTipLabel.frame.origin.y+(markTipLabel.frame.size.height-25)/2, 30, 25) andButtonStyle:starBtStyle andCallBack:^(UIButton *button) {
                NSLog(@"starBt:%ld",(long)button.tag);
                
                NSInteger selectedTag = button.tag%100;
                if (selectedTag == 0) {
                    if (_currentSelectedIndex == 0) {
                        _currentSelectedIndex = -1;
                    }else{
                        _currentSelectedIndex = selectedTag;
                    }
                }else{
                    _currentSelectedIndex = selectedTag;
                }
                
                for (int i=0; i<StarsMaxCount; i++) {
                    
                    UIView *view = [self viewWithTag:i+100];
                    if ([view isKindOfClass:[UIButton class]]) {
                        
                        UIButton *button = (UIButton*)view;
                        
                        if (_currentSelectedIndex >= i) {
                            [button setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_COMMENT_START_PRESSED_BT] forState:UIControlStateNormal];
                        }else{
                            [button setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_COMMENT_START_NORMAL_BT] forState:UIControlStateNormal];
                        }
                        
                    }
                }
                
            }];
            [starBt setTag:100+i];
            [self addSubview:starBt];
            
        }
        
        ///最下方边界区域
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, markTipLabel.frame.origin.y+markTipLabel.frame.size.height, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), CONTENT_TOP_BOTTOM_OFFSETY)];
        [bottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bottomView];
        
        ///分隔线
        UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CONTENT_TOP_BOTTOM_OFFSETY-0.5f, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), 0.5f)];
        [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_BLACKH];
        [bottomView addSubview:bottomLineLablel];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bottomView.frame.origin.y+bottomView.frame.size.height)];
        
        
    }
    
    return self;
    
}

- (NSInteger)getSelectedIndex
{
 
    return _currentSelectedIndex+1;
    
}

@end
