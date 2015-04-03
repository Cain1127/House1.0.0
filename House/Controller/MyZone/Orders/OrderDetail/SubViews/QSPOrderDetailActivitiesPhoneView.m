//
//  QSPOrderDetailActivitiesPhoneView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailActivitiesPhoneView.h"

@interface QSPOrderDetailActivitiesPhoneView ()

@property (nonatomic,copy) void(^blockButtonCallBack)(UIButton *button);

@end

@implementation QSPOrderDetailActivitiesPhoneView

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
        
        NSString *phoneStr = @"4008-123-123";
        
        
//        if (orderData) {
//            
//            if ([orderData isKindOfClass:[QSOrderListItemData class]]) {
//                
//                QSOrderListOwnerMsgDataModel *owner = ((QSOrderListItemData*)orderData).ownerData;
//                NSLog(@"owner:%@",owner);
//                if (owner && [owner isKindOfClass:[QSOrderListOwnerMsgDataModel class]]) {
//                    
//                    ownerName = [NSString stringWithFormat:@"业主:%@",owner.username];
//                    
//                    NSString *tempPhoneStr = [NSString stringWithString:owner.mobile];
//                    BOOL hidePhone = YES;
//                    if (hidePhone) {
//                        if ([tempPhoneStr length]>=8) {
//                            tempPhoneStr = [tempPhoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//                        }
//                        phoneTipStr = @"(预约成功后开放)";
//                    }else{
//                        phoneTipStr = @"";
//                    }
//                    
//                    phoneStr = [NSString stringWithFormat:@"电话:%@",tempPhoneStr];
//                    
//                }
//            }
//        }
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, labelWidth, 40)];
        [phoneLabel setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
        [phoneLabel setText:phoneStr];
        [self addSubview:phoneLabel];
        
        ///电话按钮
        QSBlockButtonStyleModel *phoneButtonStyle = [[QSBlockButtonStyleModel alloc] init];
        phoneButtonStyle.imagesNormal = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
        phoneButtonStyle.imagesHighted = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
        phoneButtonStyle.imagesSelected = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
        UIButton *phoneButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-30-10, phoneLabel.frame.origin.y+(phoneLabel.frame.size.height-34.0f)/2.f, 30, 34) andButtonStyle:phoneButtonStyle andCallBack:^(UIButton *button) {
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(button);
            }
            
        }];
        
        [self addSubview:phoneButton];
        
        ///最下方边界区域
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, phoneLabel.frame.origin.y+phoneLabel.frame.size.height, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), CONTENT_TOP_BOTTOM_OFFSETY)];
        [bottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bottomView];
        
        ///分隔线
        UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CONTENT_TOP_BOTTOM_OFFSETY-0.5f, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), 0.5f)];
        [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_BLACKH];
        [bottomView addSubview:bottomLineLablel];
        
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bottomView.frame.origin.y+bottomView.frame.size.height)];
        
        self.showHeight = self.frame.size.height;
        
        self.blockButtonCallBack = callBack;
        
    }
    
    return self;
    
}

@end
