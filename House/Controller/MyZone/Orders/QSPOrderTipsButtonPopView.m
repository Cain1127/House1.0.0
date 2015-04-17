//
//  QSPOrderTipsButtonPopView.m
//  House
//
//  Created by CoolTea on 15/4/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderTipsButtonPopView.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "NSString+Order.h"

@interface QSPOrderTipsButtonPopView ()<UITextFieldDelegate>

@property (nonatomic, strong)UIView *contentBackgroundView;
@property (nonatomic, strong)UITextField *inputPriceTextField;
@property (nonatomic, assign) ORDER_BUTTON_TIPS_VIEW_TYPE viewType;
///回调
@property (nonatomic,copy) void(^buttonTipsCallBack)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType);

@property (nonatomic,strong) NSString *houseTitle;
@property (nonatomic,strong) NSString *housePrice;


@end

@implementation QSPOrderTipsButtonPopView
@synthesize parentViewController;

#pragma mark - UI搭建
- (void)createTipAndButtonsUI
{
    
    //半透明背景层
    [self setFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    [self setBackgroundColor:COLOR_CHARACTERS_BLACKH];
    
    //背景关闭按钮
    QSBlockButtonStyleModel *bgBtStyleModel = [QSBlockButtonStyleModel alloc];
    UIButton *bgBt = [UIButton createBlockButtonWithFrame:self.frame andButtonStyle:bgBtStyleModel andCallBack:^(UIButton *button) {
        
        if (self.buttonTipsCallBack) {
            
            self.buttonTipsCallBack(button,oOrderButtonTipsActionTypeCancel);
            
        }
        
        [self hideView];
    }];
    [bgBt setTag:_viewType];
    [self addSubview:bgBt];
    
    //底部内容区域层
    self.contentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, SIZE_DEVICE_HEIGHT - DefaultHeight , SIZE_DEVICE_WIDTH, DefaultHeight)];
    [self.contentBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.contentBackgroundView];
    
    switch (_viewType) {
        case oOrderButtonTipsViewTypeSalerInputPrice:
        {
            //修改白色背景高度
            CGFloat contentHeight = 280.0f;
            [self.contentBackgroundView setFrame:CGRectMake(self.contentBackgroundView.frame.origin.x, SIZE_DEVICE_HEIGHT - contentHeight, self.contentBackgroundView.frame.size.width, contentHeight)];
            
            ///房源名字信息
            UILabel *houseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 22.0f, self.frame.size.width, 30.0f)];
            houseTitleLabel.text = self.houseTitle;
            houseTitleLabel.textAlignment = NSTextAlignmentCenter;
            houseTitleLabel.textColor = COLOR_CHARACTERS_BLACK;
            houseTitleLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
            [self.contentBackgroundView addSubview:houseTitleLabel];
            
            ///出价身份
            UILabel *priceUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, houseTitleLabel.frame.origin.y+houseTitleLabel.frame.size.height+12.0f, self.frame.size.width, 30.0f)];
            priceUserLabel.text = @"房客还价";
            priceUserLabel.textAlignment = NSTextAlignmentCenter;
            priceUserLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
            priceUserLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
            [self.contentBackgroundView addSubview:priceUserLabel];
            
            NSString *infoString = [NSString stringWithFormat:@"%@万",self.housePrice];
            NSMutableAttributedString *priceInfoString = [[NSMutableAttributedString alloc] initWithString:infoString];
            [priceInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(0, priceInfoString.length)];
            
            [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_40] range:NSMakeRange(0, self.housePrice.length)];
            [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_18] range:NSMakeRange(self.housePrice.length, priceInfoString.length-self.housePrice.length)];
            
            ///价格
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, priceUserLabel.frame.origin.y+priceUserLabel.frame.size.height+12.0f, self.frame.size.width, 30.0f)];
            priceLabel.attributedText = priceInfoString;
            priceLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentBackgroundView addSubview:priceLabel];
            
            self.inputPriceTextField = [[UITextField alloc]initWithFrame:CGRectMake(32, priceLabel.frame.origin.y + priceLabel.frame.size.height+20.0f, SIZE_DEVICE_WIDTH-64, 44.0f)];
            [self.inputPriceTextField setBackgroundColor:[UIColor whiteColor]];
            [self.inputPriceTextField setPlaceholder:@"输入还价"];
            [self.inputPriceTextField setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
            [self.inputPriceTextField setReturnKeyType:UIReturnKeyDone];
            [self.inputPriceTextField setBorderStyle:UITextBorderStyleRoundedRect];
            [self.inputPriceTextField.layer setCornerRadius:VIEW_SIZE_NORMAL_CORNERADIO];
            [self.inputPriceTextField.layer setMasksToBounds:YES];
            [self.inputPriceTextField.layer setBorderColor:COLOR_CHARACTERS_LIGHTYELLOW.CGColor];
            [self.inputPriceTextField.layer setBorderWidth:1.0f];
            [self.inputPriceTextField setDelegate:self];
            [self.contentBackgroundView addSubview:self.inputPriceTextField];
            
        }
            break;
        case oOrderButtonTipsViewTypeAcceptBuyerPrice:
        {
            //修改白色背景高度
            CGFloat contentHeight = 200.0f;
            [self.contentBackgroundView setFrame:CGRectMake(self.contentBackgroundView.frame.origin.x, SIZE_DEVICE_HEIGHT - contentHeight, self.contentBackgroundView.frame.size.width, contentHeight)];
            
            ///房源名字信息
            UILabel *houseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 22.0f, self.frame.size.width, 30.0f)];
            houseTitleLabel.text = self.houseTitle;
            houseTitleLabel.textAlignment = NSTextAlignmentCenter;
            houseTitleLabel.textColor = COLOR_CHARACTERS_BLACK;
            houseTitleLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
            [self.contentBackgroundView addSubview:houseTitleLabel];
            
            ///出价身份
            UILabel *priceUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, houseTitleLabel.frame.origin.y+houseTitleLabel.frame.size.height+12.0f, self.frame.size.width, 30.0f)];
            priceUserLabel.text = @"房客还价";
            priceUserLabel.textAlignment = NSTextAlignmentCenter;
            priceUserLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
            priceUserLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
            [self.contentBackgroundView addSubview:priceUserLabel];
            
            NSString *infoString = [NSString stringWithFormat:@"%@万",self.housePrice];
            NSMutableAttributedString *priceInfoString = [[NSMutableAttributedString alloc] initWithString:infoString];
            [priceInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(0, priceInfoString.length)];
            
            [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_40] range:NSMakeRange(0, self.housePrice.length)];
            [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_18] range:NSMakeRange(self.housePrice.length, priceInfoString.length-self.housePrice.length)];
            
            ///价格
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, priceUserLabel.frame.origin.y+priceUserLabel.frame.size.height+8.0f, self.frame.size.width, 30.0f)];
            priceLabel.attributedText = priceInfoString;
            priceLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentBackgroundView addSubview:priceLabel];
            
        }
            break;
        default:
            break;
    }
    
    ///按钮相关尺寸
    CGFloat xpoint = 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat width = (self.frame.size.width - 2.0f * xpoint - VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP) / 2.0f;
    
    ///取消按钮
    QSBlockButtonStyleModel *cancelButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    cancelButtonStyle.title = @"取消";
    
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(xpoint, self.contentBackgroundView.frame.size.height-VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP-VIEW_SIZE_NORMAL_BUTTON_HEIGHT, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:cancelButtonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.buttonTipsCallBack) {
            
            self.buttonTipsCallBack(button,oOrderButtonTipsActionTypeCancel);
            
        }
        
        [self hideView];
        
    }];
    [cancelButton setTag:_viewType];
    [self.contentBackgroundView addSubview:cancelButton];
    
    ///确认按钮
    QSBlockButtonStyleModel *confirmButtonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    confirmButtonStyle.title = @"确定";
    
    UIButton *confirmButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.frame.size.width / 2.0f + 4.0f, cancelButton.frame.origin.y, width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:confirmButtonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.buttonTipsCallBack) {
            
            self.buttonTipsCallBack(button, oOrderButtonTipsActionTypeConfirm);
            
        }
        
        [self hideView];
        
    }];
    [confirmButton setTag:_viewType];
    [self.contentBackgroundView addSubview:confirmButton];
    
