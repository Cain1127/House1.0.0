//
//  QSYChatToolViewController.m
//  House
//
//  Created by ysmeng on 15/4/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYChatToolViewController.h"
#import "QSMortgageCalculatorViewController.h"
#import "QSYToolContractViewController.h"
#import "QSYToolQuestionAndAnswerViewController.h"
#import "QSYNoiseTestViewController.h"

@interface QSYChatToolViewController ()

@end

@implementation QSYChatToolViewController

#pragma mark - 初始化
- (instancetype)init
{

    if (self = [super init]) {
        
        
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"工具"];

}

- (void)createMainShowUI
{

    [super createMainShowUI];
    
    ///按钮相关尺寸和坐标
    CGFloat width = 122.0f;
    CGFloat height = 136.0f;
    CGFloat gapH = (SIZE_DEVICE_WIDTH - 2.0f * width) / 3.0f;
    
    ///计算器
    UIButton *calculatorButton = [UIButton createBlockButtonWithFrame:CGRectMake(gapH, 64.0f + 30.0f, width, height) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///进入计算器
        QSMortgageCalculatorViewController *calculatorVC = [[QSMortgageCalculatorViewController alloc] initWithHousePrice:0.0f];
        [self.navigationController pushViewController:calculatorVC animated:YES];
        
    }];
    [calculatorButton setImage:[UIImage imageNamed:IMAGE_CHAT_TOOL_CACLULATOR_NORMAL] forState:UIControlStateNormal];
    [calculatorButton setImage:[UIImage imageNamed:IMAGE_CHAT_TOOL_CACLULATOR_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.view addSubview:calculatorButton];
    
    ///说明
    UIButton *calculatorTipsButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 90.0f, width, 20.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {}];
    [calculatorTipsButton setTitle:@"计算器" forState:UIControlStateNormal];
    [calculatorTipsButton setTitleColor:COLOR_CHARACTERS_BLACK forState:UIControlStateNormal];
    [calculatorTipsButton setTitleColor:COLOR_CHARACTERS_YELLOW forState:UIControlStateHighlighted];
    [calculatorButton addSubview:calculatorTipsButton];
    
    ///问答
    UIButton *qaButton = [UIButton createBlockButtonWithFrame:CGRectMake(calculatorButton.frame.origin.x + calculatorButton.frame.size.width + gapH, calculatorButton.frame.origin.y, width, height) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///进入问答
        QSYToolQuestionAndAnswerViewController *qaaVC = [[QSYToolQuestionAndAnswerViewController alloc] init];
        [self.navigationController pushViewController:qaaVC animated:YES];
        
    }];
    [qaButton setImage:[UIImage imageNamed:IMAGE_CHAT_TOOL_QA_NORMAL] forState:UIControlStateNormal];
    [qaButton setImage:[UIImage imageNamed:IMAGE_CHAT_TOOL_QA_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.view addSubview:qaButton];
    
    ///说明
    UIButton *qaTipsButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 90.0f, width, 20.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {}];
    [qaTipsButton setTitle:@"问答帮助" forState:UIControlStateNormal];
    [qaTipsButton setTitleColor:COLOR_CHARACTERS_BLACK forState:UIControlStateNormal];
    [qaTipsButton setTitleColor:COLOR_CHARACTERS_YELLOW forState:UIControlStateHighlighted];
    [qaButton addSubview:qaTipsButton];
    
    ///噪音检测
    UIButton *noiseButton = [UIButton createBlockButtonWithFrame:CGRectMake(gapH, calculatorButton.frame.origin.y + calculatorButton.frame.size.height + 30.0f, width, height) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///噪音检测
        QSYNoiseTestViewController *noiseVC = [[QSYNoiseTestViewController alloc] init];
        [self.navigationController pushViewController:noiseVC animated:YES];
        
    }];
    [noiseButton setImage:[UIImage imageNamed:IMAGE_CHAT_TOOL_NOISETEST_NORMAL] forState:UIControlStateNormal];
    [noiseButton setImage:[UIImage imageNamed:IMAGE_CHAT_TOOL_NOISETEST_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.view addSubview:noiseButton];
    
    ///说明
    UIButton *noiseTipsButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 90.0f, width, 20.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {}];
    [noiseTipsButton setTitle:@"噪音检测" forState:UIControlStateNormal];
    [noiseTipsButton setTitleColor:COLOR_CHARACTERS_BLACK forState:UIControlStateNormal];
    [noiseTipsButton setTitleColor:COLOR_CHARACTERS_YELLOW forState:UIControlStateHighlighted];
    [noiseButton addSubview:noiseTipsButton];
    
    ///合同
    UIButton *contractButton = [UIButton createBlockButtonWithFrame:CGRectMake(noiseButton.frame.origin.x + noiseButton.frame.size.width + gapH, noiseButton.frame.origin.y, width, height) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///进入合同模板
        QSYToolContractViewController *contractVC = [[QSYToolContractViewController alloc] init];
        [self.navigationController pushViewController:contractVC animated:YES];
        
    }];
    [contractButton setImage:[UIImage imageNamed:IMAGE_CHAT_TOOL_CONTRACT_NORMAL] forState:UIControlStateNormal];
    [contractButton setImage:[UIImage imageNamed:IMAGE_CHAT_TOOL_CONTRACT_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.view addSubview:contractButton];
    
    ///说明
    UIButton *contractTipsButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 90.0f, width, 20.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {}];
    [contractTipsButton setTitle:@"合同模板" forState:UIControlStateNormal];
    [contractTipsButton setTitleColor:COLOR_CHARACTERS_BLACK forState:UIControlStateNormal];
    [contractTipsButton setTitleColor:COLOR_CHARACTERS_YELLOW forState:UIControlStateHighlighted];
    [contractButton addSubview:contractTipsButton];

}

@end
