//
//  QSPOrderDetailPersonInfoView.m
//  House
//
//  Created by CoolTea on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailPersonInfoView.h"
#import "NSString+Calculation.h"
#import "CoreHeader.h"
#import "QSOrderListReturnData.h"

//上下间隙
#define     CONTENT_TOP_BOTTOM_OFFSETY     14.0f

@implementation QSPOrderDetailPersonInfoView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withOrderData:(id)orderData andCallBack:(void(^)(UIButton *button))callBack
{
    
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f) withOrderData:orderData andCallBack:callBack];
    
}

- (instancetype)initWithFrame:(CGRect)frame withOrderData:(id)orderData andCallBack:(void(^)(UIButton *button))callBack
{
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        CGFloat labelWidth = (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP)-44.0f;
        
        NSString *ownerName = @"";
        
        NSString *phoneStr = @"";
        
        NSString *phoneTipStr = @"";
        
        if (orderData) {
            
            if ([orderData isKindOfClass:[QSOrderListItemData class]]) {
                
                QSOrderListOwnerMsgDataModel *owner = ((QSOrderListItemData*)orderData).ownerData;
                NSLog(@"owner:%@",owner);
                if (owner && [owner isKindOfClass:[QSOrderListOwnerMsgDataModel class]]) {
                    
                    ownerName = [NSString stringWithFormat:@"业主:%@",owner.username];
                    
                    NSString *tempPhoneStr = owner.mobile;
                    BOOL hidePhone = YES;
                    if (hidePhone) {
                        if ([tempPhoneStr length]>=8) {
                            tempPhoneStr = [tempPhoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                        }
                        phoneTipStr = @"(预约成功后开放)";
                    }else{
                        phoneTipStr = @"";
                    }
                    
                    phoneStr = [NSString stringWithFormat:@"电话:%@",tempPhoneStr];
                    
                }
            }
        }
        
        //业主名
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, labelWidth, 22.0f)];
        [nameLabel setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
        [nameLabel setText:ownerName];
        [self addSubview:nameLabel];
        
        
        //电话号码
        CGFloat phoneLabelWidth = [phoneStr calculateStringDisplayWidthByFixedHeight:nameLabel.frame.size.height andFontSize:FONT_BODY_16];
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height, phoneLabelWidth, nameLabel.frame.size.height)];
        [phoneLabel setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
        [phoneLabel setText:phoneStr];
        [self addSubview:phoneLabel];
        
        //电话号码后面提示
        CGFloat phoneTipLabelWidth = [phoneTipStr calculateStringDisplayWidthByFixedHeight:nameLabel.frame.size.height andFontSize:FONT_BODY_12];
        
        UILabel *phoneTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(phoneLabel.frame.origin.x+phoneLabel.frame.size.width, phoneLabel.frame.origin.y, phoneTipLabelWidth, phoneLabel.frame.size.height)];
        [phoneTipLabel setFont:[UIFont systemFontOfSize:FONT_BODY_12]];
        [phoneTipLabel setTextColor:COLOR_CHARACTERS_GRAY];
        [phoneTipLabel setText:phoneTipStr];
        [self addSubview:phoneTipLabel];
        
        ///咨询按钮
        QSBlockButtonStyleModel *askButtonStyle = [[QSBlockButtonStyleModel alloc] init];
        askButtonStyle.imagesNormal = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
        askButtonStyle.imagesHighted = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
        askButtonStyle.imagesSelected = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
        UIButton *askButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-30, nameLabel.frame.origin.y+(nameLabel.frame.size.height+phoneLabel.frame.size.height-34.0f)/2.f, 30, 34) andButtonStyle:askButtonStyle andCallBack:^(UIButton *button) {
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(button);
            }
            
        }];
        
        [self addSubview:askButton];
        
        ///最下方边界区域
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, phoneLabel.frame.origin.y+phoneLabel.frame.size.height, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), CONTENT_TOP_BOTTOM_OFFSETY)];
        [bottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bottomView];
        
        ///分隔线
        UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CONTENT_TOP_BOTTOM_OFFSETY-0.5f, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), 0.5f)];
        [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_BLACKH];
        [bottomView addSubview:bottomLineLablel];
        
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bottomView.frame.origin.y+bottomView.frame.size.height)];
        
        self.blockButtonCallBack = callBack;
        
    }
    
    return self;
    
}

- (void)withOrderData:(id)orderData{
    
}

@end