//    ///提示信息
//    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 15.0f, self.frame.size.width, 30.0f)];
//    tipsLabel.text = @"是否将此房进行比一比？";
//    tipsLabel.textAlignment = NSTextAlignmentCenter;
//    tipsLabel.textColor = COLOR_CHARACTERS_BLACK;
//    tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
//    [contentBackgroundView addSubview:tipsLabel];
    
    ///注册键盘弹出监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarHideAction:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (instancetype)initWithSalerInputPriceVieWithHouseTitle:(NSString*)houseTitle WithBuyerPrice:(NSString*)buyerPrice wandCallBack:(void(^)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType))callBack
{
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        _viewType = oOrderButtonTipsViewTypeSalerInputPrice;
        self.houseTitle = houseTitle;
        self.housePrice = [NSString conversionPriceUnitToWanWithPriceString:buyerPrice];
        
        ///搭建UI
        [self createTipAndButtonsUI];
        
        ///保存回调
        if (callBack) {
            
            self.buttonTipsCallBack = callBack;
            
        }
        
    }
    
    return self;
    
}

- (instancetype)initWithAcceptBuyerPriceVieWithHouseTitle:(NSString*)houseTitle WithBuyerPrice:(NSString*)buyerPrice wandCallBack:(void(^)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType))callBack
{
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        _viewType = oOrderButtonTipsViewTypeAcceptBuyerPrice;
        self.houseTitle = houseTitle;
        self.housePrice = [NSString conversionPriceUnitToWanWithPriceString:buyerPrice];
        
        ///搭建UI
        [self createTipAndButtonsUI];
        
        ///保存回调
        if (callBack) {
            
            self.buttonTipsCallBack = callBack;
            
        }
        
    }
    
    return self;
}

