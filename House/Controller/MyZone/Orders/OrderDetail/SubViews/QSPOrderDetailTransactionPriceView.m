//
//  QSPOrderDetailTransactionPriceView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailTransactionPriceView.h"
#import "QSOrderDetailInfoDataModel.h"
#import "NSString+Calculation.h"
#import "NSString+Order.h"

@implementation QSPOrderDetailTransactionPriceView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withOrderData:(id)orderData{
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f) withOrderData:orderData];
}

- (instancetype)initWithFrame:(CGRect)frame withOrderData:(id)orderData{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        QSOrderDetailInfoDataModel *tempOrderData = nil;
        
        if (orderData) {
            
            if ([orderData isKindOfClass:[QSOrderDetailInfoDataModel class]]) {
                
                tempOrderData = (QSOrderDetailInfoDataModel*)orderData;
                
            }
        }
        
        if (!tempOrderData) {
            NSLog(@"QSPOrderDetailMyPriceView orderdata 格式错误！");
            return self;
        }
        
        NSString *priceString = [NSString conversionPriceUnitToWanWithPriceString:tempOrderData.last_saler_bid];
        
        NSString *priceType = @"最后成交";
        
        NSString *priceUnit= @"万";
        
        NSString *infoString = @"";
        
        if ([tempOrderData.order_type isEqualToString:@"500103"]) {
            //出租房出价
            priceString = tempOrderData.transaction_price;
            priceUnit = @"元";
            
        }else {
            
            priceString = [NSString conversionPriceUnitToWanWithPriceString:tempOrderData.transaction_price];
            priceUnit = @"万";
            
        }
        
        
        if ([@"500220" isEqualToString:tempOrderData.order_status]||[@"500302" isEqualToString:tempOrderData.order_status]) {
            
            priceType = @"协商";
            
            if ([tempOrderData.order_type isEqualToString:@"500103"]) {
                //出租房出价
                priceString = tempOrderData.transaction_price;
                
            }else {
                
                priceString = [NSString conversionPriceUnitToWanWithPriceString:tempOrderData.transaction_price];
                
            }
            
        }
        
        if ([@"500253" isEqualToString:tempOrderData.order_status]
            || [@"500254" isEqualToString:tempOrderData.order_status]
            || [@"500259" isEqualToString:tempOrderData.order_status]) {
            
            priceType = @"业主一口";
            
            if ([tempOrderData.order_type isEqualToString:@"500103"]) {
                //出租房出价
                priceString = tempOrderData.house_msg.rent_price;
                
            }else {
                
                priceString = [NSString conversionPriceUnitToWanWithPriceString:tempOrderData.house_msg.house_price];
                
            }
            
        }
        
        UIColor *color = COLOR_CHARACTERS_GRAY;//COLOR_CHARACTERS_LIGHTYELLOW;
        
        if ([@"500258" isEqualToString:tempOrderData.order_status]
            || [@"500301" isEqualToString:tempOrderData.order_status]
            || [@"500302" isEqualToString:tempOrderData.order_status]
            || [@"500320" isEqualToString:tempOrderData.order_status]
            || [@"500220" isEqualToString:tempOrderData.order_status]
            || [@"500253" isEqualToString:tempOrderData.order_status]
            || [@"500254" isEqualToString:tempOrderData.order_status]
            || [@"500259" isEqualToString:tempOrderData.order_status]) {
            
            color = COLOR_CHARACTERS_YELLOW;
            
        }
        
        infoString = [NSString stringWithFormat:@"%@价%@%@",priceType,priceString,priceUnit];
        
        
        CGFloat labelWidth = (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP);
        
        NSMutableAttributedString *priceInfoString = [[NSMutableAttributedString alloc] initWithString:infoString];
        [priceInfoString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, priceInfoString.length)];
        
        [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_18] range:NSMakeRange(0, priceInfoString.length)];
        [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_25] range:NSMakeRange(priceType.length+1, priceString.length)];
        
        UITextField *inputPriceTextField = [[UITextField alloc]initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, labelWidth, 40.0f)];
        [inputPriceTextField setBackgroundColor:[UIColor whiteColor]];
        [inputPriceTextField setTextAlignment:NSTextAlignmentCenter];
        [inputPriceTextField setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
        [inputPriceTextField setReturnKeyType:UIReturnKeyDone];
        [inputPriceTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [inputPriceTextField.layer setCornerRadius:VIEW_SIZE_NORMAL_CORNERADIO];
        [inputPriceTextField.layer setMasksToBounds:YES];
        if (color) {
            [inputPriceTextField.layer setBorderColor:color.CGColor];
        }
        [inputPriceTextField setEnabled:NO];
        [inputPriceTextField.layer setBorderWidth:1.0f];
        [inputPriceTextField setAttributedPlaceholder:priceInfoString];
        [self addSubview:inputPriceTextField];
        
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, inputPriceTextField.frame.origin.y+inputPriceTextField.frame.size.height + 10)];
        
        self.showHeight = self.frame.size.height;
        
    }
    
    return self;
    
}

@end
