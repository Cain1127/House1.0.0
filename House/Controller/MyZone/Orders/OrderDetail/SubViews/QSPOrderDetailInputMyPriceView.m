//
//  QSPOrderDetailInputMyPriceView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailInputMyPriceView.h"
#import "NSString+Calculation.h"

@interface QSPOrderDetailInputMyPriceView ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *priceTextField;

@end

@implementation QSPOrderDetailInputMyPriceView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint{
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        NSString *tipString = [NSString stringWithFormat:@"输入我的还价（议价仅限5次）"];
        
        CGFloat labelWidth = (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP);
        
        CGFloat tipLabelHeight = [tipString calculateStringDisplayHeightByFixedWidth:labelWidth andFontSize:FONT_BODY_14];
        
        UILabel *markTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, labelWidth, tipLabelHeight)];
        [markTipLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
        [markTipLabel setTextColor:COLOR_CHARACTERS_BLACK];
        [markTipLabel setText:tipString];
        [markTipLabel setNumberOfLines:0];
        [self addSubview:markTipLabel];
        
        UITextField *inputPriceTextField = [[UITextField alloc]initWithFrame:CGRectMake(markTipLabel.frame.origin.x, markTipLabel.frame.origin.y + markTipLabel.frame.size.height+6, labelWidth, 44.0f)];
        [inputPriceTextField setBackgroundColor:[UIColor whiteColor]];
        [inputPriceTextField setPlaceholder:@"输入您的房源估价"];
        [inputPriceTextField setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
        [inputPriceTextField setReturnKeyType:UIReturnKeyDone];
        [inputPriceTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [inputPriceTextField setKeyboardType:UIKeyboardTypeDecimalPad];
        [inputPriceTextField.layer setCornerRadius:VIEW_SIZE_NORMAL_CORNERADIO];
        [inputPriceTextField.layer setMasksToBounds:YES];
        [inputPriceTextField.layer setBorderColor:COLOR_CHARACTERS_LIGHTYELLOW.CGColor];
        [inputPriceTextField.layer setBorderWidth:1.0f];
        [inputPriceTextField setDelegate:self];
        [self addSubview:inputPriceTextField];
        
        self.priceTextField = inputPriceTextField;
        
        self.showHeight = inputPriceTextField.frame.origin.y+inputPriceTextField.frame.size.height + 10;
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.showHeight)];
        
    }
    
    return self;
    
}

- (NSString*)getInputPrice
{
    NSString *priceStr = nil;
    
    if (self.priceTextField) {
        priceStr = [self.priceTextField text];
    }
    
    return priceStr;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    
    [aTextfield resignFirstResponder];
    
    return YES;
}

@end
