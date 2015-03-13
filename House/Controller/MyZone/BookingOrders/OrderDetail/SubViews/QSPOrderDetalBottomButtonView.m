//
//  QSPOrderDetalBottomButtonView.m
//  House
//
//  Created by CoolTea on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetalBottomButtonView.h"
#import "QSBlockButtonStyleModel+Normal.h"

//上下间隙
#define     CONTENT_TOP_BOTTOM_OFFSETY     12.0f
//左右间隙
#define     CONTENT_LEFT_RIGHT_OFFSETX     35.0f


@implementation QSPOrderDetalBottomButtonView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withButtonCount:(NSInteger)num andCallBack:(void(^)(BOTTOM_BUTTON_TYPE buttonType, UIButton *button))callBack
{
    
    if (self = [super initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f)]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self creatButton:num];
        
        self.blockButtonCallBack = callBack;
        
    }
    
    return self;
    
}

///创建按钮
- (void)creatButton:(NSInteger)num
{
    
    if (num == 1) {
        
        ///按钮风格
        QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
        
        ///修改订单按钮
        buttonStyle.title = TITLE_MYZONE_ORDER_DETAIL_CHANGE_ORDER_TITLE_TIP;
        UIButton *changeOrderButton = [UIButton createBlockButtonWithFrame:CGRectMake(CONTENT_LEFT_RIGHT_OFFSETX, CONTENT_TOP_BOTTOM_OFFSETY, SIZE_DEVICE_WIDTH-2.0f*CONTENT_LEFT_RIGHT_OFFSETX, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(bBottomButtonTypeOne,button);
            }
            
        }];
        
        [self addSubview:changeOrderButton];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, changeOrderButton.frame.origin.y+changeOrderButton.frame.size.height+CONTENT_TOP_BOTTOM_OFFSETY)];
        
    }else if (num == 2) {
        
    }
    
}

@end