- (instancetype)initWithView:(ORDER_BUTTON_TIPS_VIEW_TYPE)viewType andCallBack:(void(^)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType))callBack
{
    
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        _viewType = viewType;
        
        ///搭建UI
        [self createTipAndButtonsUI];
        
        ///保存回调
        if (callBack) {
            
            self.buttonTipsCallBack = callBack;
            
        }
        
    }
    
    return self;
    
}

- (NSString*)getInputPrice
{
    NSString *priceStr = nil;
    
    if (self.inputPriceTextField) {
        priceStr = [self.inputPriceTextField text];
    }
    
    return priceStr;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    
    [aTextfield resignFirstResponder];
    
    return YES;
}

- (void)hideView
{
    
    if (self.contentBackgroundView) {
        for (UIView *view in [self.contentBackgroundView subviews]) {
            
            if (view && [view isKindOfClass:[UITextField class]]) {
                [(UITextField*)view resignFirstResponder];
            }
            if (view && [view isKindOfClass:[UITextView class]]) {
                [(UITextView*)view resignFirstResponder];
            }
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self setHidden:YES];
    [self removeFromSuperview];
    
}

#pragma mark - 键盘弹出和回收
- (void)keyboarShowAction:(NSNotification *)sender
{
    
    if (self.parentViewController) {
     
        //上移：需要知道键盘高度和移动时间
        CGRect keyBoardRect = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSTimeInterval anTime;
        [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
        
        CGRect keyboardRect = [self.parentViewController.view convertRect:keyBoardRect fromView:nil];
        CGRect textFieldRect = [self.parentViewController.view convertRect:self.frame fromView:self.superview];
        
        if (textFieldRect.origin.y + textFieldRect.size.height + 2.0f > (self.parentViewController.view.frame.size.height-keyboardRect.size.height)) {
            
            [UIView animateWithDuration:anTime animations:^{
                
                [self.parentViewController.view setFrame:CGRectMake(self.parentViewController.view.frame.origin.x,  ((self.parentViewController.view.frame.size.height-keyboardRect.size.height) - (textFieldRect.origin.y + textFieldRect.size.height + 2.0f)), self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.height)];
                
            }];
            
        }
        
    }
    
}

- (void)keyboarHideAction:(NSNotification *)sender
{
    
    if (self.parentViewController) {
        
        NSTimeInterval anTime;
        [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
        
        [UIView animateWithDuration:anTime animations:^{
            
            [self.parentViewController.view setFrame:CGRectMake(self.parentViewController.view.frame.origin.x, 0, self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.height)];
            
        }];
        
    }
    
}

@end
