//
//  QSPOrderEvaluationListingsViewController.m
//  House
//
//  Created by CoolTea on 15/4/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderEvaluationListingsViewController.h"
#import "QSPOrderBottomButtonView.h"
#import "QSPOrderCommentStarsView.h"
#import "NSString+Calculation.h"
#import "QSPOrderCommentSelectedButtonView.h"
#import "QSCustomHUDView.h"
#import "QSPOrderDetailActionReturnBaseDataModel.h"
#import "QSPOrderSubmitResultViewController.h"
#import "QSPOrderDetailBookedViewController.h"

@interface QSPOrderEvaluationListingsViewController ()<UITextViewDelegate>

@property (nonatomic, strong) QSPOrderCommentStarsView *totalStarsView;
@property (nonatomic, strong) QSPOrderCommentStarsView *salerStarsView;
@property (nonatomic, strong) UITextView* contentTextView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) QSPOrderCommentSelectedButtonView *suitableButtonView;
@property (nonatomic, strong) QSPOrderCommentSelectedButtonView *unSuitableButtonView;

@end

@implementation QSPOrderEvaluationListingsViewController
@synthesize orderID;

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:@"房源评价"];
    
}


///搭建主展示UI
- (void)createMainShowUI
{
    __block CGFloat mainHeightFloat = SIZE_DEVICE_HEIGHT - 64.0f;
    __block CGFloat mainOffSetY = 64.0f;
    CGFloat viewContentOffsetY = 0.0f;
    
    QSPOrderBottomButtonView *submitBtView = [[QSPOrderBottomButtonView alloc] initAtTopLeft:CGPointMake(0.0f, 0.0f) withButtonCount:1 andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
        
        switch (buttonType) {
            case bBottomButtonTypeOne:
                
                [self commitCommentAndInspectedOrder];
                
                break;
                
            default:
                break;
        }
        
    }];
    [submitBtView setCenterBtTitle:@"提交"];
    
    QSScrollView *scrollView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, mainOffSetY, SIZE_DEVICE_WIDTH, mainHeightFloat-submitBtView.frame.size.height)];
    [self.view addSubview:scrollView];
    
    [submitBtView setFrame:CGRectMake(submitBtView.frame.origin.x, scrollView.frame.origin.y+scrollView.frame.size.height, submitBtView.frame.size.width, submitBtView.frame.size.height)];
    [self.view addSubview:submitBtView];
    
    self.totalStarsView = [[QSPOrderCommentStarsView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withTitleTip:@"总体评价"];
    [scrollView addSubview:self.totalStarsView];
    viewContentOffsetY = self.totalStarsView.frame.origin.y+self.totalStarsView.frame.size.height;
    
    self.salerStarsView = [[QSPOrderCommentStarsView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withTitleTip:@"业主态度"];
    [scrollView addSubview:self.salerStarsView];
    viewContentOffsetY = self.salerStarsView.frame.origin.y+self.salerStarsView.frame.size.height;
    
    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, 16+viewContentOffsetY, SIZE_DEVICE_WIDTH-2*CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, 150)];
    [self.contentTextView setBackgroundColor:[UIColor clearColor]];
    [self.contentTextView setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
    [self.contentTextView setDelegate:self];
    [self.contentTextView setReturnKeyType:UIReturnKeyDone];
    [self.contentTextView.layer setBorderColor:[COLOR_CHARACTERS_LIGHTGRAY CGColor]];
    [self.contentTextView.layer setBorderWidth:1.0];
    [self.contentTextView.layer setCornerRadius:5.];
    [self.contentTextView setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:self.contentTextView];
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, -15, SIZE_DEVICE_WIDTH-12, 32*2)];
    [self.placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [self.placeholderLabel setText:@"输入具体评价描述(选填项)"];
    [self.placeholderLabel setNumberOfLines:0];
    [self.placeholderLabel setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
    [self.placeholderLabel setTextColor:COLOR_CHARACTERS_LIGHTGRAY];
    [self.contentTextView addSubview:self.placeholderLabel];
    viewContentOffsetY = self.contentTextView.frame.origin.y+self.contentTextView.frame.size.height;
    
    UILabel *markTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, viewContentOffsetY+12, SIZE_DEVICE_WIDTH-12, 24)];
    [markTitleLabel setBackgroundColor:[UIColor clearColor]];
    [markTitleLabel setText:@"房源初步意向"];
    [markTitleLabel setNumberOfLines:0];
    [markTitleLabel setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
    [markTitleLabel setTextColor:COLOR_CHARACTERS_LIGHTGRAY];
    [scrollView addSubview:markTitleLabel];
    viewContentOffsetY = markTitleLabel.frame.origin.y+markTitleLabel.frame.size.height;
    
    NSString *infoString = @"备注:请选择不合适订单将视为取消订单，选择合适后可与业主进行议价或成交。";
    CGFloat labelWidth = (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP);
    CGFloat labelHeight = [infoString calculateStringDisplayHeightByFixedWidth:labelWidth andFontSize:FONT_BODY_14];
    
    UILabel *markTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, viewContentOffsetY, labelWidth, labelHeight)];
    [markTipLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
    [markTipLabel setTextColor:COLOR_CHARACTERS_LIGHTGRAY];
    [markTipLabel setText:infoString];
    [markTipLabel setNumberOfLines:0];
    [scrollView addSubview:markTipLabel];
    viewContentOffsetY = markTipLabel.frame.origin.y+markTipLabel.frame.size.height;
    
    self.suitableButtonView = [[QSPOrderCommentSelectedButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withTitleTip:@"合适" andCallBack:^(UIButton *button) {
        
        if (self.suitableButtonView) {
            [self.suitableButtonView setSelectState:YES];
        }
        if (self.unSuitableButtonView) {
            [self.unSuitableButtonView setSelectState:NO];
        }
        
    }];
    [scrollView addSubview:self.suitableButtonView];
    viewContentOffsetY = self.suitableButtonView.frame.origin.y+self.suitableButtonView.frame.size.height;

    self.unSuitableButtonView = [[QSPOrderCommentSelectedButtonView alloc] initAtTopLeft:CGPointMake(0.0f, viewContentOffsetY) withTitleTip:@"不合适" andCallBack:^(UIButton *button) {
        
        if (self.suitableButtonView) {
            [self.suitableButtonView setSelectState:NO];
        }
        if (self.unSuitableButtonView) {
            [self.unSuitableButtonView setSelectState:YES];
        }
        
    }];
    [scrollView addSubview:self.unSuitableButtonView];
    viewContentOffsetY = self.unSuitableButtonView.frame.origin.y+self.unSuitableButtonView.frame.size.height;
    
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, viewContentOffsetY+20)];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    if (textView.text.length != 0)
    {
        [self.placeholderLabel setHidden:YES];
    }
    else
    {
        [self.placeholderLabel setHidden:NO];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView;
{
    if (textView.text.length != 0)
    {
        [self.placeholderLabel setHidden:YES];
    }
    else
    {
        [self.placeholderLabel setHidden:NO];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - 房客提交评论确认完成看房
- (void)commitCommentAndInspectedOrder
{
    
    if (!self.orderID || [self.orderID isEqualToString:@""]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"订单ID错误", 1.0f, ^(){
            
        })
        return;
    }
    
    if (![self.suitableButtonView getSelectedState] && ![self.unSuitableButtonView getSelectedState]) {
        
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请选择房源是否合适您", 1.0f, ^(){
            
        })
        return;
        
    }
    
    //    必选	类型及范围	说明
    //    user_id	true	string	操作用户id
    //    order_id	true	string	订单id
    //    score	true	float	总体分数,满分10分(房客确认的时候才需要)
    //    manner_score	true	float	服务态度,满分10分(房客确认的时候才需要)
    //    desc	true	string	评价描述(房客确认的时候才需要)
    //    suitable	true	int	1:合适 4：不合适 (如果不是1，全部为不合适----房客确认的时候才需要)
    
    NSString *suitableStr = @"";
    if ([self.suitableButtonView getSelectedState]) {
        suitableStr = @"1";
    }
    if ([self.unSuitableButtonView getSelectedState]) {
        suitableStr = @"4";
    }
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID forKey:@"order_id"];
    [tempParam setObject:[NSString stringWithFormat:@"%ld",[self.totalStarsView getSelectedIndex]*2] forKey:@"score"];
    [tempParam setObject:[NSString stringWithFormat:@"%ld",[self.salerStarsView getSelectedIndex]*2] forKey:@"manner_score"];
    [tempParam setObject:[self.contentTextView text] forKey:@"desc"];
    [tempParam setObject:suitableStr forKey:@"suitable"];//1:合适 4：不合适 (如果不是1，全部为不合适----房客确认的时候才需要)
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    [QSRequestManager requestDataWithType:rRequestTypeOrderCommitInspected andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        if (rRequestResultTypeSuccess == resultStatus) {
    
            QSPOrderSubmitResultViewController *srVc = [[QSPOrderSubmitResultViewController alloc] initWithResultType:oOrderSubmitResultTypeEvaluationListingsSuccessed andAutoBackCallBack:^(ORDER_SUBMIT_RESULT_BACK_TYPE backType){
                
                switch (backType) {
                    case oOrderSubmitResultBackTypeAuto:
                        
                        NSLog(@"auto back");
                        {
                            QSPOrderDetailBookedViewController *bookedVc = [[QSPOrderDetailBookedViewController alloc] init];
                            [bookedVc setOrderID:self.orderID];
                            [bookedVc setTurnBackDistanceStep:3];
                            [bookedVc setOrderType:mOrderWithUserTypeAppointment];
                            [self.navigationController pushViewController:bookedVc animated:NO];
                        }
                        
                        break;
                    default:
                        break;
                }
                
            }];
            
            [self presentViewController:srVc animated:YES completion:^{
                
            }];
    
        }

        ///转换模型
        if (headerModel) {

            if (headerModel&&[headerModel isKindOfClass:[QSPOrderDetailActionReturnBaseDataModel class]]) {
                TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.msg, 1.0f, ^(){
                    
                    
                })
            }else if (headerModel&&[headerModel isKindOfClass:[QSHeaderDataModel class]]) {
                TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.info, 1.0f, ^(){
                    
                    
                })
            }
            
        }
        
        [hud hiddenCustomHUD];
        
    }];

}


@end
