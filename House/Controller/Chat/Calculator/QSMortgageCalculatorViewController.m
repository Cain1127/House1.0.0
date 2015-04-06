//
//  QSMortgageCalculatorViewController.m
//  House
//
//  Created by 王树朋 on 15/4/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMortgageCalculatorViewController.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "UITextField+CustomField.h"
#import "NSString+Calculation.h"

#import <objc/runtime.h>

///关联
static char AccumulationViewKey;    //!<公积金关联KEY
static char BusinessViewKey;        //!<商业贷款关联KEY
static char GrounpViewKey;          //!<组合贷款关联KEY

@interface QSMortgageCalculatorViewController ()

@end

@implementation QSMortgageCalculatorViewController

-(void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"房贷计算"];
    
}

-(void)createMainShowUI
{
    
    ///列表指针
    __block UIView *accumulationView;
    __block UIView *businessView;
    __block UIView *groupView;
    
    ///指示三角指针
    __block UIImageView *arrowIndicator;
    
    ///按钮指针
    __block UIButton *accumulationButton;
    __block UIButton *businessButton;
    __block UIButton *groupButton;
    
    ///尺寸
    CGFloat widthButton = SIZE_DEVICE_WIDTH / 3.0f;
    CGFloat listYPoint = 64.0f + 44.0f ;
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.bgColorSelected = COLOR_CHARACTERS_LIGHTYELLOW;
    buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_16];
    
    ///公积金贷
    buttonStyle.title = @"公积金贷";
    accumulationButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 64.0f, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///当前已处于选择状态
        if (button.selected) {
            
            return;
            
        }
        
        ///切换按钮状态
        button.selected = YES;
        businessButton.selected = NO;
        groupButton.selected = NO;
        
        ///切换列表
        accumulationView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-listYPoint)];
        
        [self.view addSubview:accumulationView];
        
        [self createMortgageView:accumulationView andMortgageType:mMortgageAccumulationType];
        
        ///获取当前正在显示的view
        UIView *tempView = businessView ? businessView : groupView;
        
        ///移动指示器
        [UIView animateWithDuration:0.3f animations:^{
            
            arrowIndicator.frame = CGRectMake(button.frame.origin.x + button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            
            tempView.frame = CGRectMake(SIZE_DEVICE_WIDTH, tempView.frame.origin.y, tempView.frame.size.width, tempView.frame.size.height);
            
            accumulationView.frame = CGRectMake(0.0f, accumulationView.frame.origin.y, accumulationView.frame.size.width, accumulationView.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            [tempView removeFromSuperview];
            businessView = nil;
            groupView = nil;
            
        }];
        
        objc_setAssociatedObject(self, &AccumulationViewKey, accumulationView, OBJC_ASSOCIATION_ASSIGN);
        
    }];
    //accumulationButton.selected = YES;
    [self.view addSubview:accumulationButton];
    
    ///商业贷款
    buttonStyle.title = @"商业贷款";
    businessButton = [UIButton createBlockButtonWithFrame:CGRectMake(accumulationButton.frame.origin.x + accumulationButton.frame.size.width, 64.0f, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///当前已处于选择状态
        if (button.selected) {
            
            return;
            
        }
        
        ///切换按钮状态
        button.selected = YES;
        accumulationButton.selected = NO;
        groupButton.selected = NO;
        
        ///坐标
        CGFloat xpoint = -SIZE_DEVICE_WIDTH;
        CGFloat endXPoint = SIZE_DEVICE_WIDTH;
        if (accumulationView) {
            
            xpoint = -xpoint;
            endXPoint = - endXPoint;
            
        }
        
        ///切换列表
        businessView = [[UIView alloc] initWithFrame:CGRectMake(xpoint, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint)];
        [self.view addSubview:businessView];
        
        [self createMortgageView:businessView andMortgageType:mMortgageBusinessType];
        ///获取当前正在显示的view
        UIView *tempView = accumulationView ? accumulationView : groupView;
        
        ///移动指示器
        [UIView animateWithDuration:0.3f animations:^{
            
            arrowIndicator.frame = CGRectMake(button.frame.origin.x + button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            
            tempView.frame = CGRectMake(endXPoint, tempView.frame.origin.y, tempView.frame.size.width, tempView.frame.size.height);
            
            businessView.frame = CGRectMake(0.0f, businessView.frame.origin.y, businessView.frame.size.width, businessView.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            [tempView removeFromSuperview];
            accumulationView = nil;
            groupView = nil;
            
        }];
        objc_setAssociatedObject(self, &BusinessViewKey, businessView, OBJC_ASSOCIATION_ASSIGN);

        
    }];
    businessButton.selected=YES;
    [self.view addSubview:businessButton];
    
    ///组合贷款
    buttonStyle.title = @"组合贷款";
    groupButton = [UIButton createBlockButtonWithFrame:CGRectMake(businessButton.frame.origin.x + businessButton.frame.size.width, 64.0f, widthButton, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///当前已处于选择状态
        if (button.selected) {
            
            return;
            
        }
        
        ///切换按钮状态
        button.selected = YES;
        accumulationButton.selected = NO;
        businessButton.selected = NO;
        
        ///切换列表
        groupView = [[UIView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint)];
        [self.view addSubview:groupView];
        [self createMortgageView:groupView andMortgageType:mMortgageGrounpType];
        ///获取当前正在显示的view
        UIView *tempView = accumulationView ? accumulationView : businessView;
        
        ///移动指示器
        [UIView animateWithDuration:0.3f animations:^{
            
            arrowIndicator.frame = CGRectMake(button.frame.origin.x + button.frame.size.width / 2.0f - 7.5f, arrowIndicator.frame.origin.y, arrowIndicator.frame.size.width, arrowIndicator.frame.size.height);
            
            tempView.frame = CGRectMake(-SIZE_DEVICE_WIDTH, tempView.frame.origin.y, tempView.frame.size.width, tempView.frame.size.height);
            
            groupView.frame = CGRectMake(0.0f, groupView.frame.origin.y, groupView.frame.size.width, groupView.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            [tempView removeFromSuperview];
            accumulationView = nil;
            businessView = nil;
            
        }];
        objc_setAssociatedObject(self, &GrounpViewKey, groupView, OBJC_ASSOCIATION_ASSIGN);

        
    }];
    [self.view addSubview:groupButton];
    
    ///初始化时，加载商业贷款列表
    businessView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint)];
    [self.view addSubview:businessView];
    [self createMortgageView:businessView andMortgageType:mMortgageBusinessType];
    
    ///指示三角
    arrowIndicator = [[QSImageView alloc] initWithFrame:CGRectMake(businessButton.frame.size.width / 2.0f - 7.5f, businessButton.frame.origin.y + businessButton.frame.size.height - 5.0f, 15.0f, 5.0f)];
    arrowIndicator.image = [UIImage imageNamed:IMAGE_CHANNELBAR_INDICATE_ARROW];
    [self.view addSubview:arrowIndicator];
    
}

