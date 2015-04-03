//
//  QSPOrderDetailTransactionPriceView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailTransactionPriceView.h"

#import "NSString+Calculation.h"

@implementation QSPOrderDetailTransactionPriceView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint{
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        NSString *priceString = @"388";
        
        NSString *infoString = [NSString stringWithFormat:@"最后成交价%@万",priceString];
        
        UIColor *color = COLOR_CHARACTERS_GRAY;//COLOR_CHARACTERS_LIGHTYELLOW;
        
        CGFloat labelWidth = (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP);
        
        NSMutableAttributedString *priceInfoString = [[NSMutableAttributedString alloc] initWithString:infoString];
        [priceInfoString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, priceInfoString.length)];
        
        [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_18] range:NSMakeRange(0, priceInfoString.length)];
        [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_25] range:NSMakeRange(5, priceString.length)];
        
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