#pragma mark -添加UI
-(void)createMortgageView:(UIView *)view andMortgageType:(MORTGAGE_ACTION_TYPE)mortageType
{
    
    UITextField *textField = [UITextField createCustomTextFieldWithFrame:CGRectMake(25.0f, 0.0f, SIZE_DEVICE_WIDTH-2.0f*25.0f, 50.0f) andPlaceHolder:nil andLeftTipsInfo:@"贷款方式" andRightTipsInfo:@"等额本息" andLeftTipsTextAlignment:NSTextAlignmentRight andTextFieldStyle:cCustomTextFieldStyleLeftAndRightTipsAndRightArrowBlack];
    [view addSubview:textField];
    
    ///分隔线
    UILabel *sepLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(textField.frame.origin.x, textField.frame.origin.y+textField.frame.size.height-0.25f, textField.frame.size.width, 0.25f)];
    sepLabel0.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:sepLabel0];
    
    UITextField *totalField = [UITextField createCustomTextFieldWithFrame:CGRectMake(textField.frame.origin.x, textField.frame.origin.y+textField.frame.size.height, textField.frame.size.width, textField.frame.size.height) andPlaceHolder:nil andLeftTipsInfo:@"贷款总额" andRightTipsInfo:@"万元" andLeftTipsTextAlignment:NSTextAlignmentRight andTextFieldStyle:cCustomTextFieldStyleLeftAndRightTipsAndRightArrowBlack];
    [view addSubview:totalField];
    
    ///分隔线
    UILabel *sepLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(textField.frame.origin.x, totalField.frame.origin.y+totalField.frame.size.height-0.25f, textField.frame.size.width, 0.25f)];
    sepLabel1.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:sepLabel1];
    
    UITextField *yearField = [UITextField createCustomTextFieldWithFrame:CGRectMake(textField.frame.origin.x, totalField.frame.origin.y+totalField.frame.size.height, textField.frame.size.width, textField.frame.size.height) andPlaceHolder:nil andLeftTipsInfo:@"贷款年限" andRightTipsInfo:@"年" andLeftTipsTextAlignment:NSTextAlignmentRight andTextFieldStyle:cCustomTextFieldStyleLeftAndRightTipsAndRightArrowBlack];
    [view addSubview:yearField];
    
    ///分隔线
    UILabel *sepLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(textField.frame.origin.x, yearField.frame.origin.y+yearField.frame.size.height-0.25f, textField.frame.size.width, 0.25f)];
    sepLabel2.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:sepLabel2];
    
    UITextField *rateField = [UITextField createCustomTextFieldWithFrame:CGRectMake(textField.frame.origin.x, yearField.frame.origin.y+yearField.frame.size.height, textField.frame.size.width, textField.frame.size.height) andPlaceHolder:nil andLeftTipsInfo:@"贷款利率" andRightTipsInfo:@"基准率6.15%" andLeftTipsTextAlignment:NSTextAlignmentRight andTextFieldStyle:cCustomTextFieldStyleLeftAndRightTipsAndRightArrowBlack];
    [view addSubview:rateField];
    
    ///分隔线
    UILabel *rateFieldLine = [[UILabel alloc] initWithFrame:CGRectMake(textField.frame.origin.x, rateField.frame.origin.y+rateField.frame.size.height-0.25f, textField.frame.size.width, 0.25f)];
    rateFieldLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:rateFieldLine];
    
    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(rateFieldLine.frame.origin.x, rateFieldLine.frame.origin.y+rateFieldLine.frame.size.height+20.0f, rateFieldLine.frame.size.width, 120.0f)];
    resultView.backgroundColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:resultView];
    
    UILabel *repaymentToalLabel= [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 80.0f, 20.0f)];
    repaymentToalLabel.text =@"还款总额:";
    repaymentToalLabel.font = [UIFont systemFontOfSize:16.0f];
    [resultView addSubview:repaymentToalLabel];
    
    UILabel *repaymentToalResult = [[UILabel alloc] initWithFrame:CGRectMake(repaymentToalLabel.frame.origin.x+repaymentToalLabel.frame.size.width, repaymentToalLabel.frame.origin.y, 160.0f, repaymentToalLabel.frame.size.height)];
    repaymentToalResult.text = @"0元" ;
    repaymentToalResult.font = [UIFont systemFontOfSize:20.0f];
    [resultView addSubview:repaymentToalResult];
    
    UILabel *payInterestLabel= [[UILabel alloc] initWithFrame:CGRectMake(repaymentToalLabel.frame.origin.x,repaymentToalLabel.frame.origin.y+repaymentToalLabel.frame.size.height+15.0f, repaymentToalLabel.frame.size.width, repaymentToalLabel.frame.size.height)];
    payInterestLabel.text =@"支付利息:";
    payInterestLabel.font = [UIFont systemFontOfSize:16.0f];
    [resultView addSubview:payInterestLabel];
    
    UILabel *payInterestResult = [[UILabel alloc] initWithFrame:CGRectMake(payInterestLabel.frame.origin.x+payInterestLabel.frame.size.width, payInterestLabel.frame.origin.y, 160.0f, payInterestLabel.frame.size.height)];
    payInterestResult.text = @"0元" ;
    payInterestResult.font = [UIFont systemFontOfSize:20.0f];
    [resultView addSubview:payInterestResult];
    
    UILabel *monthPaymentLabel= [[UILabel alloc] initWithFrame:CGRectMake(payInterestLabel.frame.origin.x,payInterestLabel.frame.origin.y+payInterestLabel.frame.size.height+15.0f, payInterestLabel.frame.size.width, payInterestLabel.frame.size.height)];
    monthPaymentLabel.text =@"月均还款:";
    payInterestLabel.font = [UIFont systemFontOfSize:16.0f];
    [resultView addSubview:monthPaymentLabel];
    
    UILabel *monthPaymentResult = [[UILabel alloc] initWithFrame:CGRectMake(monthPaymentLabel.frame.origin.x+monthPaymentLabel.frame.size.width, monthPaymentLabel.frame.origin.y, 160.0f, monthPaymentLabel.frame.size.height)];
    monthPaymentResult.text = @"0元" ;
    monthPaymentResult.font = [UIFont systemFontOfSize:20.0f];
    [resultView addSubview:monthPaymentResult];
    
    ///分隔线
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT-108.0f-60.0f, SIZE_DEVICE_WIDTH, 0.25f)];
    bottomLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:bottomLine];
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyel = [[QSBlockButtonStyleModel alloc] init];
    buttonStyel.bgColor = COLOR_CHARACTERS_YELLOW;
    buttonStyel.cornerRadio = 6.0f;
    
    ///计算按钮
    buttonStyel.title = @"计算";
    UIButton *countButton = [QSBlockButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, bottomLine.frame.origin.y+bottomLine.frame.size.height+8.0f, bottomLine.frame.size.width - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f) andButtonStyle:buttonStyel andCallBack:^(UIButton *button) {
        NSLog(@"计算");
        
        ///刷新数据
        
    }];
    [view addSubview:countButton];
    
}

@end
